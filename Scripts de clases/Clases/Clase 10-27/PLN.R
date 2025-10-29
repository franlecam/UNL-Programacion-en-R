# CLASE: PROCESAMIENTO DE LENGUAJE NATURAL CON NOTICIAS FINANCIERAS

# En esta clase trabajaremos con técnicas básicas de Procesamiento de lenguaje natural (PLN) aplicadas a un conjunto de noticias financieras (headlines y descripciones). 

# La idea es aprender a limpiar, tokenizar y analizar texto para obtener información estructurada a partir de datos no estructurados.

# CARGA DE LIBRERÍAS ####

library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(stopwords)
library(wordcloud)
library(RColorBrewer)


# 1) EXPLORACIÓN INICIAL ####


# Leemos el dataset descargado de CNBC News
# (contiene fecha, título y descripción de la noticia)
noticias <- read.csv("cnbc_headlines.csv")

# Observamos estructura general: cuántas filas, tipos de datos, etc.
str(noticias)

# Seleccionamos y renombramos las columnas que nos interesan
noticias <- noticias %>%
  select(Time, Headlines, Description) %>%
  rename(
    fecha = Time,
    titulo = Headlines,
    descripcion = Description
  )

# Inspeccionamos las primeras filas para tener una idea del contenido
head(noticias, 5)

# NOTA:
# A menudo los datasets de texto vienen con ruido: comillas, saltos de línea,
# HTML, URLs, fechas raras, caracteres especiales. Por eso el siguiente paso
# será limpiar el texto antes de analizarlo.


# 2) LIMPIEZA DE TEXTO ####


# Unimos el título y la descripción para tener un solo campo de texto
# sobre el cual operar. Luego normalizamos el texto:
# - pasamos todo a minúsculas,
# - quitamos URLs, números, puntuación y caracteres especiales,
# - eliminamos espacios múltiples.

noticias <- noticias %>%
  mutate(
    texto = str_c(titulo, descripcion, sep = " "),
    texto = str_to_lower(texto),
    texto = str_replace_all(texto, "http\\S+", ""),    # elimina URLs
    texto = str_replace_all(texto, "[^a-z\\s]", " "),  # deja solo letras y espacios
    texto = str_squish(texto)                          # limpia espacios extra
  )

# Observamos algunos ejemplos limpios
noticias$texto[1:3]

# Comentario:
# En esta etapa no hacemos "lemmatización" (reducir palabras a su raíz)
# ni "stemming" (recortar terminaciones), aunque serían pasos comunes
# en un análisis más avanzado.


# 3) TOKENIZACIÓN ####


# La tokenización consiste en dividir el texto en unidades básicas —tokens—,
# que normalmente son palabras, aunque podrían ser frases o incluso caracteres.

tokens <- noticias %>%
  unnest_tokens(palabra, texto)

# Vemos la estructura resultante: una fila por palabra
nrow(tokens)
head(tokens, 10)

# Ejemplo conceptual:
# "The market rose today"  →  "the" | "market" | "rose" | "today"

# Este formato largo nos permite aplicar funciones de conteo y análisis
# palabra por palabra.


# 4) LIMPIEZA DE PALABRAS VACÍAS Y CONTEO ####


# Las "stopwords" son palabras que aparecen con mucha frecuencia
# pero aportan poca información semántica (ej: "the", "and", "of").
# Las removemos para concentrarnos en los términos relevantes.

tokens_limpio <- tokens %>%
  filter(!palabra %in% stopwords("en")) %>%  # eliminamos palabras vacías en inglés
  count(palabra, sort = TRUE)                # contamos frecuencia de aparición

# Inspeccionamos las 20 palabras más frecuentes
head(tokens_limpio, 20)

# Comentario:
# Este paso es fundamental: reduce el ruido y deja en evidencia
# los temas más recurrentes en el corpus (empresa, mercado, acciones, etc.).


# 5) VISUALIZACIÓN DE FRECUENCIA ####


# Graficamos las palabras más usadas con un gráfico de barras horizontal
tokens_limpio %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(reorder(palabra, n), n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Palabras más frecuentes en noticias financieras",
    x = "Palabra",
    y = "Frecuencia"
  ) +
  theme_minimal()

