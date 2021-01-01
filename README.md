Smart Save CSV
================
true

## Objective of this package

This package allows users to combine two dataframes with similar column
headers and classes. Also, there is an option to remove duplicates using
value column. valuecol parameter is passed on to the function. The
function removes duplicate rows by looking at all the column header
except the ones mentioned in the valuecol parameter. There are many use
cases for this package, especially related to saving time specific
information. For example, lets say the user has weather information for
the last 365 days and also 7 days in the future. Weather information for
the days in the past does not change but the weather forecast for the
next 7 days keep changing as we move further into the future. This
package plays an important role when we have to combined the existing
weather information, with all the latest information that is going to
come in the future. Sufficient examples are illustrated below to save
the user from any confusion.

## Including Code

You can include R code in the document as follows:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

## Including Plots

You can also embed plots, for example:

![](README-pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
