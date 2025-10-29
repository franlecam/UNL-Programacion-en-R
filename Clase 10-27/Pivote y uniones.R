options(scipen = 999)

library(dplyr)

library(readxl)

# FUNCIONES DE UNIÓN Y PIVOTEO ####

## TRAYENDO EJEMPLO####

a <- read_excel("expo.xlsx",
                   sheet = "2024",
                   range = "a9:b571",
                   col_names = F)

b <- readxl::read_excel("expo.xlsx",
                        sheet = "2023",
                        range = "a9:b580",
                        col_names = F)

c <- readxl::read_excel("expo.xlsx",
                        sheet = "2022",
                        range = "a9:b601",
                        col_names = F)

d <-  readxl::read_excel("expo.xlsx",
                     sheet = "2021",
                     range = "a9:b583",
                     col_names = F)

### FUNCIONES EN R ####

?sum()

a[[1]]

ajustar_base <- function(df, col, col2) {
  
  df[[col]] <- as.character(df[[col]])
  
  df[[col]] <- stringr::str_pad(df[[col]], width = 8, pad = "0")
  
  df[[col2]] <- gsub("-", "0", df[[col2]])   # reemplaza '-' por '0'
  
  df[[col2]] <- as.numeric(df[[col2]])       # convierte a numérico
  
  names(df)[c(col, col2)] <- c("NCM", "valor")  # renombra las columnas
  
  return(df)
  
}


#

a_fix <- ajustar_base(a,1,2)
b_fix <- ajustar_base(b,1,2)
c_fix <- ajustar_base(c,1,2)
d_fix <- ajustar_base(d,1,2)

rm(a, b, c, d, ajustar_base)

#

# options(scipen = 999)

## UNIONES POR FILA: rbind() y bind_rows() ####

library(tidyverse)

a_fix$periodo <- "2024"
b_fix$periodo <- "2023"
c_fix$periodo <- "2022"
d_fix$periodo <- "2021"

union1 <- bind_rows(a_fix, b_fix, c_fix, d_fix)

#### por qué evitar rbind() 

rbind(data.frame(x = 1:2, y = 3:4),
      data.frame(x = 5:6, z = 7:8))
# ❌ Error: las columnas no coinciden

dplyr::bind_rows(
  data.frame(x = 1:2, y = 3:4),
  data.frame(x = 5:6, z = 7:8)
)
# ✅ Une sin error, y rellena la columna faltante con NA

## UNIONES POR COLUMNA: cbind() y bind_cols() ####

cbind(a_fix, b_fix)

# Pero tiene dos limitaciones importantes:
#   
#   No verifica si las filas coinciden por una clave (solo pega por posición).
# 
# Si el número de filas no coincide, da error o recicla los valores (lo que puede distorsionar la información).

union2 <- dplyr::bind_cols(a_fix, b_fix)

#### 1) Forzar igualdad de tamaño (rellenando con NA)

# Si sabés que las bases se corresponden más o menos por orden, podés igualar su longitud para que bind_cols() funcione:

nrow(a_fix)
nrow(b_fix)

a_fix[564:572, ] <- NA

union2 <- bind_cols(a_fix, b_fix)

nrow(a_fix) # 572
nrow(b_fix) # 572 
nrow(c_fix) # 593
nrow(d_fix) # 575

max(nrow(a_fix), nrow(b_fix), nrow(c_fix), nrow(d_fix))

a_fix[573:593, ] <- NA
b_fix[573:593, ] <- NA
d_fix[576:593, ] <- NA

union3 <- bind_cols(a_fix, b_fix, c_fix, d_fix)

rm(max_filas)

### DESVENTAJAS DE LOS MÉTODOS BÁSICOS DE UNIÓN ####

# Hasta ahora trabajamos con rbind(), bind_rows(), cbind() y bind_cols().
# Estas funciones nos permitieron unir bases, ya sea apilando filas (verticalmente)
# o agregando columnas (horizontalmente).

