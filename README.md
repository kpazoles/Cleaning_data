Cleaning_data
=============

Course project for Coursera Getting and Cleaning Data

The run_analysis code performs the following tasks: 

Imports three test files (subjects, activities and data), three training files (subjects, activities and data) as well as two files with data lables (activity names and variable names). 

For both the test and training files, the analysis first matches the activities and activity names, creating a new column labeling each activity.  Then it renames the columns in the data files using the variable names.  Finally it merges the data with the subjects and activities. 

Next, the training and test data are combined, to create one data file (alldata)

Then just the columns with the mean and standard deviation are extracted, and a new file is created with just these columns, plus the subjects and activities). 

Finally, I subsetted the data to split out by subject, then by activity, to find the mean of all variables for each activity for each subject. I used loops here, although i'm sure there's a better way.  I had each loop add a row to the final dataset, and then wrote the dataframe to a txt file. 