# Interpretación:
# Este gráfico ayuda a detectar rápidamente los tópicos dominantes
# (por ejemplo: "market", "stocks", "bank", "china", "trade").


# 6) NUBE DE PALABRAS ####


# La nube de palabras (wordcloud) ofrece una forma visual y sintética
# de representar la frecuencia de los términos.
# Las palabras más frecuentes aparecen más grandes.

set.seed(123)  # para reproducibilidad

wordcloud(
  words = tokens_limpio$palabra,
  freq = tokens_limpio$n,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# Comentario:
# Las nubes son visualmente atractivas, aunque no precisas en términos
# cuantitativos. Son útiles para resúmenes o visualización exploratoria.


# 7) ANÁLISIS DE SENTIMIENTO ####


# En esta parte, introducimos la idea de un "diccionario de sentimiento":
# una lista de palabras clasificadas como positivas o negativas.
# En R, tidytext ofrece varios diccionarios predefinidos:
#   - "bing" (positivo / negativo)
#   - "afinn" (puntaje de -5 a +5)
#   - "nrc" (más categorías: ira, alegría, sorpresa, etc.)
#
# En esta clase utilizaremos el más sencillo: "bing".

# Cargamos el lexicón de Bing Liu
sentimientos <- get_sentiments("bing")

# Lo inspeccionamos brevemente
head(sentimientos)

# Luego unimos (inner_join) nuestros tokens con el diccionario.
# Esto filtra solo las palabras que aparecen en el lexicón
# y nos permite contar cuántas son positivas o negativas.
sent_an <- tokens %>%
  inner_join(sentimientos, by = c("palabra" = "word")) %>%
  count(sentiment, sort = TRUE)

# Resultado: cantidad de palabras positivas y negativas
sent_an

# Visualizamos la distribución del tono general
sent_an %>%
  ggplot(aes(x = sentiment, y = n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  labs(
    title = "Distribución general de sentimientos en noticias financieras",
    x = "",
    y = "Frecuencia"
  ) +
  scale_fill_manual(values = c("positive" = "darkgreen", "negative" = "firebrick")) +
  theme_minimal()

# Comentario:
# Este análisis es muy básico: simplemente cuenta palabras con carga positiva
# o negativa. Aun así, puede servir como aproximación rápida al tono general
# de un conjunto grande de textos.
#
# Existen métodos más sofisticados:
# - Construir un diccionario propio con palabras relevantes al dominio (por ej. finanzas)
# - Entrenar modelos supervisados (machine learning) que aprendan de ejemplos etiquetados
# - Usar modelos de embeddings o grandes modelos de lenguaje (LLMs) para análisis contextual
#
# Pero en esta etapa, el objetivo es comprender cómo funcionan las bases del análisis
# de texto y cómo los datos no estructurados pueden convertirse en información cuantitativa.

# 8) OTRAS APLICACIONES: TRADUCCIÓN Y MANIPULACIÓN DE TEXTO ####

# Además del análisis de sentimiento, el texto limpio puede manipularse
# para muchas otras aplicaciones, como:
#   - Traducción automática
#   - Clasificación de temas
#   - Extracción de entidades (nombres, lugares, empresas)
#   - Limpieza avanzada y normalización
#   - Preparación para modelos de lenguaje o embeddings

# En este apartado repasamos brevemente algunas funciones útiles
# del paquete stringr para seguir manipulando el texto.

# Ejemplo: detección de palabras clave
ejemplo <- c("Apple shares rose today",
             "Oil prices dropped again",
             "Tesla reported record profits")

# str_detect(): buscar si un texto contiene una palabra
str_detect(ejemplo, "Apple")          # devuelve TRUE/FALSE
str_subset(ejemplo, "Oil")            # filtra solo los que contienen "Oil"

# str_replace(): reemplazar texto (por ejemplo, traducir palabras)
str_replace_all(ejemplo, "shares", "acciones")
str_replace_all(ejemplo, "prices", "precios")

# str_extract(): extraer palabras específicas o números
str_extract(ejemplo, "profit[s]?")    # detecta 'profit' o 'profits'
str_extract(ejemplo, "\\d+")          # extrae números si los hubiera

# También podríamos traducir automáticamente los textos usando APIs o paquetes como translateR o deepLr, aunque aquí no lo implementamos por simplicidad (requiere conexión externa).

