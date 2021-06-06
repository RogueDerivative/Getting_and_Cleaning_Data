#packages
library(readr)
library(dplyr)

#1 Merge the test and training sets to make one data set
cnames <- read_lines("features.txt")
test_ID <- read_table("subject_test.txt", col_names = "ID")
test_data <- read_table("X_test.txt", col_names = cnames)
test_activity <- read_table("y_test.txt", col_names = "activity")
train_ID <- read_table("subject_train.txt", col_names = "ID")
train_data <- read_table("X_train.txt", col_names = cnames)
train_activity <- read_table("y_train.txt", col_names = "activity")
test_df <- as.data.frame(cbind(test_ID,test_activity,test_data))
train_df <- as.data.frame(cbind(train_ID,train_activity,train_data))
my_df <- rbind(test_df,train_df)


#2 extract columns containing mean and standard deviation
my_subset <- select(my_df,ID,activity,contains("mean"),contains("std"))


#3 rename the activity values
my_subset$activity[my_subset$activity == 1]<- "walking"
my_subset$activity[my_subset$activity == 2]<- "walking_upstairs"
my_subset$activity[my_subset$activity == 3]<- "walking_downstairs"
my_subset$activity[my_subset$activity == 4]<- "sitting"
my_subset$activity[my_subset$activity == 5]<- "standing"
my_subset$activity[my_subset$activity == 6]<- "laying"

#4 give appropriate names to the variables
names(my_subset) <- gsub("-","_",names(my_subset))
names(my_subset) <- gsub(" ","",names(my_subset))
names(my_subset) <- gsub("Acc","Accelerometer",names(my_subset))
names(my_subset) <- gsub("Gyro","Gyroscope",names(my_subset))
names(my_subset) <- gsub("0","",names(my_subset))
names(my_subset) <- gsub("1","",names(my_subset))
names(my_subset) <- gsub("2","",names(my_subset))
names(my_subset) <- gsub("3","",names(my_subset))
names(my_subset) <- gsub("4","",names(my_subset))
names(my_subset) <- gsub("5","",names(my_subset))
names(my_subset) <- gsub("6","",names(my_subset))
names(my_subset) <- gsub("7","",names(my_subset))
names(my_subset) <- gsub("8","",names(my_subset))
names(my_subset) <- gsub("9","",names(my_subset))


#5 the average of each variable for each participant and their activity
tidy_subset <- my_subset %>%
        group_by(ID,activity) %>%
        summarise_each(funs(mean)) 
