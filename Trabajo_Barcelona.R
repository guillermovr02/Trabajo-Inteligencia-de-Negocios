---
title: "Estudio sobre la vivienda en Barcelona"
author: |
  Luis Cuenca Urizar\hfill\
  Guillermo Vergara Ramón\hfill\
  Àngel Lova Tormos\hfill\
date: "2024-09-20"
output:
  pdf_document:
    latex_engine: xelatex
header-includes:
  - \usepackage{titling}
  - \preauthor{\begin{center}\small}
  - \postauthor{\end{center}}
  - \usepackage{enumitem}
  - \setlist{after=\pagebreak[0]}
---
```{r setup, include=FALSE}
# Configurar los paquetes necesarios
library(rmarkdown)  # Para la creación de documentos dinámicos en R
library(tidyverse)  # Conjunto de paquetes para manipulación de datos (dplyr, tidyr, ggplot2, etc.)
library(ggplot2)    # Paquete para visualización de datos
library(ggthemes)   # Proporciona temas adicionales para mejorar gráficos de ggplot2
library(bookdown)   # Herramienta para crear documentos, especialmente libros en varios formatos
library(dplyr)      # Paquete para la manipulación de datos (parte de tidyverse)
library(tinytex)    # Permite compilar documentos LaTeX de forma ligera
library(tidyr)      # Paquete para la limpieza y transformación de datos (parte de tidyverse)
library(emoji)      # Paquete para usar emojis en textos y gráficos
library(ggrepel)    # Mejora las etiquetas en los gráficos de ggplot2 para evitar superposición
library(here)       # Facilita la referencia a archivos dentro de un proyecto R
library(knitr)      # Paquete para la generación de informes y documentos dinámicos en R
library(corrplot)   # Visualización de matrices de correlación
library(naniar)     # Para datos faltantes
```

```{r include=FALSE}
Barcelona <- "datos_barcelona.csv"
Datos_brutos <- read.csv(file = Barcelona)
colnames(Datos_brutos) <- c(
  "Indice",                           
  "ID_Activo",                         
  "Trimestre",                          
  "Precio_de_venta",                            
  "Precio_venta_m2_euros",                   
  "Superficie_m2",             
  "Numero_habitaciones",          
  "Numero_banos",                      
  "Tiene_Terraza",                      
  "Tiene_Ascensor",                     
  "Tiene_Aire_Acondicionado",            
  "ID_Amenidad",                       
  "Tiene_Plaza_Garaje",               
  "Garaje_Incluido_Precio",        
  "Precio_Garaje",                    
  "Orientacion_Norte",               
  "Orientacion_Sur",                   
  "Orientacion_Este",                  
  "Orientacion_Oeste",                  
  "Tiene_Trastero",                     
  "Tiene_Armario_Empotrado",            
  "Tiene_Piscina",                   
  "Tiene_Portero",                      
  "Tiene_Jardin",                       
  "Es_Duplex",                         
  "Es_Estudio",                         
  "Esta_Ultima_Planta",               
  "Anio_construccion_anunciante",                  
  "Piso_Limpio",                      
  "ID_Ubicacion_Piso",                   
  "Anio_construccion_catastro",         
  "Numero_max_pisos_edificio",           
  "Numero_viviendas_edificio",                 
  "Calidad_catastral_0_Mejor_10_Peor",               
  "Es_nueva_construccion",             
  "Es_segunda_mano_restaurar",             
  "Es_segunda_mano_buen_estado",              
  "Distancia_centro_ciudad",                
  "Distancia_estacion_metro",                  
  "Distancia_calle_principal",                
  "Longitud",                        
  "Latitud",                          
  "Codigo_Barrio",                     
  "Barrio",                            
  "Codigo_Distrito",                    
  "Distrito"                          
)
Datos_4ºTrimestre <- Datos_brutos %>% # Filtramos los datos para que solo aparezcan las observaciones del 4º trimestre
  filter(Trimestre == 201812)
```

