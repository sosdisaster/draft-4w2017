# R scripts for health activities mapping
# 2017 11 01
#
# guidance https://docs.google.com/document/d/1Mv9eXVOQhebSithWVTKnj8WHy4fK2xMyNn5P4GYIKso/edit#
# TODO
# ====
# Estoy haciendo la lista de valiables para hacer una iteracion y armar todos los mapas de un chingon
# [DONE] Get the SHP file of admin3
# [DONE] define the data available
# [DONE] Run the script: ya se ve el mapa
#

#Set variable names
x4wdatafile <- "C:/Users/aguilarl/Google Drive/_Cosas de LuisH/_Rprojects/healthHNOHRP2018/4w2017/data/20171121_compiledformaps.xlsx" #Compiled XLS file
x4wdatasheet <- "Compiled"  #Datasheet in the excell
### Variables###  in the datasheet Admin3_Pcode	Admin1_Pcode	outpatient_consultations 	trauma_cases	persons_disabilities	deliveries	Total
syrshapefile <- "data/gis/syradmin3/sub-district.shp" #Shape file
#The field with relation to Admin3Pcode is Nahya_pcode




# Run any of the install.packages() commands below for packages that are not yet on your system
install.packages("shiny") 
install.packages("urltools")
install.packages("tmap")
install.packages("tmaptools")
install.packages("leaflet")
install.packages("leaflet.extras")
install.packages("rio")
install.packages("scales")
install.packages("htmlwidgets")
install.packages("sf")
install.packages("dplyr")

# Load the tmap, tmaptools, and leaflet packages into your working session: 
library("tmap")
library("tmaptools")
library("leaflet")
library("sf")
library("leaflet.extras")
library("dplyr")
library(readxl)#agregado por RStudio cuando abri el archivo

#read the 4W data file
compiled4w <- read_excel(x4wdatafile, sheet =x4wdatasheet ) #faviable names on top

#creating the dataset for Outpatience consultations
##ACA ACA ACA
compiled4w_oc  <- compiled4w[,c("Admin3_Pcode","Admin1_Pcode",	"trauma_cases")]

# Add columns for percents and margins:
# NO LAS VOY A USAR AHORA compiled4w_oc$
#nhdata$SandersMarginVotes <- nhdata$Sanders - nhdata$Clinton
#nhdata$SandersPct <- (nhdata$Sanders) / (nhdata$Sanders + nhdata$Clinton) # Will use formatting later to multiply by a hundred
#nhdata$ClintonPct <- (nhdata$Clinton) / (nhdata$Sanders + nhdata$Clinton)
#nhdata$SandersMarginPctgPoints <- nhdata$SandersPct - nhdata$ClintonPct

# Read in the shapefile for US states and counties:
syrgeo <- read_shape(file=syrshapefile, as.sf = TRUE)


# Do a quick plot of the shapefile and check its structure:
qtm(syrgeo)

# structure of the object
str(syrgeo)


# Merge data with tmaptool's append_data function
syrmap <- append_data(syrgeo, compiled4w_oc, key.shp = "Nahya_pcod", key.data="Admin3_Pcode")

# See the new data structure with
str(syrmap)

# Quick and easy maps as static images with tmap's qtm() function:
#ACA ACA ACA
qtm(syrmap, "trauma_cases")


# Same code as above, but store the map in a variable:
#ACA ACA ACA 
syrstaticmap <- tm_shape(syrmap) +
  tm_fill("trauma_cases", title="trauma Cases ", palette = "YlGnBu") + # PRGn PuBu OrRd YlOrRd  YlGnBu" Greens class 1(no sirve"
  tm_borders(alpha=.5) +
  tm_text("trauma_cases", size=0.8) + 
  tm_style_classic()

# View the map
syrstaticmap

# save the map to a jpg file with tmap's save_tmap():
#ACA ACA ACA
save_tmap(syrstaticmap, filename="trauma_cases.jpg")



#View(X20171121_compiledformaps)

#End de luish