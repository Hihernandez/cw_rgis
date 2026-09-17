if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)


# get fish site data
df_fish <- read_csv("data/data_finsync_nc.csv")
print(df_fish)

# remove duplicates in the data
sf_site <- df_fish %>%
  distinct(site_id, lon, lat) %>%
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

# mapping
mapview(sf_site)

# export
saveRDS(sf_site, "data/sf_finsync_nc.rds")

# projection
sf_ft_wgs <- sf_site %>%
  slice(c(1,2))


sf_ft_utm <- sf_ft_wgs %>%
  st_transform(crs = 32617)
mapview(sf_ft_wgs)

st_distance(sf_ft_utm)


library(tidyverse)

df_quakes <- as_tibble(quakes)

df_quakes
sf_quakes <- sf::st_as_sf(
  df_quakes,
  coords = c("long", "lat"),
  crs = 4326)

sf_quakes

mapview::mapview(sf_quakes)
# Select first two sites
sf_ft_quakes <- sf_quakes %>%
  slice(c(1,2))

# Transform to WGS 84 / UTM zone 60S
sf_ft_quakes_proj <- sf::st_transform(
  sf_ft_quakes,
  crs = 32760)

# Calculate distance
st_distance(sf_ft_quakes_proj)
saveRDS(sf_quakes, file = "data/sf_quakes.rds")
