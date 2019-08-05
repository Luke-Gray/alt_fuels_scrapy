library(dplyr)
suppressMessages(library(tidyverse, quietly = T))
library(ggplot2)
library(maps)
library(leaflet)
library(stats)
library(data.table)
library(shiny)
library(DT)
install.packages("RSQLite")
library(rsconnect)
library(RSQLite)

source("./helpers.R")
db1name = "./vehicles.sqlite"
db2name = "./fuels.sqlite"
tblname = "vehicles"
tbl2name = 'fuels'


setwd('C:\\Users\\16507\\Desktop\\Bootcamp\\Shiny_fuel_proj\\alt_fuel_app')
vehicles = read.csv('ldv.csv', encoding = 'utf-8', stringsAsFactors = F)
fuels = read.csv('fuel.csv', encoding = 'utf-8', stringsAsFactors = F)

fuels$latlong = paste(fuels$latitude, fuels$longitude, sep=":")
vehicles = vehicles[!(vehicles$fuel_type_code=='LPG' & vehicles$manufacturer!='Hyundai'& vehicles$fuel_configuration.name == 'Hybrid Electric'),]
