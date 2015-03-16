##
# Getting and Cleaning Data
# Assessment 2
# By Yanick Miron
# 2015-03-12
#
# Run Analysis.
#
##

##
# Download and unzip dataset
source("download-dataset.R")

####
# Setup path and file name
wd <- getwd()
data_dir <- file.path(wd,"data/UCI HAR Dataset")

####
# Read dataset
#
# Read list of all features
features <- read.table(file.path(data_dir, "features.txt"), header = F)

# Read activity labels
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"), header = F)

# Read test dataset
x_test <- read.table(file.path(data_dir, "test", "X_test.txt"), header = F)
y_test <- read.table(file.path(data_dir, "test", "y_test.txt"), header = F)
s_test <- read.table(file.path(data_dir, "test", "subject_test.txt"), header = F)

# Read train dataset
x_train <- read.table(file.path(data_dir, "train", "X_train.txt"), header = F)
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"), header = F)
s_train <- read.table(file.path(data_dir, "train", "subject_train.txt"), header = F)
#
# Clean path and filename variables
rm(wd, data_dir)

####
# Merges the training and the test sets to create one data set.
x_data<-rbind(x_test, x_train)
y_data<-rbind(y_test, y_train)
s_data<-rbind(s_test, s_train)
# Set variables name
names(x_data) <- features$V2
names(y_data) <- c("activity")
names(s_data) <- c("subject")
# Merge all dataset 
data <- cbind(s_data, y_data, x_data)
#
# Clean variables used to merge all datasets
rm(x_test, y_test, s_test, x_train, y_train, s_train, x_data, y_data, s_data)

####
# Extracts only the measurements on the mean and standard deviation for each measurement
sub_features <- as.character(features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)])
sub_names <- c("subject", "activity", sub_features)
data<-subset(data, select = sub_names)
# Clean used variables
rm(features, sub_features, sub_names)

####
# Uses descriptive activity names to name the activities in the data set
for (i in activity_labels$V1){
  data$activity[data$activity == i] <- as.character(activity_labels[i, "V2"])
}
data$activity<-as.factor(data$activity)
# Clean used variables
rm(i, activity_labels)

####
# Appropriately labels the data set with descriptive variable names.
#
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))

####
# Creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.
data<-aggregate(. ~subject + activity, data, mean)
data<-data[order(data$subject, data$activity),]
write.table(data, file = "tidy_data.txt",row.name=FALSE)
