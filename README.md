
<!-- README.md is generated from README.Rmd. Please edit that file -->

# surveydataset

<!-- badges: start -->

[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6992467.svg)](https://zenodo.org/record/6950435#.YukDAXZBzIU)
[![devel-version](https://img.shields.io/badge/devel%20version-0.1.7-blue.svg)](https://github.com/dataobservatory-eu/dataset)
[![dataobservatory](https://img.shields.io/badge/ecosystem-dataobservatory.eu-3EA135.svg)](https://dataobservatory.eu/)
[![Follow
rOpenGov](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/intent/follow?screen_name=ropengov)
[![Follow
author](https://img.shields.io/twitter/follow/digitalmusicobs.svg?style=social)](https://twitter.com/intent/follow?screen_name=digitalmusicobs)
<!-- badges: end -->

The goal of the ‘sruveydataset’ package is to create special datasets
for social sciences surveys that are easier to release, exchange and
reuse.

## Installation

You can install the development version of surveydataset like so:

``` r
remotes::install_github('dataobservatory-eu/surveydataset')
```

## Read in a file

``` r
library(surveydataset)
require(haven)
path <- system.file("ZA5688_v6_sample.sav", package = "surveydataset")
survey_raw       <- read_spss_declared(path)
```

We have created a wrapper around
[haven::read_spss()](https://haven.tidyverse.org/reference/read_spss.html)
and `declared::as_declared()` to read in surveys in a less ambigous
format:

``` r
summary(as.factor(survey_raw$d25))
#> Rural area or village     Small/middle town            Large town 
#>                    34                    41                    25
summary(survey_raw$d25)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>    1.00    1.00    2.00    1.91    2.25    3.00
```

## Remove constans

``` r
my_survey <- survey_raw[, c(1:5, 7, 10:12, 33)] # Only to keep example easier to read
head(my_survey)
#> # A tibble: 6 × 10
#>          studyno1       studyno2 doi   version     edition caseid isocn…¹ wextra
#>         <int+lbl>      <int+lbl> <chr> <chr>     <int+lbl>  <dbl> <chr>    <dbl>
#> 1 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 752670 IT      43123.
#> 2 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 360001 LT       2287.
#> 3 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE…   3507 PT       8890.
#> 4 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE…    876 RO      14548.
#> 5 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE…    403 SI       2140.
#> 6 5688 [GESIS ST… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE…   1759 DK       3887.
#> # … with 2 more variables: qb1_1 <int+lbl>, d25 <int+lbl>, and abbreviated
#> #   variable name ¹​isocntry
#> # ℹ Use `colnames()` to see all variable names
```

``` r
my_survey <- constant_to_attributes(x = my_survey, constant_columns = 1:5)
head(my_survey)
#> # A tibble: 6 × 5
#>   caseid isocntry wextra                         qb1_1                       d25
#>    <dbl> <chr>     <dbl>                     <int+lbl>                 <int+lbl>
#> 1 752670 IT       43123. 1 [Not in the last 12 months] 2 [Small/middle town]    
#> 2 360001 LT        2287. 1 [Not in the last 12 months] 2 [Small/middle town]    
#> 3   3507 PT        8890. 1 [Not in the last 12 months] 2 [Small/middle town]    
#> 4    876 RO       14548. 1 [Not in the last 12 months] 1 [Rural area or village]
#> 5    403 SI        2140. 1 [Not in the last 12 months] 2 [Small/middle town]    
#> 6   1759 DK        3887. 3 [3-5 times]                 2 [Small/middle town]
```

``` r
dataset_attributes <- attr(my_survey, "datasetAttributes")
dataset_attributes
#>   attribute                 value
#> 1  studyno1 GESIS STUDY ID ZA5688
#> 2  studyno2 GESIS STUDY ID ZA5688
#> 3       doi   doi:10.4232/1.12577
#> 4   version    6.0.0 (2016-08-05)
#> 5   edition       ARCHIVE EDITION
```

``` r
library(dataset)
my_survey <- dataset(
  my_survey,
  Dimensions = c("isocntry", "d25"),
  Measures = "qb1_1", 
  Attributes = "wextra", "caseid", 
  Identifier =  dataset_attributes[which(dataset_attributes$attribute == "doi"),2], 
  Title = "Eurobarometer 79.2", 
  Publisher = "GESIS", 
  Creator = person("GESIS"))

version(my_survey) <- dataset_attributes[which(dataset_attributes$attribute == "version"),2]

#my_survey <- dataset_title_create(
#Title = c("EUROBAROMETER 79.2
# APRIL-MAY 2013",dataset_attributes[which(dataset_attributes$attribute == "studyno1"),2]), 
#titleType = c("Title", "AlternativeTitle"))
```

``` r
summary(my_survey)
#>      caseid         isocntry             wextra            qb1_1      
#>  Min.   :    18   Length:100         Min.   :  305.7   Min.   :1.000  
#>  1st Qu.:  1287   Class :character   1st Qu.: 2955.1   1st Qu.:1.000  
#>  Median :181058   Mode  :character   Median : 6688.8   Median :1.000  
#>  Mean   :263517                      Mean   :13991.8   Mean   :1.293  
#>  3rd Qu.:360175                      3rd Qu.:14649.0   3rd Qu.:1.000  
#>  Max.   :988853                      Max.   :79029.3   Max.   :4.000  
#>                                                        NA's   :1      
#>       d25      
#>  Min.   :1.00  
#>  1st Qu.:1.00  
#>  Median :2.00  
#>  Mean   :1.91  
#>  3rd Qu.:2.25  
#>  Max.   :3.00  
#> 
```

``` r
utils::toBibtex(bibentry_dataset(my_survey))
#> @Misc{,
#>   title = {Eurobarometer 79.2},
#>   author = {{GESIS}},
#>   publisher = {GESIS},
#>   size = {19.62 kB [19.16 KiB]},
#> }
```
