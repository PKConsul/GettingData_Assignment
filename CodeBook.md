Getting and Cleaning Data Course Project
=========
---
Description related to the script run_analysis.R

---

Initial data sets:

  - activity_labels -> Links the class labels with their activity name
  - features -> List of all features
  - --
  - X_training_set -> Training set
  - Y_training_set -> Training labels
  - subject_training_set -> Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. Related to training set
  - --
  - Y_test_set -> Test labels
  - X_test_set -> Test set
  - subject_test_set -> Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. Related to test set
  - --


Variables storing the data after some processing :

 - X_set -> binded X_training_set and X_test_set extended with new columns containing "subject" and "activity" data {section 2.0 in the script}
 
```X_training_set["subject"]<-subject_training_set
X_training_set["activity"]<-Y_training_set

X_test_set["subject"]<-subject_test_set
X_test_set["activity"]<-Y_test_set

X_set<-rbind(X_test_set,X_training_set)
 ```
 - std_mean_rows -> vector containing indexes for std and mean in the column names based on the features columns names
```
std_mean_rows<-grep(pattern=".mean|.std",features$"V2")```
 - limited_X_set -> X_set limited with columns based on the std_mean_rows results (562,563 are columns containing 'subject' and 'activity')
 ```
limited_X_set <- X_set[,c(std_mean_rows,562,563)]```

 - act_limited_X_set -> limited_X_set with actiivity translation from the digit to the label value {finally 1st column has to be dropped to remove not needed column which contains activity id value}
 ```
act_limited_X_set <-merge(limited_X_set,activity_labels,by.x="activity",by.y="id")
act_limited_X_set<-act_limited_X_set[,2:ncol(act_limited_X_set)]
```

---

Other transformation:

- setting the labels for columns in the act_limited_X_set on first 79 columns (the remaining 2 coluns are "subject" and "activity name")

```
for (j in 1:79) {names(act_limited_X_set)[j]<-paste(features[substr(names(act_limited_X_set)[j],2,nchar(names(act_limited_X_set)[j])),2])}
write.csv(act_limited_X_set,file="first_tidy_set.txt")```

- second_set -> second tidy set created based on act_limited_X_set
```
second_set<-ddply(act_limited_X_set,.(subject,activity_name), numcolwise(mean))
```
---

Version
----

1.0


