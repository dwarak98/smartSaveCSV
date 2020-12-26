
#' @import lubridate
#' @importFrom utils read.csv write.csv
library(lubridate)
 #' @export
smartSaveCSV <- function(df, path, valuecol) {
  existingdf <- read.csv(path)
  existingdf[[dateColName]] <- ymd_hms(existingdf[[dateColName]])
  existingdf$ModifiedAt <- ymd_hms(existingdf$ModifiedAt)
  colheader <- colnames(df)
  colheader <- colheader[!colheader %in% valuecol]

  newdf <- rbind(existingdf, df) %>%
    arrange(desc(ModifiedAt))

  df2 <- newdf[!duplicated(newdf[, colheader]), ] %>%
    write.csv(path, row.names = FALSE)
}
