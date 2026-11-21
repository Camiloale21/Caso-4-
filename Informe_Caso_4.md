---
title: "Caso 4 — Predicting Customer Churn at QWE Inc."
subtitle: "Analítica de los Negocios 2026-3 · Pontificia Universidad Javeriana"
author: "Camilo Alejandro Hernández Moreno · Sofía Castiblanco Aguilera"
date: "Noviembre de 2026"
lang: es
---

# Resumen ejecutivo

Richard Wall, VP de servicio al cliente de QWE Inc., quiere pasar de una retención reactiva a una proactiva: estimar la probabilidad de que cada cliente abandone en los próximos dos meses, obtener la lista de los **100 clientes con mayor riesgo** y conocer **los tres factores que más contribuyen** a ese riesgo.

Con la base de 6.347 clientes (corte al 1 de diciembre de 2011; 323 abandonaron, una tasa de 5,1 %) encontramos que:

1. **La intuición de Wall sobre la antigüedad se confirma.** Los clientes de 6 a 14 meses son el grupo más riesgoso (7,2 % de abandono), seguidos por los de más de 14 meses (5,5 %) y los de menos de 6 meses (1,6 %). Las diferencias son estadísticamente significativas. El riesgo se dispara en el mes 12 (20,7 %), cuando vencen los contratos anuales.
2. **La felicidad del cliente (CHI) es el mejor predictor accionable.** Cada 10 puntos adicionales de CHI reducen las probabilidades (odds) de abandono en cerca de 9 %. También elevan el riesgo una caída reciente del CHI, el aumento de los días sin iniciar sesión y la caída de vistas.
3. **La hipótesis de Wall sobre el soporte técnico no se sostiene.** Quienes abandonan tienen, en promedio, menos casos de soporte que quienes se quedan, y en el modelo multivariado el soporte no es significativo.
4. **El modelo elegido es una regresión logística con segmentos de antigüedad.** Supera al modelo de probabilidad lineal y al logit con edad lineal (AUC fuera de muestra de 0,678). El 10 % de clientes con mayor riesgo estimado concentra el 33 % de los abandonos reales.
5. **La lista de los 100 clientes tiene una tasa real de abandono de 29 %**, 5,7 veces la tasa base. En casi todos, los factores principales son antigüedad de 6–14 meses, CHI bajo y aumento de días sin iniciar sesión.

**Recomendación:** contactar primero a los 100 clientes de la lista con acciones orientadas a mejorar su experiencia (no descuentos), con especial atención a quienes se acercan al mes 12 de contrato y a quienes tienen CHI bajo o en caída.

# 1. Contexto y problema de negocio

QWE Inc. vende a pymes una suscripción para gestionar su presencia en línea. Los contratos son mensuales o a 6 o 12 meses, así que el cliente puede irse al final de cada mes o al final del mes 6 o 12. Hasta 2012 la empresa solo reaccionaba cuando el cliente llamaba a cancelar y, en general, ofrecía descuentos o servicios gratis. Wall propone anticiparse: **usar las características actuales del cliente para estimar la probabilidad de abandono en los dos meses siguientes**, priorizar el contacto y actuar sobre las causas.

**Pregunta analítica.** ¿Qué tan probable es que cada cliente abandone entre diciembre de 2011 y febrero de 2012, qué clientes conforman el 1 % de mayor riesgo (los 100 primeros) y qué factores explican su riesgo?

Como la variable de interés es binaria (abandona = 1, no abandona = 0), las herramientas de la asignatura que corresponden son los **modelos de probabilidad**: el modelo de probabilidad lineal y la regresión logística, complementados con pruebas de hipótesis e intervalos de confianza para contrastar las intuiciones de Wall.

# 2. Datos y preparación

*Responsable: Camilo Alejandro Hernández Moreno — script `01_Limpieza_Datos.R`.*

La hoja *Case Data* del archivo `DATA.xlsx` contiene 6.347 clientes y 13 columnas (el enunciado menciona 6.000; trabajamos con el archivo completo). No hay valores faltantes ni identificadores duplicados, y `churn` solo toma los valores 0 y 1. Las variables siguen la convención del caso: «mes 0» es el valor al 1 de diciembre de 2011 y «0-1» es el cambio entre noviembre y diciembre.

| Variable (R) | Descripción |
|---|---|
| `edad` | Antigüedad del cliente en meses |
| `churn` | 1 = abandonó en los dos meses siguientes |
| `chi_0`, `chi_var` | Customer Happiness Index en el mes 0 y su cambio |
| `casos_0`, `casos_var` | Casos de soporte en el mes 0 y su cambio |
| `prioridad_0`, `prioridad_var` | Prioridad promedio de soporte y su cambio |
| `logins_var`, `blogs_var`, `vistas_var` | Cambio en inicios de sesión, artículos de blog y vistas |
| `dias_ult_login_var` | Cambio en días desde el último inicio de sesión |

