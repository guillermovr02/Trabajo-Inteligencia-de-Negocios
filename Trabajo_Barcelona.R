
# Librerías ---------------------------------------------------------------

# Configurar los paquetes necesarios
library(rmarkdown)
library(tidyverse)  # Conjunto de paquetes para manipulación de datos (dplyr, tidyr, ggplot2, etc.)
library(ggplot2)    # Paquete para visualización de datos
library(ggthemes)   # Proporciona temas adicionales para mejorar gráficos de ggplot2
library(bookdown)   # Herramienta para crear documentos, especialmente libros en varios formatos
library(dplyr)      # Paquete para la manipulación de datos (parte de tidyverse)
library(tinytex)    # Permite compilar documentos LaTeX de forma ligera
library(tidyr)      # Paquete para la limpieza y transformación de datos (parte de tidyverse)
library(ggrepel)    # Mejora las etiquetas en los gráficos de ggplot2 para evitar superposición
library(here)       # Facilita la referencia a archivos dentro de un proyecto R
library(knitr)      # Paquete para la generación de informes y documentos dinámicos en R
library(corrplot)   # Visualización de matrices de correlación
library(naniar)     # Para datos faltantes

# Cargar los Datos --------------------------------------------------------

Datos_4ºTrimestre <- read.csv(file = "Datos/datos_barcelona.csv")
colnames(Datos_4ºTrimestre) <- c(
  "Indice",                           
  "IDActivo",                         
  "Trimestre",                          
  "Precio de venta",                            
  "Precio de venta por m² (euros)",                   
  "Superficie (m²)",             
  "Número de habitaciones",          
  "Número de baños",                      
  "Tiene Terraza",                      
  "Tiene Ascensor",                     
  "Tiene Aire Acondicionado",            
  "IDAmenidad",                       
  "Tiene Plaza De Garaje",               
  "Garaje Incluido En El Precio",        
  "Precio Garaje",                    
  "Orientacion Norte",               
  "Orientacion Sur",                   
  "Orientacion Este",                  
  "Orientacion Oeste",                  
  "Tiene Trastero",                     
  "Tiene Armario Empotrado",            
  "Tiene Piscina",                   
  "Tiene Portero",                      
  "Tiene Jardin",                       
  "Es Duplex",                         
  "Es Estudio",                         
  "Esta En Ultima Planta",               
  "Año de construcción (anunciante)",                  
  "Piso Limpio",                      
  "IDUbicacionPiso",                   
  "Año de construcción (catastro)",         
  "Número máximo de pisos del edificio",           
  "Número de viviendas en el edificio",                 
  "Calidad catastral. 0 Mejor - 10 Peor",               
  "Es nueva construcción",             
  "Es de segunda mano para restaurar",             
  "Es de segunda mano en buen estado",              
  "Distancia al centro de la ciudad",                
  "Distancia a la estación de metro",                  
  "Distancia a la calle principal",                
  "Longitud",                        
  "Latitud",                          
  "CodigoBarrio",                     
  "Barrio",                            
  "CodigoDistrito",                    
  "Distrito"                          
)

Datos_4ºTrimestre <- Datos_4ºTrimestre %>% # Filtramos los datos para que solo aparezcan las observaciones del 4º trimestre
  filter(Trimestre == 201812)


# Analisis Exploratorio ---------------------------------------------------

# Calcular estadísticas descriptivas para el precio y la superficie construida
resumen_precio <- summary(Datos_4ºTrimestre$`Precio de venta`)
resumen_superficie <- summary(Datos_4ºTrimestre$`Superficie (m²)`)
# Calcular el precio por metro cuadrado
Datos_4ºTrimestre <- Datos_4ºTrimestre %>%
  mutate(PrecioPorMetroCuadrado = `Precio de venta` / `Superficie (m²)`)
# Calcular estadísticas descriptivas del precio por metro cuadrado
resumen_precio_m2 <- summary(Datos_4ºTrimestre$PrecioPorMetroCuadrado)


# Limpieza de Datos -------------------------------------------------------

sapply(Datos_4ºTrimestre, function(x) sum(is.na(x)))

#1.Análisis de valores inconsistentes
Datos_4ºTrimestre %>% 
  filter(if_any(everything(), ~ . >= 0))

#2.Análisis de valores faltantes

#Proporción de datos faltantes para cada variable
miss_var_summary(Datos_4ºTrimestre)





