________________________________________________
________________________________________________

This README file is made up of 4 components:

	1. Introduction
	2. Overview of folder structure
	3. Overview of data files
	4. Overview of R command scripts 

Author: Falko Buschke (falko.buschke@gmail.com)
23 January 2015
_______________________________________________
________________________________________________

1. Introduction

This archive contains the data and R scripts used for the following study:
	
Buschke, F.T., Brendonck, L. & Vanschoenwinkel (unpublished). Simple mechanistic models can partially explain local but not range-wide co-occurrence of African mammals.

A written description of the research methodology can be obtained from the manuscript.

Any comments or inquiries can be directed to the lead author, Falko Buschke (falko.buschke@gmail.com)

While the data and code have been thoroughly tested, we acknowledge that it is by no means perfect. The contents of these files were last verified on 23 January 2015.

These files contain pseudo-code in that they are annotated and complete to the extent that they can be used to replicate the results of the aforementioned study. However, they are incomplete in the sense that they cannot recreate the research outputs 100% in their unmodified form. For instance, the simulations were replicated in the study, yet the code does not include this.  Similarly, the code used for the statistical analysis only demonstrates the procedures for examining one combination of biodiversity pattern and simulated mechanistic model output (the other combinations should be tested manually).

The reason for using pseudo-code is the computationally-intensive nature of this research procedure. 
The computations presented in this study were carried out over several hundred hours on a virtual Amazon Machine Image (AMI) using RStudio version #0.98.1091, running R version 3.1.2 on Ubuntu 14.04 Long-term Support (LTS). Running the complete code on the average personal computer is not advised.

______________________________________________

2. Overview of folder structure

Once unzipped, the .zip archive - 'Code and data.zip' - contains one folder (Code and data) and one sub-folder (Shapefiles).

Unless specified otherwise, all the files are located within the parent directory (Code and data).

The sub-folder (Shapefiles) contains the spatial data used to visualise the research results (see Figures 2 and 4 in the manuscript).
______________________________________________

3. Overview of data files

The main directory contains 3 data files in .txt format: 
	- Environmental_data.txt
	- Mammal_data.txt
	- Summarised_model_output

As well as one sub-folder:
	- Shapefiles

	
	3.1. Environmental_data.txt

This file contains the environmental characteristics of each of the 2335 quadrats examined in this study. The dataset is made up of 11 columns and 2335 rows (one for each quadrat). The 11 columns represent the following variables:

	3.1.1. FID: This is the Field Identification number for the quadrat. Note that numbering starts at 0 and ends at 2334.

	3.1.2. AI: This represents the aridity index, which is the ratio between mean annual precipitation and potential evapotranspiration.

	3.1.3. BIO_1: This is the annual mean temperature measured in 1/10th of Degree Celsius (e.g. BIO_1 = 276; 27.6 Degrees Celcius). 

	3.1.4. BIO_12: This is the mean annual precipitation in mm. 

	3.1.5. BIO_15: This is precipitation seasonality, which is the coefficient of variation of monthly precipitation.

	3.1.6. BIO_4: This is temperature seasonality, which is the standard deviation of monthly temperature. The four bioclimatic variables (BIO_1, BIO_4, BIO_12, BIO_15) are all from:

	Hijmans, R.J., Cameron, S.E., Parra, J.L., Jones, P.G. & Jarvis, A. (2005) Very high resolution interpolated climate surfaces for global land areas. International Journal of Climatology, 25, 1965-1978.

	3.1.7. NPP: This variable is net primary productivity measured in grams of carbon per year. These data are from:

	Imhoff, M.L. Bounoua, L., Ricketts, T., Loucks, C., Harriss, R. & Lawrence, W.T. (2004) Global patterns in human consumption of net primary production. Nature, 429, 870-873.

	3.1.8. PET: These data are Potential Evopotranspitation, which is an estimate of the atmosphere's ability to remove water through evaporation and transpiration. These data are from:

	Trabucco, A. & Zomer, R.J. (2009) Global aridity Index (Global-aridity) and global potential evapo-transpiration (Global-PET) geospatial dataset. CGIAR Consortium for Spatial Information. Available from: CGIAR-CSI GeoPortal http://www.csi.cgiar.org (last accessed: 8 March 2012).

	3.1.9. Y: This is the latitude (in meters) of the centroids of each quadrat.

	3.1.10. X: This is the longitude (in meters) of the centroids of each quadrat.

	3.1.11. Dist_km: This variable is the distance (in kilometers) from the centroid of each quadrat to the nearest interface between biogeographical regions.

	
	3.2. Mammal_data.txt

This dataset contains the community matrix for mammals in sub-Saharan Africa, with species as columns and quadrats as rows.

There are data for 1014 species, which are labelled by their scientific binomial (Species + genus) and ordered alphabetically.

The data for 2335 quadrats are included (note that labelling begins at 0 and ends at 2334). The ID numbers of these quadrates are included in the first column.

Each combination of site and species contains a 0 if the species is absent from that quadrat and a 1 if it is present. There are, in total, 2 367 690 entries of which 207 790 indicate presence (1) and 2 159 900 indicate absence (0).

	
	3.3. Summarised_model_output.txt

