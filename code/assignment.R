# Take-home assignment for 10/16/2025

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               here)

# Q1. Read the dataset "data_finsync_nc.csv" from the data subdirectory 
# and assign it to an object named `df_fish`.
# Reference: Chapter 2

df_fish <- read_csv("data/data_finsync_nc.csv")

# Q2. Using `df_fish`, create a dataframe with unique site name (`site_id`), 
# longitude (`lon`), and latitude (`lat`), and assign it to `df_site`.
# Hint: use `distinct()` function.
# Reference: Chapter 2

df_site <- df_fish %>%
  distinct(site_id, lon, lat)

# Q3. `df_site` currently has no coordinate reference system (CRS). 
# Convert it to an `sf` object and assign the WGS 84 CRS (EPSG: 4326). 
# Save the resulting object as `sf_site`.
# Reference: Chapter 2

sf_site <- df_site %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

# Q4. Read "sf_nc_county.rds" from the data subdirectory using the `readRDS()` function.
# Assign the result to `sf_nc_county`.
# Reference: Chapter 3

sf_nc_county <- readRDS("data/sf_nc_county.rds")

# Q5. Using the `st_join()` function, associate the county column from `sf_nc_county`
# with each site in `sf_site`. Assign the result to `sf_site_w_county`.
# Reference: Chapter 3

sf_site_w_county <- st_join(
  sf_site,
  sf_nc_county %>% select(county)
)

# Q6. Convert `sf_site_w_county` to a tibble using the `as_tibble()` function.
# Assign the result to `df_site_w_county`.
# Reference: Chapter 3

df_site_w_county <- as_tibble(sf_site_w_county)

# Q7. Using `df_site_w_county`, create a vector of county names that have at least one fish survey site.
# Assign the result to `v_s1`. (Hint: use group_by(), summarize(), filter(), and pull()).
# Confirm the result contains 49 counties with `length(v_s1)`.
# Reference: https://aterui.github.io/biostats/data-manipulation.html#group-operation

v_s1 <- df_site_w_county %>%
  st_drop_geometry() %>%
  group_by(county) %>%
  summarize(n_site = n()) %>%
  filter(n_site >= 1, !is.na(county)) %>%
  pull(county)

length(v_s1)

# Q8. Using `v_s1`, subset the county polygons in `sf_nc_county` 
# to include only counties with at least one site.
# Assign the result to `sf_county_s1`.
# Reference: https://aterui.github.io/biostats/data-manipulation.html#row-manipulation

sf_county_s1 <- sf_nc_county %>%
  filter(county %in% v_s1)

nrow(sf_county_s1)

# Q9. Display `sf_county_s1` along with all sampling sites (`sf_site`) 
# on a single map using `ggplot()` and `geom_sf()`.
# Reference: Chapter 3

ggplot() +
  geom_sf(data = sf_county_s1, fill = "yellow") +
  geom_sf(data = sf_site, color = "pink") 

# Q10. Among the counties that contain at least one sampling site, 
# calculate the area of each county polygon using `st_area()`. 
# Identify the largest county and report its area in [m^2] (should be 2,289,719,021).
# NOTE: Use a projected CRS (UTM Zone 17N) for the calculation of area.
# Reference: Chapter 2 & 3

sf_county_utm <- st_transform(sf_county_s1, 32617)
sf_county_area <- sf_county_utm %>%
  mutate(area_m2 = as.numeric(st_area(geometry)))
sf_county_area %>%
  st_drop_geometry() %>%
  arrange(desc(area_m2)) %>%
  select(county, area_m2) %>%
  slice(1)
