# Raster 1: Basic terra operations 
if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)
# raster data format_________________

spr_ex <- rast("data/spr_example.tif")

# writeRaster() is a function to export raster data
writeRaster(x = spr_ex,
            filename = "data/spr_elev.tif",
            overwrite = TRUE)
# visualize raster data
ggplot() +
  geom_spatraster(
    data = spr_ex
  )
# if you want mapview() functin to work
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

# Data type in Raster__________________
# continuous
v_elev <- values(spr_ex)

extract(spr_ex, y = cbind(6.0000, 50.0000))
extract(spr_ex, y = cbind(7.0000, 92.0000))
extract(spr_ex, y = cbind(3.0000, 26.0000))
extract(spr_ex, y = cbind(4.6, 49))

# extract data at multiple points
df_point <- tibble(lon = c(6, 5.9),
       lat = c(50, 49.96)
       )

extract(spr_ex, y = df_point)

# discrete data
spr_for <- rast("data/spr_forest_nc.tif")

ggplot() +
  geom_spatraster(data = spr_for)
unique(spr_for)

v_binary <- values(spr_for)
mean(v_binary) * 100

# multiple classes - code values with multiple categories
spr_land <- rast("data/spr_land_reclass.tif")

# 1001 = forest
# 1010 = crop
# 1100 = urban
unique(spr_land)

# coordinate, lon -79.8063 lat 36.0701
extract(spr_land, cbind(-79.8063, 36.0701))

# reclass 
cm <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 1, 0, 0)
)

spr_bin <- classify(spr_land, 
                    rcl = cm)
unique(spr_bin)

v_bin <- values(spr_bin)
mean(v_bin) * 100

# calculate % cropland 
cm_crop <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0, 1, 0)
)
spr_crop <- classify(
  x =spr_land,
  rcl = cm_crop
)
v_crop <- values(spr_crop)
mean(v_crop) * 100

# calculate % urban
cm_urban <- cbind(
  c(0, 1001, 1010, 1100),
  c(0, 0, 0 ,1)
  
)

spr_urban <- classify(spr_land,
                      rcl = cm_urban)
unique(spr_urban)
v_urban <- values(spr_urban)
mean(v_urban) * 100

# exercise
# Q1

spr_prec_ncne <-rast("data/spr_prec_ncne.tif")

# Q2
# Rows: 162
# Columns: 532
# Resolution: 0.008333333, 0.008333333
# Extent: -79.89181, -75.45847, 35.24153, 36.59153  (xmin, xmax, ymin, ymax)
# Coordinates Ref. System: lon/lat WGS 84 (EPSG:4326)
# Min precipitation value: 1063.099976
# Max precipitation value: 1501.5
 
# Q3

ggplot() +
  geom_spatraster(data = spr_prec_ncne)

# Q4

sf_site <- readRDS("data/sf_finsync_nc.rds")

df_xy <- st_coordinates(sf_site)

df_land <- extract(spr_land,
        df_xy)
# Forest (has the most sites)
df_land %>%
  filter(code == 1001) %>%
  nrow()
# cropland
df_land %>%
  filter(code == 1010) %>%
  nrow()
# urban
df_land %>%
  filter(code == 1100) %>%
  nrow()

# quicker approach
table(df_land)
