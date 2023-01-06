## Data pre-processing
1. The original data consists of CSV files.
	- Occurence.csv: 20GB
	- Multimedia.csv: 1.3GB
2. I filter the data for countries of interest, Poland and Germany using bash. After navigating to the folder containing the data, the following `awk` command filters the data. 

awk -F, '$22 ~ /Poland|Germany/ {print}' occurrence.csv >> my_data.csv

The commands scans column 22 (country) of **occurrence.csv** and returns those rows with Poland and Germany and prints the output into **my_data.csv** that is 213MB.

## Missig Data
3. I fill missing values in the *vernacularName* variable with the corresponding value in the *scientificName* variable and vice versa.

## Data preparation
3. For speedy access of the data, I convert the csv into a arrow::parquet format. 
4. Subsequently, I load the data into the shiny application using the read_parquet function from the arrow package. The prquet file is 23.2MB. 





