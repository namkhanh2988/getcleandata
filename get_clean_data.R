# Clean up workspace
rm(list=ls())

# Download and unzip the dataset
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "harData.zip"
if (!file.exists(filename)){
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Load the features
features <- read.table("UCI HAR Dataset/features.txt")

# Load the activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Load the dataset
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
colnames(trainX) <- features[, 2]
trainY <- read.table("UCI HAR Dataset/train/Y_train.txt")
colnames(trainY) <- "activity"
trainS <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(trainS) <- "subject"
train <- cbind(trainS, trainY, trainX)

testX <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(testX) <- features[, 2]
testY <- read.table("UCI HAR Dataset/test/Y_test.txt")
colnames(testY) <- "activity"
testS <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(testS) <- "subject"
test <- cbind(testS, testY, testX)

# 1. Merges the training and the test sets to create one data set.
harData <- rbind(train, test)

# 2. Extract the features with mean or std (also keeps the activity and subject)
colNames <- colnames(harData)
relevantColumns <- (grepl("activity", colNames) |
                      grepl("subject", colNames) |
                      grepl("-(mean|std)\\(\\)", colNames)
)
harData <- harData[, relevantColumns]

# 3. Uses descriptive activity names to name the activities in the data set.
harData$activity = activities[harData$activity, 2]

# 4. Appropriately labels the data set with descriptive variable names.
colNames <- colnames(harData)
colNames <- gsub("^t", "time", colNames)
colNames <- gsub("^f", "frequency", colNames)
colNames <- gsub("Gyro", "Gyroscope", colNames)
colNames <- gsub("Acc", "Accelerometer", colNames)
colNames <- gsub("Mag", "Magnitude", colNames)
colNames <- gsub("BodyBody", "Body", colNames)
colNames <- gsub("-mean\\(\\)", "Mean", colNames)
colNames <- gsub("-std\\(\\)", "StdDev", colNames)
colNames <- gsub("-X", "X", colNames)
colNames <- gsub("-Y", "Y", colNames)
colNames <- gsub("-Z", "Z", colNames)
colnames(harData) <- colNames

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
tidyData = ddply(harData, c("subject","activity"), numcolwise(mean))
write.table(tidyData, file = "tidy_data.txt")
