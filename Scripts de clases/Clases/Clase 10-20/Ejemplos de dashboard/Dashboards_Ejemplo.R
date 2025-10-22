

# Más ejemplos en

# https://rstudio.github.io/flexdashboard/articles/examples.html

# LOS SIGUIENTES CÓDIGOS DEBEN SER PEGADOS EN UN RMARKDOWN

# DASHBOARD 1 ####

---
title: "Demo 1 — Layout básico (columna)"
output:
  flexdashboard::flex_dashboard:
  orientation: columns
vertical_layout: fill
theme: flatly
source_code: embed
---
  
  
  ```{r setup, include=FALSE, echo = F, message = F, warning = F}
knitr::opts_chunk$set(echo = TRUE)
```

```{r, echo = F}
library(flexdashboard)
library(leaflet)
library(ggplot2)
library(DT)
library(dplyr)
```

# Solapa 1 {data-width=40%}

## Mapa interactivo

```{r, echo = F}
set.seed(1)
df <- data.frame(
  lat = runif(300, -40, -27),
  lon = runif(300, -65, -57),
  label = paste("Punto", 1:300)
)

df <- df |>
  dplyr::mutate(ID = dplyr::row_number())

leaflet::leaflet(df) |>
  leaflet::addProviderTiles("CartoDB.Positron") |>
  leaflet::addCircleMarkers(
    radius = 4, stroke = FALSE, fillOpacity = .85,
    popup = ~paste0("ID: ", ID)
  )


```

# Solapa 2 {data-width=40%}

## Mapa interactivo

```{r, echo = F}
ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, color = factor(cyl))) +
  ggplot2::geom_point(size = 3) +
  ggplot2::labs(color = "Cilindros", x = "Peso", y = "MPG")

DT::datatable(iris, options = list(pageLength = 5, scrollX = TRUE))
```



# DASHBOARD 2 ####

---
title: "Demo 2 — Layout básico (fila)"
output:
  flexdashboard::flex_dashboard:
  orientation: rows
vertical_layout: fill
theme: cosmo
source_code: embed
---
  
  
  
```{r setup, include=FALSE, echo = F, message = F, warning = F}
knitr::opts_chunk$set(echo = TRUE)
```

```{r, echo = F}
library(flexdashboard)
library(leaflet)
library(ggplot2)
library(DT)
library(dplyr)
```

# Solapa 1 {data-width=40%}

## Indicadores clave

```{r, echo = F}

flexdashboard::valueBox(1200, caption = "Usuarios activos", icon = "fa-user", color = "primary")
flexdashboard::valueBox(88, "Satisfacción (%)", icon = "fa-smile", color = "success")
flexdashboard::valueBox(-4.2, "Variación mensual (%)", icon = "fa-chart-line",
                        color = ifelse(-4.2 >= 0, "success", "danger"))

```

# Solapa 2 {data-height=600}

## Serie de tiempo (paquete 'economics')

```{r, echo = F}

plotly::plot_ly(economics, x = ~date, y = ~uempmed, type = "scatter", mode = "lines") |>
  plotly::layout(title = "Duración de desempleo (mediana)")

```


# DASHBOARD 3 ####

---
title: "Demo 3 — Leaflet con clústers y leyenda" # otro
output:
  flexdashboard::flex_dashboard:
  orientation: rows
vertical_layout: fill
theme: flatly # otro
source_code: embed
---
  
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```  

```{r, echo = F}
library(flexdashboard)
library(leaflet)
library(ggplot2)
library(DT)
library(dplyr)
```

# Solapa 1 {data-height=700}

## Mapa con clústers

```{r, echo = F}

df <- data.frame(
  lat = runif(600, -40, -27),
  lon = runif(600, -65, -57),
  Provincia = sample(c("BA","CABA","SF","CBA","ER"), 600, TRUE)
)
sube <- sf::st_as_sf(df, coords = c("lon","lat"), crs = 4326)

sube_grp <- dplyr::mutate(sube,
                          Provincia = as.character(Provincia),
                          Grupo = dplyr::case_when(
                            Provincia %in% c("BA","CABA") ~ "PBA/AMBA",
                            Provincia == "SF" ~ "Santa Fe",
                            TRUE ~ "Resto"
                          ))

pal <- leaflet::colorFactor("Set2", domain = unique(sube_grp$Grupo))




leaflet::leaflet(sube_grp) |>
  leaflet::addProviderTiles("CartoDB.Positron") |>
  leaflet::addCircleMarkers(
    radius = 4, stroke = FALSE, fillOpacity = 0.85,
    fillColor = ~pal(Grupo),
    popup = ~paste0("Grupo: ", Grupo),
    clusterOptions = leaflet::markerClusterOptions()
  ) |>
  leaflet::addLegend("bottomright", pal = pal, values = ~Grupo, title = "Grupo")

```



