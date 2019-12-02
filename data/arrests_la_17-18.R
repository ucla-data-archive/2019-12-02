library(tidyverse)
library(sf)
library(janitor)
library(lubridate)


# zip, sex, race, number_of_arrest, arest_type

arrest_raw <- read_csv("data/ARREST_DATA_2017_2018.csv")
arrest_raw <- clean_names(arrest_raw)
names(arrest_raw)

# some variables removed - 2017-2018
arrest2017_18 <- arrest_raw %>%
  mutate(arr_date2 = mdy(arrest_date)) %>%
  #filter by date
  select(latitude, longitude, zipcode, arr_date2, arrest_time, age, sex, race_cat, arrest_type,  charge)


#filter 2017
arrest17_count_zip <- arrest_raw %>%
  mutate(arr_date2 = mdy(arrest_date)) %>%
  #filter by date
  filter(arr_date2 >= as.Date("2017-01-01") & arr_date2 <= as.Date("2017-12-31")) %>%
  select(latitude, longitude, zipcode, arr_date2, arrest_time, age, sex, race_cat, arrest_type,  charge)

#filtering dec2018
dec18_arrest_latlon_dem <- arrest_raw %>%
  mutate(arr_date2 = mdy(arrest_date)) %>%
  filter(arr_date2 >= as.Date("2018-12-01") & arr_date2 <= as.Date("2018-12-31")) %>%
  select(latitude, longitude, zipcode, arr_date2, arrest_time, age, sex, race_cat, arrest_type,  charge)

aug6_12_arr_latlon_demo <- arrest_raw %>%
  mutate(arr_date2 = mdy(arrest_date)) %>%
  filter(arr_date2 >= as.Date("2018-08-06") & arr_date2 <= as.Date("2018-08-12")) %>%
  select(latitude, longitude, zipcode, arr_date2, arrest_time, age, sex, race_cat, arrest_type,  charge) %>%
  drop_na(latitude, longitude)

write_csv(arrest2017_18, "data/2017_2018-arrests-la.csv")
write_csv(dec18_arrest_latlon_dem, "data/18dec_arrest_demo_zip_latlong.csv")
write_csv(arrest17_count_zip, 'data/17_arrest_demo_zip_latlong.csv')
write_csv(aug6_12_arr_latlon_demo, 'data/aug6_12_arrest_data.csv')

#gives you the most arrests by week number
arrest %>%
  mutate(arr_date2 = mdy(arrest_date)) %>%
  group_by(isoweek(arr_date2)) %>%
  count() %>%
  arrange(desc(n))

omit.na(aug6_12_arr_latlon_demo)
is.na(aug6_12_arr_latlon_demo)
complete.cases(aug6_12_arr_latlon_demo)


