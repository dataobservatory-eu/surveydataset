path <- system.file("ZA5688_v6_sample.sav", package = "surveydataset")
survey_raw       <- read_spss_declared(path)


Identifier <- survey_raw$doi[1]
version_info <- survey_raw$version[1]

y <- survey(
  x = survey_raw,
  Dimensions = c(10, 22:33),
  Measures = c(13:21),
  Attributes = c(7:9, 11),
  Constants = c(1:6),
  Title = "Test Survey",
  Identifier = survey_raw$doi[1],
  Label = as.character(as.factor(survey_raw$survey[1]))
)


test_that("survey() works", {
  expect_equal(ncol(y), 27)
})
