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
# [DONE]Linea 70 estoy hechando machete porque no se como poner en una misma iteracion varias lineas. los{ } solo sirven de auna linea 
# atento a la linea 100 al parecer no puedo usar ese tipo de variable  Error: Fill argument neither colors nor valid variable name(s)
# toca rebuscar como hacer esa iteracion


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
#now <- as.POSIXlt(Sys.time(), "GMT") 


#Set variable names for files
x4wdatafile <- "data/20171121_compiledformaps.xlsx" #Compiled XLS file
x4wdatasheet <- "Compiled"  #Datasheet in the excell
syrshapefile <- "data/gis/syradmin3/sub-district.shp" #Shape file #The field with relation to Admin3Pcode is Nahya_pcode

#iteration for map production #Variables#  in datasheet: Admin3_Pcode	Admin1_Pcode	outpatient_consultations 	trauma_cases	persons_disabilities	deliveries	Total
# op tc pd de
varlistfields = list("outpatient_consultations", "trauma_cases",	"persons_disabilities",	"deliveries") #Armo la lista de variables
varlistnames = list("Outpatient Consultations","Trauma Cases Supported","Persons with disabilities supported", "Deliveries attended by skill attendant")

#the construction of the iteration matrix gots too complex so for now I preffer to run the same file several times changing just those vars
thismapfield <- "deliveries"
thismapname <- "Deliveries attended"
thismappalette  <- "PRGn"
thismapfilenamejpg <- "deliveries.jpg"
thismapfilenamepng <- "deliveries.png"
thismapfilenamehtm <- "deliveries.html"

#Starting message
cat("Starting to draw the map", now )
as.POSIXlt(Sys.time(), "GMT") #da la hora del proceso no he podido dejarla como variable


# Load the tmap, tmaptools, and leaflet packages into your working session: 
library("tmap")
library("tmaptools")
library("leaflet")
library("sf")
library("leaflet.extras")
library("dplyr")
library(readxl)#added by RStudio 

#read the 4W data file
compiled4w <- read_excel(x4wdatafile, sheet =x4wdatasheet ) #faviable names on top

# Read in the shapefile for US states and counties:
syrgeo <- read_shape(file=syrshapefile, as.sf = TRUE)

# -OPTIONAL- Do a quick plot of the shapefile and check its structure:
#qtm(syrgeo)



compiled4w  <- compiled4w[,c("Admin3_Pcode","Admin1_Pcode",thismapfield )] 

#  compiled4w_oc  <- compiled4w[,c("Admin3_Pcode","Admin1_Pcode",	"outpatient_consultations")] 
#}

# Add columns for percents and margins:
# NO LAS VOY A USAR AHORA compiled4w_oc$
#nhdata$SandersMarginVotes <- nhdata$Sanders - nhdata$Clinton
#nhdata$SandersPct <- (nhdata$Sanders) / (nhdata$Sanders + nhdata$Clinton) # Will use formatting later to multiply by a hundred
#nhdata$ClintonPct <- (nhdata$Clinton) / (nhdata$Sanders + nhdata$Clinton)
#nhdata$SandersMarginPctgPoints <- nhdata$SandersPct - nhdata$ClintonPct

#  -OPTIONAL-  To see the structure of the object
#str(syrgeo)


# Merge data with tmaptool's append_data function
syrmap <- append_data(syrgeo, compiled4w, key.shp = "Nahya_pcod", key.data="Admin3_Pcode")
cat("creating the shape dataset for: '",thismapname,"' \n")

# See the new data structure with
str(syrmap)

# Quick and easy maps as static images with tmap's qtm() function:
qtm(syrmap, thismapfield)

# Same code as above, but store the map in a variable:
syrstaticmap <- tm_shape(syrmap) +
  tm_fill( thismapfield, title=thismapname, palette = thismappalette) +
  tm_borders(alpha=.2) +
  tm_text(thismapfield, size=0.8) + 
  tm_style_classic()

# View the map
#syrstaticmap

save_tmap(syrstaticmap, filename= thismapfilenamejpg , width=1920, height=1080, asp=0)
save_tmap(syrstaticmap, filename=thismapfilenamehtm)

#View(X20171121_compiledformaps)




#End de luish