Creamos dos variables:

* **`segmento_edad`**, con los tres grupos que propone Wall: menos de 6 meses (0–5), de 6 a 14 meses y más de 14 meses.
* **`muestra`**, que separa la base en entrenamiento (80 %, 5.078 clientes) y prueba (20 %, 1.269 clientes). Un cliente va a prueba si su ID es múltiplo de 5. Elegimos este muestreo sistemático en lugar de uno aleatorio para que la partición sea idéntica en cualquier computador. Las tasas de abandono quedaron equilibradas: 5,14 % en entrenamiento y 4,89 % en prueba.

Las variables de uso tienen colas muy largas (por ejemplo, el cambio de vistas va de −28.322 a 230.414). No eliminamos esos valores porque son datos reales del negocio, pero los tenemos en cuenta al interpretar los coeficientes (tabla T01).

# 3. Análisis exploratorio: ¿se cumplen las intuiciones de Wall?

*Responsable: Camilo Alejandro Hernández Moreno — script `02_Analisis_Exploratorio.R`.*

## 3.1 Antigüedad del cliente

| Segmento | Clientes | Abandonos | Tasa | IC 95 % |
|---|---:|---:|---:|---|
| Menos de 6 meses | 1.669 | 26 | 1,56 % | 0,96 % – 2,15 % |
| 6 a 14 meses | 2.284 | 165 | 7,22 % | 6,16 % – 8,29 % |
| Más de 14 meses | 2.394 | 132 | 5,51 % | 4,60 % – 6,43 % |

![Tasa de abandono por segmento de antigüedad](../04_Resultados/Graficos/G02_churn_por_segmento.png){width=70%}

* La prueba chi-cuadrado de independencia rechaza que la tasa sea igual en los tres segmentos (χ² = 65,54; gl = 2; p < 0,001).
* En las comparaciones por pares, el segmento de 6 a 14 meses abandona más que el de menos de 6 (p < 0,001) y que el de más de 14 (χ² = 5,47; p = 0,019).

**Conclusión:** los datos respaldan a Wall: el grupo de 6 a 14 meses es el más riesgoso. Sin embargo, el grupo de más de 14 meses no es «seguro», pues su tasa (5,5 %) supera el promedio. Los clientes nuevos son, de lejos, los que menos abandonan: probablemente siguen dentro de su primer contrato.

![Tasa de abandono por mes de antigüedad](../04_Resultados/Graficos/G01_churn_por_edad_meses.png)

El gráfico por mes muestra un pico de **20,7 % en el mes 12** (271 clientes), que coincide con el vencimiento de los contratos anuales descrito en el caso. También se ve un salto en el mes 6, cuando vencen los contratos semestrales. Esto sugiere que la relación entre antigüedad y abandono **no es lineal**, así que en el modelo es mejor usar segmentos que la edad como número continuo (sección 4).

## 3.2 Felicidad, soporte y uso

Comparamos las medias de quienes abandonan y quienes se quedan con la prueba t de Welch, que no supone varianzas iguales (tabla T04):

| Variable | Abandona | Se queda | p-valor | ¿Coincide con Wall? |
|---|---:|---:|---:|---|
| CHI mes 0 | 63,3 | 88,6 | < 0,001 | Sí: menor felicidad |
| Cambio CHI | −3,7 | +5,5 | < 0,001 | Sí: el CHI cae |
| Casos de soporte mes 0 | 0,37 | 0,72 | < 0,001 | **No:** tienen *menos* casos |
| Prioridad de soporte mes 0 | 0,50 | 0,83 | < 0,001 | **No:** menor prioridad |
| Cambio de casos / prioridad | — | — | 0,53 / 0,52 | Sin diferencia |
| Cambio de logins | +8,1 | +16,1 | < 0,001 | Sí: usan menos el sistema |
| Cambio de blogs | −0,10 | +0,17 | 0,012 | Sí |
| Cambio de vistas | −95,8 | +106,6 | 0,056 | Sí (al 10 %) |
| Cambio de días desde último login | +6,5 | +1,5 | < 0,001 | Sí: se desconectan |

Se confirman las intuiciones sobre felicidad y uso. La de soporte, en cambio, se contradice: los clientes que abren casos parecen ser los más comprometidos con la herramienta, no los más insatisfechos. Estas comparaciones son bivariadas, así que en la sección 4 verificamos qué efectos se mantienen al controlar por las demás variables.
