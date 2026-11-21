# =============================================================================
# CASO 4 - Predicting Customer Churn at QWE Inc.
# Script 03: Modelos de probabilidad de abandono
# Responsable: Sofía Castiblanco Aguilera
# -----------------------------------------------------------------------------
# Modelos estimados (variables sugeridas por Richard Wall en el caso):
#   M1. Modelo de Probabilidad Lineal (MPL, MCO) con edad lineal
#   M2. Regresion logistica con edad lineal
#   M3. Regresion logistica con segmentos de antiguedad (<6, 6-14, >14 meses)
# Los tres se estiman con la muestra de entrenamiento (80%) y se evaluan en
# la muestra de prueba (20%). El modelo elegido se re-estima con toda la base.
# Entrada : 02_Datos/Datos_procesados/qwe_churn_limpio.csv
# Salidas : 04_Resultados/Tablas/T05 a T08, 04_Resultados/Graficos/G03
#           02_Datos/Datos_procesados/modelos.rds (insumo del script 04)
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

ruta_datos   <- file.path("02_Datos", "Datos_procesados", "qwe_churn_limpio.csv")
ruta_modelos <- file.path("02_Datos", "Datos_procesados", "modelos.rds")
dir_tablas   <- file.path("04_Resultados", "Tablas")
dir_graf     <- file.path("04_Resultados", "Graficos")
if (!file.exists(ruta_datos)) stop("Ejecute primero 01_Limpieza_Datos.R")
dir.create(dir_tablas, recursive = TRUE, showWarnings = FALSE)
dir.create(dir_graf,   recursive = TRUE, showWarnings = FALSE)

datos <- read.csv(ruta_datos)
datos$segmento_edad <- factor(datos$segmento_edad,
                              levels = c("Menos_6", "6_a_14", "Mas_14"))

entrenamiento <- subset(datos, muestra == "entrenamiento")
prueba        <- subset(datos, muestra == "prueba")
cat("Entrenamiento:", nrow(entrenamiento), "clientes | Prueba:", nrow(prueba), "\n")

# --- 1. Especificaciones ------------------------------------------------------
vars_base <- c("chi_0", "chi_var", "casos_0", "casos_var", "prioridad_0",
               "prioridad_var", "logins_var", "blogs_var", "vistas_var",
               "dias_ult_login_var")
f_lineal <- as.formula(paste("churn ~ edad +",          paste(vars_base, collapse = " + ")))
f_seg    <- as.formula(paste("churn ~ segmento_edad +", paste(vars_base, collapse = " + ")))

# --- 2. Funciones auxiliares --------------------------------------------------
# Tabla de coeficientes (sirve para lm y glm)
tabla_coef <- function(modelo) {
  s <- summary(modelo)$coefficients
  data.frame(termino        = rownames(s),
             coeficiente    = s[, 1],
             error_estandar = s[, 2],
             estadistico    = s[, 3],
             p_valor        = s[, 4],
             row.names      = NULL)
}
# AUC (area bajo la curva ROC) mediante el estadistico de Mann-Whitney
calcular_auc <- function(y, p) {
  r  <- rank(p)
  n1 <- sum(y == 1)
  n0 <- sum(y == 0)
  (sum(r[y == 1]) - n1 * (n1 + 1) / 2) / (n1 * n0)
}
# Puntos de la curva ROC
curva_roc <- function(y, p, nombre) {
  umbrales <- sort(unique(p), decreasing = TRUE)
  data.frame(modelo = nombre,
             fpr = c(0, sapply(umbrales, function(u) mean(p[y == 0] >= u)), 1),
             tpr = c(0, sapply(umbrales, function(u) mean(p[y == 1] >= u)), 1))
}

# --- 3. Estimacion con la muestra de entrenamiento ----------------------------
m1_mpl    <- lm(f_lineal, data = entrenamiento)
m2_logit  <- glm(f_lineal, data = entrenamiento, family = binomial)
m3_logseg <- glm(f_seg,    data = entrenamiento, family = binomial)

print(summary(m1_mpl))
print(summary(m2_logit))
print(summary(m3_logseg))

write.csv(tabla_coef(m1_mpl),   file.path(dir_tablas, "T05_coeficientes_MPL.csv"),
          row.names = FALSE)
write.csv(tabla_coef(m2_logit), file.path(dir_tablas, "T06_coeficientes_logit_edad_lineal.csv"),
          row.names = FALSE)

# --- 4. Evaluacion fuera de muestra -------------------------------------------
p1 <- predict(m1_mpl,    newdata = prueba)
p2 <- predict(m2_logit,  newdata = prueba, type = "response")
p3 <- predict(m3_logseg, newdata = prueba, type = "response")

# Limitacion del MPL: predicciones fuera de [0, 1] en la base completa
p1_total <- predict(m1_mpl, newdata = datos)

comparacion <- data.frame(
  modelo = c("M1 MPL (edad lineal)", "M2 Logit (edad lineal)",
             "M3 Logit (segmentos de edad)"),
  AIC_entrenamiento = c(NA, AIC(m2_logit), AIC(m3_logseg)),
  AUC_prueba = c(calcular_auc(prueba$churn, p1),
                 calcular_auc(prueba$churn, p2),
                 calcular_auc(prueba$churn, p3)),
  predicciones_fuera_0_1 = c(sum(p1_total < 0 | p1_total > 1), 0, 0)
)
print(comparacion)
write.csv(comparacion, file.path(dir_tablas, "T08_comparacion_modelos.csv"),
          row.names = FALSE)

# --- G03. Curvas ROC en la muestra de prueba ----------------------------------
roc <- rbind(curva_roc(prueba$churn, p1, "M1 MPL"),
             curva_roc(prueba$churn, p2, "M2 Logit edad lineal"),
             curva_roc(prueba$churn, p3, "M3 Logit segmentos"))
g3 <- ggplot(roc, aes(x = fpr, y = tpr, colour = modelo)) +
  geom_line(linewidth = 0.8) +
  geom_abline(linetype = "dashed", colour = "grey50") +
  labs(title = "Curvas ROC en la muestra de prueba (20%)",
       x = "Tasa de falsos positivos", y = "Tasa de verdaderos positivos",
       colour = "Modelo") +
  theme_minimal()
ggsave(file.path(dir_graf, "G03_curvas_roc_prueba.png"), g3,
       width = 7, height = 5, dpi = 300)

# --- 5. Modelo final: M3 re-estimado con toda la base -------------------------
# Se elige M3 por menor AIC y mayor AUC fuera de muestra (ver T08).
modelo_final <- glm(f_seg, data = datos, family = binomial)
print(summary(modelo_final))

coef_final <- tabla_coef(modelo_final)
ic <- confint.default(modelo_final)            # IC 95% de Wald
coef_final$odds_ratio  <- exp(coef_final$coeficiente)
coef_final$or_ic95_inf <- exp(ic[, 1])
coef_final$or_ic95_sup <- exp(ic[, 2])
write.csv(coef_final, file.path(dir_tablas, "T07_coeficientes_logit_final.csv"),
          row.names = FALSE)

saveRDS(list(modelo_final = modelo_final, m3_entrenamiento = m3_logseg),
        ruta_modelos)
cat("Modelos guardados en:", ruta_modelos, "\n")
