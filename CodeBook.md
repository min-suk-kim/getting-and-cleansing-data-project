CODEBOOK

Note that the script run_analysis.R is written based on the dataset provided below and consists of the following steps:
1. Download + unzip the dataset
2. Load activity labels + features (read.table)
3. Extract only the data on mean and standard deviation (grep)
4. Load train and test datasets and merge them into a single table (read.table)
5. Add activity labels (merge with activity labels loaded in #2)
6. Update column names to be more descriptive (gsub)
7. Create a second tidy data set that summarizes each category's mean value for each activity and subject.

For more details about the dataset, refer to README.md