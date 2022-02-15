# Getting and Cleaning Data Course Project
Completed for Course Project for [Getting_and_Cleaning_Data](https://www.coursera.org/learn/data-cleaning) available on coursera

Author: Nicholas Shannon <br />

Original data is available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) <br/>
Original description of the dataset is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

# Project Tasks
create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Files for review criteria

Critera | Link to Item
--- | ---
Analysis R Script | [run_analysis.R](https://github.com/nbshannon/Getting-and-Cleaning-Data-Course-Project/blob/main/run_analysis.R)
Tidy dataset | [tidy_dataset_avg.txt](https://github.com/nbshannon/Getting-and-Cleaning-Data-Course-Project/blob/main/tidy_dataset_avg.txt)
Github repository | [github repository](https://github.com/nbshannon/Getting-and-Cleaning-Data-Course-Project)
Code book | [CodeBook.md](https://github.com/nbshannon/Getting-and-Cleaning-Data-Course-Project/blob/main/CodeBook.md)
Readme file | [README.md](https://github.com/nbshannon/Getting-and-Cleaning-Data-Course-Project/blob/main/README.md)

# Running the analysis

1. Pre-requisites: tidyverse collection of packages
If you need to install the package use  `install.packages("tidyverse")` in R session
2. Download or clone run_analysis.R
3. Run analysis, in R session, within project directory: `source("run_analysis.R")`

# How it works

Loads dependences and sets path to working directory
```
#setup
packages <- c("tidyverse")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()
```

Download and unzip the dataset
```
# url for dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download and unzip data
download.file(url, sprintf("%s/dataset.zip",path))
unzip(zipfile = sprintf("%s/dataset.zip",path),exdir = path)
```

Load in the feature and activity information <br/>
Used to filter and label the dataset
Generates a "featureFilter" variable to identify mean() and std() features only
```
# features
features = read.table(sprintf("%s/UCI HAR Dataset/features.txt",path),col.names=c("featureId", "featureName"))
activities = read.table(sprintf("%s/UCI HAR Dataset/activity_labels.txt",path),col.names=c("activityId", "activityName"))
# select only target features
featureFilter = grep("(mean|std)\\(\\)", features[, 'featureName'])
```

Loads the training and test datasets <br/>
Filters the datasets using our earlier featureFilter variable (see above)
```
# load train datasets (and filer to only include features of interest)
X_train <- read_table(sprintf("%s/UCI HAR Dataset/train/X_train.txt",path), col_names = features$featureName)[,featuresTarget]
Y_train <- read_table(sprintf("%s/UCI HAR Dataset/train/y_train.txt",path), col_names = 'activity')
subject_train <- read_table(sprintf("%s/UCI HAR Dataset/train/subject_train.txt",path), col_names = "subjectId")
train <- cbind(subject_train, Y_train, X_train)

# Load test datasets
X_test <- read_table(sprintf("%s/UCI HAR Dataset/test/X_test.txt",path), col_names = features$featureName)[,featuresTarget]
Y_test <- read_table(sprintf("%s/UCI HAR Dataset/test/y_test.txt",path), col_names = 'activity')
subject_test <- read_table(sprintf("%s/UCI HAR Dataset/test/subject_test.txt",path), col_names = "subjectId")
test <- cbind(subject_test, Y_test, X_test)
```

Combined train and test datasets and label activities by name
```
# combine data and change activity to activity name
tidy_data <- rbind(train,test)
tidy_data$activity <- activities[tidy_data$activity,]$activityName
```

Generate a dataset summarising values by the average of each variable for each activity and each subject
```
# average by subjectId and activity
avg_data <- tidy_data %>%
  group_by(subjectId, activity) %>%
  summarise_at(-(1:2),mean,na.rm = T)
```

Finally write the merged and averaged datasets
```
# write tidy data
write.table(tidy_data, sprintf("%s/tidy_dataset.txt",path), row.names = FALSE)
# write averaged data
write.table(avg_data, sprintf("%s/tidy_dataset_avg.txt",path), row.names = FALSE)
```
