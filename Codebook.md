Codebook
========

The following describes how the data has been cleaned by run_analysis.R, and a descriptive list of variables in the tidy data set.

Process
-------
1. Data (in txt format) is collected into R via read.table, creating a variable for each txt file
2. For note-keeping, a variable is added to the x_test and x_train data (where the observations are stored) to track which collection each observation came from
3. Because the observations are split between "test" and "train" groups, the split data are combined into single variables, keeping consistent order (first test, then train)
4. To extract only data on which a "mean" or "standard deviation" has been taken, I use grep to search the researchers' codebook for those key terms, which also tells me which indices contain that data
5. I take information grep'd from the codebook, and use it both as a filter on the data, as well as for its labels (assignment part 2 and 4)
6. Using another section of the original codebook, I rename the coded "activity" variable from a numberic indicator, to a character vector describing the activity (assignment part 3)
7. I also rename the variable's header from R's default v1 to "activity"
8. I rename the variable indicating the subject ID from R's default to "subject"
9. I order the columns so that all of the identifying columns are on the left, and the data is on the right
10.I combine this cleaned data into a single dataframe, called HAR (for "Human Activity Recognition") (assignment part 1)
11. Finally, I create a separate dataframe of summarized tidy data (called "averaged"), which groups the data by activity and by subject, removes any other non-phone-data columns, and finds the mean for all variables by the aforementioned groups (assignment part 5)

Variables
----------

In HAR dataframe:
- subject - ID describing which participant was being measured by the following recorded data
- activity - one of 6 physical actions performed by each participant, during which movement data was recorded:
  - walking
  - walking_upstairs
  - walking_downstairs
  - sitting
  - standing
  - laying
- source - variable labeling whether the data derives from the "test" group, or the "train" group
- 79 other variables, named according to the signals being produced by the accelerometer and gyroscope in the phone, measuring movement. See "features_info.txt in the original UCI HAR Dataset directory (included) for more detail.

In "averaged" dataframe:
- subject - same as above
- activity - same as above
- 79 other variables - same variables as above, averaged per activity, per subject.
