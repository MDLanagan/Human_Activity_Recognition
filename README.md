# Human_Activity_Recognition
README
The source data contains measured & calculated values related to human activities observed and recorded by a carreid device.
The data were obtained from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (downloaded 2017-06-23 08:53) and contains:
- a file providing the description label of the actvity;
- test and train folders that each contain 3 files:
  - subject (a list of subject identifier)
  - activity (a list of activity identifier)
  - values
The 3 files are:
  - combined as a single table;
  - value columns that do not contain mean or std. dev. data removed; and
  - suitable column names applied.
This step is repeated for test (dattest) and train (dattrain) data sets and the tables combined (datcombine).
The single table 'datcombine' provides the consolidated data set for further operations:
  - calculate mean values for each variable by subject & activity (datSummaryMean)
  - replace each activity number with its description
  - expand abbreviations in variable names e.g. t -> time
 
The resulting table of summary values is written out to the parent directory containing the data
(file = "Human Activity Recognition Means.txt")

to read in the txt file:
read.table("Human Activity Recognition Means.txt",sep = " ",header = TRUE)
surround with 'head' function if you want to view only
head(read.table("Human Activity Recognition Means.txt",sep = " ",header = TRUE))
