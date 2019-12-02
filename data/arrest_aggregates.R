# 1. arrests by zipcode
# take full data
# group and aggregate by zipcode
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

arrests_zip <- arrests17_18 %>%
  group_by(zipcode) %>%
  tally() %>%
  ungroup()

#geometry type:  MULTIPOLYGON
la_zips <- st_read(dsn = "data/Los_Angeles_City_Zip_Codes/Los_Angeles_City_Zip_Codes.shp")
la_zips <- clean_names(la_zips)

#merging our arrests data + zip shapes
arrest_zip <- left_join(arrests_zip, la_zips, by = c("zipcode" = "zip"))

#writing out zip
write_sf(obj = arrest_zip, dsn = "data/arrests_zip.gpkg")

# reading in zip data
arrestsbyzip <- st_read(dsn = "data/arrests_zip.gpkg")

tmap_mode("view")
#map of arrests
tm_shape(arrestsbyzip ) +
  tm_polygons("n")

st_is_empty(arrestsbyzip)

arrests17_18 %>%
  select(charge, charge_desc) %>%
  count(charge, charge_desc, sort=TRUE) %>%
  View()

## Full data - for 12/
arrests <- read_csv('data/Arrest_Data_from_2010_to_Present.csv')
arrests <- clean_names(arrests)
glimpse(arrests)
max(arrests_10_18$arrest_date)
min(arrests_10_18$arrest_date)



