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

