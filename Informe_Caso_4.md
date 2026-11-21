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

# 4. Modelos de probabilidad de abandono

*Responsable: Sofía Castiblanco Aguilera — script `03_Modelamiento.R`.*

## 4.1 Especificaciones

Incluimos las once variables que Wall sugiere y que Aggrawal extrajo. Estimamos tres modelos con la muestra de entrenamiento:

* **M1 — Modelo de probabilidad lineal (MPL):** MCO de `churn` sobre la edad (lineal) y las diez variables de CHI, soporte y uso.
* **M2 — Regresión logística** con las mismas variables.
* **M3 — Regresión logística con segmentos de antigüedad** (base: menos de 6 meses) en lugar de la edad lineal, motivada por la relación no lineal de la sección 3.

## 4.2 Comparación y elección

| Modelo | AIC (entrenamiento) | AUC (prueba) | Predicciones fuera de [0, 1] |
|---|---:|---:|---:|
| M1 MPL | — | 0,634 | 219 |
| M2 Logit, edad lineal | 1.985,3 | 0,640 | 0 |
| M3 Logit, segmentos | **1.881,6** | **0,678** | 0 |

![Curvas ROC en la muestra de prueba](../04_Resultados/Graficos/G03_curvas_roc_prueba.png){width=75%}

* **El MPL no es adecuado:** predice 219 «probabilidades» negativas (la mínima es −0,54) y su R² es de apenas 0,017. Es la limitación que vimos en clase y la razón para usar un modelo logístico.
* **M3 domina a M2:** tiene un AIC 104 puntos menor y un mejor AUC en clientes que el modelo no vio (0,678 frente a 0,640). Por tanto, elegimos M3 y lo **re-estimamos con los 6.347 clientes** para producir la lista final.

Un AUC de 0,68 indica capacidad de discriminación moderada: es poco probable predecir con certeza quién se irá, pero el modelo sí sirve para **priorizar**, que es lo que Wall necesita (sección 5).

## 4.3 Modelo final (logit M3, base completa)

| Variable | Coeficiente | p-valor | Odds ratio | Interpretación |
|---|---:|---:|---:|---|
| Antigüedad 6–14 meses | 2,152 | < 0,001 | 8,60 | Odds 8,6 veces las de un cliente de menos de 6 meses |
| Antigüedad > 14 meses | 1,876 | < 0,001 | 6,53 | Odds 6,5 veces las de un cliente de menos de 6 meses |
| CHI mes 0 | −0,0096 | < 0,001 | 0,990 | +10 puntos de CHI → odds −9,2 % |
| Cambio CHI | −0,0048 | 0,056 | 0,995 | +10 puntos de mejora → odds −4,7 % (significativo al 10 %) |
| Cambio de vistas | −0,00011 | 0,009 | 0,9999 | 1.000 vistas menos → odds +11,5 % |
| Cambio de días desde último login | 0,0072 | 0,030 | 1,007 | +10 días sin login → odds +7,4 % |
| Casos, prioridad, logins, blogs | — | > 0,11 | — | No significativos |

Intercepto: −3,840. Tabla completa en T07 y en los anexos.

Al controlar por las demás variables, **los factores que siguen siendo relevantes son la antigüedad, el nivel de CHI, la caída del CHI, la caída de vistas y la desconexión (más días sin iniciar sesión)**. Las variables de soporte, logins y blogs pierden significancia porque su información ya está recogida por el CHI y las otras variables de uso.

## 4.4 Desempeño como clasificador

*Responsable: Sofía Castiblanco Aguilera — script `04_Resultados.R`.*

Para medir el desempeño en la muestra de prueba usamos el modelo M3 de entrenamiento. Marcamos como «en riesgo» a todo cliente con probabilidad mayor que la tasa de entrenamiento (5,14 %), es decir, más riesgoso que un cliente promedio:

| | Predicho: se queda | Predicho: abandona |
|---|---:|---:|
| **Real: se queda** | 798 | 409 |
| **Real: abandona** | 28 | 34 |

El modelo identifica el 54,8 % de los abandonos (sensibilidad) y descarta correctamente el 66,1 % de los clientes que se quedan (especificidad). La precisión (7,7 %) parece baja, pero hay que compararla con la tasa base de 4,9 %. Como el abandono es un evento poco frecuente, la exactitud global (65,6 %) no es una buena medida; lo relevante para Wall es la priorización.

# 5. Los 100 clientes con mayor riesgo y sus tres factores

*Responsable: Sofía Castiblanco Aguilera — script `04_Resultados.R`.*

## 5.1 Capacidad de priorización

![Tasa real de abandono por decil de riesgo](../04_Resultados/Graficos/G04_lift_deciles.png){width=80%}

Ordenamos a los clientes por probabilidad estimada y los agrupamos en deciles. En el **decil 1** (10 % de mayor riesgo) la tasa real de abandono es de 17,0 %, 3,3 veces la tasa base, y ese decil **concentra el 33,4 % de todos los abandonos**. Los dos primeros deciles concentran el 49,2 %. En el decil 10 la tasa es de 1,7 %.

## 5.2 Cómo se identifican los tres factores

