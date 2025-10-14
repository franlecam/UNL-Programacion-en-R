#-----------------------------------------------------------------------------
# Clase de Visualización de Datos
# Tema: Análisis gráfico ESTÁTICO con ggplot2
#-----------------------------------------------------------------------------

library(ggplot2)

#-----------------------------------------------------------------------------
# Carga de datos
#-----------------------------------------------------------------------------

datos <- data.frame(
  mes = c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio"),
  ventas = c(150, 180, 220, 200, 250, 300),
  producto = c("A", "B", "A", "B", "A", "B")
)

datos$mes <- factor(datos$mes, levels = c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio"))

#-----------------------------------------------------------------------------
# 1. Gráfico de Líneas
#-----------------------------------------------------------------------------

ggplot(datos, aes(x = mes, y = ventas, group = 1)) +
  geom_line(color = "blue", size = 1.2) +
  geom_point(color = "red", size = 3) +
  labs(
    title = "Ventas mensuales de la empresa",
    subtitle = "De enero a junio",
    x = "Mes",
    y = "Ventas (en miles de $)"
  ) +
  theme_minimal()

#-----------------------------------------------------------------------------
# 2. Gráfico de Múltiples líneas
#-----------------------------------------------------------------------------

ggplot(datos, aes(x = mes, y = ventas, color = producto, group = producto)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  labs(
    title = "Ventas por producto a lo largo del tiempo",
    x = "Mes",
    y = "Ventas (en miles de $)",
    color = "Producto"
  ) +
  theme_classic()

#-----------------------------------------------------------------------------
# 3. Gráfico de barras
#-----------------------------------------------------------------------------

ggplot(datos, aes(x = mes, y = ventas)) +
  geom_col(fill = "steelblue") + 
  labs(
    title = "Ventas Mensuales de la Empresa",
    subtitle = "Grafico de barras",
    x = "Mes",
    y = "Ventas (en miles de $)"
  ) +
  theme_minimal()

#-----------------------------------------------------------------------------
# 4. Gráfico de barras agrupadas por producto
#-----------------------------------------------------------------------------

ggplot(datos, aes(x = mes, y = ventas, fill = producto)) +
  geom_col(position = "dodge") + 
  labs(
    title = "Ventas por Producto",
    subtitle = "Comparacion de ventas por mes",
    x = "Mes",
    y = "Ventas (en miles de $)",
    fill = "Producto"
  ) +
  theme_minimal()

#-----------------------------------------------------------------------------
# 5. Gráfico de caja
#-----------------------------------------------------------------------------

datos_boxplot <- data.frame(
  producto = c(rep("A", 12), rep("B", 12)),
  ventas = c(150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200, 205,
             180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290)
)

ggplot(datos_boxplot, aes(x = producto, y = ventas, fill = producto)) +
  geom_boxplot() +
  labs(
    title = "Distribucion de Ventas por Producto",
    subtitle = "Grafico de caja (Box plot)",
    x = "Producto",
    y = "Ventas (en miles de $)"
  ) +
  theme_minimal() +
  theme(legend.position = "none") 

#-----------------------------------------------------------------------------
# 5. Gráfico de torta
#-----------------------------------------------------------------------------

ggplot(datos, aes(x = "", y = ventas, fill = mes)) +
  geom_col(width = 1) +  
  coord_polar(theta = "y") + 
  labs(
    title = "Proporcion de Ventas por Mes",
    fill = "Mes" 
  ) +
  theme_void() + 
  theme(plot.title = element_text(hjust = 0.5)) 

#-----------------------------------------------------------------------------
# Clase de Visualización de Datos
# Tema: Análisis gráfico DINÁMICO con plotly
#-----------------------------------------------------------------------------

library(plotly)


datos <- data.frame(
  mes = c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio"),
  ventas = c(150, 180, 220, 200, 250, 300)
)

datos$mes <- factor(datos$mes, levels = c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio"))

#-----------------------------------------------------------------------------
# 1. Gráfico interactivo de líneas
#-----------------------------------------------------------------------------

p <- plot_ly(datos, x = ~mes, y = ~ventas, type = 'scatter', mode = 'lines+markers') %>%
  layout(title = "Ventas Mensuales de la Empresa",
         xaxis = list(title = "Mes"),
         yaxis = list(title = "Ventas (en miles de $)"))

p

#-----------------------------------------------------------------------------
# 2. Gráfico interactivo de barras
#-----------------------------------------------------------------------------

# Crear el gráfico interactivo de barras
o <- plot_ly(datos, x = ~mes, y = ~ventas, type = 'bar') %>%
  layout(title = "Ventas Mensuales de la Empresa",
         xaxis = list(title = "Mes"),
         yaxis = list(title = "Ventas (en miles de $)"))

o  

#-----------------------------------------------------------------------------
# 3. Gráfico interactivo de torta
#-----------------------------------------------------------------------------

t <- plot_ly(datos, labels = ~mes, values = ~ventas, type = 'pie') %>%
  layout(title = "Proporción de Ventas por Mes",
         showlegend = TRUE)

t

