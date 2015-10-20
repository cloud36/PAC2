#Instructions
#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#XXExtracts only the measurements on the mean and standard deviation for each measurement. 
#XXUses descriptive activity names to name the activities in the data set
#XXAppropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#load libraries
library(reshape2)

#set working directory and download files to working directory if they don't exist.

#create data directory if it doesn't exist
if (!file.exists("data")) {
  dir.create("data")
}

#download data
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = './data/dataset.zip')
unzip("./data/dataset.zip", exdir = "data")

#load datasets
features     = read.table('data/UCI HAR Dataset/features.txt',header=FALSE); #imports features.txt
activityType = read.table('data/UCI HAR Dataset/activity_labels.txt',header=FALSE); #imports activity_labels.txt

#train data
subject_train = read.table('data/UCI HAR Dataset/train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('data/UCI HAR Dataset/train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('data/UCI HAR Dataset/train/y_train.txt',header=FALSE); #imports y_train.txt

#Uses descriptive activity names to name the activities in the data set
colnames(activityType)  = c('activityId','activityType');  #labels

colnames(xTrain)        = features[,2]; #labels
colnames(yTrain)        = "activityId"; #labels

# read in test data
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
y_test <-  read.table("data/UCI HAR Dataset/test/Y_test.txt")

colnames(x_test)        = features[,2];  #labels
colnames(y_test)        = "activityId"; #labels


# merge train data
train_Data = cbind(yTrain,xTrain);
test_Data = cbind(y_test,x_test);
#extract sd, mu
test_data <- test_Data[,grepl("std|mean", colnames(test_Data))]
train_data <- train_Data[,grepl("std|mean", colnames(train_Data))]

#add subject ids
colnames(subject_train)  = "subjectId";  #labels
colnames(subject_test)  = "subjectId"; #labels
test_data <- cbind(subject_test, test_data)
train_data <- cbind(subject_train, train_data)

#colnames(subject_train)  = "subjectId";  #labels
#colnames(subject_test)  = "subjectId"; #labels

str(train_data)
str(test_data)

#merge datasets
full_data <- rbind(train_data, test_data)
