## To start running the script first download the "getdata-projectfiles-UCI HAR Dataset.zip" file 
## and unzip in your working directory. The script will use de "UCI HAR Dataset" folder.
## If you don´t have the file you can use the follow code:
##
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl, destfile = "./CourseProjectData.zip", method = "curl")
## dateDownloaded <- date()
##
## unzip("./CourseProjectData.zip", overwrite = TRUE, exdir = "./")
##
## This script use the "data.table" package

if (file.exists("UCI HAR Dataset")) {

library(data.table);

## 1. Generates the training dataset from the TXT files - 7352 rows

## Obtain training data from TXT files 
trainset_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
names(trainset_subjects) <- c("subject_id")

trainset_activities <- read.table("UCI HAR Dataset/train/y_train.txt")
names(trainset_activities) <- c("activity_id")

trainset_data <-  read.table("UCI HAR Dataset/train/x_train.txt") 

## Merge training data into one dataframe
dataset_training <- cbind(trainset_subjects,trainset_data,trainset_activities)


## 2. Generates the test dataset from the TXT files - 2947 rows

## Obtain training data from TXT files - 2947 rows
testset_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(testset_subjects) <- c("subject_id")

testset_activities <- read.table("UCI HAR Dataset/test/y_test.txt")
names(testset_activities) <- c("activity_id")

testset_data <- read.table("UCI HAR Dataset/test/x_test.txt")

## Merge training data into one dataframe
dataset_test <- cbind(testset_subjects,testset_data,testset_activities)


## 3. Merge de train set and the test set to create one dataset.

complete_dataset <- rbind(dataset_training,dataset_test)


## 4. Extract only the measurements on the mean and standard deviation from the dataset

## The mean and standard deviation of each measurement corresponds to the follow index column (numbers) 
## according with the features.TXT file information (66 columns)
features <- read.table("UCI HAR Dataset/features.txt")
variables_selected <- c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,345:350,424:429,503:504,516:517,529:530,542:543)
variables_names <- as.vector(features[variables_selected,2])

## add a "V" prefij to select the colums by name from the "complete_dataset" dataframe 
variables_selected <- paste0("V",variables_selected)

## extract only the variables requered from the complete dataset, including the "subject" and "activity" values
variables_dataset <- complete_dataset[,c("subject_id",variables_selected,"activity_id")]

## 5. Add the Activity name from the activity_labels.TXT file to each row in the "variables_dataset"

activities_name <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activities_name) <- c("activity_id","activity_name")

variables_dataset <- merge(variables_dataset,activities_name,by.x="activity_id",by.y="activity_id")

## 6. Creates the tidy dataset with the average of each variable for activity and subject

DT_variables_dataset <- data.table(variables_dataset)

##paste0(paste0(paste0(variables_selected,"=mean("),variables_selected),"),")
DT_tidy_dataset <- DT_variables_dataset[,
list(V1=mean(V1),V2=mean(V2),V3=mean(V3),V4=mean(V4),V5=mean(V5),V6=mean(V6),    
V41=mean(V41), V42=mean(V42), V43=mean(V43), V44=mean(V44), V45=mean(V45), V46=mean(V46),  
V81=mean(V81), V82=mean(V82), V83=mean(V83), V84=mean(V84), V85=mean(V85), V86=mean(V86),  
V121=mean(V121), V122=mean(V122), V123=mean(V123), V124=mean(V124), V125=mean(V125), V126=mean(V126), 
V161=mean(V161), V162=mean(V162), V163=mean(V163), V164=mean(V164), V165=mean(V165), V166=mean(V166), 
V201=mean(V201), V202=mean(V202), V214=mean(V214), V215=mean(V215), V227=mean(V227), V228=mean(V228), 
V240=mean(V240), V241=mean(V241), V253=mean(V253), V254=mean(V254), V266=mean(V266), V267=mean(V267), 
V268=mean(V268), V269=mean(V269), V270=mean(V270), V271=mean(V271), V345=mean(V345), V346=mean(V346), 
V347=mean(V347), V348=mean(V348), V349=mean(V349), V350=mean(V350), V424=mean(V424), V425=mean(V425), 
V426=mean(V426), V427=mean(V427), V428=mean(V428), V429=mean(V429), V503=mean(V503), V504=mean(V504), 
V516=mean(V516), V517=mean(V517), V529=mean(V529), V530=mean(V530), V542=mean(V542), V543=mean(V543)),
by=c("activity_name","subject_id")]

## 7. Set the variables name to the tidy dataset

tidy_dataset <- data.frame(DT_tidy_dataset)
names(tidy_dataset) <- c("activity_name","subject_id", variables_names);

## 8. Final tidy dataset

## A TXT file with the tidy dataset has been created in your working directory
write.table(tidy_dataset, file="tidy_dataset.txt", row.names=FALSE);
tidy_dataset;

} else {

print('The Samsung data is not in your working directory')

}