###############################################################
# INTRODUCCIÓN A R
# Clase práctica
###############################################################

# ---- 1. R como calculadora ----
(4 + 4) * 5
8 - 4
12 * 12
9 / 3
64^(1/2)   # raíz cuadrada

# ---- 2. Definición de objetos ----
# Numeric
A <- 8
B <- 4
A - B

# Character
C <- "Perro"
D <- "Gato"

# Lógicos
A == B
A != B
C != D
A >= B
A < B
A <= B

E <- C != D
E   # Objeto lógico

# ---- 3. Operaciones aritméticas ----
A <- 100
B <- 4

A * B
A / B
A + B
A - B
A ^ 2

# ---- 4. Funciones útiles ----
rm(A)       # elimina un objeto
ls()        # lista objetos en el entorno

# Secuencias y repeticiones
x <- seq(1, 10, 2)
rep(12, 5)

length(x)

A <- rep(8, 8)
sum(A)

# ---- 5. Creando bases de datos ----
id_firma   <- rep(seq(1:20), 5)
Año        <- rep(2018:2022, each = 20)
Produccion <- sample(10000:50000, 100, replace = TRUE)
Empleados  <- sample(1:150, 100, replace = TRUE)

base <- data.frame(id_firma, Año, Produccion, Empleados)
head(base)

# ---- 6. Guardar y leer archivos ----
saveRDS(base, "base.rds")
# base_recuperada <- readRDS("base.rds")

# Exportar a Excel (requiere openxlsx)
# install.packages("openxlsx")
# library(openxlsx)
# write.xlsx(base, "base.xlsx")

# Leer Excel (requiere readxl)
# library(readxl)
# base1 <- read_excel("base.xlsx")

# ---- 7. Paquetes y tidyverse ----
# install.packages("tidyverse") # instalación (una sola vez)
library(tidyverse)

base2 <- base %>%
  select(id_firma, Año, Produccion, Empleados) %>%
  filter(Año > 2020) %>%
  rename("Numero" = "id_firma") %>%
  mutate(contador = 1)

head(base2)

# ---- 8. Matrices ----
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

# ---- 9. Operaciones con matrices numéricas ----
F <- matrix(c(2, 4, 6, 3, 5, 7), 2, 3, byrow = TRUE)

rowSums(F)
colSums(F)

A2 <- matrix(c(10, 23, 4, 18), 2, 2, byrow = TRUE)
B2 <- matrix(c(5, 66, 14, 2), 2, 2, byrow = TRUE)

A2 + B2
A2 %*% B2   # producto matricial
t(A2)       # transpuesta
solve(A2)   # inversa (si existe)

# ---- 10. Ejercicio simple de insumo-producto ----
a <- c(3, 8, 6)
m <- c(2, 4, 5)
s <- c(7, 3, 9)

Sectores <- c("Agricultura", "Manufacturas", "Servicios")
Z <- rbind(a, m, s)
colnames(Z) <- Sectores
rownames(Z) <- Sectores

x <- c(22, 18, 31)
df <- x - rowSums(Z)  # Demanda final
VA <- x - colSums(Z)  # Valor agregado

A <- Z %*% solve(diag(x))  # Matriz técnica
I <- diag(3)
L <- solve(I - A)          # Inversa de Leontief

L %*% df
