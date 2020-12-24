# setwd(dirname(rstudioapi::isAvailable()::getActiveDocumentContext()$path))
source("R/helperMethods.R")
library(lubridate)

#' @export smartSaveCSV
#' @import lubridate
#' @importFrom utils read.csv write.csv

getWindPenetration <- function(df) {
  df %>% dplyr::filter(variable %in% c("wind_pen_actual", "wind_pen_STF", "wind_pen_MTF"))


}

createBlankCSV <- function(name){
  file.create(name)

}



smartSaveCSV <- function(df,csvfile,valuecol) {
  existingdf <- read.csv(path)
  existingdf[[dateColName]] <- ymd_hms(existingdf[[dateColName]])
  existingdf$ModifiedAt <- ymd_hms(existingdf$ModifiedAt)
  colheader<- colnames(df)
  colheader <- colheader[!colheader %in% valuecol]

  newdf <- rbind(existingdf,df) %>%
    arrange(desc(ModifiedAt))

 df2 <- newdf[!duplicated(newdf[,distinctcols]),] %>%
    write.csv(path,row.names = FALSE)

}

df <- getForecastVsActual() %>%
  getWindPenetration()

dateColName <- "Interval"
df[[dateColName]] <- ymd_hms(df[[dateColName]])
df$ModifiedAt <- Sys.time()
df$ModifiedAt <- ymd_hms(df$ModifiedAt)

month_year <- format(as.Date(Sys.Date()), "%m_%Y")
name <- paste("Wpen_Forecast_Vs_Actual_",month_year,".csv",sep="")

day_of_the_month <- format(as.Date(Sys.Date()), "%d")
path <- paste("Data/",name,sep="")
if(day_of_the_month ==1){

  createBlankCSV(path)
  write.csv(df,path,row.names = FALSE)
}
# rm(list = c("combine_df_Columns", "format_DateTime", "getForecastVsActual", "getGenMix"))


smartSaveCSV(df,path,"value")

