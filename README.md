# This is the Yellowhammer benchmark

PLEASE NOTE: this benchmark is currently under development. Please feel free to reload the data to get the latest version.

## Complete dataset

You have access to a CSV file, [Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv.zip), containing 22,641 counting data entries with the year of observation, location, climatic, bioclimatic and habitat variables.

The complete dataset is used to produce the final estimated model.

## 70/30 test dataset
The 70/30 test dataset consists of 70% of the data for estimation and 30% for validation. You have access to two CSV files, [Data_Estimation_70.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Estimation_70_V1.csv.zip) and [Data_Validation_30.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Validation_30_V1.csv.zip), containing rows from 100 random 70/30 draws from the complete data table.

## Prediction test dataset
The prediction test dataset splits the data into two parts, with the first 19 years for estimation and the last 5 years for validation. Actually, You have access to a CSV file, [Data_Estimation_2001_2019.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Estimation_2001_2019.csv.zip), containing data from the first 19 years for estimation. Validation performance is derived from the complete dataset, taking into account only the last five years.

## Explicative variables
The climatic variables _prec(x, y, t)_, _tmax(x, y, t)_ and _tmin(x, y, t)_, the bioclimatic variables _BIO..(x, y, t)_ and the habitat variables _CLC...(x, y, t)_ in two formats for easy use:

- Matlab data files
- Shape files

These files provide all the explicative variables on the map of France to produce the ecological niche modelling.

Link to download files: [explicative_variables.zip](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/explicative_variables.zip)

## Some programmes for handling datasets

Programmes in Matlab, Python, and R for easy use

## License

Yellowhammer benchmark is released under the MIT License. See [LICENSE](LICENSE) for more information.

## Contributors

- [Régis OUVRARD](https://www.lias-lab.fr/members/regisouvrard/), LIAS, University of Poitiers, France
- [Thierry POINOT](https://www.lias-lab.fr/members/thierrypoinot/), LIAS, University of Poitiers, France
