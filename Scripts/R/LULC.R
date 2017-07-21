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
nlcd_2001 <- raster(raster_2001)
nlcd_2001 <- aggregate(nlcd_2001, fact = 100, fun = modal)

raster_2006 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2006_MD_Clip.tif')
nlcd_2006 <- raster(raster_2006)
nlcd_2006 <- aggregate(nlcd_2006, fact = 100, fun = modal)

raster_2011 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2011_MD_Clip.tif')
nlcd_2011 <- raster(raster_2011)
nlcd_2011 <- aggregate(nlcd_2011, fact = 100, fun = modal)

#Stack raster files for ease of processing
#nlcd_stack <- stack(c(raster_2001,raster_2006,raster_2011))
#nlcd_stack <- aggregate(nlcd_stack, fact = 100, fun = modal)
plot(nlcd_stack, 1) #would plot the first layer in the stack

# see also for an alternative method for locating files and stacking them
# nlcd_stacklist.files(path = , pattern = '*.tif', full.names = TRUE)


#Filter counties dataset to only include Maryland
counties_md <- filter(counties, STATEFP == '24')

#Filter NLCD layers to only examine change in forest cover
forest_stack <- (nlcd_stack %in% c(41,42,43))
names(forest_stack) <- c('NLCD2001', 'NLCD2006', 'NLCD2011')

#Clip NLCD files to Maryland boundary
counties_md <- as(counties_md, "Spatial")
state_md <- st_transform(state_md,crs = '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83
+units=m +no_defs +ellps=GRS80 +towgs84=0,0,0')
state_md <- as(state_md, 'Spatial')

nlcd_md_2001 <- mask(nlcd_2001, state_md)
nlcd_md_2006 <- mask(nlcd_2006, state_md)
nlcd_md_2011 <- mask(nlcd_2011, state_md)
nlcd_stack <- stack(c(nlcd_md_2001,nlcd_md_2006,nlcd_md_2011))

plot(nlcd_md)

#Animate NLCD files to show change over time in Maryland
forest_stack <- mask(forest_stack, state_md)
testAnimate <- animate(forest_stack, pause = 1, n = 1)
