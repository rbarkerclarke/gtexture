#' GLCM Metrics
#' @param glcm A normalized co-occurrence matrix as generated by previous
#' @param k summation equal to k 
#' @export
#' @name glcm_metrics

#### All GLCM functions are applied to normalised co-occurrence matrices
# These are square matrices of size n_levels x n_levels
# where n_levels is the number of discretized fitness levels
# To generate a random co-occurrence matrix in a system with 3 levels
# x = matrix(sample.int(9, size = 9, replace = TRUE), ncol = 3)
# x = x / sum

#### Sum over
#Sum each element where the indices of the matrix sum to k

xplusy_k <- function(glcm, k){
  sum <- 0
  map <- as.numeric(colnames(glcm))
  for(value in map){
    target <- k - value
    #check if target in map
    targetInMap <- which(map == target)
    if( length(targetInMap > 0) ) 
      sum <- sum + glcm[targetInMap, which(map == value)]
    #Stop early to avoid checking values which
    #are larger than k (i.e. could never sum to k)
    if(value > k) break
  }
  sum
  }


xminusy_k <- function(glcm, k){
  #Sum each element where the indices of the matrix sum to k
  sum <- 0
  map <- as.numeric(colnames(glcm))
  for(value in map){
    target <- k + value
    #check if target in map
    targetInMap <- which(map == target)
    if( length(targetInMap > 0) ) sum <- sum + glcm[targetInMap, which(map == value)]
  }

  #This ensures that values on both sides of the symmetrical matrix are accounted for
  #if k = 0 it's only values along the main diagonal, and thus doesn't need doubling
  if(k == 0){ return(sum) }
  return(sum*2)
}


p_xsuby.matrix <- function(glcm) {
  nlevels=dim(glcm)[1]
  #p_k=c()
  p_k = rep(0, nlevels)
  for (i in 1:nlevels){
    for (j in 1:nlevels){
      k = abs(i-j)
      p_k[k+1] = p_k[k+1] + glcm[i,j]
    }
  }
  return(p_k)
}

### Matrix PXSubY
#' @describeIn glcm_metrics psubxy
#' @noRd
#' @param x landscape
p_xsuby.FitLandDF <- function(x) {
  nlevels=dim(x)[1]
  #p_k=c()
  p_k = rep(0, nlevels)
  for (i in 1:nlevels){
    for (j in 1:nlevels){
      k = abs(i-j)
      p_k[k+1] = p_k[k+1] + x[i,j]
    }
  }
  return(p_k)
}

### FitLand PXPlusY
#' @describeIn glcm_metrics plusxy
#' @noRd
#' @param x matrix 
p_xplusy.matrix <- function(x) {
  nlevels=dim(x)[1]
  #p_k=c()
  p_k = rep(0, 2*nlevels)
  for (i in 1:nlevels){
    for (j in 1:nlevels){
      k = i+j
      p_k[k] = p_k[k] + x[i,j]
    }
  }
  return(p_k)
}

### FitLand PXPlusY
#' @describeIn glcm_metrics plusxy landscape
#' @noRd
#' @param x landscape 
p_xplusy.FitLandDF <- function(x) {
    nlevels=dim(x)[1]
    #p_k=c()
    p_k = rep(0, 2*nlevels)
    for (i in 1:nlevels){
      for (j in 1:nlevels){
        k = i+j
        p_k[k] = p_k[k] + x[i,j]
      }
    }
    return(p_k)
}

#' @describeIn glcm_metrics Mean
#' @noRd
glcm_mean <- function(glcm){
  #Mean for symmetric glcm
  return(sum(seq(1,dim(glcm)[1]) * colSums(glcm)))
}


#' @describeIn glcm_metrics Mean.df
#' @noRd
glcm_mean.df <- function(glcm){
  #see http://www.fp.ucalgary.ca/mhallbey/ans_ex_12.htm
  return(sum(as.numeric(colnames(glcm)) * colSums(glcm)))
}


#' @describeIn glcm_metrics Mean.matrix
#' @noRd
glcm_mean.matrix <- function(glcm){
  return(sum(seq(1,dim(glcm)[1]) * colSums(glcm)))
}


#' @describeIn glcm_metrics mu_x
#' @noRd
mu_x.matrix <- function(glcm){
  return(sum(seq(1,dim(glcm)[1]) * colSums(glcm)))
}

#' @describeIn glcm_metrics mu_y
#' @noRd
mu_y.matrix <- function(glcm){
  return(sum(seq(1,dim(glcm)[1]) * rowSums(glcm)))
}

#### Variance #####
# Variance of gray-level differences
#' @describeIn glcm_metrics Variance
#'@param glcm gray level co-occurrence matrix 
glcm_variance <- function(glcm){
  sum <- 0
  mean <- glcm_mean(glcm)
  for(i in 1:nrow(glcm)){
    for(j in 1:ncol(glcm)){
      sum <- sum + ((((i-1) - mean)^2) * glcm[i,j])
    }
  }
  return(sum)
}


#### SUM AVERAGE #####
# Sum average is the mean value of the sum in marginal distribution px+y
#' @describeIn glcm_metrics Sum Average
#' @noRd
#' @param x landscape
sum_avg.FitLandDF <- function(x) {
  p_xplusy = p_xplusy.FitLandDF(x)[-1]
  nlevels=dim(x)[1]
  i = 2:(2*nlevels)
  sum_avg = i * p_xplusy
  return(sum(sum_avg))
}

#### SUM ENTROPY #####
# Sum entropy is the entropy of marginal distribution px+y
#' @describeIn glcm_metrics Sum Entropy
#' @param x gray level co-occurrence matrix 
#' @noRd
sum_entropy.matrix<- function(x) {
  xplusy = p_xplusy.matrix(x)[-1] #Starts at index 2
  sum_entropy = - xplusy * log (xplusy)
  return(sum(sum_entropy, na.rm=TRUE))
}

### SumEntropyLandscape
#' @describeIn glcm_metrics landscape SumEntropyLandscape
#' @noRd
#' @param x landscape 
# Sum entropy is the entropy of marginal distribution px+y
sum_entropy.FitLandDF <- function(x) {
  xplusy = p_xplusy.FitLandDF(x)[-1] #Starts at index 2
  sum_entropy = - xplusy * log (xplusy)
  return(sum(sum_entropy, na.rm=TRUE))
}

#### DIFFERENCE ENTROPY #####
# Difference entropy is the entropy of marginal distribution px-y
#' @describeIn glcm_metrics Difference Entropy
#' @param base Base of the logarithm in differenceEntropy.
#' @noRd
differenceEntropy.matrix <- function(glcm, base=2){
  sum <- 0
  for(i in 1:(nrow(glcm)-1)){
    pxy <- xminusy_k(glcm, i-1)
    sum <- sum + ifelse(pxy > 0, pxy*logb(pxy,base=base),0)
  }
  return(-1*sum)
}

#### DISSIMILARITY #####
# Dissimilarity is the weighted sum of gray-level differences
#' @describeIn glcm_metrics Dissimilarity
#' @noRd
dissimilarity.matrix <- function(glcm){
  sum <- 0
  for(i in 1:nrow(glcm)){
    for(j in 1:ncol(glcm)){
      sum <- sum + (abs(i - j))*glcm[i,j]
    }
  }
  return(sum)
}
