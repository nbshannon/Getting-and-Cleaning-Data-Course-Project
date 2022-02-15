# objectives
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# setup
packages <- c("tidyverse")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()


# url for dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

print(sprintf("%s/dataset.zip",path))
# download and unzip data
download.file(url, sprintf("%s/dataset.zip",path))
unzip(zipfile = sprintf("%s/dataset.zip",path),exdir = path)

# features
features = read.table(sprintf("%s/UCI HAR Dataset/features.txt",path),col.names=c("featureId", "featureName"))
activities = read.table(sprintf("%s/UCI HAR Dataset/activity_labels.txt",path),col.names=c("activityId", "activityName"))
# select only target features
featureFilter = grep("(mean|std)\\(\\)", features[, 'featureName'])

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

# combine data and change activity to activity name
tidy_data <- rbind(train,test)
tidy_data$activity <- activities[tidy_data$activity,]$activityName

# average by subjectId and activity
avg_data <- tidy_data %>%
  group_by(subjectId, activity) %>%
  summarise_at(-(1:2),mean,na.rm = T)

# write tidy data
write.table(tidy_data, sprintf("%s/tidy_dataset.txt",path), row.names = FALSE)
# write averaged data
write.table(avg_data, sprintf("%s/tidy_dataset_avg.txt",path), row.names = FALSE)