# TidyData

Welcome to Git repo for cleaning data project

## About the tidy data

For explanation of variables in tidy data and how they are selected and generated, please see [code book](CodeBook.MD).

## Configuration

- Download raw data file from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip);
- Extract data zip file to R working directory. You will see folder "UCI HAR Dataset" in R working directory, which contains data files.
- Copy R script file ["run_analysis.R"](run_analysis.R) to your R working directory.

## Run script in R console

	source("run_analysis.R")
	tidyData <- GenerateTidyData()
	
Caution: it may take 10+ minutes to load and parse the data.

## View tidy data file

After running the script, a new data file "TidyData.txt" is generated in R working directory. You can run following scripts in R to view the data file:

	data <- read.table("TidyData.txt", header = TRUE)
	View(data)
