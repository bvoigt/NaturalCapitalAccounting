#load libraries
library(dplyr)
library(ggplot2)
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
dfUse = bind_rows(df00, df05, df10)

#Remove old tables
rm(df2000, df2005, df2010, df00, df05, df10)

## Read in supply data (later add code to read directly from netCDF files on-line
dfSupply = read.csv('/nfs/NaturalCapitalAccounting-data/WaterAccounts/SupplyData.csv')

## Compute total supply - as Precip minus Evapotranspiration
dfSupply$Supply = dfSupply$pr - dfSupply$et

#Join on YEAR and FIPS
dfAll <- merge(dfUse, dfSupply, by=c('YEAR','FIPS'))

#Set factors
dfAll$FIPS = as.factor(dfAll$FIPS)
dfAll$YEAR = as.factor(dfAll$YEAR)
dfAll$STATE= as.factor(dfAll$STATE)

#Save the file
write.csv(dfAll,'/nfs/NaturalCapitalAccounting-data/WaterAccounts/UseAndSupplyData.csv')

##Ploting...
#Generate a scatter plot of [sector] vs population
theVar = log10(dfAll$Public)
thePlot = ggplot(data=dfAll,
                 aes(x=log10(Population),y=theVar,color=STATE)) + 
  geom_point()
thePlot

#Generate a box plot of a variable over the three years
theVar = dfAll$Supply
allStatesPlot <- ggplot(data = dfAll,
                        aes(x=YEAR,y=log10(theVar))) + 
  geom_boxplot()
allStatesPlot


##Display average usage over time - all categories and all states combined

#Generate the table of year x summed usage & supply
allStates <- dfAll %>% 
  #Group by time
  group_by(YEAR) %>%
  #Summarize all records
  summarize("Population" = sum(Population),
            "Public" = sum(Public), 
            "Domestic" = sum(Domestic),
            "Industrial" = sum(Industrial),
            "Irrigation" = sum(Irrigation),
            "Aquaculture" = sum(Aquaculture),
            "Livestock" = sum(Livestock),
            "Mining" = sum(Mining),
            "Thermoelectric" = sum(Thermoelectric),
            "Total" = sum(Total),
            "Supply" = sum(Supply))

##Display average usage over time - by categories, all states combined

#Generate the table of year x summed usage & supply
byStates <- dfAll %>% 
  #Group by time and state
  group_by(YEAR,STATE) %>%
  #Summarize all records
  summarize("Population" = sum(Population),
            "Public" = sum(Public), 
            "Domestic" = sum(Domestic),
            "Industrial" = sum(Industrial),
            "Irrigation" = sum(Irrigation),
            "Aquaculture" = sum(Aquaculture),
            "Livestock" = sum(Livestock),
            "Mining" = sum(Mining),
            "Thermoelectric" = sum(Thermoelectric),
            "Total" = sum(Total),
            "Supply" = sum(Supply))

