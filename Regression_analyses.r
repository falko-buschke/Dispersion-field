###############################################################################
#####                                                                     #####
#####  Please consult README.txt file before continuing with this script  #####
#####                                                                     #####
###############################################################################

# This script outlines the functions used for the statistical procedures 


# set working directory
setwd("C:/ADD YOUR OWN WORKING DIRECTORY")
install.packages("spdep") # install the spdep package for Spatial regression (Table 2)
install.packages("ncf") # install the ncf package for Spatial regression (Table 2)
install.packages("SpatialPack") # install the SpatialPack package for Spatial correlation (Table 3)
library(spdep)
library(ncf) 
library(SpatialPack)

#--------------------------------------------------------------------------------
# 1) Open all the required datasets
#--------------------------------------------------------------------------------

# open the envirnmental data
environ <- read.table("Environmental_data.txt",header=TRUE)
attach(environ)

# geographic coordinates
coord <- as.data.frame(cbind (environ$X,environ$Y))
plot(coord)

# open simulation outputs
output <- read.table("Summarised_model_output.txt",header=TRUE)
attach(output)

#--------------------------------------------------------------------------------
# 2) Table 2: Regression between observed and predicted values
#--------------------------------------------------------------------------------
# Change this to change which of the observed/simulated heterogeneity metrics are tested
Depend  <- obs.rich   # Dependent variable is the empirical data
Indep <- full.rich.m  # Independent variable is the simulated data

# This creates the panels for Figure 3 (Each panel has to be created manually!)
# Remember to change and axis limits.
    # For richness,  used the interval [0,260]
    # For dipersion field volume,  used the interval [400,1200]
    # For dispersion field heterogeneity,  used the interval [0,0.5]
plot(Depend ~ Indep, xlab = "Predicted value", ylab = "Observed value", col="grey",xlim=c(0,260),ylim=c(0,260))
abline(a=0,b=1,col="red") # Unity line
abline(lm(obs.val~test.val),col="blue")   # OLS regression line


# Manually calculate the R2 value for the Unity line
SS.res <- sum((Depend - Indep)^2)   # Sum of squared residuals
y.mean <- mean(Depend)               # Mean of observed values
SS.tot <- sum((Depend - y.mean)^2)   # Sum of squared differnces from mean
(R2 <- 1 -(SS.res/SS.tot))


#Constructing regression models in R
#-------------------------------------------------------------------------------
# This code is largely based on the code written by W. Daniel Kissling (danielkissling@web.de),
# for contact and further information see also: www.danielkissling.de
#
# For more information, please consult Kissling & Carl (2007)
#
#-------------------------------------------------------------------------------

#----------   Define coordinates, neighbourhoods, and spatial weights ------------#

# Define neighbourhood (here distance 190 km; this ensures that the 8 surrounding quadrates are selected)
nb1.5 <- dnearneigh (as.matrix(coord),0,190)

# Spatial weights, illustrated with coding style "W" (row standardized)
nb1.5.w <- nb2listw(nb1.5, glist=NULL, style="W", zero.policy=FALSE)


#--------------------------  OLS model ----------------------------------------#

# OLS model
ols <- lm(Depend~Indep)
summary(ols)  # Compare this R2 to that of the unity line regression

# Check the spatial autocorrelation of the residuals
res.ols <- residuals(ols)
# Correlogram for OLS model residuals
cor.ols.res <- correlog(X, Y, z=residuals(ols), na.rm=T, increment=1, resamp=1)

# Set plotting options to plot correlogram
par(mar=c(5,5,2,0.1), mfrow=c(1,1))
# Plot correlogram
plot(cor.ols.res$correlation[1:75], type="b", pch=1, cex=1.2, lwd=1.5,
  	ylim=c(-0.5, 1), xlab="Distance class", ylab="Moran's I", cex.lab=1.5, cex.axis=1.2)
abline(h=0)
title(main="OLS residuals", cex=1.5)

#------------------------------ SARerr model ----------------------------------#

#Specify SARerr model
sem.nb1.5.w <- errorsarlm (Depend~Indep, listw=nb1.5.w)
summary(sem.nb1.5.w)

# Check the spatial autocorrelation of the residuals
res.sem.nb1.5.w <- residuals(sem.nb1.5.w)
# Correlogram for SAR regression model
cor.sem.nb1.5.w <- correlog(X, Y, z=residuals(sem.nb1.5.w), na.rm=T, increment=1, resamp=1)

# Set plotting options to plot correlogram
par(mar=c(5,5,2,0.1), mfrow=c(1,1))
# Plot correlogram
plot(cor.sem.nb1.5.w$correlation[1:30], type="b", pch=4, cex=1.2, lwd=1.5,
ylim=c(-0.5, 1), xlab="distance", ylab="Moran's I", cex.lab=1.5, cex.axis=1.2)
abline(h=0)
title(main="Correlogram SARerr", cex=1.5)


#--------------------------------------------------------------------------------
# 3) Table 3: Correlation between Dispersion field heterogeneity and
#             distance to nearest biogeographical interface
#--------------------------------------------------------------------------------

# computing the modified t-test of spatial association

# Change this to change which of the observed/simulated heterogeneity metrics are tested
heterogeneity <- obs.het
    # obs.het = Empirical data; scat.het.m = Scatter model; env.het.m = Environmental model
    # sd.het.m = Spreading dye model; rp.het.m = Range position model; full.het.m = Full model

# The rank transformation ensures that the correlation coefficient is equal to 
# the Spearman coefficient  (as opposed to Pearson's coefficient)

z <- modified.ttest(rank(heterogeneity),rank(Dist_km),coord, nclass=22)
z

################################################################################