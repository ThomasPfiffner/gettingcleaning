# week 4 assignment

fileUrl <-
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("data")){
  dir.create("data")
}
download.file(fileUrl, destfile="./data/week_4_dataset.zip", method="curl")
unzip("./data/week_4_dataset.zip",exdir="./data")

## 1. Merges the training and the test sets to create one data set.

trainSet <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
testSet <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
mergedData <- rbind(trainSet, testSet)
features <- read.table("./data/UCI HAR Dataset/features.txt")
names(mergedData) <- features[,2]

trainLabel <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
testLabel <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
mergedLabel <- rbind(trainLabel, testLabel) 
names(mergedLabel) <- "activity"

trainSubject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
mergedSubject <- rbind(trainSubject, testSubject)
names(mergedSubject) <- "subject"

activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(activityLabels) <- c("activity", "activityName")

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

meanStd <- grep("(mean|std)\\(\\)",names(mergedData),value=TRUE)
meanStdData <- mergedData[, meanStd]

# Step 3+4: Naming, labelling

cleanedMeanStdData <- cbind(mergedSubject,mergedLabel,meanStdData)

names(cleanedMeanStdData) <- sub("-mean\\(\\)-","Mean",names(cleanedMeanStdData))
names(cleanedMeanStdData) <- sub("-std\\(\\)-","Std",names(cleanedMeanStdData))
names(cleanedMeanStdData) <- sub("-mean\\(\\)","Mean",names(cleanedMeanStdData))
names(cleanedMeanStdData) <- sub("-std\\(\\)","Std",names(cleanedMeanStdData))

library(plyr)
cleanedMeanStdData$activity <- mapvalues(factor(cleanedMeanStdData$activity), from = as.character(activityLabels$activity), 
                                          to = as.character(activityLabels$activityName))

# step 5: grouping

groupedData <- cleanedMeanStdData %>% group_by(activity, subject) %>% summarise_each(funs(mean))

write.table(groupedData,file="./data/groupedDataUCI.txt", quote=FALSE)

