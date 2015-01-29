###############################################################################
#####                                                                     #####
#####  Please consult README.txt file before continuing with this script  #####
#####                                                                     #####
###############################################################################

# This script outlines the functions used simulate diversity patterns with known
# underlying mechanisms 

# set working directory
setwd("C:/ADD YOUR OWN WORKING DIRECTORY")
install.packages("vegan") # install the vegan package for calculating the dipersion field heterogeneity
library(vegan)

#--------------------------------------------------------------------------------
# 1) Open all the required datasets
#--------------------------------------------------------------------------------

# open the envirnmental data
environ <- read.table("Environmental_data.txt",header=TRUE)

# geographic coordinates
coord <- as.data.frame(cbind (environ$X,environ$Y))
plot(coord)

# import mammal presence-absence community matrix (sites in rows, species in columns)
comm <- read.table("Mammal_data.txt", header=TRUE, row.names= 1, sep="\t", na.strings="NA", dec=".", strip.white=TRUE)

################################################################################
################################################################################

#--------------------------------------------------------------------------------
# 2) Determine the climate suitability using GLM
#--------------------------------------------------------------------------------

env.prob <- matrix(NA, nrow = dim(comm)[1],ncol = dim(comm)[2])

# This is to create a matrix of coefficients
# This matrix is not used in subsequence commands, but it is a handy tool to
# assess the response betweenn species presence/absence and predictor variables.
env.coef <- matrix(NA, nrow = dim(comm)[2],ncol = 8)
colnames(env.coef) <- c("Intercept", "BIO_1", "BIO_4", "BIO_12", "BIO_15", "PET", "AI", "NPP")

for (i in 1: dim(comm)[2]) {
  sp.glm <- glm(comm[,i] ~ BIO_1 + BIO_4 + BIO_12 + BIO_15 + PET + AI+ NPP, data = environ, family = binomial)
  env.prob[,i] <- fitted.values(sp.glm) + 1e-16  # add a tiny number to ensure that every quadrates as a non-zero chance of being colonised
  env.coef[i,] <- as.vector(sp.glm$coef)
}

#--------------------------------------------------------------------------------
# 3) Simulation models
#--------------------------------------------------------------------------------

range.size <- colSums(comm)   # create a vector of empirical range sizes (occupancy)
sp <- dim(comm)[2]  # number of species
site <- dim(comm)[1] # number of sites


################################################################################

# Scatter Model
scat.com <- matrix (0,nrow=site,ncol=sp)

for (k in 1:sp) {
  abund <- rep(c(0,1),c((site-range.size[k]),range.size[k]))
  scat.com[,k] <- sample(abund,site,replace=FALSE)
  scat.com
}

# Write scatter community as .txt file.
write.table(scat.com,"Scatter_model.txt",quote=F,row.names=F,sep="\t")

################################################################################

# Pure Climate Model
clim.com <- matrix (0,nrow=site,ncol=sp)

for (k in 1:sp) {
  suit <- env.prob[,k]
  site.id <- rep(NA,site)
  site.code <- 1:site
  site.id <- sample(site.code,range.size[k],replace=F,prob=c(suit))
  clim.com[c(site.id),k] <- 1
  clim.com
}

# Write scatter community as .txt file
write.table(clim.com,"Env_model.txt",quote=F,row.names=F,sep="\t")

################################################################################

# Random Spreading Dye
cells <- 1:site
# The flowwing lines create a neighbourhood matrix for each quadrat
neigh <- as.matrix(dist(coord,diag=T,upper=T))
neigh[neigh > 100] <- 0
neigh[neigh == 100] <- 1

# Seelct the starting point of range expansion randomly
start.cell <- sample(cells,sp,replace=T)

Dye.com <- matrix (0,nrow=site,ncol=sp)

for (i in 1:sp){
  Dye.com[start.cell[i],i] <- 1  #set seed cell to 1
  new.id1 <- sample(cells,1,prob=neigh[,start.cell[i]]) #sample from neighbourhood matrix 
  Dye.com[new.id1, i] <- 1

    for (l in 1:range.size[i]){
      # This updates the neighbourhood matrix as the range expands
      ID <- which(Dye.com[,i] > 0)
      prob.t2 <- apply((neigh[,c(ID)]),1,sum)
      prob.t2[c(ID)] <- 0
      new.id2 <- sample(cells,1,prob=prob.t2)
      Dye.com[new.id2,i] <- 1
    }
}

# Write Spreading dye community as .txt file
write.table(Dye.com,"Spreading_dye.txt",quote=F,row.names=F,sep="\t")

################################################################################

# Range Position Spreading Dye (This identical to the spreading dye, except for 
# the change in selecting the starting quadrat) 
cells <- 1:2175
neigh <- as.matrix(dist(coord,diag=T,upper=T))
neigh[neigh > 100] <- 0
neigh[neigh == 100] <- 1

# Start cell is selected from within the empirical range
start.cell <- rep(NA,sp)
for (j in 1:sp){
start.cell[j] <- sample(cells,1,replace=T, prob = c(comm[,j]))
}

RPdye.com <- matrix (0,nrow=sp,ncol=2175)

for (i in 1:sp){
  RPdye.com[i,start.cell[i]] <- 1  #set seed cell to 1
  new.id1 <- sample(cells,1,prob=neigh[,start.cell[i]])
  RPdye.com[i,new.id1] <- 1

  for (l in 1:range.size[i]){
    ID <- which(RPdye.com[i,] > 0)
    prob.t2 <- apply((neigh[,c(ID)]),1,sum)
    prob.t2[c(ID)] <- 0
    new.id2 <- sample(cells,1,prob=prob.t2)
    RPdye.com[i,new.id2] <- 1
  }
}

# Write Range position community as .txt file
write.table(RPdye.com,"Range_position.txt",quote=F,row.names=F,sep="\t")


################################################################################

# Spatial-Climate model (+ Range position)
cells <- 1:site
neigh <- as.matrix(dist(coord,diag=T,upper=T))
neigh[neigh > 100] <- 0
neigh[neigh == 100] <- 1

# Start cell is selected from within the empirical range
start.cell <- rep(NA,sp)
for (j in 1:sp){
start.cell[j] <- sample(cells,1,replace=T, prob = c(comm[,j]))
}

envdye.com <- matrix (0,nrow=site,ncol=sp)

for (i in 1:sp){
  envdye.com[start.cell[i],i] <- 1  #set seed cell to 1
  new.id1 <- sample(cells,1,prob=neigh[,start.cell[i]])
  envdye.com[new.id1,i] <- 1

  for (l in 1:range.size[i]){
    ID <- which(envdye.com[,i] > 0)
    prob.t2 <- apply((neigh[,c(ID)]),1,sum)
    prob.t2[c(ID)]<- 0
    # Here the environmental conditions are added to change the probability of range expansion
    prob.t2 <- prob.t2 * env.prob[,i]
    new.id2 <- sample(cells,1,prob=prob.t2)
    envdye.com[new.id2,i] <- 1
  }
}

# Write Spatial-Climate community as .txt file
write.table(envdye.com,"Spatal_climate.txt",quote=F,row.names=F,sep="\t")

################################################################################