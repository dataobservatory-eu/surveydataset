#' @title Create a survey
#' @description Create a dataset suitable for working with social sciences surveyd data.
#' @importFrom dataset dataset
#' @inheritParams dataset::dataset
#' @return A well-described and formatted data frame with survey data and rich metadata.
#' @examples
#' path <- system.file("ZA5688_v6_sample.sav", package = "surveydataset")
#' survey_raw       <- read_spss_declared(path)
#'
#' Identifier <- survey_raw$doi[1]
#'
#' y <- survey(
#'   x = survey_raw,
#'   Dimensions = c(10, 22:33),
#'   Measures = c(13:21),
#'   Attributes = c(7:9, 11),
#'   Constants = c(1:6),
#'   Title = "Test Survey",
#'   Identifier = survey_raw$doi[1],
#'   Label = as.character(as.factor(survey_raw$survey[1]))
#' )
#' @export

survey <- function(x,
                   Dimensions, Measures, Attributes, Constants,
                   Title = NULL, Identifier,
                   Label = NULL, Creator = NULL,  Publisher = NULL, Issued = NULL,
                   Subject = NULL ) {

  tmp <- dataset(x,
                 Dimensions=Dimensions,
                 Measures=Measures,
                 Attributes=Attributes,
                 Title = Title,
                 Label = Label,
                 Creator = Creator,
                 Identifier = Identifier,
                 Subject = Subject)


  tmp <- constant_to_attributes(x=tmp, constant_columns = Constants)

  tmp
}

