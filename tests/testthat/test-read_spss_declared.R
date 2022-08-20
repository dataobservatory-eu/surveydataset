haven_tested <- haven::read_sav(file, encoding = NULL, user_na = FALSE, col_select = NULL, skip = skip, n_max = n_max,
                .name_repair = .name_repair)

tested <- read_sav_declared(system.file("ZA5688_v6_sample.sav", package = "surveydataset"),
                  encoding = NULL, user_na = FALSE, col_select = NULL, skip = skip, n_max = n_max,
                  .name_repair = .name_repair)

test_that("read_sav_declared() works", {
  expect_equal(nrow(tested), nrow(haven_tested))
  expect_equal(ncol(haven_tested), ncol(tested))
})

tested_spss <- read_spss_declared(
  file = system.file("ZA5688_v6_sample.sav", package = "surveydataset"),
  encoding = NULL, user_na = FALSE, col_select = NULL, skip = skip, n_max = n_max,
  .name_repair = .name_repair)


test_that("read_spss_declared() works", {
  expect_equal(nrow(tested), nrow(haven_tested))
  expect_equal(ncol(haven_tested), ncol(tested))
})
