#' Production and farm value of maple products in Canada
#'
#' @source Statistics Canada. Table 001-0008 - Production and farm value of
#'  maple products, annual. \url{http://www5.statcan.gc.ca/cansim/}
#' @name smartSaveCSV
#' @param df This is a Data Frame
#' @param path This is the path to the CSV file
#'
#' @format A data frame with columns:
#' \describe{
#'  \item{Year}{A value between 1924 and 2015.}
#'  \item{Syrup}{Maple products expressed as syrup, total in thousands of gallons.}
#'  \item{CAD}{Gross value of maple products in thousands of Canadian dollars.}
#'  \item{Region}{Postal code abbreviation for territory or province.}
#' }
#'
#' @import lubridate
#' @import pracma
#' @importFrom utils read.csv write.csv
library(lubridate)
library(pracma)
#' @export
smartSaveCSV <- function(latestdf, existingdf, pathToSave, valuecol) {

  colheader1 <- colnames(latestdf)
  colheader2 <- colnames(existingdf)
  for (col in colheader1){

    if(strcmpi(class(latestdf[[col]])[1],class(existingdf[[col]])[1])==FALSE && (strcmp(class(latestdf[[col]])[1],"POSIXct")==TRUE || strcmp(class(existingdf[[col]])[1],"POSIXct")==TRUE)){
      stop(paste(col," class does not match between existing df and the latest df"),sep=" ")
    }

    if(strcmpi(class(latestdf[[col]])[1],class(existingdf[[col]])[1])==FALSE){
      warning(paste(col," class does not match between existing df and the latest df"),sep=" ")
    }
  }


  latestdf$ModifiedAtColumn <- Sys.time()
  latestdf$ModifiedAtColumn <- ymd_hms(latestdf$ModifiedAtColumn)
  existingdf$ModifiedAtColumn <- Sys.time() - 3600
  existingdf$ModifiedAtColumn <- ymd_hms(existingdf$ModifiedAtColumn)


  appendedDF <- rbind(existingdf, latestdf) %>%
    arrange(desc(ModifiedAtColumn))

  drops <- c("ModifiedAtColumn")
  appendedDF <- appendedDF[, !(names(appendedDF) %in% drops)]
  colheader <- colnames(appendedDF)
  colheader <- colheader[!colheader %in% valuecol]

  appendedDF[!duplicated(appendedDF[, colheader]), ] %>%
    write.csv(pathToSave, row.names = FALSE)
}
