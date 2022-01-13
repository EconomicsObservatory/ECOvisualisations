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
# the extra phrase in the  import is to avoid a reversed interrogation mark in the first column
cpi_data <- read.csv(file= "clevelandcore.csv", fileEncoding="UTF-8-BOM")
cpi_data$Date <- as.Date(cpi_data$Date, format = "%m/%d/%Y")
                          
head(cpi_data)
class(cpi_data$Date)
str(cpi_data)
tail(cpi_data)
#melts df into one column using date as id
meltdf <- melt(cpi_data , id = "Date")
ggplot(meltdf, aes(Date , y=value , color=variable )) + geom_line()+
  #sets start date adn leaves end date to be determined by data
  xlim(as.Date(c("2000-01-01" , NA))) +
ggtitle("Chart 1 Inflation: Headline and Core ") + labs(caption = "Source: BLS, FRED") + 
  xlab( "Date")  + ylab("CPI % yoy ") + theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.line = element_line(colour = "black"))

#
