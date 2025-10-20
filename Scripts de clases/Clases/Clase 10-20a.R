library(ggplot2)
library(sf)
library(rnaturalearth)
library(dplyr)
library(ggspatial)

# PUNTOS DONDE ESTÁN LAS ADUANAS ####

localidades <- tibble::tribble(
  ~nombre,              ~lon,      ~lat,
  "Rosario",           -60.634450618104644,  -32.943681072931064,
  "San Lorenzo",       -60.733798777589115,  -32.74001398207213,
  "Santa Fe",          -60.7039777276099,  -31.6457669380087,
  "Villa Constitución",-60.32534157706479,  -33.227930885711935,
  "Rafaela",           -61.510203337380766,  -31.225544281437216
)

## Convertir a objeto sf

localidades_sf <- st_as_sf(localidades, coords = c("lon", "lat"), crs = 4326)

## LIMITES ####

arg <- st_read("C:/DISCO D/Francisco/Bases/Archivos para mapas/ARG_adm1.shp")# o el nombre que corresponda en tu shapefile

santa_fe <- st_read("C:/DISCO D/Francisco/Bases/Archivos para mapas/ARG_adm1.shp") %>%
  filter(NAME_1 == "Santa Fe")
departamentos <- st_read("C:/DISCO D/Francisco/Bases/Archivos para mapas/ARG_adm2.shp") %>%
  filter(NAME_1 == "Santa Fe") # o el nombre que corresponda en tu shapefile

### OTRAS FORMAS DE IMPORTAR LIMITES ####

# arg <- ne_countries(scale = "medium", country = "Argentina", returnclass = "sf")
# provincias <- ne_states(country = "Argentina", returnclass = "sf")
# santa_fe <- provincias %>% filter(name == "Santa Fe")

# PRIMERA ALTERNATIVA ####
# ggplot() +
#   # Mapa base Argentina y Santa Fe
#   geom_sf(data = arg, fill = "gray95", color = "gray85") +
#   geom_sf(data = santa_fe, fill = "white", color = "black", size = 1.2) +
#   geom_sf(data = departamentos, fill = NA, color = "gray50", linetype = "dotted", size = 0.4) +
#   
#   # Puntos de localidades
#   geom_sf(data = localidades_sf, color = "#1E90FF", size = 3) +
#   
#   # Escala y orientación
#   annotation_scale(location = "bl", width_hint = 0.25, style = "bar", text_cex = 0.8) +
#   annotation_north_arrow(location = "tl", which_north = "true", 
#                          style = north_arrow_fancy_orienteering, height = unit(1, "cm")) +
#   
#   # Límites del gráfico (zoom)
#   coord_sf(xlim = c(-63.5, -58), ylim = c(-34.5, -28), expand = FALSE) +
#   
#   # Título personalizado
#   labs(title = "Localidades seleccionadas en Santa Fe") +
#   
#   # Estética general
#   theme_minimal(base_family = "sans") +
#   theme(
#     plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
#     axis.text = element_blank(),
#     axis.ticks = element_blank(),
#     panel.grid.major = element_blank(),
#     panel.background = element_rect(fill = "white", color = NA),
#     plot.background = element_rect(fill = "white", color = "gray85", linewidth = 0.3)
#   )

# SEGUNDA ####

ggplot() +
  # Mapa base de Argentina (más claro o con transparencia)
  geom_sf(data = arg, fill = "black", color = "gray80", alpha = 0.4) +
  
  # Provincia de Santa Fe destacada
  geom_sf(data = santa_fe, fill = "white", color = "black", size = 1.2) +
  
  # Departamentos de Santa Fe
  geom_sf(data = departamentos, fill = NA, color = "gray50", linetype = "dotted", size = 0.4) +
  
  # Localidades destacadas
  geom_sf(data = localidades_sf, color = "steelblue1", size = 5) +
  
  # Escala gráfica
  annotation_scale(
    location = "br",
    width_hint = 0.25,
    style = "bar",
    text_cex = 0.8,
    pad_x = unit(1.0, "cm")  # desplazamiento hacia la izquierda
  ) +
  
  # Zoom al área de interés
  coord_sf(xlim = c(-63.5, -58), ylim = c(-34.5, -28), expand = FALSE) +
  
  # Título
  labs(title = "") +
  
  # Tema personalizado
  theme_minimal(base_family = "sans") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    # plot.background = element_rect(fill = "white", color = "gray85", linewidth = 0.3)
  )

# MAPA CON DATOS ####

