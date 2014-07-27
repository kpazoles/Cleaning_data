library(plyr)
library(reshape2)
#importing files
testdata<-read.table("./test/X_test.txt")
trainingdata<-read.table("./train/X_train.txt")
testlabels<-read.table("./test/y_test.txt")
testsubjects<-read.table("./test/subject_test.txt")
traininglabels<-read.table("./train/y_train.txt")
trainingsubjects<-read.table("./train/subject_train.txt")
activitylabels<-read.table("activity_labels.txt")
variablenames<-read.table("features.txt")

#combines the subjects and labels
test1<-cbind(testsubjects,testlabels)
#matches the labels to activity names and adds the names to the test set
mtest<-match(test1[,2],activitylabels[,1])
test1$name<-activitylabels[mtest,2]
#rename columns of test data
variables<-as.vector(variablenames[,2])
colnames(testdata)<-variables
#combines the test data with the subjects and labels
test2<-cbind(test1,testdata)

training1<-cbind(trainingsubjects,traininglabels)
mtraining<-match(training1[,2],activitylabels[,1])
training1$name<-activitylabels[mtraining,2]
colnames(trainingdata)<-variables
training2<-cbind(training1,trainingdata)

#combines everything into one data set
alldata<-rbind(test2,training2)

#extracting the mean and standard deviation columns
std<-alldata[grep("std",colnames(alldata))]
mean<-alldata[grep("mean",colnames(alldata))]

#creates a dataset with just the subject, activity and standard deviation and mean for each measurement
tidydata1<-cbind(alldata[,1],alldata[,3],std,mean)
colnames(tidydata1)[1]<-"Subject"
colnames(tidydata1)[2]<-"Activity"

#reshaping the data to find the mean for each subject, and creating the final file.
meltdata<-melt(tidydata1,id.vars=c("Subject", "Activity"))
subject_means<-ddply(meltdata,.(Subject,variable),summarize,mean=mean(value))
meandata<-dcast(subject_means,Subject~variable,value.var="mean")

write.table(meandata,file="tidy_data.txt")