# load the UCI HAR dataset text files into R

library(dplyr)
library(tidyr)


setwd("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")

temp = list.files(pattern="*.txt")
try(for (i in 1:length(temp)) 
    assign(temp[i], read.table(temp[i])),silent = TRUE)

# load the train text files into R

setwd("./train")
temp = list.files(pattern="*.txt")
for (i in 1:length(temp)) 
    assign(temp[i], read.table(temp[i]))

# load the test text files into R


setwd("./test")
temp = list.files(pattern="*.txt")
for (i in 1:length(temp)) 
    assign(temp[i], read.table(temp[i]))

# Adds activity label to the train and test y-label codes from the activity_labels file (# 3. Uses descriptive activity names to name the activities in the data set)

y_train <- full_join(y_train.txt,activity_labels.txt, by="V1")
y_test <- full_join(y_test.txt,activity_labels.txt, by="V1")

# Rename column as activity 

names(y_train)[2] <- "Activity"
names(y_test)[2] <- "Activity"

# Adds column names to the train and test x-label data set from the features file (#4. Appropriately labels the data set with descriptive variable names.)

colnames(X_train.txt) <- features.txt$V2

colnames(X_test.txt) <- features.txt$V2


# bind the subject ID and activity to the training and testing sets

x_train <-cbind(Subjects = subject_train.txt$V1, Activity = y_train$Activity, X_train.txt)
x_test<-cbind(Subjects = subject_test.txt$V1, Activity = y_test$Activity, X_test.txt)

# 1. Merges the training and the test sets to create one data set.

allData <- rbind(x_train,x_test)

# 2. Extract the measurement of the mean and the standard deviation for each measurement

allData2 <-select(allData, Subjects, Activity, grep("mean|std",names(allData)))

# 3. Uses descriptive activity names to name the activities in the data set (see above)

# 4. Appropriately labels the data set with descriptive variable names. (see above)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

allData3 <- group_by(allData2 ,Subjects,Activity)
finalTidyData <- summarise_all(allData3,mean)
