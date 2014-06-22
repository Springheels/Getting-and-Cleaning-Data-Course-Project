=======================================================================
Getting and Cleaning Data Course Project
README.md - Version 1.0
=======================================================================
Pre Execution Steps
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

The mergefiles function merges data files as well as test and train data sets. Data is cleaned up and formatted to create two tidy datasets.

=======================================================================
Output Files
=======================================================================

Two tidy datasets are created 

1. sastdmeantesttrain contains Subject and Activity data as well as standard deviation and mean data. This is written into stdmeandatafile.txt. 

2. averagedata contains average of the selected standard deviation and mean data for each Subject and Activity. This is written into averagedatafile.txt.

=======================================================================
References
=======================================================================
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
Vitoria-Gasteiz, Spain. Dec 2012

