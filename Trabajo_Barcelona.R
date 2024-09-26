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

# 1. Introducción

-   **Objetivo del análisis**: Investigar la variación de los precios de las viviendas en Barcelona en función de la ubicación geográfica y las características intrínsecas de las propiedades.

-   **Importancia del estudio**: Comprender estos patrones es crucial para agentes inmobiliarios, compradores, inversores y planificadores urbanos.

-   **Descripción del conjunto de datos**:

    -   **Indice**: Número de índice que identifica cada registro en el conjunto de datos; es decir, el número de fila.

    <!-- -->

    -   **ID_Activo**: Identificador único asignado a cada propiedad o activo inmobiliario.

    -   **Trimestre**: Periodo del año en que se recopiló la información, dividido en trimestres. (Se utilizarán únicamente las observaciones del 4º Trimestre)

    -   **Precio_de_venta**: Precio total de venta de la vivienda en euros.

    -   **Precio_venta_m2_euros**: Precio de venta por metro cuadrado de la vivienda en euros.

    -   **Superficie_m2**: Tamaño o área total de la vivienda en metros cuadrados.

    -   **Numero_habitaciones**: Cantidad de habitaciones o dormitorios que tiene la vivienda.

    -   **Numero_banos**: Cantidad de baños disponibles en la vivienda.

    -   **Tiene_Terraza**: Indica si la vivienda cuenta con una terraza (Sí/No).

    -   **Tiene_Ascensor**: Indica si el edificio donde se encuentra la vivienda tiene ascensor (Sí/No).

    -   **Tiene_Aire_Acondicionado**: Indica si la vivienda dispone de sistema de aire acondicionado (Sí/No).

    -   **ID_Amenidad**: Identificador de las amenidades o características adicionales asociadas a la vivienda.

    -   **Tiene_Plaza_Garaje**: Indica si la vivienda incluye una plaza de garaje o estacionamiento (Sí/No).

    -   **Garaje_Incluido_Precio**: Indica si el precio de la plaza de garaje está incluido en el precio total de venta de la vivienda (Sí/No).

    -   **Precio_Garaje**: Precio de la plaza de garaje en euros, en caso de que no esté incluida en el precio de venta.

    -   **Orientacion_Norte**: Indica si la orientación principal de la vivienda es hacia el norte (Sí/No).

    -   **Orientacion_Sur**: Indica si la orientación principal de la vivienda es hacia el sur (Sí/No).

    -   **Orientacion_Este**: Indica si la orientación principal de la vivienda es hacia el este (Sí/No).

    -   **Orientacion_Oeste**: Indica si la orientación principal de la vivienda es hacia el oeste (Sí/No).

    -   **Tiene_Trastero**: Indica si la vivienda cuenta con un trastero o espacio de almacenamiento adicional (Sí/No).

    -   **Tiene_Armario_Empotrado**: Indica si la vivienda dispone de armarios empotrados en las habitaciones (Sí/No).

    -   **Tiene_Piscina**: Indica si la vivienda o el edificio cuenta con una piscina (Sí/No).

    -   **Tiene_Portero**: Indica si el edificio tiene servicio de portería o conserjería (Sí/No).

    -   **Tiene_Jardin**: Indica si la vivienda o el edificio dispone de un jardín (Sí/No).

    -   **Es_Duplex**: Indica si la vivienda es un dúplex, es decir, tiene dos niveles conectados internamente (Sí/No).

    -   **Es_Estudio**: Indica si la vivienda es un estudio, generalmente un espacio abierto sin divisiones (Sí/No).

    -   **Esta_Ultima_Planta**: Indica si la vivienda se encuentra en la última planta del edificio (Sí/No).

    -   **Anio_construccion_anunciante**: Año de construcción de la vivienda según la información proporcionada por el anunciante o vendedor.

    -   **Piso_Limpio**: Posiblemente indica si la vivienda ha sido limpiada o preparada para la venta; podría referirse al estado general de limpieza (interpretación puede variar según contexto).

    -   **ID_Ubicacion_Piso**: Identificador único asociado a la ubicación específica de la vivienda.

    -   **Anio_construccion_catastro**: Año de construcción de la vivienda según los registros oficiales del catastro.

    -   **Numero_max_pisos_edificio**: Número máximo de plantas que tiene el edificio donde se encuentra la vivienda.

    -   **Numero_viviendas_edificio**: Número total de viviendas o unidades habitacionales en el edificio.

    -   **Calidad_catastral_0_Mejor_10_Peor**: Calificación de la calidad catastral de la vivienda en una escala de 0 a 10, donde 0 indica la mejor calidad y 10 la peor.

    -   **Es_nueva_construccion**: Indica si la vivienda es de nueva construcción y no ha sido habitada previamente (Sí/No).

    -   **Es_segunda_mano_restaurar**: Indica si la vivienda es de segunda mano y requiere restauración o reformas significativas (Sí/No).

    -   **Es_segunda_mano_buen_estado**: Indica si la vivienda es de segunda mano pero se encuentra en buen estado y no requiere reformas (Sí/No).

    -   **Distancia_centro_ciudad**: Distancia desde la vivienda hasta el centro de la ciudad, generalmente medida en kilómetros o metros.

    -   **Distancia_estacion_metro**: Distancia desde la vivienda hasta la estación de metro más cercana.

    -   **Distancia_calle_principal**: Distancia desde la vivienda hasta la calle principal más cercana o importante.

    -   **Longitud**: Coordenada geográfica de longitud de la ubicación de la vivienda.

    -   **Latitud**: Coordenada geográfica de latitud de la ubicación de la vivienda.

    -   **Codigo_Barrio**: Código numérico o alfanumérico que identifica de manera única al barrio donde se encuentra la vivienda.

    -   **Barrio**: Nombre del barrio o vecindario donde está ubicada la vivienda.

    -   **Codigo_Distrito**: Código numérico o alfanumérico que identifica de manera única al distrito municipal.

    -   **Distrito**: Nombre del distrito municipal donde se ubica la vivienda.

