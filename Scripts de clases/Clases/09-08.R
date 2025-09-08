

View(tabla)

# quizá sería más interesante ver por mes... o por año...

library(tidyverse)

base_modif <- base_op %>%
  mutate(año = year(as.Date(Fecha)),
         mes = month(as.Date(Fecha)),
         dia = weekdays(as.Date(Fecha))) %>%
  group_by(dia) %>%
  summarise(n = n())

# ---- 8. Estructuras de datos en R ----
## Diferencias entre data.frame, tibble, matrix, array y list

### 📌 Introducción

# En R existen distintas estructuras para almacenar y manipular datos. Es fundamental conocer sus diferencias para elegir la más apropiada según la tarea. Las más comunes son:
#   
#   - `data.frame`: estructura tabular base de R
# - `tibble`: versión moderna de data.frame (tidyverse)
# - `matrix`: tabla bidimensional de un solo tipo de dato
# - `array`: generalización de matrix a múltiples dimensiones
# - `list`: contenedor flexible de objetos de cualquier tipo




base <- read.csv("C:/DISCO D/Francisco/Trabajos/FCE/Optativa/Bases/train_bi_2025.csv")

str(base)

names(base)

names(base)[1] <- "Fecha"

names(base)[4] <- "Zona"

names(base)[5] <- "Barrio"

names(base)[c(1,4,5)] <- c("Fecha", "Zona", "Barrio")

names(base)

head(base, 10)

base_op <- base[,-c(2,3,12)]

head(base_op,10)

# a veces, cuando exploramos inicialmente bases grandes (y estamos limitados de pc) --> reducirlas.
# varias formas de reducirla:

# una forma particular: tomar una muestra

set.seed(121822)

base_sample <- dplyr::sample_n(base_op, 50000) # Pregunta: siempre nos va a servir esto?

# vamos a comprobarlo:

lapply(base_op, mean)

sapply(base_op, is.numeric)

sapply(base_op[sapply(base_op, is.numeric)==T], mean)

options(scipen = 999, digits = 4)

# como hago para conocer la fecha promedio? 

# respuesta ####

as.Date(mean(as.numeric(as.Date(base_op$created_on))))

as.Date(mean(as.numeric(as.Date(base_op$created_on))), origin = "1970-01-01")
as.Date(median(as.numeric(as.Date(base_op$created_on))), origin = "1970-01-01")

#####

# existen otras formas de hacer lo mismo...

# Funciones  ####

library(tidyverse)
library(lubridate)

## Select ####

names(base)

base_pruebas <- base_sample %>%
  select(Fecha, 6:8) # o bie

base_pruebas <- base_sample %>%
  select("Fecha", "Barrio", "surface_total", "surface_covered")

base_pruebas <- base_sample %>%
  select(1,6:8) # 

base_pruebas <- base_sample %>%
  select("Fecha", 6:8) # o bie

base_pruebas <- select(Fecha, "Barrio")

base_pruebas <- select(base_sample, Fecha)

## mutate | Crear variables nuevas a partir de otras ####

base_pruebas <- base_sample %>%
  mutate(
    Fecha = as.Date(Fecha),
    ratio_cov = surface_covered / surface_total,
    year = as.integer(format(Fecha, "%Y")),
    year = year(Fecha)  
  )

#

base_pruebas <- base_sample %>%
  mutate(
    ratio_cov = ifelse(surface_total > 0, surface_covered / surface_total, NA),
    grande = surface_total >= 100
  )

# Usando across() para transformar columnas por patrón

base_pruebas <- base_sample %>%
  mutate(
    across(c(surface_total, surface_covered), ~ replace_na(., 0))
    )

## rename | Renombrar columnas puntuales ####

base_pruebas <- base_sample %>%
  rename(
    total_m2 = surface_total, # (nuevo = viejo)
    covered_m2 = surface_covered
  )

# 

base_pruebas <- base_sample %>%
  rename(
    fecha = 1
  )

# Renombrar por regla con rename_with()

base_pruebas <- base_sample %>%
  rename_with(tolower, c(Fecha, Barrio)) # 

## summarise | summarize ####

base_pruebas <- base_sample %>%
  summarise(
    n = n(),
    mean_tot = mean(surface_total, na.rm = TRUE),
    sd_tot   = sd(surface_total, na.rm = TRUE)
  )

# group_by

base_pruebas <- base_sample %>%
  group_by(Fecha) %>%
  summarise(
    n = n(),
    mean_tot = mean(surface_total, na.rm = TRUE),
    sd_tot   = sd(surface_total, na.rm = TRUE)
  )

# Actividad ####

# utilizar al menos una vez cada función creando 4 objetos diferentes.

# GRÁFICOS ####

# 1. Gráficos básicos en R (base R)

# Dispersión (scatterplot)

plot(base$surface_total, base$surface_covered,
     main = "Cubierta vs. Total",
     xlab = "Superficie total (m2)",
     ylab = "Superficie cubierta (m2)",
     pch = 19, col = "blue")



# Histograma

hist(base$surface_total,
     main = "Distribución de superficies totales",
     xlab = "Superficie total (m2)",
     col = "lightgreen", border = "white")


# Boxplot

boxplot(surface_total ~ Barrio, data = base,
        main = "Superficie total por barrio",
        xlab = "Barrio", ylab = "Superficie total (m2)",
        col = "orange")



# Curva de densidad

plot(density(base$surface_total, na.rm = TRUE),
     main = "Densidad de superficie total",
     xlab = "Superficie total (m2)",
     col = "red", lwd = 2)

## Entrando a GGPLOT2 ####

ggplot(base, aes(x = surface_total, y = surface_covered)) +
  geom_point()

ggplot(base, aes(x = surface_total)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "white")

ggplot(base, aes(x = Barrio, y = surface_total)) +
  geom_boxplot(fill = "orange")

ggplot(base, aes(x = surface_total)) +
  geom_density(fill = "lightgreen", alpha = 0.5)

## Añadiendo particularidades ####

# Estéticas adicionales

# Coloreamos por variable categórica (Barrio)

ggplot(base, aes(x = surface_total, y = surface_covered, color = Barrio)) +
  geom_point()


# Tamaño de puntos según otra variable (Precio, por ejemplo)

ggplot(base, aes(x = surface_total, y = surface_covered, size = price)) +
  geom_point(alpha = 0.6)

# Personalizar títulos y etiquetas
ggplot(base, aes(x = surface_total)) +
  geom_histogram(binwidth = 10, fill = "steelblue", color = "white") +
  labs(
    title = "Distribución de superficies totales",
    x = "Superficie total (m2)",
    y = "Frecuencia"
  )

# Histograma + densidad

ggplot(base, aes(x = surface_total)) +
  geom_histogram(aes(y = ..density..), binwidth = 10,
                 fill = "lightgray", color = "white") +
  geom_density(color = "red", size = 1)


# Puntos + línea de regresión

ggplot(base, aes(x = surface_total, y = surface_covered)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", se = FALSE, color = "red")

# Facetas (subgráficos por grupo)

ggplot(base, aes(x = surface_total, y = surface_covered)) +
  geom_point(alpha = 0.6) +
  facet_wrap(~ Barrio)

# Temas (aspecto general)

ggplot(base, aes(x = surface_total, y = surface_covered, color = Barrio)) +
  geom_point() +
  theme_minimal() +
  labs(title = "Relación entre superficies por barrio")


