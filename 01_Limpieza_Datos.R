# =============================================================================
# CASO 4 - Predicting Customer Churn at QWE Inc.
# Script 01: Carga, validacion y limpieza de datos
# Responsable: Camilo Alejandro Hernández Moreno
# -----------------------------------------------------------------------------
# Entrada : 02_Datos/Datos_originales/DATA.xlsx (hoja "Case Data")
# Salida  : 02_Datos/Datos_procesados/qwe_churn_limpio.csv
# Ejecutar con el directorio de trabajo en la raiz del repositorio
# (abrir CASO_4_ANALITICA.Rproj en RStudio lo hace automaticamente).
# =============================================================================

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
})

# --- 1. Rutas -----------------------------------------------------------------
ruta_original  <- file.path("02_Datos", "Datos_originales", "DATA.xlsx")
ruta_procesada <- file.path("02_Datos", "Datos_procesados", "qwe_churn_limpio.csv")

if (!file.exists(ruta_original)) {
  stop("No se encuentra ", ruta_original,
       ". Abra CASO_4_ANALITICA.Rproj o use setwd() en la raiz del repositorio.")
}

# --- 2. Lectura ---------------------------------------------------------------
# El libro de Excel tiene una hoja de portada y hojas ocultas de StatTools;
# los datos del caso estan unicamente en la hoja "Case Data".
datos_raw <- read_excel(ruta_original, sheet = "Case Data")
stopifnot(ncol(datos_raw) == 13)

# --- 3. Nombres de variables en espanol, cortos y sin espacios ----------------
# Convencion del caso: "Month 0" = valor al 1 de diciembre de 2011;
# "0-1" = cambio entre noviembre (mes 1) y diciembre (mes 0).
names(datos_raw) <- c(
  "id",                  # ID del cliente
  "edad",                # Customer Age (meses como cliente)
  "churn",               # 1 = abandono en los dos meses siguientes, 0 = no
  "chi_0",               # Customer Happiness Index en el mes 0
  "chi_var",             # Cambio del CHI (mes 0 - mes 1)
  "casos_0",             # Casos de soporte en el mes 0
  "casos_var",           # Cambio en casos de soporte
  "prioridad_0",         # Prioridad promedio de soporte (SP) en el mes 0
  "prioridad_var",       # Cambio en la prioridad de soporte
  "logins_var",          # Cambio en numero de logins
  "blogs_var",           # Cambio en articulos de blog
  "vistas_var",          # Cambio en vistas
  "dias_ult_login_var"   # Cambio en dias desde el ultimo login
)

# --- 4. Validaciones de calidad -----------------------------------------------
cat("Filas leidas:", nrow(datos_raw), "\n")
cat("Valores faltantes:", sum(is.na(datos_raw)), "\n")
cat("IDs duplicados:", sum(duplicated(datos_raw$id)), "\n")
stopifnot(sum(is.na(datos_raw)) == 0,
          !any(duplicated(datos_raw$id)),
          all(datos_raw$churn %in% c(0, 1)),
          all(datos_raw$edad >= 0))
# Nota: el enunciado menciona 6.000 clientes, pero el archivo contiene 6.347.
# Se trabaja con la totalidad del archivo entregado.

# --- 5. Variables derivadas ---------------------------------------------------
datos <- datos_raw %>%
  mutate(across(everything(), as.numeric)) %>%
  mutate(
    # Segmentos de antiguedad propuestos por Richard Wall en el caso:
    # menos de 6 meses (0-5), entre 6 y 14 meses, y mas de 14 meses.
    segmento_edad = cut(edad,
                        breaks = c(-Inf, 5, 14, Inf),
                        labels = c("Menos_6", "6_a_14", "Mas_14")),
    # Particion reproducible entrenamiento/prueba (80/20) sin aleatoriedad:
    # uno de cada cinco IDs va a prueba. Al ser un muestreo sistematico, el
    # resultado es identico en cualquier computador y version de R.
    muestra = ifelse(id %% 5 == 0, "prueba", "entrenamiento")
  )

# Verificacion de la particion: la tasa de abandono debe ser similar
print(datos %>% group_by(muestra) %>%
        summarise(clientes = n(), tasa_churn = mean(churn), .groups = "drop"))

# --- 6. Exportar --------------------------------------------------------------
dir.create(dirname(ruta_procesada), recursive = TRUE, showWarnings = FALSE)
write.csv(datos, ruta_procesada, row.names = FALSE)
cat("Base limpia guardada en:", ruta_procesada, "\n")
