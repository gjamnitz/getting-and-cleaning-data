library(plyr)

# reading and creating test data
dsTest <- read.csv("test/X_test.txt", header = FALSE, sep = "")
subTest <- read.csv("test/subject_test.txt", header = FALSE, sep = "")
typeTest <- read.csv("test/y_test.txt", header = FALSE, sep = "") 
dsTest <- cbind(subTest, dsTest)
dsTest <- cbind(typeTest, dsTest)

# reading and creating training data
dsTrain <- read.csv("train/X_train.txt", header = FALSE, sep = "")
subTrain <- read.csv("train/subject_train.txt", header = FALSE, sep = "")
typeTrain <- read.csv("train/y_train.txt", header = FALSE, sep = "") 
dsTrain <- cbind(subTrain, dsTrain)
dsTrain <- cbind(typeTrain, dsTrain)

# merging - step 1
dsAll <- rbind(dsTest, dsTrain)

# column names
feats <- read.csv("features.txt", header = FALSE, sep = "")
names(feats) <- c("colnum", "colname")

# selecting necessary columns (numbers)
colsNeeded <- feats[grepl("mean()", feats$colname) | grepl("std()", feats$colname),]

# extract only mean and sd columns (plus first 2 columns - step 2)
dsExtracted <- dsAll[, c(c(1, 2), colsNeeded[,1] + 2)]

# activity labels
actLabels <- read.csv("activity_labels.txt", header = FALSE, sep = "")

# set activity names (step3) 
dsExtracted[,1] <- actLabels[dsExtracted[,1], 2]

# set better variable names (step4)
names(dsExtracted) <- c(c("activity", "subject"), as.character(colsNeeded[,2]))
names(dsExtracted) <- gsub('\\(|\\)',"",names(dsExtracted), perl = TRUE)
names(dsExtracted) <- make.names(names(dsExtracted))

# creating tidy ds (step5)
dsTidy <- ddply(dsExtracted, c("subject","activity"), numcolwise(mean))

# writing tidy dataset  
write.table(dsTidy, file = "tidyDataset.txt", row.name = FALSE)



