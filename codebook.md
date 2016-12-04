## CodeBook

### Data download

-  from the [URL]("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") the zip file is downloaded in the folder ```data``` (if the folder ```data```doesn't already exist, it will be created). In the next step, the file will be unzipped. The upzipped files are stored in the folder  ```data/UCI HAR Dataset```  
-  the following files are read into a corresponding dataframe. The table below gives an overview of the dataframe names and the files
 
 dataframe name | underlying file | description------------ | -------------   |------trainSet | ./data/UCI HAR Dataset/train/X_train.txt | training data set testSet | ./data/UCI HAR Dataset/train/X_train.txt  | test data set
trainLabel | ./data/UCI HAR Dataset/train/y_train.txt | training activities testLabel | ./data/UCI HAR Dataset/test/y_test.txt | test activities 
trainSubject | ./data/UCI HAR Dataset/train/subject_train.txt | individuals id's (1-30) for the train data set
testSubject | ./data/UCI HAR Dataset/test/subject_test.txt  | individuals id's (1-30) for the test data set
features | ./data/UCI HAR Dataset/features.txt | column names for the datasets
activityLabels | ./data/UCI HAR Dataset/activity_labels.txt | activity names


### Merging test and train dataframes

The several train/test dataframes are merged along the rows (```rbind``` command):

- ```trainSet + testSet --> mergedData```
- ```trainLabel + testLabel -->  mergedLabel ```
- ```trainSubject + testSubject -->  mergedSubject```

   
### Reduce columns

- the ```features``` dataframe is used for the data columns. It describes the variables and can therefore be assigned to the names of the ```mergedData```dataframe
- the number of columns is reduced according to the name of the variable. Only columns with the expression ```mean()``` or ```std()``` in its name are used.
- the resulting dataframe is called ```meanStdData```    


### Final merging and naming , labelling
- the dataframes ```mergedSubject, mergedLabel, meanStdData``` are merged by their columns
- a new dataframe results with the name ```cleanedMeanStdData``` (Dimension: 10,299 x 68)
- the mean / std variables are renamed ("Mean" instead "-mean()-", analogous for the std)
- the activities (numbers from 1-6) are replaced with the corresponding  activity names, stored in the ```activityLabels```dataframe, using the ```mapvalues```function from the ```plyr```-package
- here's an excerpt of the columns of the ```cleanedMeanStdData``` dataframe:


column name |  description------------ | -------------   |subject | individuals id's (1-30)activity | activity name (6 activities: "walking", "laying", etc.)
tBodyAccMeanX | ...tBodyAccMeanY | ...
… | ...


### Grouping
- the dataframe ```cleanedMeanStdData``` is grouped by the ```activity``` and the ```subject```. For every variables (```tBodyAccMeanX, tBodyAccMeanY, etc.```) the average for each activity/subject combination is computed
- the results are stored in the dataframe ```groupedData``` (dimension: 180 x 68)
- the dataframe ```groupedData``` is written to the txt file "./data/groupedDataUCI.txt" with the default seperators (" ").
 
 