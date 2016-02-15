# Getting and cleaning data course project

## Overview

This repo contains the work for the course project in Getting and Cleaning Data course from Data Science specialization offered on Coursera by John Hopkins University.

## Content

This repo contains the following files

* `get_clean_data.R`: This is the script which does the following
  + Download data
  + Merge test and train data
  + Filter the relevant features
  + Update the activity data with descriptive data information
  + Update the column names with descriptive names
  + Aggregate data and write to a new file called `tidy_data.txt`
* `tidy_data.txt`: This is the output of the last step from `get_clean_data.R`
* `CodeBook.md`: This file describes the variables, the data, and the transformations that I performed to clean up the data.
* `README.txt`: This is me, please read me! :)

## Analysis Steps

### Download data

If the file wasn't downloaded, download it and unzip it in the current working directory. Inside the directory `UCI HAR Dataset`, the files are:
* features.txt
* activity_labels.txt
* train/
  + subject_train.txt
  + x_train.txt
  + y_train.txt
* test/
  + subject_test.txt
  + x_test.txt
  + y_test.txt
  
### Load and merge data

Load the respective data into the following data frames:
* features
* activities
* trainX, trainY, trainS
* testX, testY, testS
Along the way, assign the correct column names to the data frames. Then combine the test and train data into `test` and `train`.

Finally, merge `test` and `train` data by row into `harData`

### Extract relevant features only

Per project requirement, we need to extract the features related to mean or std. We extract the column names contains `activity` or `subject` or `-mean()` or `-std()` into a logical vector. Then the logical vector is used to extract the relevant features from `harData`

### Use descriptive activity

Activity data has activity id which is not descriptive. The description of these activities are in `activities` variable. We use the description here to replace the `activity` column in `harData` data frame.

### Use descriptive attributes

* Use `gsub` function to remove all the "()" and "-" from the attribute names.
* Also use `gsub` to change the short hand to full descriptive words:
  + `t` -> `time`
  + `f` -> `frequency`
  + `BodyBody` -> `Body`
  + `Gyro` -> `Gyroscope`
  + `Acc` -> `Accelerometer`
  + `Mag` -> `Magnitude`
  + `std` -> `StdDev`
  + `mean` -> `Mean`

### Aggregate data based on subject and activity

Per the project instructions, we need to produce only a data set with the average of each veriable for each activity and subject. We use `ddply` function from `plyr` library. After that, write the resulting data frame to `tidy_data.txt`