# # Datos de localidades (reutilizamos los existentes)
# localidades <- tibble::tribble(
#   ~nombre,              ~lon,      ~lat,
#   "Rosario",           -60.6393,  -32.9442,
#   "San Lorenzo",       -60.7383,  -32.7485,
#   "Santa Fe",          -60.7087,  -31.6230,
#   "Villa Constitución",-60.2369,  -33.2279,
#   "Rafaela",           -61.4860,  -31.2500
# )
# 
# # Flechas a la izquierda (todas las localidades)
# flechas_izq <- localidades %>%
#   mutate(
#     x_start = lon,
#     x_end = -61.5,  # valor fijo para alineación
#     y_start = lat,
#     y_end = lat,
#     numero = row_number()
#   )
# 
# # Flechas a la derecha (sin Villa Constitución)
# flechas_der <- localidades %>%
#   filter(nombre != "Villa Constitución") %>%
#   mutate(
#     x_start = lon,
#     x_end = -59.8,  # valor fijo para alineación
#     y_start = lat,
#     y_end = lat,
#     numero = row_number()
#   )
# 
# 
# # Convertir a sf para puntos
# localidades_sf <- st_as_sf(localidades, coords = c("lon", "lat"), crs = 4326)
# 
# # En tu gráfico, agregás las flechas así:
# ggplot() +
#   # Mapa base de Argentina (más claro o con transparencia)
#   geom_sf(data = arg, fill = "black", color = "gray80", alpha = 0.4) +
#   
#   # Provincia de Santa Fe destacada
#   geom_sf(data = santa_fe, fill = "white", color = "black", size = 1.2) +
#   
#   # Departamentos de Santa Fe
#   geom_sf(data = departamentos, fill = NA, color = "gray50", linetype = "dotted", size = 0.4) +
#   
#   # Localidades destacadas
#   geom_sf(data = localidades_sf, color = "steelblue1", size = 3) +
#   
#   # Escala gráfica
#   annotation_scale(
#     location = "br",
#     width_hint = 0.25,
#     style = "bar",
#     text_cex = 0.8,
#     pad_x = unit(1.0, "cm")  # desplazamiento hacia la izquierda
#   ) +
#   
#   # Zoom al área de interés
#   coord_sf(xlim = c(-63.5, -58), ylim = c(-34.5, -28), expand = FALSE) +
#   
#   # Título
#   labs(title = "") +
#   
#   # Tema personalizado
#   theme_minimal(base_family = "sans") +
#   theme(
#     plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
#     axis.text = element_blank(),
#     axis.ticks = element_blank(),
#     panel.grid.major = element_blank(),
#     panel.background = element_rect(fill = "white", color = NA)) +
#     # plot.background = element_rect(fill = "white", color = "gray85", linewidth = 0.3)
#     
#   # geom_sf(data = localidades_sf, color = "blue", size = 3) +
#   
#   # Flechas hacia la izquierda
#   geom_segment(data = flechas_izq,
#                aes(x = x_start, xend = x_end, y = y_start, yend = y_end),
#                arrow = arrow(length = unit(0.2, "cm")),
#                color = "black") +
#   geom_text(data = flechas_izq,
#             aes(x = x_end - 0.1, y = y_end, label = numero),
#             hjust = 1, size = 4) +
#   
#   # Flechas a la derecha (alineadas)
#   geom_segment(data = flechas_der,
#                aes(x = x_start, xend = x_end, y = y_start, yend = y_end),
#                arrow = arrow(length = unit(0.2, "cm")),
#                color = "black") +
#   geom_text(data = flechas_der,
#             aes(x = x_end + 0.1, y = y_end, label = numero),
#             hjust = 0, size = 4)

## SEGUNDA ALT ####
library(ggplot2)
library(sf)
library(dplyr)
library(tibble)

# Localidades
localidades <- tibble::tribble(
  ~nombre,              ~lon,      ~lat,
  "Rosario",           -60.6393,  -32.9442,
  "San Lorenzo",       -60.7383,  -32.7485,
  "Santa Fe",          -60.7087,  -31.6230,
  "Villa Constitución",-60.2369,  -33.2279,
  "Rafaela",           -61.4860,  -31.2500
)

# Parámetros para la longitud fija de flechas
x_izq  <- -63.5 # extremo izquierdo
x_der  <- -58  # extremo derecho

# Flechas en ambos sentidos
flechas <- localidades %>%
  bind_rows(localidades) %>%
  mutate(
    direccion = rep(c("izq", "der"), each = nrow(localidades)),
    x_start = lon,
    x_end   = ifelse(direccion == "izq", x_izq, x_der),
    y_start = lat,
    y_end   = lat
  )

# Convertir a sf para puntos
localidades_sf <- st_as_sf(localidades, coords = c("lon", "lat"), crs = 4326)

# Gráfico
ggplot() +
  # Mapa base de Argentina (más claro o con transparencia)
  geom_sf(data = arg, fill = "black", color = "gray80", alpha = 0.4) +
  
  # Provincia de Santa Fe destacada
  geom_sf(data = santa_fe, fill = "white", color = "black", size = 1.2) +
  
  # Departamentos de Santa Fe
  geom_sf(data = departamentos, fill = NA, color = "gray50", linetype = "dotted", size = 0.4) +
  
  # Localidades destacadas
  geom_sf(data = localidades_sf, color = "steelblue1", size = 5) +
  
  # Escala gráfica
  annotation_scale(
    location = "br",
    width_hint = 0.25,
    style = "bar",
    text_cex = 0.8,
    pad_x = unit(1.0, "cm")
  ) +
  # Margen blanco izquierdo más ancho
  annotate("rect", xmin = -65, xmax = -63.3, ymin = -Inf, ymax = Inf, fill = "white") +
  
  # Margen blanco derecho más ancho
  annotate("rect", xmin = -58.2, xmax = -57, ymin = -Inf, ymax = Inf, fill = "white") +
  
  
  # Flechas horizontales
  geom_segment(data = flechas,
               aes(x = x_start, xend = x_end, y = y_start, yend = y_end),
               arrow = arrow(length = unit(0.2, "cm")),
               color = "steelblue", linewidth = 0.6) +
  
  # Puntos de las localidades
  geom_sf(data = localidades_sf, color = "deepskyblue", size = 4) +
  
  # Zoom + permitir que las flechas salgan
  coord_sf(xlim = c(-63.5, -58), ylim = c(-34.5, -28), expand = FALSE)+
  labs(title = "") +
  theme_minimal(base_family = "sans") +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),  # <- Esto elimina "x_start" y "y_start"
    axis.ticks = element_blank(),
    panel.grid.major = element_blank(),
    panel.background = element_rect(fill = "white", color = NA)
  )


