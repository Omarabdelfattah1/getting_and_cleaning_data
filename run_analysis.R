# load libraries
library(dplyr) 

#merge x datasets for train and test 
x_train   <- read.table("./datasets/train/X_train.txt")
x_test   <- read.table("./datasets/test/X_test.txt")
merged_x   <- rbind(x_train, x_test)

#merge y datasets for train and test
y_train   <- read.table("./datasets/train/Y_train.txt")
y_test   <- read.table("./datasets/test/Y_test.txt") 
merged_y  <- rbind(y_train, y_test) 

#merge sub datasets for train and test
sub_train <- read.table("./datasets/train/subject_train.txt")
sub_test <- read.table("./datasets/test/subject_test.txt")
merged_sub <- rbind(sub_train, sub_test) 


# read features description 
features <- read.table("./datasets/features.txt") 

# read activity labels 
activity_labels <- read.table("./datasets/activity_labels.txt") 

# merge of training and test sets

# keep only measurements for mean and standard deviation 
variable_names <- read.table("./datasets/features.txt", header = F)
subFeaturesNames <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
merged_x      <- merged_x[,subFeaturesNames[,1]]

# name columns
colnames(merged_x)   <- subFeaturesNames[,2]
colnames(merged_y)   <- "activity"
colnames(merged_sub) <- "subject"

# merge final dataset
final_merged <- cbind(merged_sub, merged_y, merged_x)

# turn activities & subjects into factors 
final_merged$activity <- factor(final_merged$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
final_merged$subject  <- as.factor(final_merged$subject) 

# create a summary independent tidy dataset from final dataset 
# with the average of each variable for each activity and each subject. 
total_mean <- final_merged %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

# export summary dataset
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
