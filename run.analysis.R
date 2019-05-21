##################################################
##                                              ##
##                                              ##
##   Getting and Cleaning Data Course Project   ##
##                    Script                    ##
##                                              ##
##################################################

### Script information ###
# Author: L.T. van der Heijden
# Date created: May 13th 2019
# Date updated: - 

##################################################
### Start script ###
# Empty global environment
rm(list=ls())

# Set working directory
wd <- "~/Documents/datasciencecourse/course 3/week 4"
setwd(wd)

# Download Human Activity Recognition Using Smartphones Data Set 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./HumanActivity.zip", method = "curl")

# Store download time
download_time <- date()

# Read training data
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "") # Labels of the activity performed
train_data <- read.csv("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "") # measurements of the activities for the train dataset
train_id <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")

# Create training dataset 
train <- data.frame(train_id, train_labels, train_data)

# Name the columns of the training dataset
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "") # Read in the feature text file containing the means of the measured variables
features <- features[ ,2]  # select the second column with the variable names
features <- as.character(features) #change to character variable 

names(train) <- c(c("id", "activity"), features)

# Reat test data
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "" ) # Labels of the activities
test_data <- read.csv("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "") # measurements of the activities variables
test_id <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "") # subject id of the test dataset

# Create test dataset
test <- data.frame(test_id, test_labels, test_data)

# Name the columns of the test dataset 
names(test) <- c(c("id", "activity"), features)

# Merge the training and test datset to together 
dat <- rbind(test, train)

# Extract only the measurements on the mean and standard deviation for each measurement 
dat <- dat[ ,c(1,2, grep("mean|std", names(dat)))]

# Name the activities in the dataset with the descriptive activity names
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep = " ")

activity <- as.factor(dat$activity)  #Make a factor of the activities code
levels(activity) <- activity_names[,2] #Assign the names of the activities to the levels 
dat$activity <- activity #Resign to dataset

# Appropiately label the dataset with descriptive variable names
names_data <- names(dat)  #Store variable names of data 

names_data <- gsub("^t", "time", names_data)  #Change the first t to time 
names_data <- gsub("Acc", "Acceloremeter", names_data) 
names_data <- gsub("-mean", "MEAN", names_data)
names_data <- gsub("-std", "STD", names_data, ignore.case = TRUE)
names_data <- gsub("Mag", "Magnitude", names_data)
names_data <- gsub("^f", "frequency", names_data) #Change the first f into frequency
names_data <- gsub ("BodyBody", "Body", names_data)
names_data <- gsub("Gyro", "Gyroscope", names_data)
names_data <- gsub("Freq", "frequnecy", names_data)

names(dat) <- names_data #Resign the variable names to the dataset

# Create a second tidy dataset with the average of each variable for each activity and subject
library(dplyr)

tidydata <- dat %>% group_by(id, activity) %>% summarise_all(funs(mean))

# Write dataset
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)

### End of Script ###
