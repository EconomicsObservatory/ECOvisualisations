library(ggplot2)
library(readxl)
library(xlsx)
library(moments)
library(lubridate)
library(ggplot)
library(zoo)
library(writexl)
library(directlabels)
library(reshape2)
pce_data <- read.csv(file = "pceinflation.csv", fileEncoding = "UTF-8-BOM")
str(pce_data)
cons_data <- read.csv( file = "realcons.csv" , fileEncoding = "UTF-8-BOM")

# the extra phrase in the  import is to avoid a reversed interrogation mark in the first column
#this code converts character date to date format
cons_data$Date <- as.Date(cons_data$Date, format = "%Y-%m-%d")
pce_data$Date <- as.Date(pce_data$Date, format =  "%Y-%m-%d")

head(cpi_data)
class(cpi_data$Date)
str(cons_data)

#melts df into one column using date as id
meltdf1 <- melt(pce_data , id = "Date")
ggplot(meltdf1, aes(Date , y=value , color=variable )) + geom_line()+
  #sets start date adn leaves end date to be determined by data
  xlim(as.Date(c("1990-01-01" , NA))) +
  ggtitle(" Chat4 PCE Inflation: Components ") + labs(caption = "Source: BLS, FRED") + 
  xlab( "Date")  + ylab(" % yoy ") + theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.line = element_line(colour = "black"))+
  geom_hline(yintercept=0, colour = "black") 



# produces Chart of real Consumption Indexed on Decemebr 2019
#melts df into one column using date as id
meltdf2 <- melt(cons_data , id = "Date")
ggplot(meltdf2, aes(Date , y=value , color=variable )) + geom_line()+
  #sets start date and leaves end date to be determined by data
  xlim(as.Date(c("2019-01-01" , NA))) +
  ggtitle("Real Consumption: Components ") + labs(caption = "Source: BLS, FRED") + 
  xlab( "Date")  + ylab(" Index, December 2019 = 100 ") + theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  geom_hline(yintercept=100, colour = "black") 
