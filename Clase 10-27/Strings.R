# INTRODUCCIÓN A STRINGR ####
# stringr es parte del tidyverse y facilita la manipulación de texto.

library(stringr)

## 1) DETECCIÓN DE PATRONES ####
# Permite identificar si un patrón o palabra aparece dentro de un texto.

texto <- c("Exportaciones crecieron 15%", 
           "Caída de la recaudación provincial", 
           "El tipo de cambio se mantiene estable",
           "Las exportaciones industriales aumentaron 20% en agosto")

# Buscar si aparece una palabra específica
str_detect(texto, "recaudación")

# Filtrar frases que contienen cierta palabra
texto[str_detect(texto, "Export")]

# Buscar expresiones usando patrones (regex)
# Ejemplo: detectar si hay un número en la frase
str_detect(texto, "\\d+")

# Detectar frases que mencionen "exportaciones" o "importaciones"
str_detect(texto, "exportaciones|importaciones")

# Contar cuántas frases contienen la palabra “exportaciones”
sum(str_detect(str_to_lower(texto), "exportaciones"))

# Ejemplo útil en informes: detectar menciones de provincias
str_detect(texto, regex("santa fe|tierra del fuego|chaco", ignore_case = TRUE))


## 2) REEMPLAZO DE PATRONES ####
# Se usa para limpiar o normalizar textos: corregir errores, uniformar expresiones, etc.

# Cambiar "Caída" por "Descenso"
str_replace(texto, "Caída", "Descenso")

# Reemplazar todas las apariciones de un patrón
str_replace_all(texto, " ", "_")  # reemplaza espacios por guiones bajos

# Normalizar nombres o expresiones
texto2 <- c("SANTA FE", "Sta. Fe", "Santa fe", "santa-fé")
str_replace_all(texto2, regex("sta.?\\s?fe", ignore_case = TRUE), "Santa Fe")

# Reemplazar varios patrones a la vez
frases <- c("IPC", "PBI", "Exportaciones")
str_replace_all(frases, c("IPC" = "Inflación", "PBI" = "Producto Bruto Interno"))

# Eliminar caracteres no deseados (por ejemplo, símbolos de %)
str_replace_all(texto, "%", "")


## 3) EXTRACCIÓN ####
# Permite extraer información específica, como números o palabras clave.

# Extraer números
str_extract(texto, "\\d+")

# Extraer palabras que empiezan con mayúscula
str_extract_all(texto, "\\b[A-ZÁÉÍÓÚÑ][a-záéíóúñ]+")

# Extraer todo lo que esté entre dos palabras o símbolos
frase <- "El índice ICA-SFE creció un 2.3% en septiembre"
str_extract(frase, "(?<=creció un ).*(?=%)")

# Extraer nombres de provincias o países
texto3 <- c("Santa Fe lideró las exportaciones.", 
            "Buenos Aires aumentó su recaudación.",
            "Tierra del Fuego mostró estabilidad fiscal.")
str_extract(texto3, "Santa Fe|Buenos Aires|Tierra del Fuego")

# Extraer solo las letras (eliminar números y signos)
str_extract_all(texto, "[A-Za-zÁÉÍÓÚáéíóúñÑ ]+")

## 4) TRANSFORMACIONES GENERALES ####
# Operaciones comunes de limpieza y estandarización de texto.

# Pasar todo a minúsculas
str_to_lower(texto)

# Pasar todo a mayúsculas
str_to_upper(texto)

# Capitalizar la primera letra
str_to_title("tierra del fuego")

# Quitar espacios en blanco al inicio o final
frase2 <- "   recaudación provincial   "
str_trim(frase2)

# Repetir un texto varias veces
str_dup("Exportaciones ", 3)

# Contar caracteres de cada frase
str_length(texto)

# Extraer los primeros 10 caracteres de cada frase
str_sub(texto, 1, 10)

# Reemplazar subcadenas: ejemplo, cambiar los primeros 12 caracteres por “Informe:”
str_sub(texto, 1, 12) <- "Informe: "

# Concatenar frases
str_c("Total de frases:", length(texto))

# Unir un vector en una sola cadena, separado por punto y coma
str_c(texto, collapse = "; ")

## 5) DIVISIÓN DE TEXTO ####
# A veces es necesario dividir frases en palabras o partes.

# Dividir por espacios
str_split(texto, " ")

# Dividir por una palabra clave
str_split("Santa Fe - Córdoba - Mendoza", " - ")

# Obtener la primera palabra de cada frase
sapply(str_split(texto, " "), `[`, 1)

# Obtener la última palabra de cada frase
sapply(str_split(texto, " "), function(x) tail(x, 1))

## 6) CASOS APLICADOS ####
# Algunos ejemplos típicos de uso en análisis económico o institucional.

# a) Limpieza de nombres de series o variables
nombres <- c("PIB(%)", "Inflación_Mensual", "Tipo.de.Cambio")
str_replace_all(nombres, "[^A-Za-z]", "_")  # elimina caracteres especiales

# b) Identificación de variables relacionadas
series <- c("PIB_Real", "PIB_Nominal", "IPC_General", "IPC_Núcleo")
str_detect(series, "PIB")  # detectar todas las que incluyen PIB

# c) Homogeneizar descripciones
descripciones <- c("Santa fé", "santa fe", "Sta Fe", "Sta. Fé")
str_replace_all(descripciones, regex("sta.?\\s?fe", ignore_case = TRUE), "Santa Fe")

# d) Extracción de unidades
valores <- c("12,3%", "4.5 puntos", "1.000 millones")
str_extract(valores, "\\d+[\\.,]?\\d*")

