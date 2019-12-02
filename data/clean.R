#use our 2017-2018 arrests data 
# make a simple feature spatial data set 
# join with la zip shape file on zipcode
# save as a shape file

library(tidyverse)
library(sf)
library(janitor)
library(lubridate)
library(tmap)

arrests17_18 <- read_csv('data/ARREST_DATA_2017_2018.csv')
arrests17_18 <- clean_names(arrests17_18)
#names(arrests17_18)

arrests18 <- arrests17_18 %>%
  mutate(arr_date = mdy(arrest_date)) %>%
  sample_n(25000) %>% 
  filter(arr_date >= as.Date("2018-01-01") & arr_date <= as.Date("2018-12-31")) %>%
  select(latitude, longitude, zipcode, arr_date, arrest_time, age, sex, race_cat, arrest_type, chg_grp_desc)

#geometry type:  MULTIPOLYGON
la_zips <- st_read(dsn = "data/Los_Angeles_City_Zip_Codes/Los_Angeles_City_Zip_Codes.shp")
la_zips <- clean_names(la_zips)
la_zips <- lwgeom::st_make_valid(la_zips)
la_zips <- la_zips %>% 
  select(zip, geometry)

#merging our arrests data + zip shapes
arrest18_sf <- left_join(arrests17_18, la_zips, by = c("zipcode" = "zip"))
arrest18_sf <- st_as_sf(arrest18_sf)

#writing out zip
write_sf(obj = arrest17_18_sf, dsn = "data/arrests_zip.gpkg")

# reading in zip data
arrest18_sf <- st_read(dsn = "data/arrests_zip.gpkg")

arrest18_byzip <- arrest18_sf %>% 
  count(zipcode)

tmap_mode("view")
# #map of arrests
tm_shape(arrest18_byzip) +
 tm_polygons("n")

# st_is_empty(arrestsbyzip)

## select charge and chage description

arrests17_18 %>%
  select(zipcode,charge, chg_grp_desc, sex) %>%
  count(zipcode, chg_grp_desc, sex, sort=TRUE)