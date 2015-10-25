#Instructions
#You should create one R script called run_analysis.R that does the following. 
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#load libraries
library(reshape2)
library(data.table)

#set working directory and download files to working directory if they don't exist.
#create data directory if it doesn't exist
#and download, unzip data
if (!file.exists("data")) {
  dir.create("data")
  #download data
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = './data/dataset.zip')
  unzip("./data/dataset.zip", exdir = "data")
}

#load datasets
features <- read.table('data/UCI HAR Dataset/features.txt',header=FALSE);
activityType <- read.table('data/UCI HAR Dataset/activity_labels.txt',header=FALSE);

#train data
subject_train <- read.table('data/UCI HAR Dataset/train/subject_train.txt',header=FALSE); #imports subject_train.txt
x_train <- read.table('data/UCI HAR Dataset/train/x_train.txt',header=FALSE); #imports x_train.txt
y_train <- read.table('data/UCI HAR Dataset/train/y_train.txt',header=FALSE); #imports y_train.txt

#Uses descriptive activity names to name the activities in the data set
colnames(activityType) <- c('activityId','activityType');  #labels
colnames(x_train) <- features[,2]; #labels
colnames(y_train) <- "activityId"; #labels

# read in test data
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
y_test <-  read.table("data/UCI HAR Dataset/test/Y_test.txt")

colnames(x_test)        = features[,2];  #labels
colnames(y_test)        = "activityId"; #labels

#extract sd, mu
x_train <- x_train[,grepl("std|mean", colnames(x_train))]
x_test <- x_test[,grepl("std|mean", colnames(x_test))]

train_data = cbind(y_train,x_train);
test_data = cbind(y_test,x_test);

#add subject ids
colnames(subject_train)  = "subjectId";  #labels
colnames(subject_test)  = "subjectId"; #labels

test_data <- cbind(subject_test, test_data)
train_data <- cbind(subject_train, train_data)

#merge datasets
full_data <- rbind(train_data, test_data)
full_dt <- data.table(full_data)
full_dt <- full_dt[,lapply(.SD,mean),by=list(subjectId,activityId)]
#change activityId to descriptive string
full_dt$activityId <- as.factor(full_dt$activityId)
levels(full_dt$activityId)[levels(full_dt$activityId)=="1"] <- "walking"
levels(full_dt$activityId)[levels(full_dt$activityId)=="2"] <- "walking_upstairs"
levels(full_dt$activityId)[levels(full_dt$activityId)=="3"] <- "walking_downstairs"
levels(full_dt$activityId)[levels(full_dt$activityId)=="4"] <- "sitting"
levels(full_dt$activityId)[levels(full_dt$activityId)=="5"] <- "standing"
levels(full_dt$activityId)[levels(full_dt$activityId)=="6"] <- "laying"

#write table
write.table(full_dt, "./data/tidy.txt")





