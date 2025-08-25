# R como calculadora 

(4+4)*5
8-4
12*12
9/3
64^(1/2)

# Definición de objetos

  # Objetos de tipo "numeric"

A <- 8 # al número 8 lo llamo saltar

A-B

  # Objeto de tipo "Character"
C <- "Perro" 

D <- "Gato"
# Operaciones lógicas

A == B 

A != B

C != D

A >= B

A < B 

A <= B

A < B

E <- C != D # Objeto lógico

E 

# Operaciones aritméticas


A <- 100
B <- 4 

A*B
C*D


A/B
A+B
A-B
A^2

# Funciones

rm(A) #remueve objetos que le precisemos.
ls() # nos devuelve todos los objetos que fueron definidos/creados y que se visualizan en el enviornment
rm(list = ls(a)) # eliminamos todos... aunque también hay otra alternativa (clic en escoba)

?seq()

x <- seq(1,10,2) # sequencia de números, a partir de un patrón o no.
rep(12,5) # repeticion del primer argumento, las n veces que disponga el segundo argumento.

A <- rep(8,8)


x


length(x) == 5

A <- sum(A) # suma los elementos de un vector


  # creando bases de datos

id_firma <- rep(seq(1:20),5)
año_1 <- rep(2018,20)
año_2 <- rep(2019,20)
año_3 <- rep(2020,20)
año_4 <- rep(2021,20)
año_5 <- rep(2022,20)

Año <- c(año_1,año_2,año_3,año_4,año_5)
Produccion <- sample(10000:50000, 100, replace = TRUE)
Empleados <- sample(1:150,100, T)

base <- data.frame(id_firma, Año, Produccion, Empleados)

# exportar e importar objetos creados
saveRDS(base, "base.rds")

# paquete openxlsx
# para instalar paquetes (por única vez) --> install.pachages("nombre_del_paquete") sí, con comillas.
# para abri/cargar el paquete deseado (cada  vez que se abre sesión de R) --> library(nombre_del_paquete) sí, sin comillas.

write.xlsx(base, "base de datos.xlsx")
base1 <- read_excel("base de datos.xlsx")


# Paquetes // 
# ggplot2
# leaflet y 
# install.packages("tidyverse")

library(tidyverse)

# library(tidyverse)
# tidyverse --> limpieza y manejo de datos
# eph
# ioanalysis 

library(tidyverse)

base2 <- base1 %>%
  select(id_firma, Año, Produccion, Empleados)

base2 <- base2 %>%
  filter(Año>2020)

base3 <- base2 %>%
  rename("Numero" = "id_firma") %>%
  mutate(contador = 1)

base4 <- base3 %>%
  filter(Año != 2020) %>%
  group_by(Año) %>%
  summarise(total = sum(contador[Empleados>20]))

head(base3)

max(base3$Produccion)


base3[which.max(base3$Empleados),]
        

# navegar en la base de datos

base3[,3] # nos devuelve la observación o fila 3
base3[2,4] <- 5 # nos devuelve el elemento 2,4.

a <- base3[2,4]

base.a <- base[,1:2]
base.b <- base[,3:4]
base.error1 <- base[2,1:2] # separamos el data frame
base.error2 <- base.1

cbind(base.a, base.b) # une columnas de data frames (tienen que tener misma cantidad de filas)
rbind(base[1:3,],base.1[4:5,]) # une filas de data frames (misma cantidad de columnas ¡y nombres!)

# la función left.join es una alternativa para combinar data frames sin restricción de cantidad fila y columnas.

# Matrices

# Funcion matrix()

Datos <- c("B", "C", "D", "E")

A <- matrix(Datos, nrow = 2, byrow = TRUE)

A1 <- matrix(c("B", "C", "D", "E"), ncol = 2, byrow = TRUE)

# Funciones rbind() y cbind()

B1 <- c(2, 4)
C1 <- c(3, 6, 9)

A <- rbind(A, B1)
A <- cbind(A, C1)

# Funciones rownames() y colnames()

rownames(A) <- c("Agricultura", "Manufacturas", "Servicios")
colnames(A) <- c("Agricultura", "Manufacturas", "Servicios")

# Funciones  rowSums() y colSums()

F <- matrix(c(2, 4, 6, 3, 5, 7), 2, 3, byrow = TRUE)

P <- rowSums(F)
O <- colSums(F)

# Funcion dim() y det()

dim(F)

F <- rbind(F, c(8, 10, 12))

det(F)

# Operaciones con matrices

A2 <- matrix(c(10, 23, 4, 18), 2, 2, byrow = TRUE)
B2 <- matrix(c(5, 66, 14, 2), 2, 2, byrow = TRUE)

A2 + B2

B2 - A2

A2 * 2

B2 / 2 

A2 * B2

A2 %*% B2

# Otras funciones ?tiles

t(A)

L <- t(A)

solve(A2) # No es lo mismo que 1 / A2

diag(3)

diag(O)

diag(A) <- 3

# Ejemplo

I <- diag(3)

F %*% I

I2 <- matrix(c(1, 0, 1, 0, 0, 1), 3, 2, byrow = TRUE)

F %*% I2

t(I2) %*% F %*% I2

# Seleccionar elementos de una matriz

F[3, 1]

F[2, ]

F[, 1]

F[1:3, 1:2] 

# Ejercicio 1

a <- c(3, 8, 6)
m <- c(2, 4, 5)
s <- c(7, 3, 9)

Sectores <- c("Agricultura", "Manufacturas", "Servicios")

Z <- rbind(a, m, s) # Matriz de transacciones intermedias

colnames(Z) <- Sectores
row.names(Z) <- Sectores

x <- c(22, 18, 31)

df <- x - rowSums(Z) # Vector de demanda final

VA <- x - colSums(Z) # Vector de valor agregado

vc <- VA / x # Vector de coeficientes de valor agregado

vc[x == 0] <- 0

inv_x <- solve(diag(x))

A <- Z %*% inv_x # Matriz de coeficientes t?cnicos

I <- diag(3) 

L <- solve(I - A) # Matriz inversa de Leontief

MIP <- cbind(rbind(Z, VA, x), df, x)

MIP[4:5, 4:5] <- 0

# Ejercicio 2

x <- c(50, 100, 50)

z <- matrix(c(0.05, 0.2, 0.05, 0.3, 0.15, 0.3,  0.05, 0.05, 0.10), 3, 3, byrow = TRUE)

Z <- z %*% diag(x)

inv_x <- solve(diag(x))

A <- Z %*% inv_x

I <- diag(3)

L <- solve(I - A)

df <- c(0, 20, 0)

L %*% df

# Ejercicio 3

A <- c(40, 60, 50, 70)
B <- c(50, 10, 60, 70)
C <- c(30, 70, 50, 50)
D <- c(45, 45, 80, 50)

Z <- cbind(A, B, C, D)

f <- c(200, 200, 300, 400)

x <- f + rowSums(Z)

VA <- x - colSums(Z)

inv_x <- solve(diag(x))

Y <- Z %*% inv_x

I <- diag(4)

L <- solve(I - Y)

df1 <- c(100, 0, 0, 0)

sum(L %*% df1)

df2 <- c(0, 100, 0, 0)

sum(L %*% df2)

df3 <- c(0, 0, 100, 0)

sum(L %*% df3)

df4 <- c(0, 0, 0, 100)

sum(L %*% df4)


