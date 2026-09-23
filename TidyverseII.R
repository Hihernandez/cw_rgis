library(tidyverse)

iris %>%
  ggplot(aes(x= Sepal.Length,
             y= Sepal.Width)) + geom_point()

##aec(...,color=columname)
iris %>%
  ggplot(aes(x= Sepal.Length,
             y= Sepal.Width,
             color= Species)) + geom_point()
## Any Color You Like
iris %>%
  ggplot(aes(x= Sepal.Length, 
             y= Sepal.Width)) + geom_point(color= "pink")
# Line Figure
df_x <- tibble(x= 1:50,
               y= 2*x)
df_x %>%
  ggplot(aes(x= x, 
             y= y)) + geom_line()
# Histogram
iris %>%
  ggplot(aes(x= Sepal.Length)) + geom_histogram()
# Boxplot
iris %>%
  ggplot(aes(x= Species, 
             y= Sepal.Length)) + geom_boxplot()
## Change Box-plot Color (border)
iris %>%
  ggplot(aes(x= Species,
             y= Sepal.Length,
             color= Species)) + geom_boxplot()
## Change Boxplot Color
iris %>%
  ggplot(aes(x= Species,
             y= Sepal.Length,
             fill= Species)) + geom_boxplot()
#Exercise
#Q1 Using "iris" data, identify longest Sepal.Length
#using arrange() function

arrange(iris, Sepal.Length)
iris %>%
  arrange(desc(Sepal.Length))

#Q2 using "iris" data, filter individual
#Sepal.Width greater than 3.0, use "filter()"

iris %>%
  filter(Sepal.Width>3.0)
#Q3 using "iris" data, select the colums "Petal.Length
# and "Petal.Length(desc.)
#Assign result to object "df_petal"

df_petal <- iris %>%
  select(Petal.Length, Petal.Width) %>%
  arrange(desc(Petal.Length))

#Q4 Calculate mean Sepal.Length by Species
#Assign the result to "df_mean"

df_mean <- iris %>%
  group_by(Species) %>%
  summarize(mean=mean(Sepal.Length))

#Q5 Create a point figure of Petal.Width(y-axis) and Sepal.Width (x-axis)
#with colors distiguishing species

iris %>%
  ggplot(aes(x= Sepal.Width,
             y= Sepal.Length,
             color= Species)) + geom_point()