En el logit, el logaritmo de las odds es una suma de términos $\beta_j x_j$. Para cada cliente $i$ calculamos la **contribución** de cada factor frente a un cliente promedio, $\beta_j (x_{ij} - \bar{x}_j)$. Una contribución positiva indica que ese factor eleva el riesgo de ese cliente. Los tres factores son las tres contribuciones positivas más grandes. Solo usamos factores con efecto significativo al 10 % (antigüedad, CHI mes 0, cambio de CHI, cambio de vistas y cambio de días desde el último login) para no recomendar acciones sobre efectos que podrían ser ruido. La etiqueta «(alto)» o «(bajo)» indica si el cliente está por encima o por debajo del promedio en esa variable. Para unos pocos clientes solo dos factores elevan el riesgo, así que el tercero queda vacío.

## 5.3 Resultado

La lista completa está en `04_Resultados/Tablas/T11_top100_clientes_riesgo.csv` y en los anexos. Los diez primeros son:

| # | ID | Antigüedad | Prob. | Factor 1 | Factor 2 | Factor 3 |
|---:|---:|---:|---:|---|---|---|
| 1 | 357 | 12 | 37,2 % | Cambio vistas (bajo) | Antigüedad 6–14 | Días sin login (alto) |
| 2 | 929 | 11 | 29,7 % | Cambio vistas (bajo) | Antigüedad 6–14 | — |
| 3 | 2287 | 34 | 26,2 % | Cambio vistas (bajo) | Antigüedad > 14 | — |
| 4 | 3604 | 9 | 23,3 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio CHI (bajo) |
| 5 | 335 | 12 | 22,4 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio CHI (bajo) |
| 6 | 4680 | 6 | 22,0 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio vistas (bajo) |
| 7 | 299 | 14 | 21,9 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio CHI (bajo) |
| 8 | 3671 | 10 | 21,9 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio CHI (bajo) |
| 9 | 109 | 40 | 21,4 % | CHI mes 0 (bajo) | Cambio CHI (bajo) | Antigüedad > 14 |
| 10 | 3569 | 9 | 21,2 % | CHI mes 0 (bajo) | Antigüedad 6–14 | Cambio CHI (bajo) |

![Factores más frecuentes en la lista](../04_Resultados/Graficos/G05_factores_top100.png){width=80%}

* Las probabilidades de la lista van de 18,8 % a 37,2 %. Hay 96 clientes de 6 a 14 meses y 4 de más de 14.
* **29 de los 100 clientes abandonaron realmente**: una tasa 5,7 veces la base (5,1 %). Si Wall hubiera llamado a 100 clientes al azar, habría encontrado unos 5.
* Factores más frecuentes entre los tres principales: antigüedad (100 clientes), CHI bajo en el mes 0 (97, y es el factor n.° 1 en 96 casos), aumento de días sin iniciar sesión (78), caída del CHI (18) y caída de vistas (5).

# 6. Conclusiones y recomendaciones

1. **Priorizar con el modelo, no con intuición.** Contactar a los 100 clientes de la lista reduce el esfuerzo a 1,6 % de la base y multiplica por casi seis la probabilidad de encontrar a alguien que está por irse.
2. **Actuar sobre la felicidad del cliente.** El CHI bajo es el factor principal en casi toda la lista. La intervención debe ser de servicio (acompañamiento, capacitación, revisión de la cuenta) y no un descuento, como pretendía Wall desde el principio.
3. **Gestionar los vencimientos de contrato.** El pico del mes 12 (y el salto del mes 6) indica que el contacto debe hacerse **antes** de la fecha de renovación. Se sugiere un protocolo de renovación desde el mes 10.
4. **Vigilar la desconexión.** El aumento de días sin iniciar sesión y la caída de vistas son señales tempranas y baratas de monitorear. Pueden activar alertas automáticas.
5. **Reorientar la lectura del soporte.** Abrir casos de soporte no indica riesgo; en la comparación simple, quienes abren casos abandonan *menos*. No conviene usar el número de casos como alarma.

# 7. Limitaciones

* **Datos de un solo corte.** El modelo se estimó con datos del 1 de diciembre de 2011 y se aplicó a los mismos clientes para construir la lista. En la operación habría que aplicar los coeficientes a los datos *actuales* de cada cliente y re-estimar el modelo periódicamente.
* **Poder predictivo moderado** (AUC 0,68). Faltan variables que podrían mejorar el modelo, como el tipo de contrato (mensual, 6 o 12 meses), los meses que faltan para la renovación o el valor del cliente. La base de QWE tiene más de 230 campos.
* **Asociación, no causalidad.** Los coeficientes describen asociaciones. Que un CHI bajo prediga abandono no garantiza que subir el CHI lo evite; convendría validarlo con un experimento (prueba A/B de la intervención de retención).
* **Valores extremos** en las variables de uso (vistas, logins). Hacen que el efecto por unidad sea pequeño y pueden influir en algunos clientes de la lista (por ejemplo, el n.° 1, con una caída grande de vistas).

# Nota sobre el uso de inteligencia artificial

Conforme a la política de la asignatura, declaramos que usamos un asistente de IA (Claude, de Anthropic) como apoyo en este trabajo. La IA nos ayudó a generar el código en R, a organizar la estructura del repositorio y a redactar un primer borrador del informe, incluida una propuesta inicial de análisis y de interpretación de los resultados.

Como equipo, ejecutamos el código en R y verificamos que las cifras del informe coincidieran con nuestras salidas. También revisamos y discutimos cada decisión metodológica: los segmentos de antigüedad, el uso del logit en lugar del modelo de probabilidad lineal, la validación fuera de muestra y el cálculo de los tres factores por cliente. Ajustamos la redacción y las conclusiones según nuestro criterio. Asumimos la responsabilidad por la elección del método, la interpretación de los resultados y las conclusiones, y estamos en capacidad de sustentarlos sin apoyo de la IA.
