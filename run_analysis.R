setwd("~/R/Getting and Cleaning data")

if (!require("data.table")) {
  install.packages("data.table",dependencies = TRUE)
}

if (!require("reshape2")) {
  install.packages("reshape2",dependencies = TRUE)
}

require("data.table")
require("reshape2")


#Merges the training and the test sets to create one data set.

X_train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train_data <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)


X_test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test_data <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train_data <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test_data <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X_data <- rbind(X_train_data, X_test_data)
y_data <- rbind(y_train_data, y_test_data)
subject_data <- rbind(subject_train_data, subject_test_data)


#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 

features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feature_id', 'feature_name')
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feature_name) 
X_data <- X_data[, index_features] 
names(X_data) <- gsub("\\(|\\)", "", (features[index_features, 2]))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('activity_id', 'activity_name')
y_data[, 1] = activities[y_data[, 1], 2]

names(y_data) <- "Activity"
names(subject_data) <- "Subject"

# bind tidy data
tidy_data <- cbind(subject_data, y_data, X_data)

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_2nd <- tidy_data[, 3:dim(tidy_data)[2]] 
tidy_data_Avg <- aggregate(tidy_2nd,list(tidy_data$Subject, tidy_data$Activity), mean)

names(tidy_data_Avg)[1] <- "Subject"
names(tidy_data_Avg)[2] <- "Activity"


write.csv(tidy_data, file = "tidy_data.txt",row.names = FALSE)
write.csv(tidy_data_Avg, file = "tidy_data_mean.txt",row.names = FALSE)






