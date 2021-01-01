source("helperMethods.R")
# setwd(dirname(rstudioapi::isAvailable()::getActiveDocumentContext()$path))
library(lubridate)
library(smartSaveCSV)
library(readr)
library(pracma)


getWindPenetration <- function(df) {
  df %>% dplyr::filter(variable %in% c("wind_pen_actual", "wind_pen_STF", "wind_pen_MTF"))
}

createBlankCSV <- function(name) {
  file.create(name)
}


df <- getForecastVsActual() %>%
  getWindPenetration()

month_year <- format(as.Date(Sys.Date()), "%m_%Y")
name <- paste("Wpen_Forecast_Vs_Actual_", month_year, ".csv", sep = "")

day_of_the_month <- format(as.Date(Sys.Date()), "%d")
path <- paste("Data/", name, sep = "")
if (day_of_the_month == 1) {
  createBlankCSV(path)
  write.csv(df, path, row.names = FALSE)
}

existingdf <- read_csv(path, guess_max = 5001)
datecols <- c("Interval", "GMTIntervalEnd")
# datecols <- c("Interval")
for (dateColName in datecols)
{
  existingdf[[dateColName]] <- parse_date_time(x = existingdf[[dateColName]], orders = c("mdy HM", "ymd HM", "mdy HMS", "ymd HMS"))
  df[[dateColName]] <- parse_date_time(x = df[[dateColName]], orders = c("mdy HMS", "ymd HMS"))
}

appendeddf <- smartSaveCSV::smartAppend(df, existingdf, "value")

smartSaveCSV(df, existingdf, path, "value")

