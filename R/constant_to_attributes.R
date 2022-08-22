#' @title Constants to attributes
#' @description Move columns that have only a single value present the dataset into the
#' attributes of a dataset.
#' @param x A data frame or similar R object.
#' @param constant_colums A selection of constant columns. Defaults to \code{'all'}.
#' @param attribute_name The name of the attribute which will containt the \code{constant_columns}.
#' @return A subsetted data frame, which includes the unique values of the constant columns
#' among the attributes of the R object.
#' @family dimension reduction functions
#' @examples
#' path <- system.file("ZA5688_v6_sample.sav", package = "surveydataset")
#' survey_raw <- read_spss_declared(path)
#' survey_raw <- survey_raw[, c(1:5, 7, 10:12 )]
#' constant_to_attributes(x = survey_raw, constant_columns = 1:5)
#'
#' my_survey <- constant_to_attributes(x = survey_raw, constant_columns = 1:5)
#' attr(my_survey, "datasetAttributes")
#' @export

constant_to_attributes <- function(x,
                                   constant_columns,
                                   attribute_name = "datasetAttributes") {

  if(is.numeric(constant_columns)) {

    if ( !all(constant_columns %in% seq_along(x))) {

      message("constant_to_attributes(x, constant_columns, ...) - not in  x:",
              paste(constant_columns[!constant_columns %in% seq_along(x)], collapse = ', ')
              )
      constant_columns <- constant_columns[constant_columns %in% seq_along(x)]
    }
    constant_columns <- names(x)[constant_columns]
  }

  columns_not_present <- not_in_df(x, constant_columns)

  available_columns <- constant_columns[! constant_columns %in% columns_not_present ]

  subsetted_df <- subset(x, select = available_columns)

  not_unique_columns <- subsetted_df[, ! vapply(subsetted_df, unique_columns, logical(1))]

  if (ncol(not_unique_columns)>0) {
    message("constant_to_attributes(x, constant_columns) - not constant: ", paste(names(not_unique_columns), collapse = (', ')))
    subsetted_df <- subsetted_df[, which(! names(subsetted_df) %in% names(not_unique_columns))]
  }

  dataset_attributes <- data.frame(
    attribute = names(subsetted_df),
    value = as.character(vapply(subsetted_df, function(x) as.character(unique(x)), character(1)))
  )

  attr(x, which=attribute_name) <- dataset_attributes

  x[, names(x) %in% names(subsetted_df)] <- NULL

  x
}


#' @keywords internal
not_in_df <- function(x, columns) {
  names(x)[which (!columns %in% names(x))]
}

#' @keywords internal
unique_columns <- function(x) {
  length(unique(x))==1
}
