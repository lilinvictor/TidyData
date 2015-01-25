# Function to load feature list
GetFeatureList <- function()
{
	fname <- "UCI HAR Dataset/features.txt"
	if(!file.exists(fname)) {
		stop(sprintf("Can't find data file: %s.", fname))
	}
	f <- read.table(fname, sep = "")
	
	# Add VarName and remove ()
	f$VarName <- gsub("\\(\\)", "", f$V2)
	
	# Replace special character to underscore
	f$VarName <- gsub("[,\\(\\)-]", "_", f$VarName)
	
	# Remove tail underscore and multiple underscores
	f$VarName <- gsub("_$", "", f$VarName)
	f$VarName <- gsub("_{2,}", "_", f$VarName)

	f$VarName
}

# Function to filter features related with mean and standard deviation
GetFeatureFilter <- function(list)
{
	grep("(mean|std)", list, ignore.case = TRUE)
}

# Function to load activity table with id and labels
GetActivityTable <- function()
{
	fname <- "UCI HAR Dataset/activity_labels.txt"
	if(!file.exists(fname)) {
		stop(sprintf("Can't find data file: %s.", fname))
	}
	f <- read.table(fname, sep = "")
	names(f) <- c("id", "activity")
	
	f
}

# Function to load measurement data for specified dataset (train or test)
LoadDataset <- function(set)
{	
	folder <- sprintf("UCI HAR Dataset/%s", set);
	if(!file.exists(folder)) {
		stop(sprintf("Can't find data folder: %s.", folder))
	}
	
	# Load subject IDs for dataset
	fname <- paste(folder, sprintf('subject_%s.txt', set), sep = '/')
	subject <- read.table(fname, sep = "", col.names = c("id"))
	
	# Load activity IDs for dataset
	fname <- paste(folder, sprintf('y_%s.txt', set), sep = '/')
	activity <- read.table(fname, sep = "", col.names = c("id"))
	
	# Load raw data for measurement. This may take long time to complete.
	print(date())
	fname <- paste(folder, sprintf('X_%s.txt', set), sep = '/')
	print(sprintf("Load and parse raw data file '%s' ...", fname))
	data <- read.fwf(fname, widths = rep(16, 561), buffersize = 200)
	
	# Filter with selected features
	feature <- GetFeatureList()
	filter <- GetFeatureFilter(feature)
	data <- data[,filter]
	names(data) <- feature[filter]
	
	# Merge with ActivityId and SubjectId
	data$subjectId <- subject$id
	data$activityId <- activity$id
	
	# Merge with descriptive activity names
	merge(x = data, y = GetActivityTable(), by.x = "activityId", by.y = "id")
}

# Function to merge train and test dataset
MergeDataset <- function()
{
	trainData <- LoadDataset("train")
	testData <- LoadDataset("test")
	
	rbind(trainData, testData)
}

# Function to analyse dataset and generate tidy data
GenerateTidyData <- function()
{
	data <- MergeDataset()
	
	# Aggreate all data grouped by activity and subject
	feature <- GetFeatureList()
	filter <- GetFeatureFilter(feature)
	featureList <- feature[filter]
	tidyData <- aggregate(data[,featureList], by = data[, c("activityId","activity","subjectId")], FUN = mean)
	
	# Sort by activity, subject
	tidyData <- tidyData[order(tidyData$activityId, tidyData$subjectId),]
	
	# Save to txt file
	write.table(tidyData, "TidyData.txt", row.name = FALSE)
	
	tidyData
}