###############################################################################
#####                                                                     #####
#####  Please consult README.txt file before continuing with this script  #####
#####                                                                     #####
###############################################################################

# This script outlines the functions used for the demonstrative simulation 
# used to illustrate how dispersion field heterogeneity is related to 
# competitive, random and mutualistic associations between species 
# for different levels of species richness and occupancy (Appendix S1) 

install.packages("vegan")
library(vegan)

###############################################################################

# Here is were you change the number of species used in the simulations
S <- 10

# Here is were you change the occuancy used in the simulations
# Note: this must be a positive integer smaller than 10
Range.size <- 4

# Here is were you set the number of replicate simulations
Replicates <- 100

###############################################################################

# Create blank vectors for the outcomes of each replicate for the competitive (comp),
# random (rand) annd mutualistic (mut) associations.
RSP.comp <- rep(NA,Replicates)
RSP.rand <- rep(NA,Replicates)
RSP.mut <- rep(NA,Replicates)

###############################################################################

# Start the simulations
for (i in 1:Replicates) {
  
#############################
  # Competition model
  mat <- matrix(0,ncol=10,nrow=S)
  mat[,1] <- 1    # All species present in first quadrat
  mat[1,] <- 1    # Species 1 is present in all 10 quadrats

    for (k in 2:S) {
      id <- 2:10
      rich <- colSums(mat[,2:10])
      like <- rich/(k-1)
      like <- 1/like # Likelihood of colonisation is proportional to inverse richness
      pres.site <- sample(id,(Range.size-1),replace=F,prob= like)
      mat[k,c(pres.site)] <- 1
    }

  # Calculate the dispersion field heterogeneity    
  GROUP <- rep(1,S)
  ran.dist <- raupcrick(mat, null = "r1", nsimul = 99, chase = FALSE)
  disper <- betadisper(ran.dist,GROUP)
  RSP.comp[i]  <- mean(disper$distances)
  
#############################
  # Random model
  mat <- matrix(0,ncol=10,nrow=S)
  mat[,1] <- 1    # All species present in first quadrat
  mat[1,] <- 1    # Species 1 is present in all 10 quadrats
  
    for (k in 2:S) {
      pr.ab <- c(rep(1,(Range.size-1)),rep(0,10-Range.size))
      mat[k,2:10] <- sample(pr.ab,9,replace=F)
    }

  # Calculate the dispersion field heterogeneity    
  GROUP <- rep(1,S)
  ran.dist <- raupcrick(mat, null = "r1", nsimul = 99, chase = FALSE)
  disper <- betadisper(ran.dist,GROUP)
  RSP.rand[i]  <- mean(disper$distances)

#############################
  # Mutualistic model
  mat <- matrix(0,ncol=10,nrow=S)
  mat[,1] <- 1    # All species present in first quadrat
  mat[1,] <- 1    # Species 1 is present in all 10 quadrats

    for (k in 2:S) {
      id <- 2:10
      rich <- colSums(mat[,2:10])
      like <- rich/(k-1) # Likelihood of colonisation is proportional to richness
      pres.site <- sample(id,(Range.size-1),replace=F,prob= like)
      mat[k,c(pres.site)] <- 1
    }
    
  # Calculate the dispersion field heterogeneity    
  GROUP <- rep(1,S)
  ran.dist <- raupcrick(mat, null = "r1", nsimul = 99, chase = FALSE)
  disper <- betadisper(ran.dist,GROUP)
  RSP.mut[i]  <- mean(disper$distances)
}

################################################################################

# Make the plot used in Figure S1

Output <- cbind(RSP.comp,RSP.rand,RSP.mut)
colnames(Output) <- c("Competitive", "Random", "Mutualistic") 
boxplot(Output, ylim=c(0.2,0.6), outline=F, ylab="Dispersion field heterogeneity")

################################################################################