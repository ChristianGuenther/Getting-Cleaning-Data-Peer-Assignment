## 1.Merges the training and the test sets to create one data set.

## install readTable package
install.packages("data.table")
library(data.table)

# read data sets
train<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
test<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
features<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
subject_train<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
activity_lables<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
y_train<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

## combine training and test data
traintest<-rbind(train,test)

## set column names to features description
colnames(traintest)<-features[,2]

## create subject vector
subject<-rbind(subject_train,subject_test)

## create activity vector
y_traintest<-rbind(y_train,y_test)

## create activity column
l<-length(y_traintest[,1])
activity<-factor(activity_lables[,2])
for (i in 1:l){
  activity[i]<-activity_lables[y_traintest[i,],2]  
}

## attach subject vector to table
traintest<-cbind(traintest,subject)

## rename column to "Subject"
names(traintest)[562]<-"Subject"

## attach activity column
traintest<-cbind(traintest,activity)

## rename column to "Activity"
names(traintest)[563]<-"Activity"


## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 

## get vector with colmn no which contains mean and std in the description
mea<-grep("mean",features[,2])
st<-grep("std",features[,2])
Vmeast<-append(mea,st)

## extract columns with mean and std in the description to new data frame meast
meast<-traintest[,Vmeast]


## 3.Uses descriptive activity names to name the activities in the data set

## attach activity column
meast<-cbind(activity,meast)

## rename column to "Activity"
names(meast)[1]<-"Activity"

## attach subject vector to table
meast<-cbind(subject,meast)

## rename column to "Subject"
names(meast)[1]<-"Subject"


## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## create tidy data file
meastMelt<-melt(meast,id=c("Subject", "Activity"),measure.variables=features)
write.table(meastMelt,"tidydata.txt",row.name=FALSE)

