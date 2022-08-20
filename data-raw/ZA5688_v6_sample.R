## code to prepare `DATASET` dataset goes here

spss_file_path <- file.path("C:/_markdown/retroharmonize-publication/data-raw/eurobarometer/")
ZA5688_v6_raw <- haven::read_spss(file.path(spss_file_path, "ZA5688_v6-0-0.sav"))
set.seed(123)
selected_rows <- floor(runif(100, min=1, max=nrow(ZA5688_v6_raw)))

names(ZA5688_v6_raw)[582:593]
names(ZA5688_v6_raw)[297:306]
names(ZA5688_v6_raw)[c(1:9, 12, 60)]

ZA5688_v6_sample <- ZA5688_v6_raw[selected_rows, c(1:9, 12, 60,297:306, 582:593)]

haven::write_sav(ZA5688_v6_sample, path = here::here('inst', "ZA5688_v6_sample.sav"))

