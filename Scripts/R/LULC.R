library(sf)
library(rgdal)
library(raster)
library(dplyr)

DATADIR <- '/nfs/NaturalCapitalAccounting-data'

#Read in county shapefile
shp <- file.path(DATADIR, 'cb_2016_us_county_5m')
counties <- st_read(shp, stringsAsFactors = FALSE)

#Read in raster files for NLCD 2001, 2006, 2011
raster_2001 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2001_MD_Clip.tif')
#nlcd_2001 <- raster(raster_2001)
raster_2006 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2006_MD_Clip.tif')
raster_2011 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2011_MD_Clip.tif')

#Stack raster files for ease of processing
nlcd_stack <- stack(c(raster_2001,raster_2006,raster_2011))
nlcd_stack <- aggregate(nlcd_stack, fact = 10, fun = modal)
plot(nlcd_stack, 1) #would plot the first layer in the stack

# see also for an alternative method for locating files and stacking them
# nlcd_stacklist.files(path = , pattern = '*.tif', full.names = TRUE)


#Filter counties dataset to only include Maryland
counties_md <- filter(counties, STATEFP == '24')

#Filter NLCD layers to only examine change in forest cover
forest <- (nlcd_stack %in% c(41,42,43))

#Clip NLCD files to Maryland boundary
nlcd_md <- extract(nlcd_stack, counties_md, fun = sum)

#Animate NLCD files to show change over time in Maryland
testAnimate <- animate(nlcd_stack, pause = 1, n = 1)
