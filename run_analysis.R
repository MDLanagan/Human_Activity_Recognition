#process data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and extracted to local drive
#to produce a tidy data set of means. The resulting table "Human Activity Recognition Means.txt" has:
#	- 1 row of values for each subject/activity observation
#	- separate columns for subject, activity and each variable measured
#	and hence conforms to a wide-form tidy data set

#set working directory to parent folder and store location
setwd("C:/Data/DataScienceCoursera/Getting and Cleaning Data Project/UCI HAR Dataset")
defWD<- getwd()

#read activity labels
datlabels<-read.table("activity_labels.txt",col.names = c("activitylabel", "activitydescription")) #get activity descriptions

#read all recorded variable names
datfeatures<-read.table("features.txt") #get activity data column names
# add a logical column to activity data to indicate if column contains mean or sd data - double escape to include opening parenthis so that columns that
# include mean or std in the description but this is not the measured parameter are excluded
datfeatures$vmeanstd<-grepl("std\\(|mean\\(",datfeatures$V2) 
listcol<-datfeatures[datfeatures$vmeanstd,]#subset to get a list of mean & sd feature column numbers
extractcol<-listcol[,1] #vector of column numbers to return later
extractcolnames<-listcol[,2]#vector of column names to return later

#change working directory to 'test' sub-folder, read each table, subset to jsut requuired mean & sd value columns and combine to a single table
setwd(file.path(defWD,"/test/"))
datsubjecttest<-read.table("subject_test.txt", col.names = "subject")
datactivitytest<-read.table("y_test.txt", col.names = "activity")
datxtest<-read.table("X_test.txt")
datxtestmean<-datxtest[,extractcol]
names(datxtestmean)<-extractcolnames
dattest<-cbind(datsubjecttest,datactivitytest,datxtestmean)

#change working directory to 'train' sub-folder, read each table, subset to just required mean & sd value columns and combine to a single table
setwd(file.path(defWD,"/train/"))
datsubjecttrain<-read.table("subject_train.txt", col.names = "subject")
datactivitytrain<-read.table("y_train.txt", col.names = "activity")
datxtrain<-read.table("X_train.txt")
datxtrainmean<-datxtrain[,extractcol]
names(datxtrainmean)<-extractcolnames
dattrain<-cbind(datsubjecttrain,datactivitytrain,datxtrainmean)

setwd(defWD)#return to default working directory

datcombine<-rbind(dattest,dattrain)#combine tables

#calculate mean of each value column
datSummaryMean<-aggregate(datcombine[,3:68],list(subject=datcombine$subject, activity=datcombine$activity),mean)

#replace activity labels (digit) with description (converted to lower case and underscore removed; 
#completing this step here requires renaming 180 values vs 10299 values in combined data
for (i in 1:6) {datSummaryMean$activity<-sub(datlabels$activitylabel[i],tolower(sub("_","",datlabels$activitydescription[i])),datSummaryMean$activity)}

#replace short abbreviations in variable names
names(datSummaryMean)<-sub("^t","time",names(datSummaryMean))
names(datSummaryMean)<-sub("^f","frequency",names(datSummaryMean))
names(datSummaryMean)<-sub("Mag","Magnitude",names(datSummaryMean))

#sort data in final table by activity and subject
datSummaryMean<-datSummaryMean[order(datSummaryMean$activity, datSummaryMean$subject),]

#write out summary table to file
write.table(datSummaryMean, file = "Human Activity Recognition Means.txt", sep = " ", row.names = FALSE, quote = FALSE)
#or as csv
# write.csv(datSummaryMean, file = "Human Activity Recognition Means.csv",row.names = FALSE)

#to read in txt file, surround with 'head' function if you want to view only
#read.table("Human Activity Recognition Means.txt",sep = " ",header = TRUE)
#head(read.table("Human Activity Recognition Means.txt",sep = " ",header = TRUE))
 