## The mergefiles function merges data files as well as test and train data sets.
## Data is cleaned up and formatted to create two tidy datasets.

mergefiles <- function() {

library(doBy)

## Read the fixed width file subject_test and rename column to Subject.

stest <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
stestdata <- read.fwf(stest, c(1),skip=0)
colnames(stestdata) <- c("Subject")

## Read the fixed width file y_test and rename column to Activity.

ytest <- ".\\UCI HAR Dataset\\test\\y_test.txt"
ytestdata <- read.fwf(ytest, c(1),skip=0)
colnames(ytestdata) <- c("Activity")

## Read the file X_test using read.table.

xtest <- ".\\UCI HAR Dataset\\test\\X_test.txt"
xtestdata <- read.table(xtest, comment.char = "",colClasses="numeric")
         
## Cbind the above 3 dataframes 

syxtest <- cbind(stestdata,ytestdata,xtestdata)

## Read the fixed width file subject_train and rename column to Subject.

strain <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
straindata <- read.fwf(strain, c(1),skip=0)
colnames(straindata) <- c("Subject")

## Read the fixed width file y_train and rename column to Activity.

ytrain <- ".\\UCI HAR Dataset\\train\\y_train.txt"
ytraindata <- read.fwf(ytrain, c(1),skip=0)
colnames(ytraindata) <- c("Activity")

### Read the file X_train using read.table.

xtrain <- ".\\UCI HAR Dataset\\train\\X_train.txt"
xtraindata <- read.table(xtrain, comment.char = "",colClasses="numeric")

## Cbind the above 3 dataframes 

syxtrain <- cbind(straindata,ytraindata,xtraindata)

## Rbind the combined test and train dataframes 

testtrain <- rbind(syxtest,syxtrain)

## Names of the 561 columns in X_test and X_train are in features.txt

featuresfile <- ".\\UCI HAR Dataset\\features.txt"
featuresdata <- read.table(featuresfile)

## Find data in features file with std and mean in the names. 

stdmean <- grep("std|mean",featuresdata$V2)

## Define column names for the fields which need to be selected from testtrain.

stdmeancolumns <- paste("V", stdmean, sep="")

## Extract the Subject and Activity columns 

satesttrain <- subset(testtrain, select = 1:2)

## Extract columns with std deviation and mean

stdmeantesttrain <- subset(testtrain, select = stdmeancolumns )

# Combine std deviation and mean columns with subject and activity columns

sastdmeantesttrain <- cbind(satesttrain,stdmeantesttrain)

## Replace numeric activity keys with actual activity descriptions

sastdmeantesttrain$Activity <- gsub("1", "WALKING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("2", "WALKING_UPSTAIRS", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("3", "WALKING_DOWNSTAIRS", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("4", "SITTING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("5", "STANDING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("6", "LAYING", sastdmeantesttrain$Activity)

## Column names contain () and -. These have to be removed. 

cnames <-featuresdata[stdmean,]
colnames<-c('Subject','Activity',as.character(cnames$V2))
colnames <- gsub("\\()|-","",colnames)
colnames(sastdmeantesttrain) <- c(colnames)

## Use aggregate to summarize sastdmeantesttrain

averagedata<-aggregate(sastdmeantesttrain[,3:81], 
          by=list((Subject=sastdmeantesttrain$Subject), 
                  (Activity=sastdmeantesttrain$Activity)), FUN=mean,na.rm=TRUE)

## Create a text file with the sastdmeantesttrain 

datafile <- file("stdmeandatafile.txt")
write.table(sastdmeantesttrain,datafile)

## Create a text file with the averagedata

avgfile <- file("averagedatafile.txt")
write.table(averagedata,avgfile)

}