This file contains the summarised values of species richness, dispersion field volume and dispersion field heterogeneity for the empirical data and 5 simulated data sets. It is made up of 2335 rows (one for each quadrat) and 18 columns.

The column name are made up of 3 parts (2 in the case of observed data; the last 3 columns). 

The first part represents the name of the dataset:
	- Scat: Scatter model
	- env: Climate model ('env' is a abbreviation of environmental)
	- sd: Spreading Dye model
	- rp: Range position model
	- full: Spatial-climate model ('full' denotes that all the constraints were used in the simulations)

The second part of the name represents the diversity pattern:
	- rich: Species richness
	- vol: Dispersion field volume
	- het: Dispersion field heterogeneity

The final part of the name represents whether the variable is an average of multiple replicates. This is denoted by the letter 'm' (for mean). The empirical data do not have this last part as they are not averaged values and only represent the single observed value for each quadrat.
	
	Example: env.het.m = The averaged dispersion field heterogeneity of the Climate model.


	3.4. Subfolder: Shapefiles:

This sub-directory contains three vector-based ESRI shapefiles. Each shapefile is made up of the same 7 standard sub-files for projection format (.prj), attribute format (.dbf), spatial index format (.sbn and .sbx), shape index format (.shx) and geospatial metadata (.xml).

The following three shapefiles are in the folder:
	
	3.4.1. Africa_100km: This shapefile is the grid of 2335 sampling quadrates.
	
	3.4.2. Africa_outline: This is the coastline of sub-Saharan Africa
	
	3.4.3. Intefaces_mammals: This is the geographic location of the interfaces between the biogeographical regions identified for mammals by:
	
	Linder, H.P., de Klerk, H.M., Born, J., Burgess, N.D., Fjeldså, J. & Rahbek, C. (2012) The partitioning of Africa: statistically defined biogeographical regions in sub-Saharan Africa. Journal of Biogeography, 39, 1189-1205.

______________________________________________

4. Overview of R command scripts 

There are four fully-annotated files of R command scripts in the .r format (these can be opened with any text editor). 

These are:
	- Mechanistic_model_simulations.r
	- Dispersion_field_metrics.r
	- Regression_analyses.r
	- GIS_maps.r
	- Appendix_S1.r

In order for these command scripts to work, it is important that the data files (Section 3) are all in the same folder (the GIS shapefiles should be in a sub-folder: 'Shapefiles'). Then, in each of the scripts, it is essential that the working director be defined explicitly (unless you re useing the default directory, in which case you must delete the command line that defines the working directory). 


	4.1. Mechanistic_model.simulations.r

This contains all the code required to simulate the mechanistic models used in the study. Note, however, that this script only creates a single replicate of each model and saves the resulting community matrix 
(with the same dimensions as the empirical community matrix: Section 3.2). 

In order to fully emulate our study, it is necessary to simulate multiple replicates of each type of the model.

*** Warning: The models with spatial constraints require a lot of time to run completely!


	4.2. Dispersion_field_metrics.r

This script imports a community matrix (whether empirical or simulated using the simulation script described in Section 4.1) and calculates the species richness, dispersion field volume and dispersion field heterogeneity. It combines the values for these three diversity patterns into a single data frame and writes this output to a .txt file.

It is important that these metrics are calculate separately for each mechanistic model as well as for each replicate run of a model. The three diversity patterns should then be summarised into a single averaged value for the replicates (as demonstrated in the data output described in Section 3.3).

*** Warning: Calculating dispersion field heterogeneity is a computationally intensive procedure, which require multiple randomisations!


	4.3. Regression_analyses.r

This script is to recreate the results displayed in Tables 2 and 3. It also contains the plotting command used to create the scatter plots shown in Figure 3.

For Table 2, the script performs a ordinary least squares (OLS) regression, a unity line regression and a simultaneous autoregression (SAR) with a spatial error model category. The code for the latter analyses is largely based on the supplementary appendix of:

	Kissling, W.D. & Carl, G. (2008) Spatial autocorrelation and the selection of simultaneous autoregressive models. Global Ecology and Biogeography, 17, 59-71.

For Table 3, the commands performs a basic Spearman correlation, but corrects for spatial autocorrelation by assessing significance after estimating the effective degrees of freedom. This is based on themethodology by:

	Clifford, P., Richardson, S. & Hémon, D. (1989) Assessing the significance of the correlation between two spatial processes. Biometrics, 45, 123-134.
 

	4.4. GIS_maps.r

This script can be used to visualise the outputs geographically using Geographic Information Systems (GIS) integrated in R. The basic plotting commands are uncomplicated, but this script includes the command necessary for defining meaningful colour ramps.

For Figure 2, the colour ramps on the maps are based on equal quantile intervals for the empirical data.

For Figure 4, the colour ramp is based on equal interval of the difference between empirical and simulated data. This script also includes the command to plot a colour-coordinated histogram to match the  colouring of the maps. 

	
	4.5. Appendix_S1.r

This final script recreates the demonstrative model used to illustrate how dispersion field heterogeneity is related to competitive, random and mutualistic associations between species for different levels of species richness and occupancy. The details of this simulation are provided in Apendix S1 of the main manuscript.

This code recreates one of the panels from Figure S1. To create the other panels, the user must change the numebr of species and levels of occupancy at the beginning of the script.


-----------------------------------------------------------------------------------
