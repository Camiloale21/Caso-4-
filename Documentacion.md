# Documentación del Caso 4

*Responsable: Camilo Alejandro Hernández Moreno*

## 1. Fuentes

| Documento | Ubicación |
|---|---|
| Enunciado: *Predicting Customer Churn at QWE Inc.* (Darden UV6694, A. Ovchinnikov, 2013) | Repositorio del curso: [`Cases/Predicting _Customer_Churn/Predicting_Customer_Churn.pdf`](https://github.com/Nicolas-Velasquez-Oficial/business-analytics-2026-3/tree/main/Cases) |
| Datos del caso (`DATA.xlsx`, hoja *Case Data*) | `02_Datos/Datos_originales/DATA.xlsx` (copia del repositorio del curso) |
| Marco teórico: modelos de probabilidad lineal y regresión logística | Clase 8, *Modelos REG probabilidad* (`Lectures/08-MRL&Bayes`) |
| Pruebas de hipótesis e intervalos de confianza | Clase 4 (`Lectures/04-hypothesis_proofs`) |
| Política de uso de IA y evaluación | `Syllabus/Syllabus_Analitica_2026-3.pdf` |

El PDF del enunciado no se copia en este repositorio porque es material con derechos de Darden Business Publishing; se enlaza al repositorio del curso. Por la misma razón, se recomienda que este repositorio sea **privado**, con el profesor como colaborador.

## 2. Análisis del enunciado

El caso no trae preguntas numeradas. Los requerimientos se derivan de lo que Richard Wall le pide a V. J. Aggrawal y de las hipótesis que plantea en la conversación:

| # | Requisito | Origen en el enunciado | Dónde se resuelve |
|---|---|---|---|
| R1 | Estimar la probabilidad de que cada cliente abandone en los **dos meses siguientes** a partir de sus características actuales | p. 1: «use current characteristics to determine probability of churn within two months» | Script 03, Informe §4 |
| R2 | Entregar la lista de los **100 clientes con mayor probabilidad** de abandono | p. 1: «generate a list of the 100 customers who were most likely to leave» | Script 04, T11, Informe §5 |
| R3 | Identificar, si es posible, **los tres factores que más contribuyen** a esa probabilidad | p. 1: «the three factors contributing most to that likelihood» | Script 04, T11–T12, Informe §5 |
| R4 | Contrastar la hipótesis de **antigüedad**: < 6 meses incierto, 6–14 meses el grupo más riesgoso, > 14 meses menos riesgo | p. 2, conversación Wall–Aggrawal | Script 02, T02–T03, G01–G02, Informe §3.1 |
| R5 | Contrastar la hipótesis de **felicidad**: CHI alto → menos abandono; CHI bajo o en caída → más abandono | p. 2 | Scripts 02 y 03, T04, T07 |
| R6 | Contrastar la hipótesis de **servicio**: muchos casos o alta prioridad → más abandono | p. 2 | Scripts 02 y 03, T04, T07 |
| R7 | Contrastar la hipótesis de **uso**: más logins, blogs y vistas → menos abandono | p. 2 | Scripts 02 y 03, T04, T07 |
| R8 | Usar los datos de valor en el mes 0 y del cambio entre noviembre y diciembre | p. 2–3 | Script 01 (todas las variables) |
| R9 | Aplicar los métodos de la asignatura: modelos de probabilidad (MPL y logit), pruebas de hipótesis, R | Sílabo, semana 16; Clase 8 | Scripts 02–03 |
| R10 | Proyecto en equipos de 2, con sustentación oral | Sílabo, evaluación | Este repositorio, plan de commits |
| R11 | Nota breve sobre dónde y cómo se usó IA | Sílabo, «Divulgación» | Informe final y README |

## 3. Diccionario de datos

| Columna original | Nombre en R | Tipo | Descripción |
|---|---|---|---|
| ID | `id` | entero | Identificador del cliente |
| Customer Age (in months) | `edad` | entero | Meses como cliente al 1-dic-2011 |
| Churn (1 = Yes, 0 = No) | `churn` | binaria | Abandonó entre el 1-dic-2011 y febrero de 2012 |
| CHI Score Month 0 | `chi_0` | entero | Customer Happiness Index en diciembre |
| CHI Score 0-1 | `chi_var` | entero | Cambio del CHI de noviembre a diciembre |
| Support Cases Month 0 | `casos_0` | entero | Casos de soporte en diciembre |
| Support Cases 0-1 | `casos_var` | entero | Cambio en casos de soporte |
| SP Month 0 | `prioridad_0` | decimal | Prioridad promedio de soporte en diciembre |
| SP 0-1 | `prioridad_var` | entero | Cambio en prioridad de soporte |
| Logins 0-1 | `logins_var` | entero | Cambio en inicios de sesión |
| Blog Articles 0-1 | `blogs_var` | entero | Cambio en artículos de blog |
| Views 0-1 | `vistas_var` | entero | Cambio en vistas |
| Days Since Last Login 0-1 | `dias_ult_login_var` | entero | Cambio en días desde el último inicio de sesión |
| — (creada) | `segmento_edad` | factor | `Menos_6` (0–5), `6_a_14`, `Mas_14` |
| — (creada) | `muestra` | texto | `prueba` si `id` es múltiplo de 5; si no, `entrenamiento` |

## 4. Decisiones metodológicas

1. **Base completa (6.347 clientes)** aunque el texto diga 6.000: es el archivo oficial del caso y no tiene faltantes ni duplicados.
2. **Segmentos de antigüedad de Wall** en lugar de la edad lineal: la tasa de abandono por mes no es lineal (pico en el mes 12) y los segmentos reducen el AIC y mejoran el AUC fuera de muestra.
3. **Partición 80/20 sistemática por ID** en lugar de `sample()`: es reproducible sin semilla y deja tasas de abandono equilibradas.
4. **Logit sobre MPL:** el MPL produce probabilidades negativas (219 casos) y tiene un R² muy bajo.
5. **Modelo final re-estimado con toda la base** después de validar fuera de muestra, para aprovechar toda la información en la lista de 100.
6. **Factores por cliente:** contribución $\beta_j(x_{ij}-\bar{x}_j)$ al log-odds, usando solo variables significativas al 10 %.
7. **Umbral de clasificación = tasa base de entrenamiento** para la matriz de confusión, porque el abandono es raro y un umbral de 0,5 no clasificaría a casi nadie como riesgoso.
8. **No se eliminaron valores extremos** de las variables de uso: son observaciones reales y no hay evidencia de error de captura.

## 5. Distribución del trabajo

| Integrante | Responsabilidades |
|---|---|
| Camilo Alejandro Hernández Moreno | Estructura del repositorio, documentación, limpieza y validación de datos (script 01), análisis exploratorio y pruebas de hipótesis (script 02), secciones 1–3 del informe y resumen ejecutivo, README final |
| Sofía Castiblanco Aguilera | Modelos MPL y logit y su comparación (script 03), resultados para la gerencia: matriz de confusión, lift, lista de 100 y factores (script 04), secciones 4–7 del informe, anexos, script de ejecución completa y revisión final de reproducibilidad |