# Sin embargo, presentan varios problemas cuando las bases no son perfectamente compatibles:

# 1. Requieren coincidencia exacta de estructura:
#    rbind() falla si las columnas no tienen el mismo nombre o tipo de dato.
#    bind_rows() es más flexible, pero igualmente puede introducir muchos NA si hay diferencias.

# 2. No verifican el contenido:
#    cbind() y bind_cols() no comprueban si las filas corresponden al mismo código.
#    Solo “pegan” por posición, por lo que una diferencia en el orden de los NCM
#    puede desalinear completamente la información.

# 3. No detectan códigos faltantes:
#    Si un producto aparece en 2024 pero no en 2023, estas funciones no lo identifican.
#    Simplemente agregan NA o, peor aún, lo emparejan con el valor equivocado.

# 4. No permiten combinar por una clave específica:
#    No podemos decirles “uní las bases por la columna NCM”.
#    Para eso debemos recurrir a las funciones de unión por clave (joins).

# En resumen:
# - rbind() / bind_rows() son útiles cuando las bases tienen la misma estructura (mismos nombres).
# - cbind() / bind_cols() solo sirven cuando las filas están perfectamente alineadas.
# - Pero en bases reales, los códigos, los años y el orden suelen variar.
#   Por eso necesitamos herramientas más inteligentes: los join().

## HACIA LOS JOIN() ####

# A diferencia de cbind() o bind_cols(), los join() emparejan filas según una clave común.
# En este caso, esa clave será la columna NCM (el código de producto).

# Los join() (inner_join, left_join, right_join, full_join) permiten unir
# dos bases a partir de una o más columnas clave, típicamente un identificador como el NCM.

# Ejemplo: queremos combinar los valores de 2024 y 2023 según el código de producto.

### trayendo nuevmente codigo viejo ####

a <- readxl::read_excel("expo.xlsx",
                        sheet = "2024",
                        range = "a9:b571",
                        col_names = F)

b <- readxl::read_excel("expo.xlsx",
                        sheet = "2023",
                        range = "a9:b580",
                        col_names = F)

c <- readxl::read_excel("expo.xlsx",
                        sheet = "2022",
                        range = "a9:b601",
                        col_names = F)

d <-  readxl::read_excel("expo.xlsx",
                         sheet = "2021",
                         range = "a9:b583",
                         col_names = F)

ajustar_base <- function(df, col, col2) {
  df[[col]] <- as.character(df[[col]])
  df[[col]] <- stringr::str_pad(df[[col]], width = 8, pad = "0")
  df[[col2]] <- gsub("-", "0", df[[col2]])   # reemplaza '-' por '0'
  df[[col2]] <- as.numeric(df[[col2]])       # convierte a numérico
  names(df)[c(col, col2)] <- c("NCM", "valor")  # renombra las columnas
  return(df)
}


#

a_fix <- ajustar_base(a,1,2)
b_fix <- ajustar_base(b,1,2)
c_fix <- ajustar_base(c,1,2)
d_fix <- ajustar_base(d,1,2)

rm(a, b, c, d, ajustar_base)

# Partimos de nuestras bases ya estandarizadas:
a_sel <- a_fix[, c("NCM", "valor")]
b_sel <- b_fix[, c("NCM", "valor")]
c_sel <- c_fix[, c("NCM", "valor")]
d_sel <- d_fix[, c("NCM", "valor")]

### 1) LEFT JOIN ####
# Mantiene todas las filas de la base izquierda (por ejemplo, 2024)
# y completa con los valores de la base derecha (por ejemplo, 2023) cuando el NCM coincide.
# Si no existe en 2023, deja NA.

?left_join
left <- dplyr::left_join(a_sel, b_sel, by = "NCM")

left <- dplyr::left_join(a_sel, b_sel, by = "NCM",
                         suffix = c("_2024", "_2023"))

?left_join

# Es útil cuando la base izquierda es tu “base principal” (la más completa o la de referencia)
# y solo querés agregarle información de otra.

