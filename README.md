
<!-- README.md is generated from README.Rmd. Please edit that file -->

# surveydataset

<!-- badges: start -->

[![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7013164.svg)](https://zenodo.org/record/7013164#.YwFmc3ZBzIU)
[![devel-version](https://img.shields.io/badge/devel%20version-0.1.0-blue.svg)](https://github.com/dataobservatory-eu/surveydataset)
[![dataobservatory](https://img.shields.io/badge/ecosystem-dataobservatory.eu-3EA135.svg)](https://dataobservatory.eu/)
[![Follow
rOpenGov](https://img.shields.io/twitter/follow/ropengov.svg?style=social)](https://twitter.com/intent/follow?screen_name=ropengov)
[![Follow
author](https://img.shields.io/twitter/follow/digitalmusicobs.svg?style=social)](https://twitter.com/intent/follow?screen_name=digitalmusicobs)
[![Codecov test
coverage](https://codecov.io/gh/dataobservatory-eu/surveydataset/branch/master/graph/badge.svg)](https://app.codecov.io/gh/dataobservatory-eu/surveydataset?branch=master)
[![R-CMD-check](https://github.com/dataobservatory-eu/surveydataset/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/dataobservatory-eu/surveydataset/actions/workflows/R-CMD-check.yaml)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/dataobservatory-eu/surveydataset?branch=master&svg=true)](https://ci.appveyor.com/project/dataobservatory-eu/surveydataset)
<!-- badges: end -->

The goal of the ‘surveydataset’ package is to create special datasets
for social sciences surveys that are easier to release, exchange and
reuse. It builds on the [dataset](http://dataset.dataobservatory.eu/)
package which creates data frames that have clear structural and
referncial metadata to be used in statistical exchanges or placed in
scientific repositories. The ‘surveydataset’ package extends this
functionality with the pecularities of social sciences surveys, and
offers a data frame like container to be used with
[DDIwR](https://CRAN.R-project.org/package=DDIwR) for survey
documentation and
[retroharmonize](https://retroharmonize.dataobservatory.eu/) for the
retrospective harmonization of survey datasets.

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

The `read_spss_declared()` imports SPSS survey data into a
[tibble](https://CRAN.R-project.org/package=tible), and changes the
[labelled](https://CRAN.R-project.org/package=labelled) vectors
(variable columns) to
[declared](https://CRAN.R-project.org/package=declared) columns.

## Remove constans

``` r
small_survey <- survey_raw[, c(1:6, 7, 10:14, 33)] # Only to keep example easier to read
head(small_survey)
#> # A tibble: 6 × 13
#>           studyno1       studyno2 doi   version     edition        survey caseid
#>          <int+lbl>      <int+lbl> <chr> <chr>     <int+lbl>     <int+lbl>  <dbl>
#> 1 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar… 752670
#> 2 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar… 360001
#> 3 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar…   3507
#> 4 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar…    876
#> 5 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar…    403
#> 6 5688 [GESIS STU… 5688 [GESIS S… doi:… 6.0.0 … 2 [ARCHIVE… 792 [Eurobar…   1759
#> # … with 6 more variables: isocntry <chr>, wextra <dbl>, qb1_1 <int+lbl>,
#> #   qb1_2 <int+lbl>, qb1_3 <int+lbl>, d25 <int+lbl>
#> # ℹ Use `colnames()` to see all variable names
```

``` r
my_survey <- survey(
  small_survey,
  Dimensions = c("isocntry", "d25"),
  Measures = c("qb1_1","qb1_2", "qb1_3"), 
  Attributes = c("wextra", "caseid"), 
  Constants = c(1:5),
  Identifier =  small_survey$doi[1], 
  Label = as.character(as.factor(small_survey$survey[1])),
  Title = "Eurobarometer 79.2 (Small Demo Sample)", 
  Publisher = "GESIS", 
  Issued = substr("6.0.0 (2016-08-05)", 8, 17),
  Creator = person("GESIS"))

dataset::version(my_survey) <- small_survey$version[1]
```

``` r
summary(my_survey)
#>      survey        caseid         isocntry             wextra       
#>  Min.   :792   Min.   :    18   Length:100         Min.   :  305.7  
#>  1st Qu.:792   1st Qu.:  1287   Class :character   1st Qu.: 2955.1  
#>  Median :792   Median :181058   Mode  :character   Median : 6688.8  
#>  Mean   :792   Mean   :263517                      Mean   :13991.8  
#>  3rd Qu.:792   3rd Qu.:360175                      3rd Qu.:14649.0  
#>  Max.   :792   Max.   :988853                      Max.   :79029.3  
#>                                                                     
#>      qb1_1           qb1_2          qb1_3           d25      
#>  Min.   :1.000   Min.   :1.00   Min.   :1.00   Min.   :1.00  
#>  1st Qu.:1.000   1st Qu.:1.00   1st Qu.:1.00   1st Qu.:1.00  
#>  Median :1.000   Median :1.00   Median :1.00   Median :2.00  
#>  Mean   :1.293   Mean   :1.65   Mean   :1.47   Mean   :1.91  
#>  3rd Qu.:1.000   3rd Qu.:2.00   3rd Qu.:2.00   3rd Qu.:2.25  
#>  Max.   :4.000   Max.   :4.00   Max.   :4.00   Max.   :3.00  
#>  NA's   :1
```

``` r
my_attributes <- attributes(my_survey)
my_attributes$names <- my_attributes$row.names <- NULL; 
my_attributes
#> $dimensions
#>             names            class
#> isocntry isocntry        character
#> d25           d25 declared|integer
#>                                                                                                                                                     isDefinedBy
#> isocntry https://purl.org/linked-data/cube|https://raw.githubusercontent.com/UKGovLD/publishing-statistical-data/master/specs/src/main/vocab/sdmx-attribute.ttl
#> d25      https://purl.org/linked-data/cube|https://raw.githubusercontent.com/UKGovLD/publishing-statistical-data/master/specs/src/main/vocab/sdmx-attribute.ttl
#>                 codeList
#> isocntry not yet defined
#> d25      not yet defined
#> 
#> $measures
#>       names            class                       isDefinedBy       codeListe
#> qb1_1 qb1_1 declared|integer https://purl.org/linked-data/cube not yet defined
#> qb1_2 qb1_2 declared|integer https://purl.org/linked-data/cube not yet defined
#> qb1_3 qb1_3 declared|integer https://purl.org/linked-data/cube not yet defined
#> 
#> $attributes
#>         names   class
#> caseid caseid numeric
#> wextra wextra numeric
#>                                                                                                                                                   isDefinedBy
#> caseid https://purl.org/linked-data/cube|https://raw.githubusercontent.com/UKGovLD/publishing-statistical-data/master/specs/src/main/vocab/sdmx-attribute.ttl
#> wextra https://purl.org/linked-data/cube|https://raw.githubusercontent.com/UKGovLD/publishing-statistical-data/master/specs/src/main/vocab/sdmx-attribute.ttl
#>              codeListe
#> caseid not yet defined
#> wextra not yet defined
#> 
#> $Type
#>       resourceType resourceTypeGeneral
#> 1 DCMITYPE:Dataset             Dataset
#> 
#> $Title
#>                                    Title titleType
#> 1 Eurobarometer 79.2 (Small Demo Sample)     Title
#> 
#> $Identifier
#> [1] "doi:10.4232/1.12577"
#> 
#> $Creator
#> [1] "GESIS"
#> 
#> $Source
#> [1] NA
#> 
#> $Publisher
#> [1] NA
#> 
#> $Rights
#> [1] NA
#> 
#> $Description
#> [1] NA
#> 
#> $Size
#> [1] "33.08 kB [32.3 KiB]"
#> 
#> $Date
#> [1] "2022-08-22"
#> 
#> $datasetAttributes
#>   attribute                 value
#> 1  studyno1 GESIS STUDY ID ZA5688
#> 2  studyno2 GESIS STUDY ID ZA5688
#> 3       doi   doi:10.4232/1.12577
#> 4   version    6.0.0 (2016-08-05)
#> 5   edition       ARCHIVE EDITION
#> 
#> $class
#> [1] "dataset"    "data.frame"
#> 
#> $Version
#> [1] "6.0.0 (2016-08-05)"
```

``` r
utils::toBibtex(dataset::bibentry_dataset(my_survey))
```

## Further work

The `surveydataset` package is in a very early stage of its development.
For citations please refer to the current development version as:

``` r
citation('surveydataset')
#> 
#> To cite surveydataset in publications use:
#> 
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Misc{,
#>     year = {2022},
#>     publisher = {Reprex},
#>     title = {surveydataset: An R Package For Findable, Accessible, Interoperable, and Reusable Survey Datasets},
#>     author = {Daniel Antal},
#>     url = {https:://surveydataset.dataobservatory.eu/},
#>     version = {0.1.0},
#>     doi = {10.5281/zenodo.7013164},
#>   }
```

## Code of Conduct

Please note that the surveydataset project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
