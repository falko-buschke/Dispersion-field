###############################################################################
#####                                                                     #####
#####  Please consult README.txt file before continuing with this script  #####
#####                                                                     #####
###############################################################################

# This script outlines the functions used create the maps used in Figures 2 and 4
# Using R


# set working directory
setwd("C:/ADD YOUR OWN WORKING DIRECTORY")
install.packages("rgdal") # install the rgdal package for visualising Shapefiles inR
library(rgdal) 

#--------------------------------------------------------------------------------
# 1) Open all the required datasets
#--------------------------------------------------------------------------------

# This opens the summarised outputs for the dispersion field metrics (see README.txt file for details)
output <- read.table("Summarised_model_output.txt",header=TRUE)
attach(output)

# Be sure to have the folder with shapefile in the working directory! 
# All have the same coordinate system. 

# Import vector shapefile of the quadrats
Quadrat <- readOGR("Shapefiles", "Africa_100km")
# Import the vector shapefile of the interfaces between biogeographical regions
Region <- readOGR("Shapefiles", "Interfaces_mammals")
# Import the vector shapefile of the outline of sub-Saharan Africa
Continent <- readOGR("Shapefiles", "Africa_outline")


#--------------------------------------------------------------------------------
# 2) Create the maps used in Figure 2
#--------------------------------------------------------------------------------

bins <- 20 # Number of bins in the colour ramp

# Colour ramp is based on equal quantile intervals of empirical data
Observed <- obs.rich # (Choose between 'obs.rich', 'obs.vol' and 'obs.het' values)

brks <- c(0,as.numeric(quantile (Observed,seq(0,1,by =1/bins))))
grps <-  cut(Observed, breaks = brks, include.lowest = TRUE)
col.ramp <- colorRampPalette(c("yellow","green","darkblue"), interpolate = "linear")(bins+1) 

plot(Quadrat, col=col.ramp[grps],border="transparent")
plot(Region,  border="black",add=T,lwd=1)
plot(Continent,  border="black",add=T,lwd=1)
box()  # add a border around the map

# To plot the data for the simulated data, ensure that you use the same colour-ramp 
# from the observed data

Simulated <- scat.rich.m # (Choose from the various simulated outputs: see README.txt file) 
grps.sim <-  cut(Simulated, breaks = brks, include.lowest = TRUE)

plot(Quadrat, col=col.ramp[grps.sim],border="transparent")
plot(Region,  border="black",add=T,lwd=1)
plot(Continent,  border="black",add=T,lwd=1)
box()  


#--------------------------------------------------------------------------------
# 3) Create the maps used in Figure 3
#--------------------------------------------------------------------------------

bins <- 20 # Number of bins in the colour ramp

# Colour ramp is based on equal intervals of difference between obseved and simulated values
diffr <- obs.rich - scat.rich.m

# The breaks are determined by the typ of metric
    # For richness,  used the interval [-200,200]
    # For dipersion field volume,  used the interval [-700,700]
    # For dispersion field heterogeneity,  used the interval [-0.4,0.4]
brks <-  seq(-200, 200, length.out = bins+1)
grps <-  cut(diffr, breaks = brks, include.lowest = TRUE)
col.ramp <- colorRampPalette(c("blue","white","red"), interpolate =  "linear")(bins)

# This plots the histogram and uses the colour-ramp for the bins 
hist(diffr, breaks = brks, col=col.ramp, main = "", xlab = "Observed-Predicted")

# This plots the maps
plot(Quadrat, col=col.ramp[grps],border="transparent")
plot(Region,  border="black",add=T,lwd=1)
plot(Continent,  border="black",add=T,lwd=1)
box() 

################################################################################