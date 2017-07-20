library(sf)
library(rgdal)
library(raster)
library(dplyr)

DATADIR <- '/nfs/NaturalCapitalAccounting-data'

shp <- file.path(DATADIR, 'cb_2016_us_county_5m')
counties <- st_read(shp, stringsAsFactors = FALSE)

raster_2001 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2001_MD_Clip.tif')
#nlcd_2001 <- raster(raster_2001)
raster_2006 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2006_MD_Clip.tif')
raster_2011 <- file.path(DATADIR, 'Land_Use_and_Land_Change/LC_2011_MD_Clip.tif')
nlcd_stack <- stack(c(raster_2001,raster_2006,raster_2011))
nlcd_stack <- aggregate(nlcd_stack, fact = 10, fun = modal)
plot(nlcd_stack, 1) #would plot the first layer in the stack

# see also for an alternative method for locating files and stacking them
# nlcd_stacklist.files(path = , pattern = '*.tif', full.names = TRUE)

counties_md <- filter(counties, STATEFP == '24')

forest <- (nlcd_stack %in% c(41,42,43))

nlcd_md <- extract(nlcd_stack, counties_md, fun = sum)
