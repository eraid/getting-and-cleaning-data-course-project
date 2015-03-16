##
# Getting and Cleaning Data
# Assessment 2
# By Yanick Miron
# 2015-03-12
#
# Download and unzip dataset.
#
##

##
# Setup path and file name
wd <- getwd()
data_dir <- file.path(wd,"data")
dataset_sfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataset_dfile <- file.path(data_dir,"getdata-projectfiles-UCI_HAR_Dataset.zip")
##
# Create data directory if not already exists. 
if(! file.exists(data_dir)) {
  dir.create(data_dir)
}

##
# Download dataset
download.file(url = dataset_sfile, destfile = dataset_dfile, method = "curl")
# Keep last downloaded time 
zfile_lddate <- Sys.time()

##
# Unzip downloaded data package in data folder.
unzip(zipfile = dataset_dfile, exdir = data_dir )

##
# Clean variables
rm(wd,data_dir,dataset_sfile,dataset_dfile)

