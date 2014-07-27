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
#matches the labels to activity names and adds the names to the training set
mtraining<-match(training1[,2],activitylabels[,1])
training1$name<-activitylabels[mtraining,2]
#rename columns
colnames(trainingdata)<-variables
#combines the training data with the subjects and labels
training2<-cbind(training1,trainingdata)

#combines everything into one data set
alldata<-rbind(test2,training2)
colnames(alldata)[1]<-"Subject"
colnames(alldata)[2]<-"Activity"

#extracting the mean and standard deviation columns
std<-alldata[grep("std",colnames(alldata))]
mean<-alldata[grep("mean",colnames(alldata))]


#creates a dataset with just the subject, activity and standard deviation and mean for each measurement
tidydata1<-cbind(alldata[,1:3],std,mean)


#reshaping the data to split by subject then by activity within subject, find the mean and add it to the final data frame.
final_data<-subset(tidydata1[0,])
x<-(1:30)
for (i in x){
        subject<-subset(tidydata1,Subject==i)
        y<-(1:6)
        for (i in y){
                activity<-subset(subject,Activity==i)
                means<-t(as.data.frame(colMeans(activity[4:82])))
                means<-cbind(activity[1:3],means)
                final_data<-rbind(final_data,means)
        }
}
                
write.table(final_data,file="tidy_data.txt")
