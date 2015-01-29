###############################################################################
#####                                                                     #####
#####  Please consult README.txt file before continuing with this script  #####
#####                                                                     #####
###############################################################################

# This script outlines the functions used to calculate species richness,
# dispersion field volume and dispersion field heterogeneity. It assumes that 
# communtiy data has already been simulated. 


# set working directory
setwd("C:/ADD YOUR OWN WORKING DIRECTORY")
install.packages("vegan") # install the vegan package for calculating the dipersion field heterogeneity
library(vegan)

#--------------------------------------------------------------------------------
# 1) Open all the required datasets
#--------------------------------------------------------------------------------

# open the envirnmental data for plotting dipersion field
environ <- read.table("Environmental_data.txt",header=TRUE)

# extract geographic coordinates
coord <- as.data.frame(cbind (environ$X,environ$Y))
plot(coord)

# import empirical or simulated presence-absence community matrix (sites in rows, species in columns)
comm <- read.table("Mammal_data.txt", header=TRUE, row.names= 1, sep="\t", na.strings="NA", dec=".", strip.white=TRUE)
# The calculate dispersion field metrics for simulated data, run the code to simulated mechanistic model,
# write the simulated data to a text file, which should be imported here instead of the "Mammal_data.txt" file. 


################################################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 2) Calculate all the metrics for imported community data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# === 2.1 === Calculate species richness by summing the community data over rows
richness <- rowSums(comm)


# === 2.2 ===  Calculate the dispersion field volume.
vol <- rep(NA,dim(comm)[1])

for (k in 1:dim(comm)[1]) {
  loc.species <- as.matrix(comm[,which(comm[k,] == 1)])
    if (dim(loc.species)[2]>1){
      species.height <- rowSums(loc.species)
      vol[k] <- (sum(species.height))/(max(species.height))
      vol
    } else {
      vol[k] <- length(which(rowSums(loc.species)>0))
    }
  # The following snippet of code is to visualise the dispersion field,
  # it is not essential for calculating the metrics, but it is handy for
  # understanding the concept of the dispersion field   
  color.ramp <- topo.colors(max(species.height)+1)
  plot(coord,pch=15,col=color.ramp[species.height+1])
  points(coord[k,],col="red",pch=16)
}


# === 2.3 === Calculate the dispersion field heterogeneity
RSP <- rep(NA,dim(comm)[1])

# Only calculate this metric for species with occupancy levels greater than 
# 5 quadrats. Similarity indices tend to show unpredicatable behavious when 
# occupancy levels are too low (see Chase et al. 2011 for further explanation)
ran.com1 <- comm[,which(colSums(comm) > 5)] 

# This calculates a species-by-species pair-wise similarity matrix for all species 
# across the whole of Africa. If the extent of the dispersion field for a particular 
# quadrat also covers the entire extent of the continent, then it is computationally 
# faster to sample the relevent species from this gloabal pair-wise matrix, instead
# of calculating a new similarity matrix for that quadrat (the outcome should qualitatively  
# be the same, but their might be slight differences to to the randomisation procedure.   
RC.full  <- raupcrick(t(ran.com1), null = "r1", nsimul = 99, chase = FALSE)
# Use '?raupcrick' to access the help files for raupcrick function in vegan package

for (k in 1:dim(comm)[1]) {
  # Get the list of species in the focal quadrate
  ran.loc <- ran.com1[,which(ran.com1[k,] ==1)] 
  # Get the spatial extent of ADF
  ran.loc2 <- ran.loc[which(rowSums(ran.loc)>0),] 
  rm(ran.loc)
  # If the extent of the dispersion field is the whole continent, sample from the
  # global pair-wise similarit matrix. If not, calculate a new pairwise matrix for
  # the quadrate, 
    if(dim(ran.loc2)[1]==site) {
      GROUP <- ifelse(ran.com1[k,] == 1,1,2)
      disper <- betadisper(RC.full,GROUP) # use '?betadisper' to access the 
      # help files for beatdisper function in vegan package
      RSP [k] <- mean(disper$distances[which(disper$group==1)])
    } else {
      GROUP <- rep(1,dim(ran.loc2)[2])
      ran.dist <- raupcrick(t(ran.loc2), null = "r1", nsimul = 99, chase = FALSE)
      disper <- betadisper(ran.dist,GROUP)
      RSP [k] <- mean(disper$distances)
    }
  # This snippet of code is just to show the progress of the function (it reports
  # after the dispersion field heterogeneity has been calculated for every 50 quadrates
  if (k/50 == floor(k/50))
    {print(k)
    flush.console()} 
}


# === 2.4 === Combine metrics into data frame and export as .txt file.
Output <- cbind(richness,vol, RSP)
write.table(Output,"DF_stats.txt",quote=F,row.names=F,sep="\t")
################################################################################