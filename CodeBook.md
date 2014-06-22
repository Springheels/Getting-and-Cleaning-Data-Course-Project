=======================================================================
Getting and Cleaning Data Course Project
CodeBook.md - Version 1.0
=======================================================================
Purpose
=======================================================================
The CodeBook describes the data set used, different variables and their definition as well as the data processing steps used to clean up and create two tidy datasets. 
=======================================================================
Experiment Details 
=======================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, the  3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured.  The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained 
by calculating variables from the time and frequency domain. 

Reference
 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using
+Smartphones for additional information

The original dataset includes the following files:

'features_info.txt': Shows information about the variables used on the feature vector.
'features.txt': List of all features.
'activity_labels.txt': Links the class labels with their activity name.
'train/X_train.txt': Training set.
'train/y_train.txt': Training labels.
'test/X_test.txt': Test set.
'test/y_test.txt': Test labels.
'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.
'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

=======================================================================Pre Execution Steps
=======================================================================

The run_Analysis.R file contains the mergefiles function.

The data files should be present in the working directory. 

Download data files using the following code (this is a one time activity).

fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "Datafiles.zip", method = "curl")

unzip("Datafiles.zip")

The folder structure and file names should be maintained as is. 

=======================================================================
Data Processing Steps
=======================================================================

1. Read the fixed width file subject_test and rename column to Subject.
   
stest <- ".\\UCI HAR Dataset\\test\\subject_test.txt"
stestdata <- read.fwf(stest, c(1),skip=0)
colnames(stestdata) <- c("Subject")

2. Read the fixed width file y_test and rename column to Activity.
   
ytest <- ".\\UCI HAR Dataset\\test\\y_test.txt"
ytestdata <- read.fwf(ytest, c(1),skip=0)
colnames(ytestdata) <- c("Activity")
      
3. Read the file X_test using read.table.
   
xtest <- ".\\UCI HAR Dataset\\test\\X_test.txt"
xtestdata <- read.table(xtest, comment.char = "",colClasses="numeric")

4. Cbind the above 3 dataframes 

syxtest <- cbind(stestdata,ytestdata,xtestdata)
	   
5. Read the fixed width file subject_train and rename column to Subject.

strain <- ".\\UCI HAR Dataset\\train\\subject_train.txt"
straindata <- read.fwf(strain, c(1),skip=0)
colnames(straindata) <- c("Subject")

6. Read the fixed width file y_train and rename column to Activity.

ytrain <- ".\\UCI HAR Dataset\\train\\y_train.txt"
ytraindata <- read.fwf(ytrain, c(1),skip=0)
colnames(ytraindata) <- c("Activity")

7. Read the file X_train using read.table.

xtrain <- ".\\UCI HAR Dataset\\train\\X_train.txt"
xtraindata <- read.table(xtrain, comment.char = "",colClasses="numeric")

8. Cbind the above 3 dataframes 

syxtrain <- cbind(straindata,ytraindata,xtraindata)

9. Rbind the combined test and train dataframes 

testtrain <- rbind(syxtest,syxtrain)

10. Names of the 561 columns in X_test and X_train are in features.txt

featuresfile <- ".\\UCI HAR Dataset\\features.txt"
featuresdata <- read.table(featuresfile)

11. Find data in features file with std and mean in the names. 

stdmean <- grep("std|mean",featuresdata$V2)

12. Define column names for the fields which need to be selected from testtrain.

stdmeancolumns <- paste("V", stdmean, sep="")

13. Extract the Subject and Activity columns

satesttrain <- subset(testtrain, select = 1:2)

14. Extract columns with std deviation and mean

stdmeantesttrain <- subset(testtrain, select = stdmeancolumns )

15. Combine std deviation and mean columns with subject and activity columns

sastdmeantesttrain <- cbind(satesttrain,stdmeantesttrain)

16. Replace numeric activity keys with actual activity descriptions

sastdmeantesttrain$Activity <- gsub("1", "WALKING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("2", "WALKING_UPSTAIRS", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("3", "WALKING_DOWNSTAIRS", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("4", "SITTING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("5", "STANDING", sastdmeantesttrain$Activity)
sastdmeantesttrain$Activity <- gsub("6", "LAYING", sastdmeantesttrain$Activity)

17. Column names contain () and -. These have to be removed. 

cnames <-featuresdata[stdmean,]
colnames<-c('Subject','Activity',as.character(cnames$V2))
colnames <- gsub("\\()|-","",colnames)
colnames(sastdmeantesttrain) <- c(colnames)

18. Use aggregate to summarize sastdmeantesttrain

averagedata<-aggregate(sastdmeantesttrain[,3:81], 
          by=list((Subject=sastdmeantesttrain$Subject), 
                  (Activity=sastdmeantesttrain$Activity)), FUN=mean,na.rm=TRUE)

19. Create a text file with the sastdmeantesttrain 

datafile <- file("stdmeandatafile.txt")
write.table(sastdmeantesttrain,datafile)

20. Create a text file with the averagedata

avgfile <- file("averagedatafile.txt")
write.table(averagedata,avgfile)

=======================================================================
Output Files
=======================================================================

Two tidy datasets are created 

1. sastdmeantesttrain contains Subject and Activity data as well as standard deviation and mean data. 

2. averagedata contains average of the selected standard deviation and mean data for each Subject and Activity. 

=======================================================================
References
=======================================================================
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012