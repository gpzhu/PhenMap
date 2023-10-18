#' Mapping emergence date of insect after overwintering
#' @import raster terra rgdal
#' @param tasmax stack raster of grid daily maximum temperature, SpatRaster object (1-365 days basis)
#' @param tasmin stack raster of grid daily minimum temperature, SpatRaster object (1-365 days basis)
#' @param DVD0 basal temperature/low threshold development temperature, based on which insect start to develop
#' @param GDD growing degree days of egg to adult

emerg<-function(DVD0=NULL, GDD=NULL, tasmax, tasmin){

  nn<-seq(1,365,1)
  names(tasmax)<-nn
  names(tasmin)<-nn

  tasmax<-as(tasmax, "Raster")
  tasmin<-as(tasmin, "Raster")

  tasmax1<-rasterToPoints(tasmax)
  tasmin1<-rasterToPoints(tasmin)

  mm1<-tasmax1[,1:3]
  colnames(mm1)<-c("long","lat","date")

  mm1<-as.data.frame(mm1)
  mm1[,3]<-NA

  tasmax1<-as.data.frame(tasmax1)
  tasmin1<-as.data.frame(tasmin1)

  tt<-tasmax1[,c(-1,-2)]
  tt[,]=0
  tt<-cbind(tasmax1[,1:2],tt)


  for (i in 1:dim(tasmin1)[1]){
    for(j in 3: 367){
      if ((tasmax1[i,j]>DVD0) & (tasmin1[i,j]<=40)){
        if (tasmin1[i,j]>=DVD0){tt[i,j]<-((tasmax1[i,j]+tasmin1[i,j])/2-DVD0)}
        if (tasmin1[i,j]< DVD0){tt[i,j]<-((tasmax1[i,j]+DVD0)/2-DVD0)}
      } else {tt[i,j]<-0}
    }
  }

  for (i in 1:dim(tt)[1]){
    for(j in 3:367){
      aa<- sum(tt[i,3:j])
      if (aa>=GDD) {
        mm1[i,3]=colnames(tt)[j]
        break}
    }
  }

  mm1$date1<-substring(mm1[,3],2)
  mm1<-mm1[,-3]
  mm1$date1<-as.numeric(mm1$date1)

  rst <- rasterFromXYZ(mm1)
  crs(rst)<- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


  return(rst)
}
