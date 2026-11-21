# =============================================================================
# CASO 4 - Predicting Customer Churn at QWE Inc.
# Script 04: Resultados para la gerencia
#   - Matriz de confusion en la muestra de prueba
#   - Lift por deciles de riesgo
#   - Lista de los 100 clientes con mayor probabilidad de abandono y los
#     tres factores que mas contribuyen a esa probabilidad (pedido de Wall)
# Responsable: Sofía Castiblanco Aguilera
# -----------------------------------------------------------------------------
# Entradas: 02_Datos/Datos_procesados/qwe_churn_limpio.csv y modelos.rds
# Salidas : 04_Resultados/Tablas/T09 a T12, 04_Resultados/Graficos/G04 y G05
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})

ruta_datos   <- file.path("02_Datos", "Datos_procesados", "qwe_churn_limpio.csv")
ruta_modelos <- file.path("02_Datos", "Datos_procesados", "modelos.rds")
dir_tablas   <- file.path("04_Resultados", "Tablas")
dir_graf     <- file.path("04_Resultados", "Graficos")
if (!file.exists(ruta_modelos)) stop("Ejecute primero 03_Modelamiento.R")

datos <- read.csv(ruta_datos)
datos$segmento_edad <- factor(datos$segmento_edad,
                              levels = c("Menos_6", "6_a_14", "Mas_14"))
modelos      <- readRDS(ruta_modelos)
modelo_final <- modelos$modelo_final
m3_entren    <- modelos$m3_entrenamiento

vars_base <- c("chi_0", "chi_var", "casos_0", "casos_var", "prioridad_0",
               "prioridad_var", "logins_var", "blogs_var", "vistas_var",
               "dias_ult_login_var")

# --- T09. Matriz de confusion (modelo M3 de entrenamiento, muestra de prueba) --
# Umbral = tasa de abandono de entrenamiento: se marca "en riesgo" a quien
# tiene una probabilidad mayor que la de un cliente promedio.
prueba <- subset(datos, muestra == "prueba")
umbral <- mean(datos$churn[datos$muestra == "entrenamiento"])
p_prueba <- predict(m3_entren, newdata = prueba, type = "response")
pred <- as.integer(p_prueba >= umbral)

vp <- sum(pred == 1 & prueba$churn == 1)   # verdaderos positivos
fn <- sum(pred == 0 & prueba$churn == 1)   # falsos negativos
fp <- sum(pred == 1 & prueba$churn == 0)   # falsos positivos
vn <- sum(pred == 0 & prueba$churn == 0)   # verdaderos negativos
matriz <- data.frame(
  indicador = c("Umbral de clasificacion", "Verdaderos positivos",
                "Falsos negativos", "Falsos positivos", "Verdaderos negativos",
                "Sensibilidad", "Especificidad", "Precision", "Exactitud"),
  valor = c(umbral, vp, fn, fp, vn, vp / (vp + fn), vn / (vn + fp),
            vp / (vp + fp), (vp + vn) / nrow(prueba))
)
print(matriz)
write.csv(matriz, file.path(dir_tablas, "T09_matriz_confusion_prueba.csv"),
          row.names = FALSE)

# --- Probabilidad estimada para toda la base con el modelo final -------------
datos$prob_churn <- predict(modelo_final, newdata = datos, type = "response")

# --- T10. Lift por deciles de riesgo ------------------------------------------
tasa_base <- mean(datos$churn)
rango <- rank(-datos$prob_churn, ties.method = "first")
datos$decil <- cut(rango, breaks = quantile(rango, probs = seq(0, 1, 0.1)),
                   include.lowest = TRUE, labels = 1:10)
lift <- datos %>%
  group_by(decil) %>%
  summarise(clientes = n(), abandonos = sum(churn), tasa = mean(churn),
            prob_media = mean(prob_churn), .groups = "drop") %>%
  mutate(lift = tasa / tasa_base,
         captura_acumulada = cumsum(abandonos) / sum(abandonos))
print(lift)
write.csv(lift, file.path(dir_tablas, "T10_lift_deciles.csv"), row.names = FALSE)

g4 <- ggplot(lift, aes(x = decil, y = tasa)) +
  geom_col(fill = "#08519c") +
  geom_hline(yintercept = tasa_base, linetype = "dashed") +
  geom_text(aes(label = paste0(round(100 * tasa, 1), "%")), vjust = -0.5, size = 3) +
  scale_y_continuous(labels = function(x) paste0(round(100 * x), "%")) +
  labs(title = "Tasa real de abandono por decil de riesgo estimado",
       subtitle = "Decil 1 = 10% de clientes con mayor probabilidad. Linea: tasa global.",
       x = "Decil de riesgo", y = "Tasa real de abandono") +
  theme_minimal()
ggsave(file.path(dir_graf, "G04_lift_deciles.png"), g4,
       width = 7, height = 4.5, dpi = 300)

