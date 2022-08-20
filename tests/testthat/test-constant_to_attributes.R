path <- system.file("ZA5688_v6_sample.sav", package = "surveydataset")
survey_raw <- read_spss_declared(path)
survey_raw <- survey_raw[, c(1:5, 7, 10:12 )]
x <- survey_raw
my_survey <- constant_to_attributes(x = survey_raw, constant_columns = 1:5)
attr(my_survey, "datasetAttributes")

test_that("constant_to_attributes() works", {
  expect_equal(ncol(my_survey), ncol(survey_raw)-5)
  expect_equal(nrow(attr(my_survey, "datasetAttributes")), 5)
})
