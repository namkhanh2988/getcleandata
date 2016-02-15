# Getting and cleaning data course project Cook Book

## Overview

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## Input data

[data collected from the accelerometers from the Samsung Galaxy S smartphone](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Dataset information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Attributes

For each record in the dataset it is provided:
* An identifier of the subject who carried out the experiment. This is stored in the files named `subject_(test|train).txt`.
* Activity id, activity description of the experiment. This is stored in the files named `y_(test|train).txt`.
* A 561-feature vector with time and frequency domain variables. These are stored in the files named `X_(test|train).txt`.
* List of features of the experiments. These are stored in the file named `features.txt`.
* Description of the activity ids. This is in the file named `activity_labels.txt`.

## Experiment Steps

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