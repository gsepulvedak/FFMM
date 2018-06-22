library(tidyverse)
library(readr)

#Crear carpeta para almacenar data de FFMM en csv
if(!dir.exists("~/R_wd/FFMM/Archivos")) dir.create("~/R_wd/FFMM/Archivos")

#Crear dataset vacío 
dataset <- data.frame(FondoMutuo = character(),
                  Fecha = numeric(),
                  ValorCuota = numeric(),
                  Nominal_d = numeric(),
                  Nominal_30d = numeric(),
                  Real_30d = numeric(),
                  Nominal_3m = numeric(),
                  Real_3m = numeric(),
                  Nominal_12m = numeric(),
                  Real_12m = numeric(),
                  Nominal_YTD = numeric(),
                  Real_YTD = numeric()
                  )

#Generar archivo csv inicial
write_csv(dataset, "~/R_wd/FFMM/Archivos/FFMM_data.csv")
rm(dataset)
