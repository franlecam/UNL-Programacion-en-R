propiedades_limpio <- as.data.frame(readxl::read_excel("propiedades_properati.xlsx"))

str(prope)

# ==============================================================
# PROCESAMIENTO DE LENGUAJE NATURAL CON DESCRIPCIONES DE PROPIEDADES
# ==============================================================

library(dplyr)
library(stringr)
library(tidytext)
library(ggplot2)
library(stopwords)
library(wordcloud)
library(RColorBrewer)

# 1) EXPLORACIÓN INICIAL ####

# Asumimos que ya cargaste el dataset
str(propiedades_limpio)

# Seleccionamos columnas relevantes
prop_txt <- propiedades_limpio %>%
  select(titulo, descripcion)

head(prop_txt, 3)

# 2) LIMPIEZA DE TEXTO ####

# Normalizamos el texto:
# - pasamos todo a minúsculas,
# - quitamos URLs, números, puntuación y caracteres especiales,
# - limpiamos tildes mal codificadas (Ã¡ → á, etc.),
# - eliminamos espacios múltiples.

prop_txt <- prop_txt %>%
  mutate(
    texto = str_c(titulo, descripcion, sep = " "),
    texto = iconv(texto, from = "UTF-8", to = "UTF-8"),  # fuerza codificación
    texto = str_to_lower(texto),
    texto = str_replace_all(texto, "http\\S+", ""),
    texto = str_replace_all(texto, "[^a-záéíóúñü\\s]", " "),  # deja letras y acentos
    texto = str_replace_all(texto, "\\s+", " "),               # espacios múltiples
    texto = str_squish(texto)
  )

# Ver primeros ejemplos
prop_txt$texto[1:3]

# 3) TOKENIZACIÓN ####

tokens <- prop_txt %>%
  unnest_tokens(palabra, texto)

nrow(tokens)
head(tokens, 10)

# 4) LIMPIEZA DE PALABRAS VACÍAS Y CONTEO ####

# Palabras vacías en español
tokens_limpio <- tokens %>%
  filter(!palabra %in% stopwords("es")) %>%
  count(palabra, sort = TRUE)

# Inspeccionamos las más frecuentes
head(tokens_limpio, 20)

# 5) VISUALIZACIÓN DE FRECUENCIA ####

tokens_limpio %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(reorder(palabra, n), n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Palabras más frecuentes en descripciones de propiedades",
    x = "Palabra",
    y = "Frecuencia"
  ) +
  theme_minimal()

# 6) NUBE DE PALABRAS ####

set.seed(123) # Si no fijás una semilla, cada vez que corras el código, la nube mostrará las mismas palabras pero en posiciones diferentes. En otras palabras, guardar semilla en caso de que interese conservar el orden.

wordcloud(
  words = tokens_limpio$palabra,
  freq = tokens_limpio$n,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)

# 4bis) FILTRADO DE PALABRAS ESPECÍFICAS DEL DOMINIO ####

# Palabras que no aportan información (nombres, lugar, legales, inmobiliarias)
stop_dom <- c(
  "santa", "fe", "inmobiliario", "inmobiliaria", 
  "corredor", "responsable", "presente", "publicación",
  "ley", "contacto", "cargo", "operación", "propiedad", "s", "r", "l", "rau", "venta",
  "cada", "web", "inmobiliarias", "departamento", "cuyos"
)

# Filtramos stopwords comunes + estas adicionales
tokens_filtrado <- tokens %>%
  filter(!palabra %in% stopwords("es")) %>%  # palabras vacías comunes
  filter(!palabra %in% stop_dom) %>%         # palabras del dominio a excluir
  count(palabra, sort = TRUE)

# 5) VISUALIZACIÓN DE FRECUENCIA (post-filtrado) ####

tokens_filtrado %>%
  slice_max(n, n = 15) %>%
  ggplot(aes(reorder(palabra, n), n)) +
  geom_col(fill = "darkseagreen4") +
  coord_flip() +
  labs(
    title = "Palabras más frecuentes en descripciones de propiedades (filtradas)",
    x = "Palabra",
    y = "Frecuencia"
  ) +
  theme_minimal()

wordcloud(
  words = tokens_filtrado$palabra,
  freq = tokens_limpio$n,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)
