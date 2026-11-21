# =============================================================================
# CASO 4 - Predicting Customer Churn at QWE Inc.
# Script 02: Analisis exploratorio y contraste de las hipotesis de Richard Wall
# Responsable: Camilo Alejandro Hernández Moreno
# -----------------------------------------------------------------------------
# Entrada : 02_Datos/Datos_procesados/qwe_churn_limpio.csv
# Salidas : 04_Resultados/Tablas/T01 a T04
#           04_Resultados/Graficos/G01 y G02
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

ruta_datos <- file.path("02_Datos", "Datos_procesados", "qwe_churn_limpio.csv")
dir_tablas <- file.path("04_Resultados", "Tablas")
dir_graf   <- file.path("04_Resultados", "Graficos")
if (!file.exists(ruta_datos)) stop("Ejecute primero 01_Limpieza_Datos.R")
dir.create(dir_tablas, recursive = TRUE, showWarnings = FALSE)
dir.create(dir_graf,   recursive = TRUE, showWarnings = FALSE)

datos <- read.csv(ruta_datos)
datos$segmento_edad <- factor(datos$segmento_edad,
                              levels = c("Menos_6", "6_a_14", "Mas_14"))

vars_num <- c("edad", "chi_0", "chi_var", "casos_0", "casos_var",
              "prioridad_0", "prioridad_var", "logins_var", "blogs_var",
              "vistas_var", "dias_ult_login_var")

# --- T01. Estadisticos descriptivos -------------------------------------------
resumen <- data.frame(
  variable = vars_num,
  media    = sapply(datos[vars_num], mean),
  de       = sapply(datos[vars_num], sd),
  minimo   = sapply(datos[vars_num], min),
  p25      = sapply(datos[vars_num], quantile, probs = 0.25),
  mediana  = sapply(datos[vars_num], median),
  p75      = sapply(datos[vars_num], quantile, probs = 0.75),
  maximo   = sapply(datos[vars_num], max),
  row.names = NULL
)
write.csv(resumen, file.path(dir_tablas, "T01_resumen_descriptivo.csv"),
          row.names = FALSE)
cat("Tasa global de abandono:", round(mean(datos$churn), 4),
    "(", sum(datos$churn), "de", nrow(datos), "clientes )\n")

# --- T02. Tasa de abandono por segmento de antiguedad (hipotesis de Wall) -----
tabla_seg <- datos %>%
  group_by(segmento_edad) %>%
  summarise(clientes  = n(),
            abandonos = sum(churn),
            tasa      = mean(churn),
            .groups   = "drop") %>%
  mutate(ee     = sqrt(tasa * (1 - tasa) / clientes),   # error estandar
         ic_inf = tasa - qnorm(0.975) * ee,              # IC 95% (Wald)
         ic_sup = tasa + qnorm(0.975) * ee)
print(tabla_seg)
write.csv(tabla_seg, file.path(dir_tablas, "T02_churn_por_segmento_edad.csv"),
          row.names = FALSE)

# --- T03. Pruebas de hipotesis sobre la antiguedad ----------------------------
# H0 global: la tasa de abandono es igual en los tres segmentos (chi-cuadrado).
tab <- table(datos$segmento_edad, datos$churn)
chi <- chisq.test(tab, correct = FALSE)

# Comparaciones por pares (prueba de diferencia de proporciones).
pares <- list(c("6_a_14", "Menos_6"), c("6_a_14", "Mas_14"), c("Mas_14", "Menos_6"))
pruebas_pares <- do.call(rbind, lapply(pares, function(p) {
  sub <- tabla_seg[match(p, tabla_seg$segmento_edad), ]
  pt  <- prop.test(x = sub$abandonos, n = sub$clientes)
  data.frame(prueba      = paste("Proporciones:", p[1], "vs", p[2]),
             estadistico = unname(pt$statistic),
             gl          = unname(pt$parameter),
             p_valor     = pt$p.value)
}))
pruebas_edad <- rbind(
  data.frame(prueba      = "Chi-cuadrado de independencia (3 segmentos)",
             estadistico = unname(chi$statistic),
             gl          = unname(chi$parameter),
             p_valor     = chi$p.value),
  pruebas_pares
)
print(pruebas_edad)
write.csv(pruebas_edad, file.path(dir_tablas, "T03_pruebas_hipotesis_edad.csv"),
          row.names = FALSE)

# --- T04. Clientes que abandonan vs. que permanecen (otras hipotesis de Wall) --
# Prueba t de Welch (no asume varianzas iguales) para cada variable.
comparacion <- do.call(rbind, lapply(vars_num, function(v) {
  x1 <- datos[[v]][datos$churn == 1]
  x0 <- datos[[v]][datos$churn == 0]
  tt <- t.test(x1, x0)
  data.frame(variable       = v,
             media_churn    = mean(x1),
             media_no_churn = mean(x0),
             diferencia     = mean(x1) - mean(x0),
             t              = unname(tt$statistic),
             p_valor        = tt$p.value)
}))
print(comparacion)
write.csv(comparacion, file.path(dir_tablas, "T04_comparacion_medias_churn.csv"),
          row.names = FALSE)

# --- G01. Tasa de abandono por mes de antiguedad ------------------------------
# Solo meses con al menos 30 clientes para que la tasa sea estable.
por_mes <- datos %>%
  group_by(edad, segmento_edad) %>%
  summarise(clientes = n(), tasa = mean(churn), .groups = "drop") %>%
  filter(clientes >= 30)

g1 <- ggplot(por_mes, aes(x = edad, y = tasa, fill = segmento_edad)) +
  geom_col() +
  geom_hline(yintercept = mean(datos$churn), linetype = "dashed") +
  scale_y_continuous(labels = function(x) paste0(round(100 * x), "%")) +
  scale_fill_manual(values = c("#9ecae1", "#08519c", "#6baed6"),
                    labels = c("Menos de 6", "6 a 14", "Mas de 14")) +
  labs(title = "Tasa de abandono por antiguedad del cliente",
       subtitle = "Linea punteada: tasa global (5,1%). Meses con 30 o mas clientes.",
       x = "Antiguedad (meses)", y = "Tasa de abandono",
       fill = "Segmento (meses)") +
  theme_minimal()
ggsave(file.path(dir_graf, "G01_churn_por_edad_meses.png"), g1,
       width = 8, height = 4.5, dpi = 300)

# --- G02. Tasa de abandono por segmento con IC 95% ----------------------------
g2 <- ggplot(tabla_seg, aes(x = segmento_edad, y = tasa)) +
  geom_col(fill = "#08519c", width = 0.6) +
  geom_errorbar(aes(ymin = ic_inf, ymax = ic_sup), width = 0.15) +
  geom_text(aes(label = paste0(round(100 * tasa, 1), "%")), vjust = -1.2) +
  scale_x_discrete(labels = c("Menos de 6", "6 a 14", "Mas de 14")) +
  scale_y_continuous(labels = function(x) paste0(round(100 * x), "%"),
                     limits = c(0, 0.10)) +
  labs(title = "Tasa de abandono por segmento de antiguedad",
       subtitle = "Barras de error: intervalo de confianza del 95%",
       x = "Antiguedad (meses)", y = "Tasa de abandono") +
  theme_minimal()
ggsave(file.path(dir_graf, "G02_churn_por_segmento.png"), g2,
       width = 6, height = 4.5, dpi = 300)

cat("Analisis exploratorio terminado.\n")
