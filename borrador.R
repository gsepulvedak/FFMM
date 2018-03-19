library(tidyverse)
library(XML)
library(rvest)
library(stringr)

url <- "https://www.aafm.cl/tecnoera/index.php?clase=informe&metodo=rentabilidad_eei_html&administradora=96667040&dia=1&mes=1&anio=2010"

cols <- c("Administradora", "Run", "FontoMutuo", "Serie", "ValorCuota", "Nominal_d", "Nominal_30d", "Real_30d", "Nominal_3m", "Real_3m", "Nominal_12m", "Real_12m", "Nominal_YTD", "Real_YTD")

doc <- read_html(url)
doc_parsed <- htmlParse(doc)

data <- xpathSApply(doc_parsed, "//td[text()='UNIVE']/..", xmlValue)

data <- lapply(data, str_split, "\t")
names(data) <- 1:length(data)
dataset <- t(cross_df(data)) %>% as_tibble()
names(dataset) <- names
dataset[] <- lapply(dataset, str_replace_all, pattern = "\n|%", replacement = "")
dataset[] <- lapply(dataset, str_replace_all, pattern = "\\.", replacement = "")
dataset[] <- lapply(dataset, str_replace_all, pattern = ",", replacement = "\\.")


