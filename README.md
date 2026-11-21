# Caso 4 — Predicting Customer Churn at QWE Inc.

**Analítica de los Negocios 2026-3 · Pontificia Universidad Javeriana**
Profesor: Juan Nicolás Velásquez Rey

## Descripción del caso

QWE Inc. ofrece a pequeñas y medianas empresas un servicio de suscripción para gestionar su presencia en línea. Richard Wall, VP de servicio al cliente, quiere reemplazar la retención reactiva (ofrecer descuentos cuando el cliente ya llamó a cancelar) por una **proactiva**: estimar con anticipación qué clientes van a abandonar y por qué. Para eso cuenta con una muestra de **6.347 clientes** al 1 de diciembre de 2011, con su antigüedad, su índice de felicidad (CHI), su uso del soporte técnico, su actividad en la plataforma y si abandonaron o no en los dos meses siguientes.

## Objetivos

1. Estimar la probabilidad de abandono (*churn*) de cada cliente en los dos meses siguientes.
2. Entregar la lista de los **100 clientes con mayor probabilidad de abandono**.
3. Identificar **los tres factores que más contribuyen** al riesgo de cada uno de esos clientes.
4. Contrastar con datos las hipótesis de Wall sobre antigüedad, felicidad, soporte y uso.

## Integrantes

| Integrante | Rol principal |
|---|---|
| Camilo Alejandro Hernández Moreno | Datos, análisis exploratorio, pruebas de hipótesis, documentación |
| Sofía Castiblanco Aguilera | Modelos de probabilidad, evaluación, lista de 100 clientes y factores, anexos |

## Metodología

1. **Preparación de datos** (`01_Limpieza_Datos.R`): validación (sin faltantes ni duplicados), nombres en español, segmentos de antigüedad de Wall (< 6, 6–14, > 14 meses) y partición reproducible entrenamiento/prueba 80/20.
2. **Análisis exploratorio** (`02_Analisis_Exploratorio.R`): tasas de abandono con intervalos de confianza, prueba chi-cuadrado y pruebas de proporciones por segmento, y pruebas t de Welch entre quienes abandonan y quienes se quedan.
3. **Modelamiento** (`03_Modelamiento.R`): modelo de probabilidad lineal, logit con edad lineal y logit con segmentos de antigüedad. Comparación por AIC, AUC fuera de muestra y validez de las probabilidades. El modelo elegido se re-estima con toda la base.
4. **Resultados** (`04_Resultados.R`): matriz de confusión, lift por deciles, lista de los 100 clientes de mayor riesgo y descomposición de cada probabilidad en la contribución de cada factor.

## Tecnologías

* R (≥ 4.2) y RStudio
* Paquetes: `readxl`, `dplyr`, `ggplot2`
* Git y GitHub

## Estructura del repositorio

```
CASO_4_ANALITICA/
├── README.md
├── CASO_4_ANALITICA.Rproj          # Abre el proyecto con la raíz como directorio de trabajo
├── .gitignore
├── 01_Documentacion/
│   └── Documentacion.md            # Requisitos del caso, diccionario de datos, decisiones
├── 02_Datos/
│   ├── Datos_originales/DATA.xlsx  # Base del caso (sin modificar)
│   └── Datos_procesados/qwe_churn_limpio.csv
├── 03_Codigo_R/
│   ├── 00_Ejecutar_Todo.R          # Ejecuta los cuatro scripts en orden
│   ├── 01_Limpieza_Datos.R
│   ├── 02_Analisis_Exploratorio.R
│   ├── 03_Modelamiento.R
│   └── 04_Resultados.R
├── 04_Resultados/
│   ├── Tablas/                     # T01–T12 (.csv)
│   └── Graficos/                   # G01–G05 (.png)
├── 05_Informe_Final/
│   ├── Informe_Caso_4.md           # Informe (se lee directamente en GitHub)
│   └── Informe_Caso_4.pdf
└── 06_Anexos/
    └── Anexos.md                   # Tablas completas, lista de 100, valores de control
```

## Cómo ejecutar

1. Clonar el repositorio y abrir `CASO_4_ANALITICA.Rproj` en RStudio.
2. En la consola de R:
   ```r
   source("03_Codigo_R/00_Ejecutar_Todo.R")
   ```
   El script instala los paquetes que falten y ejecuta los cuatro scripts en orden (tarda menos de un minuto).
3. Las tablas y gráficos se regeneran en `04_Resultados/`. Los valores de control para verificar la ejecución están en `06_Anexos/Anexos.md` (sección A7).

Si no usa RStudio, fije el directorio de trabajo en la raíz del repositorio con `setwd()` antes de ejecutar.

## Entregables

| Entregable | Archivo |
|---|---|
| Informe final | `05_Informe_Final/Informe_Caso_4.md` y `.pdf` |
| Lista de 100 clientes con sus tres factores | `04_Resultados/Tablas/T11_top100_clientes_riesgo.csv` |
| Código reproducible en R | `03_Codigo_R/` |
| Tablas y gráficos | `04_Resultados/` |
| Documentación y anexos | `01_Documentacion/`, `06_Anexos/` |
