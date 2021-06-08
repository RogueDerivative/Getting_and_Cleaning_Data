#packages
library(readr)
library(dplyr)


#Open the files
if(!file.exists("data")){
        dir.create("data")
}
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url1, destfile = "./data/df1.zip")
unzip(zipfile = "./data/df1.zip")

#confirm download date
dateDownloaded <- date()


#read in the files
cnames <- read_lines("./UCI HAR Dataset/features.txt")
test_ID <- read_table("./UCI HAR Dataset/subject_test.txt", col_names = "ID")
test_data <- read_table("./UCI HAR Dataset/X_test.txt", col_names = cnames)
test_activity <- read_table("./UCI HAR Dataset/y_test.txt", col_names = "activity")
train_ID <- read_table("./UCI HAR Dataset/subject_train.txt", col_names = "ID")
train_data <- read_table("./UCI HAR Dataset/X_train.txt", col_names = cnames)
train_activity <- read_table("./UCI HAR Dataset/y_train.txt", col_names = "activity")



#class and dimension of files
# class(cnames); dim(cnames)
# class(test_ID); dim(test_ID)
# class(test_data); dim(test_data)
# class(test_activity); dim(test_activity)
# class(train_ID); dim(train_ID)
# class(train_data); dim(train_data)
# class(train_activity); dim(train_activity)
# class(test_df); dim(test_df)
# class(train_df); dim(train_df)
# class(my_df); class(my_df)

#1 Merge the test and training sets to make one data set
test_df <- as.data.frame(cbind(test_ID,test_activity,test_data))
train_df <- as.data.frame(cbind(train_ID,train_activity,train_data))
my_df <- rbind(test_df,train_df)

#class and dimension of merged data
# class(test_df); dim(test_df)
# class(train_df); dim(train_df)
# class(my_df); class(my_df)


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
        summarise(across(3:86,mean))
write.table(tidy_subset, file = "./tidy.txt", row.names = FALSE)
