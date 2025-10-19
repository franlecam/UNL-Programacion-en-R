#----------------------------------------------------------------
### Práctica de Visualización de Datos con ggplot2 | Semana 22/9
#----------------------------------------------------------------

## Fecha límite de entrega: Jueves 25 de septiembre 23:59hs

## Para esta práctica, continúen trabajando con la base de datos que eligieron y exploraron en la práctica anterior. Como cada estudiante trabajará con una base de datos distinta, les animamos a ser creativos con los colores, temas y etiquetas que le añadan a sus gráficos. 

# Consigna 1. Crear un gráfico de dispersión para visualizar la relación entre dos variables numéricas de su base de datos. Darle un título claro al gráfico. 

# Consigna 2. Realizar un gráfico de caja para comparar la distribución de una variable numérica entre las diferentes categorías de una variable de su base. Personalicen el color de relleno de las cajas según la variable categórica y añadan etiquetas descriptivas a los ejes X e Y.

# Consigna 3. Generar un gráfico de pastel que muestre la proporción de observaciones por las categorías de una variable de su base de datos. 

# Consigna 4. Elaborar un gráfico de líneas para explorar la evolución de una variable a medida que otra variable numérica aumenta. Para ello, es fundamental que primero ordenen de menor a mayor su conjunto de datos según la variable que usarán en el eje X. 

# Consigna 5. Realizar un gráfico de dispersión que muestre la relación entre dos variables numéricas de su base de datos. Añadan una línea de regresión lineal (geom_smooth(method = "lm")) para mostrar la tendencia. Utilicen la función labs() para agregar un título, un subtítulo y etiquetas a los ejes que expliquen claramente el gráfico. Cambiar el color de los puntos y la línea de tendencia a gusto personal.

# Consigna 6. Usando el flujo de trabajo de la práctica anterior, agrupen los datos por una variable categórica. Luego, calculen la media de una variable numérica para cada grupo. Finalmente, creen un gráfico de barras para visualizar esta media por grupo y personalicen el color de las barras. Ayuda: Usen group_by() y summarise() de la librería dplyr antes de pasar el resultado a ggplot2.