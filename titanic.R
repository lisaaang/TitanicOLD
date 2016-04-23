#Data Wrangling Assignment 2

#0: Load the data in RStudio
library(dplyr)
library(tidyr)
titanicP <- read.csv("titanic_original.csv", stringsAsFactors = FALSE)
passengers <- tbl_df(titanicP)
#Remove last row with all NA values. Not sure why this is there?
passengers <- passengers %>% slice(1:1309)



#1:Port of embarkation - fill in missing value "" with S
#Replace blanks with S
embL <- passengers$embarked
embL[embL == ""] <- "S"
passengers$embarked <- embL
#NOTE:passengers$embarked has 2 missing values [169,285] not 1. Filled both with S

#2:Age - missing values
#Calculate mean age of passengers
avg_age <- mean(passengers$age, na.rm = TRUE)

for (i in 1:length(passengers$age)){
  if (is.na(passengers$age[i]) == TRUE){
    passengers$age[i] <- avg_age
  }
}

#Using the mean or the median age of ship passengers to fill in missing values is meaningless 
#because the age of any one passenger has no bearing on the age of another passenger.
#There is no meaningful way to extrapolate an age for the persons with missing values 
#in this table unless one has access to other pertinent information not contained in this table.


#3: Lifeboat
#Replace missing values "" with NA
lifeBoat <- passengers$boat
lifeBoat[lifeBoat == ""] <- NA
passengers$boat <- lifeBoat

#4: Cabin
#Every passenger had a cabin assigned to them, but without the original log, there is no way to 
#extrapolate the information unless they were sharing with another passenger who survived and 
#provided a cabin number for them.

#Replace all missing values with NA
cabinNum <- passengers$cabin
cabinNum[cabinNum == ""] <- NA
passengers$cabin <- cabinNum

#create new column has_cabin_number
passengers$has_cabin_number <- 0
#Replace 0 with 1 if cabin number is known for each passenger
for (i in 1:length(passengers$cabin)){
  if (is.na(passengers$cabin[i]) == FALSE){
    passengers$has_cabin_number[i] <- 1
  }
}
#Rearrange columns so that has_cabin_number is next to cabin
#use which(colnames(passengers)=="cabin") to get column number 
passengers <- passengers[,c(1:10,15,11:14)]


#5:Output to csv file for upload on github
write.csv(passengers, file = "titanic_clean.csv")