# 1. Introducción
- **Objetivo del análisis**: Investigar la variación de los precios de las viviendas en Barcelona en función de la ubicación geográfica y las características intrínsecas de las propiedades.
- **Importancia del estudio**: Comprender estos patrones es crucial para agentes inmobiliarios, compradores, inversores y planificadores urbanos.
- **Descripción del conjunto de datos**: Presenta las variables clave relacionadas con precios, ubicación y características de las viviendas.

```{r include=FALSE}
# Calcular estadísticas descriptivas para el precio y la superficie construida
resumen_precio <- summary(Datos_4ºTrimestre$Precio_de_venta)
resumen_superficie <- summary(Datos_4ºTrimestre$Superficie_m2)
# Calcular el precio por metro cuadrado
Datos_4ºTrimestre <- Datos_4ºTrimestre %>%
  mutate(PrecioPorMetroCuadrado = Precio_de_venta / Superficie_m2)
# Calcular estadísticas descriptivas del precio por metro cuadrado
resumen_precio_m2 <- summary(Datos_4ºTrimestre$PrecioPorMetroCuadrado)
```

```{r include=FALSE}
# Calcular el % de valores NA en cada variable
# 'sapply' aplica la función 'mean(is.na(x)) * 100' a cada columna del dataframe, 
# lo que devuelve el porcentaje de valores faltantes (NA) por cada variable (columna).
sapply(Datos_4ºTrimestre, function(x) mean(is.na(x)) * 100)

# Calcular el porcentaje de NA por fila
# 'apply' aplica la misma función pero a nivel de filas (indicando '1' como segundo argumento),
# para obtener el porcentaje de NA en cada observación (fila).
porcentaje_NA_por_fila <- apply(Datos_4ºTrimestre, 1, function(x) mean(is.na(x)) * 100)

# Filtrar las observaciones con más del 20% de valores NA
# Se filtran las filas que tienen más del 20% de valores NA, seleccionando solo aquellas observaciones 
# cuyo porcentaje de NA supera el 20%.
observaciones_con_mas_de_20_NA <- Datos_4ºTrimestre[porcentaje_NA_por_fila > 20, ]

# Ver las observaciones filtradas
# Se muestran las observaciones que tienen más del 20% de valores NA.
observaciones_con_mas_de_20_NA

# Eliminar la columna 'Anio_construccion_anunciante' del dataframe
# 'select()' elimina la columna especificada del dataframe 'Datos_4ºTrimestre'.
Datos_4ºTrimestre <- Datos_4ºTrimestre %>% 
  select(-Anio_construccion_anunciante)
```

```{r include=FALSE}
# Convertir la variable 'Barrio' en un factor
# Esto es útil para trabajar con variables categóricas en análisis y modelos estadísticos.
Datos_4ºTrimestre$Barrio <- as.factor(Datos_4ºTrimestre$Barrio)

# Convertir la variable 'Distrito' en un factor
# Esto permite que R trate 'Distrito' como una variable categórica con niveles.
Datos_4ºTrimestre$Distrito <- as.factor(Datos_4ºTrimestre$Distrito)

# Convertir la variable 'Codigo_Distrito' en un factor
# Esto asegura que el 'Codigo_Distrito' también sea tratado como una variable categórica.
Datos_4ºTrimestre$Codigo_Distrito <- as.factor(Datos_4ºTrimestre$Codigo_Distrito)

```

```{r include=FALSE}
# Precio medio por distrito
precio_por_distrito <- Datos_4ºTrimestre %>%
  group_by(Distrito) %>%
  summarise(
    PrecioMedio = mean(Precio_de_venta, na.rm = TRUE),
    PrecioMediano = median(Precio_de_venta, na.rm = TRUE),
    NumeroViviendas = n()
  )
```

```{r}
# Boxplot de precios por distrito con precios en miles de euros
ggplot(Datos_4ºTrimestre, aes(x = Distrito, y = Precio_de_venta / 1000)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Distribución de precios por Distrito",
       x = "Distrito",
       y = "Precio de venta (miles de euros)")
```
