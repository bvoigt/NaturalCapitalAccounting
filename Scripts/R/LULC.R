library(sf)
library(rgdal)
library(raster)
library(dplyr)

DATADIR <- '/nfs/NaturalCapitalAccounting-data'
DATADIR2 <- '/nfs/NaturalCapitalAccounting-data/Land_Use_and_Land_Change'

#Read in county shapefile
countyShp <- file.path(DATADIR, 'cb_2016_us_county_5m')
counties <- st_read(countyShp, stringsAsFactors = FALSE)

stateShp <- file.path(DATADIR2, 'MD_Extract.shp')
state_md <- st_read(stateShp, stringsAsFactors = FALSE)

#Read in raster files for NLCD 2001, 2006, 2011
raster_2001 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2001_MD_Clip.tif')
#nlcd_2001 <- raster(raster_2001)
raster_2006 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2006_MD_Clip.tif')
raster_2011 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2011_MD_Clip.tif')
nlcd_2011 <- raster(raster_2011)

#Stack raster files for ease of processing
nlcd_stack <- stack(c(raster_2001,raster_2006,raster_2011))
#nlcd_stack <- aggregate(nlcd_stack, fact = 100, fun = modal)
plot(nlcd_stack, 1) #would plot the first layer in the stack

# see also for an alternative method for locating files and stacking them
# nlcd_stacklist.files(path = , pattern = '*.tif', full.names = TRUE)


#Filter counties dataset to only include Maryland
counties_md <- filter(counties, STATEFP == '24')

#Filter NLCD layers to only examine change in forest cover
forest <- (nlcd_md %in% c(41,42,43))

#Clip NLCD files to Maryland boundary
counties_md <- as(counties_md, "Spatial")
state_md <- st_transform(state_md,crs = '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83
+units=m +no_defs +ellps=GRS80 +towgs84=0,0,0')
state_md <- as(state_md, 'Spatial')
nlcd_md <- mask(nlcd_2011, state_md)
plot(nlcd_md)

#Animate NLCD files to show change over time in Maryland
testAnimate <- animate(nlcd_md, pause = 1, n = 1)
