# download data

filename <- "gcdproject.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}


# Load activity labels + features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
colnames(activitylabels) = c('activity','activitylabel')
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresinscope <- grep(".*mean.*|.*std.*", features[,2])
featuresinscope.names <- features[featuresinscope,2]
#featuresinscope.names = gsub('-mean', 'Mean', featuresinscope.names)
#featuresinscope.names = gsub('-std', 'Std', featuresinscope.names)
#featuresinscope.names <- gsub('[-()]', '', featuresinscope.names)


# Load the train and test datasets
traindata <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresinscope]
trainactivities <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainactivities, traindata)

testdata <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresinscope]
testactivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubjects, testactivities, testdata)

# merge datasets and add labels
alldata <- rbind(train, test)
colnames(alldata) <- c("subject", "activity", featuresinscope.names)
finaldata <- merge(alldata,activitylabels,by='activity',all.x=TRUE)

# relabel columns with more descriptive names
finalcolnames <- colnames(finaldata)
for (i in 1:length(finalcolnames)) 
{
    finalcolnames[i] = gsub("\\()","",finalcolnames[i])
    finalcolnames[i] = gsub("-std","StdDev",finalcolnames[i])
    finalcolnames[i] = gsub("-mean","Mean",finalcolnames[i])
    finalcolnames[i] = gsub("^(t)","time",finalcolnames[i])
    finalcolnames[i] = gsub("^(f)","freq",finalcolnames[i])
    finalcolnames[i] = gsub("([Gg]ravity)","Gravity",finalcolnames[i])
    finalcolnames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",finalcolnames[i])
    finalcolnames[i] = gsub("[Gg]yro","Gyro",finalcolnames[i])
    finalcolnames[i] = gsub("AccMag","AccMagnitude",finalcolnames[i])
    finalcolnames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",finalcolnames[i])
    finalcolnames[i] = gsub("JerkMag","JerkMagnitude",finalcolnames[i])
    finalcolnames[i] = gsub("GyroMag","GyroMagnitude",finalcolnames[i])
};

colnames(finaldata) <- finalcolnames

# create a second, independent tidy data set

# calculate the average of each variable for each activity and each subject
alldata <- finaldata[,names(finaldata) != 'activitylabel']
tidydatadraft <- aggregate(alldata, by=list(subject=alldata$subject, activity=alldata$activity),mean)

# merge tidydata with activitylabels
tidydata <- merge(tidydatadraft[,3:83],activitylabels,by='activity',all.x=TRUE)

write.table(tidydata, "tidydata.txt", sep="\t")
