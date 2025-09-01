# ----1. CONTENEDORES ----

BARRIOS  <- c(32,33,33,33,32)

SEXO  <-  c("Varon","Mujer","Mujer","Varon","Mujer")

EDAD  <-  c(60,54,18,27,32)

class(BARRIOS)

sum(EDAD)
mean(EDAD)
median(EDAD)
sd(EDAD)

length(EDAD)

pais <- rep("Argentina",100)
id_firma   <- rep(seq(1:20), 5)
Año        <- rep(2021:2025, each = 20)
Produccion <- sample(10000:50000, 100, replace = TRUE)
Empleados  <- sample(1:150, 100, replace = TRUE)

base <- data.frame(pais, id_firma, Año, Produccion, Empleados)

# (*)

base <- data.frame(rep("Argentina",100), rep(seq(1:20), 5), rep(2018:2022, each = 20), sample(10000:50000, 100, replace = TRUE), sample(1:150, 100, replace = TRUE))
base <- data.frame(pais, id_firma, Año, Produccion, Empleados)

View(base) # distintas formas de hacer esto

# Otras formas de agregar muchos datos

base_arg <- data.frame(pais, id_firma, Año, Produccion, Empleados)

pais <- rep("Brasil", 100)
Produccion <- sample(10000:50000, 100, replace = TRUE) # opción con set.seed()
Empleados  <- sample(1:150, 100, replace = TRUE)
base_br <- data.frame(pais, id_firma, Año, Produccion, Empleados) 

pais <- rep("Chile", 100)
Produccion <- sample(10000:50000, 100, replace = TRUE) # opción con set.seed()
Empleados  <- sample(1:150, 100, replace = TRUE)
base_ch <- data.frame(pais, id_firma, Año, Produccion, Empleados) 

Lista <- list(base_arg, base_br, base_ch)

class(base_arg)
class(Lista)

View(Lista)

# ---- 2. Navegando componentes ----

## Navegando en data frame ####

base_arg$pais # qué pasa si hacemos esto creando base como (*)?

base[,1]
base[1,1]

class(base$pais)

base[,4]

mean(base[,4])
weighted.mean(base[,4], base[,3]) # Quiz, ¿por qué me dan similares?

# para cerrar, guardamos objeto.

saveRDS(Lista, "lista.rds")

# ---- 3. Guardar y leer archivos ----

base_recuperada <- readRDS("lista.rds")

# Exportar a Excel (requiere openxlsx)
# install.packages("openxlsx")
library(openxlsx)
write.xlsx(base, "base.xlsx")

# Leer Excel (requiere readxl)
library(readxl)
 base1 <- read_excel("base.xlsx")
 
# ---- 4. Paquetes y tidyverse ----

# install.packages("tidyverse") # instalación (una sola vez)
library(tidyverse)

base2 <- base %>%
  select(id_firma, Año, Produccion, Empleados) %>%
  filter(Año > 2020) %>%
  rename("Numero" = "id_firma") %>%
  mutate(contador = 1)

head(base2)
head(base2)

# ---- 5. Matrices ----
Datos <- c("B", "C", "D", "E")

A <- matrix(Datos, nrow = 2, byrow = TRUE)
A1 <- matrix(c("B", "C", "D", "E"), ncol = 2, byrow = TRUE)

# Operaciones con matrices
B1 <- c(2, 4)
C1 <- c(3, 6, 9)

A <- rbind(A, B1)
A <- cbind(A, C1)

rownames(A) <- c("Agricultura", "Manufacturas", "Servicios")
colnames(A) <- c("Agricultura", "Manufacturas", "Servicios")

# ---- 6. Operaciones con matrices numéricas ----
F <- matrix(c(2, 4, 6, 3, 5, 7), 2, 3, byrow = TRUE)

rowSums(F)
colSums(F)

A2 <- matrix(c(10, 23, 4, 18), 2, 2, byrow = TRUE)
B2 <- matrix(c(5, 66, 14, 2), 2, 2, byrow = TRUE)

A2 + B2
A2 %*% B2   # producto matricial
t(A2)       # transpuesta
solve(A2)   # inversa (si existe)

# ---- 7. Bases de datos ####

## 

base <- read.csv("C:/Users/franl/Dropbox/Trabajos/bases de datos/train_bi_2025.csv")

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

base_pruebas <- dplyr::sample_n(base_op, 50000) # Pregunta: siempre nos va a servir esto? 

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

## Funciones interesantes ####

# Select

# group_by

# mutate

# rename 

# summarise | summarize



tabla <- table(as.Date(base_op$Fecha)) 
  mutate(dia = weekdays(as.Date(Var1)))

View(tabla)

# quizá sería más interesante ver por mes... o por año...

library(tidyverse)

base_modif <- base_op %>%
  mutate(año = year(as.Date(Fecha)),
         mes = month(as.Date(Fecha)),
         dia = weekdays(as.Date(Fecha))) %>%
  group_by(dia) %>%
  summarise(n = n())



