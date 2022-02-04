library(Quandl)
Quandl.api_key("h-ML235AsaAnv15Ui6VN")
mich1y <- (Quandl("UMICH/SOC32" ))
str(mich1y)
library(tidyverse)
library(reshape2)
library(eFRED)
fred(MedianPCE <- "MEDCPIM158SFRBCLE", corePCE <- "PCEPILFE" )
head(mich1y)
tail(mich1y)
mich5y <- (Quandl("UMICH/SOC33"  ))
str(mich5y)
tail(mich5y)
head(mich5y)
new_data1 <- mich1y[, c(1,16)]  
str(new_data1)
new_data5 <- mich5y[, c(1,16)]
colnames((new_data1))
names(new_data1)[names(new_data1) == "Median"] <-"Median_1_year"
str(new_data1)
names(new_data5)[names(new_data5) == "Median"] <-"Median_5_year"
str(new_data5)


# this uses dyplr to join two dataframes of unequal length
#one is the data from Quandl, the other the July data from Michigan in DF

joint <- new_data1 %>% right_join(new_data5)
str(joint)
#DF <- data.frame("Date"  =  as.Date("2021-11-30") ,
#                "Median_1_year" =   4.9  , "Median_5_year" =  3.0)
                 
                 
                 



#DF1 <- rbind(DF, joint)
#str(DF1)

#ggplot(data = DF1) + aes( x = Median_1_year , y = Median_5_year) + geom_point()

#Now, melt DF1 into one column using date as id

meltDF1 <- melt(joint , id = "Date")
head(meltDF1)

ggplot(meltDF1, aes(Date , y=value , color=variable )) + geom_line() +
  #sets start date adn leaves end date to be determined by data
  xlim(as.Date(c("2000-10-01" , NA))) +
  labs( y = "Expected Inflation rate") + (ylim(1, 6)) +
  ggtitle("Michigan 1 and 5 year Inflation expectations") +
 labs(caption = "Source: University of Michigan, Quandl") + 
   theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(axis.line = element_line(colour = "black"))+
  geom_hline(yintercept=0, colour = "black")
        