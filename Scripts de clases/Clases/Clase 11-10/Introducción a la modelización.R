options(scipen = 999)

############################################################
# CLASE: REGRESIÓN LINEAL SIMPLE Y MÚLTIPLE CON DATOS "REALES"
# Dataset: Prestige (carData)
############################################################


library(carData)
library(car)

?Prestige

data("Prestige")
head(Prestige)
str(Prestige)

# Exploración inicial ####

summary(Prestige)

plot(Prestige$prestige)

cor(Prestige$women, Prestige$income)

plot(Prestige$women, Prestige$prestige)

cor(Prestige$women, Prestige$prestige)

vars <- Prestige[, c("income", "education", "women", "prestige")]

cor_matrix <- cor(vars, use = "complete.obs")

print(round(cor_matrix, 2))

corrplot(cor_matrix, method = "color", 
         type = "upper", order = "hclust",
         addCoef.col = "black",
         tl.col = "black", tl.srt = 45,
         col = colorRampPalette(c("darkred", "white", "steelblue"))(200))


# 1. REGRESIÓN LINEAL SIMPLE #####


# Relación entre ingreso y prestigio
modelo_simple <- lm(prestige ~ income, data = Prestige)
summary(modelo_simple)

# Gráfico del ajuste
plot(Prestige$income, Prestige$prestige,
     pch = 19, col = "darkgray",
     main = "Regresión simple: Prestigio vs Ingreso",
     xlab = "Ingreso promedio", ylab = "Prestigio ocupacional")
abline(modelo_simple, col = "blue", lwd = 2)

# Interpretación:
# - La pendiente indica cuánto aumenta el prestigio por unidad de ingreso.
# - El R² muestra qué proporción del prestigio se explica por el ingreso.


# Relación entre ingreso y prestigio
modelo_simple <- lm(prestige ~ women, data = Prestige)
summary(modelo_simple)

# Gráfico del ajuste
plot(Prestige$women, Prestige$prestige,
     pch = 19, col = "darkgray",
     main = "Regresión simple: Prestigio vs Ingreso",
     xlab = "Ingreso promedio", ylab = "Prestigio ocupacional")
abline(modelo_simple, col = "blue", lwd = 2)


# 2. REGRESIÓN LINEAL MÚLTIPLE ####

# Agregamos educación y % de mujeres como variables explicativas
modelo_multiple <- lm(prestige ~ income + education + women, data = Prestige)
summary(modelo_multiple)

# Interpretación:
# - Cada coeficiente muestra el efecto parcial de cada variable sobre el prestigio,
#   manteniendo las demás constantes.
# - R² ajustado indica cuánto mejora el modelo al incluir más variables.

# 3. ADICIÓN DE VARIABLES Y TEST F (significancia) ####

# Modelo solo con ingreso

modelo_ingreso <- lm(prestige ~ income, data = Prestige)

# Modelo con ingreso + educación

modelo_ingreso_educ <- lm(prestige ~ income + education, data = Prestige)

?anova

anova(modelo_ingreso, modelo_ingreso_educ)

# Si p-value < 0.05 → agregar educación mejora el ajuste significativamente.

# 4. PREDICCIÓN EN NUEVOS DATOS ####

nuevos_datos <- data.frame(
  income = c(4000, 8000, 10000, 13000, 15000, 20000),
  education = c(9, 11, 12, 13, 14, 15),
  women = c(30, 40, 50, 60, 70, 80)
)

predicciones <- predict(modelo_multiple, newdata = nuevos_datos, interval = "prediction")
resultados <- cbind(nuevos_datos, predicciones)
print(resultados)

# 5. VISUALIZACIÓN: VALORES PREDICHOS ####

ggplot(resultados, aes(x = income, y = fit)) +
  geom_point(size = 3, color = "blue") +
  geom_errorbar(aes(ymin = lwr, ymax = upr), width = 300, color = "darkgray") +
  labs(
    title = "Predicción del prestigio en nuevos casos",
    x = "Ingreso promedio",
    y = "Prestigio predicho (con IC 95%)"
  ) +
  theme_minimal(base_size = 12)

# 6. EVALUACIÓN (opcional) ####

# Supongamos que tenemos valores “reales” observados para estos casos !!!

valores_reales <- c(35, 45, 50, 60, 65, 70)

# Medimos el error promedio (RMSE)

MSE <- sqrt(mean((valores_reales - resultados$fit)^2))
cat("RMSE sobre los nuevos casos:", round(RMSE, 2), "\n")

# Root Mean Square Error o error cuadrático medio

# ¿es mucho o poco?

range(Prestige$prestige)

rango <- max(Prestige$prestige) - min(Prestige$prestige)
MSE / rango

sd(Prestige$prestige)

MSE / sd(Prestige$prestige)

# Podemos graficar real vs predicho
comparacion <- data.frame(real = valores_reales, predicho = resultados$fit)

ggplot(comparacion, aes(x = real, y = predicho)) +
  geom_point(size = 3, color = "darkgreen") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(
    title = "Comparación entre valores reales y predichos",
    x = "Prestigio real",
    y = "Prestigio predicho"
  ) +
  theme_minimal(base_size = 12)

# 7. SET DE ENTRENAMIENTO Y TESTEO ####

set.seed(123)
n <- nrow(Prestige)
train_index <- sample(1:n, size = 0.7 * n)

train <- Prestige[train_index, ]
test <- Prestige[-train_index, ]

modelo_train <- lm(prestige ~ income + education + women, data = train)

# Predicciones sobre el set de testeo
pred_test <- predict(modelo_train, newdata = test)

# RMSE sobre test
rmse_test <- sqrt(mean((test$prestige - pred_test)^2))

# RMSE sobre entrenamiento
pred_train <- predict(modelo_train, newdata = train)
rmse_train <- sqrt(mean((train$prestige - pred_train)^2))

cat("RMSE entrenamiento:", round(rmse_train, 2), "\n")
cat("RMSE testeo:", round(rmse_test, 2), "\n")
