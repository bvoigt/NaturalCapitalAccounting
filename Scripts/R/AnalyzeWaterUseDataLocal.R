#load libraries
library(dplyr)
library(ggplot2)
#library(plotly)

#read in usgs use data
dfWater = read.csv('/nfs/NaturalCapitalAccounting-data/WaterAccounts/CountyUseAndSupply.csv')

dfWater$YEAR = as.factor(dfWater$YEAR)
dfWater$FIPS = as.factor(dfWater$FIPS)
#Plot usage by year (Just MD)

ggplot(data = dfWater,
       aes(x=state,y=Supply)) +
  geom_point(aes(shape=YEAR),
             size = 3,
             stat = 'summary',
             fun.y = 'mean')


#box plot of county usage by category - all us
#Select by year and compute mean of each category
dfCountyByYear = dfWater%>% 
  group_by(YEAR,FIPS) %>%
  summarize('public' = sum(Public),
            'domestic' = sum(Domestic),
            'industry' = sum(Industry))
#summarize for all states


df2000 = dfUsage%>% 
  filter(YEAR == 2000) %>%
  summarize('public' = sum(Public),
            'domestic' = sum(Domestic),
            'industry' = sum(Industry))

boxPlot(SUPPLY ~ state, data=df2000)



# summarize population on state fips
dfState <- group_by(dfUsage,(state))
popSummary <- summarize(dfState,supply=sum(SUPPLY),usage=sum(TOTAL)) 

supplyVSusage <- ggplot(data = popSummary,
       aes(x = supply, y = usage)) +
  geom_point()
supplyVSusage