### 2) RIGHT JOIN ####
# Hace lo inverso: mantiene todos los registros de la base derecha (por ejemplo, 2023)
# y agrega los valores de la base izquierda cuando coinciden.

right <- dplyr::right_join(a_sel, b_sel, by = "NCM", suffix = c("_2024", "_2023"))

# ESTÁ BIEN HACER LEFT_JOIN Y RIGHT JOIN EN ESTOS CASOS?

### 3) INNER JOIN ####
# Solo conserva los registros que aparecen en ambas bases.
# Si un código está en 2024 pero no en 2023 (o viceversa), se descarta.

inner <- dplyr::inner_join(a_sel, b_sel, by = "NCM", suffix = c("_2024", "_2023"))

# Este tipo de unión es ideal cuando te interesa analizar solo los códigos comunes
# a los dos períodos, sin introducir NA.

### 4) OUTER JOIN (FULL JOIN) ####
# A veces se habla de “outer join” para referirse a las uniones que conservan
# todas las observaciones, de ambos lados.

# En R, eso se implementa directamente con full_join().

full <- dplyr::full_join(a_sel, b_sel, by = "NCM", suffix = c("_2024", "_2023"))

# FULL JOIN combina absolutamente todo:
# - Si el NCM existe en ambas bases, muestra ambas columnas con valores.
# - Si existe solo en una, completa con NA del otro lado.
# Es el equivalente a una "unión total".


# CUÁL DE TODAS LAS ALTERNATIVAS ES LA MEJOR?

### 5) EJEMPLO RESUMEN ####
# Podemos visualizar qué hace cada join con un ejemplo muy simple:

df1 <- data.frame(NCM = c("A", "B", "C"), valor_2024 = c(10, 20, 30))
df2 <- data.frame(NCM = c("B", "C", "D"), valor_2023 = c(200, 300, 400))

left_join(df1, df2, by = "NCM")   # mantiene A, B, C
right_join(df1, df2, by = "NCM")  # mantiene B, C, D
inner_join(df1, df2, by = "NCM")  # mantiene solo B, C
full_join(df1, df2, by = "NCM")   # mantiene A, B, C, D

# En nuestro caso concreto, full_join() será el más útil, ya que queremos conservar
# todos los códigos de producto, incluso si no estuvieron presentes en un año determinado.

## FUNCIONES DE PIVOTEO: pivot_longer() y pivot_wider() ####

# Los pivots sirven para "dar vuelta" los datos:
# - pivot_longer(): pasa de formato ancho a largo.
# - pivot_wider(): pasa de formato largo a ancho.

library(tidyr)

### EJEMPLO BÁSICO #### 
# Supongamos que tenemos una tabla con el valor exportado por país y año:

exportaciones <- data.frame(
  pais = c("Argentina", "Brasil", "Chile"),
  `a2022` = c(120, 150, 90),
  `a2023` = c(140, 165, 110),
  `a2024` = c(155, 180, 130)
)

exportaciones

# Este es el formato ANCHO: una columna por año.

#### 1) pivot_longer(): ANCHO → LARGO ####
# Queremos pasar a formato largo, donde cada fila representa
# un país y un año con su valor asociado.

exportaciones_largo <- pivot_longer(
  exportaciones,
  cols = 2:4,
  names_to = "anio",
  values_to = "valor"
)

exportaciones_largo


# Este formato largo es el que prefieren la mayoría de las funciones
# de análisis y visualización en R (ggplot, modelos, etc.).
# Cada observación es única: (pais, anio).

#### 2) pivot_wider(): LARGO → ANCHO ####
# Si después quisiéramos volver al formato original:

exportaciones_ancho <- pivot_wider(
  exportaciones_largo,
  names_from = anio,
  values_from = valor
)

exportaciones_ancho

### EJEMPLO CONCRETO ####

union1

union_wide <- tidyr::pivot_wider(
  union1,
  names_from = periodo,
  values_from = valor,
  names_prefix = "valor_"
)

