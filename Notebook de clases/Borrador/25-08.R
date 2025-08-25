###############################################################
# INTRODUCCIÓN A R
###############################################################

# ---- 1. Operaciones | R como calculadora ####

## Aritmeticas ####

#suma 

5+6

#Resta

6-8


8 - 4

#multiplicacion

12 * 2

#cociente

9 / 3

#Potencia

3^3

144^(1/2)   # raíz cuadrada

64^(1/3) # raíz cúbica

# combinando...

-3 + ((3^2-4*2*4)/2*2)
+3 + ((3^2-4*2*4)/2*2)

## Lógicas ####

30 > 30
30 >= 30

45 < 100

45 <= 100

45 == 44.99999

45 != 44.99999

30 > 10 | 45 < 10
30 > 10 | 45 > 10

30 > 10 & 45 < 10
30 > 10 & 45 > 10

# ---- 2. Definición de objetos ####

# ¿como definimos objetos?

A <- 300
A = 300

## ¿Que tipos de objetos existen? ####

### Numericos ####

A <- 8
A
print(A) # FUNCION

B <- 4
B

A - B

A + 107

B + 300*45

#Redefinimos los valores A y B ¿que sucedera con los valores previamente definidos?

A <- 10
B <- 20

### lógicos ####

C <- A > B
C
C <- A >= B
C
C <- A < B
C
C <- A <= B
C
C <- A == B 
C
C <- A != B
C

C <- B > A & B > 100
C
C <- B > A | B > 100
C

## Practica:    ####
#1) Crear un objeto llamado "mi_numero" que almecene un número que ustedes quieran. ¿Qué pasa si lo intentan nombrar como "mi numero"?         
#2) Realizar alguna operación matemática con el objeto y guardar el resultado como un nuevo objeto llamado "otro_numero".     
#3) Comprobar lógicamente si el segundo objeto es igual a 10.    
#4) Comprobar lógicamente si alguno de los dos objetos es mayor a 10 
#5) crear un objeto de tipo lógico

### Respuesta ####
mi_numero <- 9
mi numero
otro_numero <- 9 + 2
mi_numero>10
mi_numero > 10 | otro_numero > 10

### caracteres ####

C <- "Perro"
D <- "Gato"

C + D # ¿Que pasa si hago esto? operaciones aritmeticas

C == D
C != D

C <- "El contenido de este objeto puede ser una oración."

### Fecha ####

Sys.Date() # FUNCION | fecha de hoy

A <- Sys.Date() 
A
B <- A + 365
B

A > B

# CONTENEDORES: ¿cómo están contenidos los objetos en el ambiente? | luego retomamos.

# ---- 4. Funciones útiles y paquetes ----
# ¿Qué son las funciones?

?rm()

getwd() # otras formas de saberlo --> mirar panel.
setwd("/otra direccion")

rm(A)       # elimina un objeto
ls()        # lista objetos en el entorno

# Secuencias y repeticiones

seq(1, 10, 2)
seq(1995,2025,5)

rep(12, 5)

sum(35,109,399)
sum(35^(1/2),109/2,399*2)

A <- 300
B <- 5
rep(A,B)

sum(rep(A,B)) # ¿Qué sucede si hacemos esto?

mean(rep(A,B)) # y esto?


library(stringr)
# install.packages("stringr")

A <- c("Hoy es un gran día.")

str_detect(A, "jornada") # Qué tipo de objeto devolverá esto?

class(str_detect(A, "jornada"))

str_detect(A, "[áéíóúÁÉÍÓÚñÑ]")

stringr::str_detect(A, "[áéíóúÁÉÍÓÚñÑ]")

stringi::stri_trans_general(A, "Latin-ASCII")

?tolower()
?toupper()

detach("package:stringr", unload = TRUE)

# ----5. CONTENEDORES ----

AGLOMERADO  <- c(32,33,33,33,32)

SEXO  <-  c("Varon","Mujer","Mujer","Varon","Mujer")

EDAD  <-  c(60,54,18,27,32)

class(AGLOMERADO)

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

# ---- 6. Navegando componentes ----

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
