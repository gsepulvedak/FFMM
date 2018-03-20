library(tidyverse)
library(XML)
library(rvest)
library(stringr)
library(lubridate)

#Definir intervalo de tiempo a procesar
start <- ymd(20100101)
end <- today()
days <- time_length(interval(start, end), unit = "day")
url_date <- start+0:days

#Generar URL para descarga
url_base <- "https://www.aafm.cl/tecnoera/index.php?clase=informe&metodo=rentabilidad_eei_html&administradora=96667040"
url_dia <- paste0("&dia=", day(url_date))
url_mes <- paste0("&mes=", month(url_date))
url_anio <- paste0("&anio=", year(url_date))
url <- paste0(url_base, url_dia, url_mes, url_anio)

#Iterar sobre URL para obtener datos
dataset <- map2(url, url_date, function(url, url_date){
  #leer documento html
  doc <- read_html(url)
  doc_parsed <- htmlParse(doc)
  
  #Obtener y post procesar los datos de interés
  data <- xpathSApply(doc_parsed, "//td[text()='UNIVE']/..", xmlValue)
  data <- lapply(data, str_split, "\t")
  names(data) <- 1:length(data)
  dataset <- t(cross_df(data)) %>% as_tibble()
  dataset[] <- lapply(dataset, str_replace_all, pattern = "\n|%", replacement = "")
  dataset[] <- lapply(dataset, str_replace_all, pattern = "\\.", replacement = "")
  dataset[] <- lapply(dataset, str_replace_all, pattern = ",", replacement = "\\.")
  dataset <- dataset %>% select(-V1,-V2,-V4) %>% mutate(Fecha = url_date) %>% .[,c(1,12,2:11)]
  
  #Almacenar en csv FFMM_data
  write_csv(dataset, "~/R_wd/FFMM/Archivos/FFMM_data.csv", append = TRUE)
})

