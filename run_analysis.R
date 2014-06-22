###########################################
print("loading data:")

subject_test_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
activity_labels<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

features<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

X_training_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Y_training_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
Y_test_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
subject_training_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
X_test_set<-read.table("getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

colnames(activity_labels)[1] <- "id"
colnames(activity_labels)[2] <- "activity_name"

###########################################
print("Merges the training and the test sets to create one data set.")
X_training_set["subject"]<-subject_training_set
X_training_set["activity"]<-Y_training_set

X_test_set["subject"]<-subject_test_set
X_test_set["activity"]<-Y_test_set

X_set<-rbind(X_test_set,X_training_set)


###########################################
print("Extracts only the measurements on the mean and standard deviation for each measurement. ")

std_mean_rows<-grep(pattern=".mean|.std",features$"V2")
limited_X_set <- X_set[,c(std_mean_rows,562,563)]

###########################################
print("Uses descriptive activity names to name the activities in the data set")

act_limited_X_set <-merge(limited_X_set,activity_labels,by.x="activity",by.y="id")
act_limited_X_set<-act_limited_X_set[,2:ncol(act_limited_X_set)]


###########################################
print("Appropriately labels the data set with descriptive variable names. ")

for (j in 1:79) {names(act_limited_X_set)[j]<-paste(features[substr(names(act_limited_X_set)[j],2,nchar(names(act_limited_X_set)[j])),2])}
write.csv(act_limited_X_set,file="first_tidy_set.txt")

###########################################
print("Creates a second, independent tidy data set with the average of each variable for each activity and each subject. ")
library(plyr)
  
second_set<-ddply(act_limited_X_set,.(subject,activity_name), numcolwise(mean))
write.csv(second_set,file="second_tidy_set.txt")

###########################################
print("Script has finished")
