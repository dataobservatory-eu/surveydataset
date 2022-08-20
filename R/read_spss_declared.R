#' @title Read and write SPSS files
#' @description
#' `read_sav()` reads both `.sav` and `.zsav` files.
#' `read_por_declared()` reads `.por` files.
#' `read_spss_declared()` uses either `read_por_declared()` or `read_sav_declared()` based on the
#' file extension.
#' @details
#' Currently haven can read and write logical, integer, numeric, character
#' and factors. This is not ideal for social science surveys, and therefore we created a
#' wrapper haven's functions to read the data into declared types.
#' @importFrom haven read_spss read_por read_sav
#' @param file The file to read.
#' @param col_select One or more selection expressions, like in
#'   [dplyr::select()]. Use `c()` or `list()` to use more than one expression.
#'   See `?dplyr::select` for details on available selection options. Only the
#'   specified columns will be read from `data_file`.
#' @param skip Number of lines to skip before reading data.
#' @param n_max Maximum number of lines to read.
#' @param encoding The character encoding used for the file. The default,
#'   `NULL`, use the encoding specified in the file, but sometimes this
#'   value is incorrect and it is useful to be able to override it.
#' @return A tibble, data frame variant with nice defaults.
#'
#'   Variable labels are stored in the "label" attribute of each variable.
#'   It is not printed on the console, but the RStudio viewer will show it.
#' @name read_spss_declared
#' @examples
#' path <- system.file("examples", "ZA5688_v6_sample.sav", package = "surveydataset")
#' read_sav_declared(path)
#'
#' tmp <- tempfile(fileext = ".sav")
#' read_sav_declared(tmp)
NULL

#' @export
#' @rdname read_spss_declared
read_sav_declared <- function(file,
                              encoding = NULL,
                              user_na = FALSE,
                              col_select = NULL,
                              skip = 0,
                              n_max = Inf,
                              .name_repair = "unique") {

  argg <- list(encoding = encoding,
               col_select = col_select)

  if (is.null(col_select)) {
    tmp <- haven::read_sav(file, encoding = argg$encoding, user_na = user_na, skip = skip, n_max = n_max, .name_repair = .name_repair)

  } else {
    tmp <- haven::read_sav(file, encoding = argg$encoding,
                           user_na = user_na,
                           col_select = col_select,
                           skip = skip, n_max = n_max,
                           .name_repair = .name_repair)
  }

  declared::as.declared(tmp)
}

#' @export
#' @rdname read_spss_declared
read_por_declared <- function(file, user_na = FALSE, col_select = NULL, skip = 0, n_max = Inf, .name_repair = "unique") {

  argg <- list(encoding = encoding,
               col_select = col_select)

  if (is.null(col_select)) {
    tmp <- haven::read_por(file, encoding = argg$encoding, user_na = user_na, skip = skip, n_max = n_max, .name_repair = .name_repair)

  } else {
    tmp <- haven::read_por(file, encoding = argg$encoding,
                           user_na = user_na,
                           col_select = col_select,
                           skip = skip, n_max = n_max,
                           .name_repair = .name_repair)
  }
  declared::as.declared(tmp)
}


#' @export
#' @rdname read_spss_declared
#' @param user_na If `TRUE` variables with user defined missing will
#'   be read into [labelled_spss()] objects. If `FALSE`, the
#'   default, user-defined missings will be converted to `NA`.
read_spss_declared <- function(file,
                               user_na = FALSE,
                               col_select = NULL,
                               skip = 0,
                               n_max = Inf,
                               .name_repair = "unique") {


  if (is.null(col_select)) {
    tmp <- haven::read_spss(file, user_na = user_na, skip = skip, n_max = n_max, .name_repair = .name_repair)

  } else {
    tmp <- haven::read_spss(file,
                            user_na = user_na,
                            col_select = col_select,
                            skip = skip, n_max = n_max,
                            .name_repair = .name_repair)
  }
  declared::as.declared(tmp)
}

