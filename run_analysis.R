require("dplyr")

### Merge all data into one Data.frame
# Collect all txt files into variables
#Test:
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
#Train:
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

### Combine Test and Train groups
# Add column for whether the data is from Test or Train to "x"
x_test$source <- "test"
x_train$source <- "train"
# combine rows from test and train, in that order, for each data set
x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <- rbind(subject_test,subject_train)

# Use grep to find which labels in y are associated with mean and std
### - 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- readLines("UCI HAR Dataset/features.txt")
feature_mean_std <- grep("mean|std",features, value = T)
# tidy the names of these labels, removing line numbers
feature_mean_std <- gsub("^[0-9]+ ","", feature_mean_std)
feature_mean_std_index <- grep("mean|std",features) # indices for each measurement

# Use these grepped labels and indices to label the dataframe
### - 4. Appropriately labels the data set with descriptive variable names.
x2 <- x[, feature_mean_std_index]
names(x2) <- feature_mean_std
x2$source <- x$source

# rename variable for "Activity" on y, and replace each index with a given activity name
### - 3. Uses descriptive activity names to name the activities in the data set
names(y) <- "activity"
y2 <- y
y2$activity <- gsub("1", "walking", y2$activity)
y2$activity <- gsub("2", "walking_upstairs", y2$activity)
y2$activity <- gsub("3", "walking_downstairs", y2$activity)
y2$activity <- gsub("4", "sitting", y2$activity)
y2$activity <- gsub("5", "standing", y2$activity)
y2$activity <- gsub("6", "laying", y2$activity)

# Rename column header for "subject", and merge this row and y2 into the newly polished x2
names(subject) <- "subject"
### - 1. Merges the training and the test sets to create one data set.
HAR <- cbind(subject, y2, x2)

### final cleaning of data
# put "HAR$source" further to the left of columns, where indexing info is
HAR <- HAR[,c(1,2,(ncol(HAR)),( 3:(ncol(HAR)-1) ))]
# sort by subject, then by activity
HAR <- arrange(HAR,subject,activity)


### - 5. From the data set after step 4, creates a second, independent tidy data set 
###         with the average of each variable for each activity and each subject.
averaged <- HAR %>%
    group_by(activity, subject) %>% # finding stats "for each activity and each subject"
    select(-source) %>% # remove my "source" variable, as it's not necessary here
    # for each grouped set of values (by activity and subject) under each column (variable), find the mean
    summarise_all(function(x){mean(x)}) 