# --- Contribucion de cada factor a la probabilidad de cada cliente ------------
# En el logit, log(p/(1-p)) = b0 + sum(b_j * x_j). La contribucion del factor j
# para el cliente i, frente a un cliente promedio, es b_j * (x_ij - media_j).
# Contribucion positiva = el factor eleva el riesgo de ese cliente.
# Solo se consideran factores con efecto significativo al 10% en el modelo
# final, para no recomendar acciones sobre efectos que podrian ser ruido.
b    <- coef(modelo_final)
pval <- summary(modelo_final)$coefficients[, 4]
X    <- model.matrix(modelo_final)
vars_factor <- vars_base[pval[vars_base] < 0.10]
cat("Factores significativos al 10%:", paste(vars_factor, collapse = ", "), "\n")

seg_logodds <- X[, "segmento_edad6_a_14"] * b["segmento_edad6_a_14"] +
               X[, "segmento_edadMas_14"] * b["segmento_edadMas_14"]
contrib <- data.frame(segmento_edad = unname(seg_logodds - mean(seg_logodds)))
for (v in vars_factor) {
  contrib[[v]] <- unname(b[v]) * (datos[[v]] - mean(datos[[v]]))
}

nombres <- c(chi_0 = "CHI mes 0", chi_var = "Cambio CHI",
             casos_0 = "Casos soporte mes 0", casos_var = "Cambio casos soporte",
             prioridad_0 = "Prioridad soporte mes 0",
             prioridad_var = "Cambio prioridad soporte",
             logins_var = "Cambio logins", blogs_var = "Cambio blogs",
             vistas_var = "Cambio vistas",
             dias_ult_login_var = "Cambio dias desde ultimo login")

# Etiqueta legible: nombre del factor + si el cliente esta por encima o por
# debajo del promedio en esa variable.
etiqueta_factor <- function(v, i) {
  if (v == "segmento_edad") {
    return(ifelse(datos$segmento_edad[i] == "6_a_14",
                  "Antiguedad 6-14 meses", "Antiguedad >14 meses"))
  }
  paste0(nombres[[v]],
         ifelse(datos[[v]][i] > mean(datos[[v]]), " (alto)", " (bajo)"))
}

# --- T11. Los 100 clientes con mayor probabilidad de abandono -----------------
idx_top <- order(datos$prob_churn, decreasing = TRUE)[1:100]
factores <- t(sapply(idx_top, function(i) {
  c_i <- unlist(contrib[i, ])
  c_i <- sort(c_i[c_i > 0], decreasing = TRUE)
  nm  <- names(c_i)[seq_len(min(3, length(c_i)))]
  et  <- vapply(nm, function(v) etiqueta_factor(v, i), character(1))
  c(unname(et), rep("", 3 - length(et)))
}))

top100 <- data.frame(
  ranking        = 1:100,
  id             = datos$id[idx_top],
  edad_meses     = datos$edad[idx_top],
  segmento_edad  = datos$segmento_edad[idx_top],
  prob_churn     = round(datos$prob_churn[idx_top], 4),
  factor_1       = factores[, 1],
  factor_2       = factores[, 2],
  factor_3       = factores[, 3],
  churn_observado = datos$churn[idx_top]
)
print(head(top100, 10))
write.csv(top100, file.path(dir_tablas, "T11_top100_clientes_riesgo.csv"),
          row.names = FALSE)
cat("De los 100 clientes de mayor riesgo,", sum(top100$churn_observado),
    "abandonaron realmente (tasa base:", round(100 * tasa_base, 1), "%).\n")

# --- T12. Frecuencia de cada factor entre los tres principales ----------------
# Se agrupa por factor (sin la direccion alto/bajo) para el resumen gerencial.
factor_base <- function(x) sub(" \\((alto|bajo)\\)$", "", x)
todos <- factor_base(c(top100$factor_1, top100$factor_2, top100$factor_3))
todos <- todos[todos != ""]
todos[grepl("^Antiguedad", todos)] <- "Antiguedad (6-14 o >14 meses)"
frecuencia <- as.data.frame(sort(table(todos), decreasing = TRUE),
                            stringsAsFactors = FALSE)
names(frecuencia) <- c("factor", "clientes_top100")
frecuencia$como_factor_1 <- sapply(frecuencia$factor, function(f) {
  f1 <- factor_base(top100$factor_1)
  f1[grepl("^Antiguedad", f1)] <- "Antiguedad (6-14 o >14 meses)"
  sum(f1 == f)
})
print(frecuencia)
write.csv(frecuencia, file.path(dir_tablas, "T12_frecuencia_factores_top100.csv"),
          row.names = FALSE)

g5 <- ggplot(frecuencia, aes(x = reorder(factor, clientes_top100), y = clientes_top100)) +
  geom_col(fill = "#08519c") +
  geom_text(aes(label = clientes_top100), hjust = -0.3) +
  coord_flip() +
  labs(title = "Factores mas frecuentes entre los 100 clientes de mayor riesgo",
       subtitle = "Numero de clientes en que el factor aparece entre sus 3 principales",
       x = NULL, y = "Clientes") +
  theme_minimal()
ggsave(file.path(dir_graf, "G05_factores_top100.png"), g5,
       width = 8, height = 4.5, dpi = 300)

cat("Resultados generados en 04_Resultados/.\n")
