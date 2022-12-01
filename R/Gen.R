#' Mapping number of generation based on basal temperature and growing degree days
#' @import raster
#' @param stk stack raster of grid daily mean temperature for a specific year
#' @param DVD0 basal temperature/low threshold development temperature, based on which insect start to develop
#' @param GDD growing degree days of egg to adult
#'
Gen<-function(DVD0=NULL, GDD=NULL, stk){

  for (i in 1:nlayers(stk)){
    ss1 <- stk[[i]]-DVD0
    ss1[ss1 < 0] <- 0
    stk[[i]]<-ss1
  }

  dd<-sum(stk)/GDD

  return(dd)
}
