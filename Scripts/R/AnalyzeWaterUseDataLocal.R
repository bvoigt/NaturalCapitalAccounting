#load libraries
library(dplyr)
library(ggplot2)
#install.packages('plotly')
#library(plotly)

#read in usgs use data
dfUsage = read.csv('/nfs/NaturalCapitalAccounting-data/WaterAccounts/UseAndSupply.csv')
names(dfUsage)


#box plot of county usage by category - all us
#Select by year and compute mean of each category
df2000 = dfUsage%>% 
  group_by(YEAR) %>%
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

