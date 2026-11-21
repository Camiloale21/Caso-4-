# =============================================================================
# CASO 4 - Predicting Customer Churn at QWE Inc.
# Script 00: Ejecuta todo el analisis en orden
# -----------------------------------------------------------------------------
# Uso: abrir CASO_4_ANALITICA.Rproj en RStudio y ejecutar
#      source("03_Codigo_R/00_Ejecutar_Todo.R")
# =============================================================================

# Instala los paquetes que falten (solo la primera vez)
paquetes <- c("readxl", "dplyr", "ggplot2")
faltantes <- paquetes[!paquetes %in% rownames(installed.packages())]
if (length(faltantes) > 0) install.packages(faltantes)

# Verifica que el directorio de trabajo sea la raiz del repositorio
if (!dir.exists("03_Codigo_R")) {
  stop("El directorio de trabajo debe ser la raiz del repositorio (donde esta README.md).")
}

scripts <- c("01_Limpieza_Datos.R", "02_Analisis_Exploratorio.R",
             "03_Modelamiento.R", "04_Resultados.R")
for (s in scripts) {
  cat("\n==============================\nEjecutando", s, "\n==============================\n")
  source(file.path("03_Codigo_R", s), echo = FALSE, encoding = "UTF-8")
}
cat("\nListo: todas las tablas y graficos estan en 04_Resultados/.\n")
