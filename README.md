# This is the Yellowhammer benchmark
by Régis Ouvrard

PLEASE NOTE: This benchmark is currently under development. Please feel free to reload the data to get the latest version.

# Complete dataset
A CSV file, _Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv_, containing 22,641 counting data entries with the year of observation, location, climatic, bioclimatic and habitat variables.

The complete dataset is used to produce the final estimated model.

# 70/30 test dataset, with 70% of the data for estimation and 30% for validation

Two CSV files, _Data_Estimation_70.csv_ and _Data_Validation_30.csv_, containing rows from 100 random 70/30 draws from the complete data table.

# Prediction test dataset, with data from the first 19 years for estimation and the last 5 years for validation

A CSV file, _Data_Estimation_2001_2019.csv_, containing data from the first 19 years for estimation.

Validation performance is derived from the complete dataset, taking into account only the last five years.

# Explicative variables

The climatic variables _prec(x, y, t)_, _tmax(x, y, t)_ and _tmin(x, y, t)_, the bioclimatic variables _BIO..(x, y, t)_ and the habitat variables _CLC...(x, y, t)_ in two formats for easy use:
* Matlab data files
* Shape files

These files provide all the explicative variables on the map of France to produce the ecological niche modelling.

# Some programmes for handling datasets
Programmes in Matlab, Python, and R for easy use
