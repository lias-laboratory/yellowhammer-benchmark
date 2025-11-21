# The Yellowhammer benchmark

PLEASE NOTE: this benchmark is currently under development. Please feel free to reload the data to get the latest version.

Abstract: We believe that system identification has strong potential to provide support for decision-making tools in the fight against biodiversity loss. To stimulate collaboration between the System Identification, Ecological Modelling, and Biostatistics communities, we propose to provide ready-to-use data with ‘long’ series and dynamics in time and space, and to mobilise a group of researchers from these communities. As a foundation for this collaboration, we are making available a benchmark dataset focused on a bird species whose population is affected by agricultural practices and climate change, a real dataset provided by the national French Breeding Bird Survey (Jiguet et al., 2012). To address this issue, biostatisticians employ statistical models (e.g., GLM or GAM), deterministic models (ODE, PDE) or machine learning methods (MaxEnt, Random Forest). If you work with these tools, biostatisticians, ecologists or specialists in data-driven modelling, we invite you to test your models and methodologies on this dataset, and contribute to a better understanding of how global change affects wildlife populations. The medium-term objectives are to understand the issues involved in ecological modelling, share tools and methodologies, compare models and algorithms on the same dataset, and provide new tools to decision-makers so that they can take biodiversity into account in public policy.

Jiguet, F., Devictor, V., Julliard, R., Couvet, D., October 2012. French citizens monitoring ordinary birds provide tools for conservation and ecological sciences. Acta Oecologica 44, 58–66.

## Complete dataset

You have access to a CSV file, [Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv.zip), containing 22,641 counting data entries with the year of observation, location, climatic, bioclimatic and habitat variables.

The complete dataset is used to produce the final estimated model.

## 70/30 test dataset
The 70/30 test dataset consists of 70% of the data for estimation and 30% for validation. You have access to two CSV files, [Data_Estimation_70.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Estimation_70_V1.csv.zip) and [Data_Validation_30.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Validation_30_V1.csv.zip), containing rows from 100 random 70/30 draws from the complete data table.

## Prediction test dataset
The prediction test dataset splits the data into two parts, with the first 19 years for estimation and the last 5 years for validation. Actually, You have access to a CSV file, [Data_Estimation_2002_2019.csv](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/Data_Estimation_2001_2019.csv.zip), containing data from the first 19 years for estimation. Validation performance is derived from the complete dataset, taking into account only the last five years.

## Explicative variables
The climatic variables _prec(x, y, t)_, _tmax(x, y, t)_ and _tmin(x, y, t)_, the bioclimatic variables _BIO..(x, y, t)_ and the habitat variables _CLC...(x, y, t)_ in two formats for easy use:

- Matlab data files
- Shape files

These files provide all the explicative variables on the map of France to produce the ecological niche modelling.

Link to download files: [explicative_variables.zip](https://forge.lias-lab.fr/datasets/yellowhammer-benchmark/explicative_variables.zip)

## Some programs

Under development! 

You have access to some programs in Matlab, Python, and R to facilitate the use and processing of data sets.

## License

Yellowhammer benchmark is released under the MIT License. See [LICENSE](LICENSE) for more information.

## Contributors

- [Régis OUVRARD](https://www.lias-lab.fr/members/regisouvrard/), LIAS, University of Poitiers, France
- [Thierry POINOT](https://www.lias-lab.fr/members/thierrypoinot/), LIAS, University of Poitiers, France
