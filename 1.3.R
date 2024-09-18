
# Librerias ---------------------------------------------------------------


library(tidyverse)
library(stringr)
library(openxlsx)

# Obtención del IPC -------------------------------------------------------

direccion_enlace_excel <- "https://www.bde.es/webbe/es/estadisticas/compartido/datos/xlsx/be2623.xlsx"

datos_inflacion <- read.xlsx(xlsxFile = direccion_enlace_excel, na.strings = "-", colNames = FALSE)






