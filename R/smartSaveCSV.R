#' Append two datasets and contains the latest information
#'
#' This package exports out two functions. the smartAppend() function returns a dataframe which
#' appends two other dataframes (latestdf, existingdf) and also removes duplicates based on value
#' column. The smartSaveCSV() function saves the appended dataframe in a csv file.
#'
#' @name smartSaveCSV
#' @param latestdf Latest Dataframe whose contents should not be removed when removing duplicates from
#' the appended dataframe
#' @param existingdf Old Dataframe whose contents might be removed if duplicates are found after appending
#' the two dataframes.
#' @param pathToSave This is the path+Name to save the csv file. Acceptable formats should end with .csv
#' extension
#' @param valuecol This parameter is used when removing duplicate rows in the appended dataframe.
#' Typically, we want to leave the columns mentioned in this parameter and then remove duplicate rows
#' from rest of the columns. Acceptable formats: c("value","variable","Amount")
#' @return smartAppend function returns a combined dataframe after removing duplicated rows.
#'
#' @note These two functions checks for the similarities in column datatype. The function
#' returns an error if any datetime column or date column has incorrect formats. Also, the function
#' throws a warning when there is differences in classes of columns in two dataframes.
#'
#'
#' @import lubridate
#' @import pracma
#' @importFrom utils read.csv write.csv
library(lubridate)
library(pracma)


#' @export
smartAppend <- function(latestdf, existingdf, valuecol) {
  colheader1 <- colnames(latestdf)
  colheader2 <- colnames(existingdf)
  for (col in colheader1) {
    if (strcmpi(class(latestdf[[col]])[1], class(existingdf[[col]])[1]) == FALSE && (strcmp(class(latestdf[[col]])[1], "POSIXct") == TRUE || strcmp(class(existingdf[[col]])[1], "POSIXct") == TRUE)) {
      stop(paste(col, " class does not match between existing df and the latest df"), sep = " ")
    }

    if (strcmpi(class(latestdf[[col]])[1], class(existingdf[[col]])[1]) == FALSE) {
      warning(paste(col, " class does not match between existing df and the latest df"), sep = " ")
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

  return(appendedDF[!duplicated(appendedDF[, colheader]), ])
}

#' @export
smartSaveCSV <- function(latestdf, existingdf, pathToSave, valuecol) {
  smartAppend(df, existingdf, "value") %>%
    write.csv(pathToSave, row.names = FALSE)
}
