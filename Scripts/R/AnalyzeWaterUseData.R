#load libraries
library(dplyr)
library(ggplot2)
#install.packages('plotly')
#library(plotly)

#read in usgs use data
df2000 <- read.delim('https://water.usgs.gov/watuse/data/2000/usco2000.txt',na='')
df2005 <- read.delim('https://water.usgs.gov/watuse/data/2005/usco2005.txt',na='')
df2010 <- read.delim('https://water.usgs.gov/watuse/data/2010/usco2010.txt')


#Rename rename freshwater total columns
df00 <- df2000 %>%
  rename("Population" = "TP.TotPop") %>%
  rename("Public" = "PS.WFrTo") %>%
  rename("Domestic" = "DO.WFrTo") %>%
  rename("Industrial" = "IN.WFrTo") %>%
  rename("Irrigation" = "IT.WFrTo") %>%
  rename("Aquaculture" = "LA.WFrTo") %>%
  rename("Livestock" = "LS.WFrTo") %>%
  rename("Mining" = "MI.WFrTo") %>%
  rename("Thermoelectric" = "PT.WFrTo") %>%
  rename("Total" = "TO.WFrTo") %>%
#Remove all other supply columns
  select(-contains("."))
#Add year column equal to 2000
df00['YEAR'] = 2000

#Rename rename freshwater total columns
df05 <- df2005 %>%
  rename("Population" = "TP.TotPop") %>%
  rename("Public" = "PS.WFrTo") %>%
  rename("Domestic" = "DO.WFrTo") %>%
  rename("Industrial" = "IN.WFrTo") %>%
  rename("Irrigation" = "IR.WFrTo") %>%
  rename("Aquaculture" = "LA.WFrTo") %>%
  rename("Livestock" = "LS.WFrTo") %>%
  rename("Mining" = "MI.WFrTo") %>%
  rename("Thermoelectric" = "PT.WFrTo") %>%
  rename("Total" = "TO.WFrTo") %>%
  #Remove all other supply columns
  select(-contains(".")) %>%
  select(-X)
df05['YEAR'] = 2005

#Rename rename freshwater total columns
df10 <- df2010 %>%
  rename("Population" = "TP.TotPop") %>%
  rename("Public" = "PS.WFrTo") %>%
  rename("Domestic" = "DO.WFrTo") %>%
  rename("Industrial" = "IN.WFrTo") %>%
  rename("Irrigation" = "IR.WFrTo") %>%
  rename("Aquaculture" = "AQ.WFrTo") %>%
  rename("Livestock" = "LI.WFrTo") %>%
  rename("Mining" = "MI.WFrTo") %>%
  rename("Thermoelectric" = "PT.WFrTo") %>%
  rename("Total" = "TO.WFrTo") %>%
  #Remove all other supply columns
  select(-contains(".")) %>%
  select(-COUNTY) %>%
  select(-X)

#Combine all tables
dfAll = bind_rows(df00, df05, df10)