# 2. Importación y preparación de datos
- Cambiamos el nombre de todas las variables para que sean más fáciles de identificar.
- Filtramos los datos para coger solamente el 4º trimestre.
- Se elimina la variable "Anio_construccion_anunciante" ya que tiene más de un 20% de datos faltantes.
- Se convierten las variables categoricas "Barrio", "Distrito" y "Codigo_Distrito" a factores.
```{r introducción_de_datos, include=FALSE}
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
```

```{r 4º_Trimestre, include=FALSE}
Datos_4ºTrimestre <- Datos_brutos %>% # Filtramos los datos para que solo aparezcan las observaciones del 4º trimestre
  filter(Trimestre == 201812)
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
# Calcular estadísticas descriptivas para el precio y la superficie construida
resumen_precio <- summary(Datos_4ºTrimestre$Precio_de_venta)
resumen_superficie <- summary(Datos_4ºTrimestre$Superficie_m2)
# Calcular el precio por metro cuadrado
Datos_4ºTrimestre <- Datos_4ºTrimestre %>%
  mutate(PrecioPorMetroCuadrado = Precio_de_venta / Superficie_m2)
# Calcular estadísticas descriptivas del precio por metro cuadrado
resumen_precio_m2 <- summary(Datos_4ºTrimestre$PrecioPorMetroCuadrado)
```

# 3. Análisis exploratorio de datos (EDA)

## 3.1. Análisis por ubicación

Distribución de precios por distrito y barrio:

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

```{r}
library(dplyr)
library(ggplot2)
library(forcats)

# Filtrar los datos eliminando los outliers por distrito usando el IQR
Datos_sin_outliers <- Datos_4ºTrimestre %>%
  group_by(Distrito) %>%
  filter(
    Precio_de_venta > (quantile(Precio_de_venta, 0.25) - 1.5 * IQR(Precio_de_venta)) &
    Precio_de_venta < (quantile(Precio_de_venta, 0.75) + 1.5 * IQR(Precio_de_venta))
  )

# Calcular las medianas de precio por distrito
medianas_por_distrito <- Datos_sin_outliers %>%
  group_by(Distrito) %>%
  summarise(mediana_precio = median(Precio_de_venta, na.rm = TRUE)) %>%
  arrange(mediana_precio)

# Reordenar el factor 'Distrito' según la mediana calculada
Datos_sin_outliers <- Datos_sin_outliers %>%
  mutate(Distrito = factor(Distrito, levels = medianas_por_distrito$Distrito))

# Crear el boxplot sin los datos anómalos, con distritos ordenados por mediana
ggplot(Datos_sin_outliers, aes(x = Distrito, y = Precio_de_venta / 1000)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Distribución de precios por Distrito (sin outliers y ordenados por mediana)",
       x = "Distrito",
       y = "Precio de venta (miles de euros)")

```
