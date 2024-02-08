library(ggplot2)
library(dplyr)

setwd('C:/Users/lesag/OneDrive - Cardiff University/Desktop/Github/lego-price-changes/v2')

df <- read.csv('output.csv')

head(df)

final_date = as.Date(paste0('01 ', 'January 2024'), format = '%d %B %Y')

df <- df %>% 
  filter(retail>100) %>%
  mutate(total_returns = value/retail) %>%
  mutate(retire_date_object = as.Date(paste0('01 ', retire_month), format = '%d %B %Y')) %>%
  mutate(years_since_retirement = as.numeric(difftime(final_date, retire_date_object, units = 'days'))/365) %>%
  mutate(cagr = total_returns**(1/years_since_retirement))

mean(df$cagr)
length(df$cagr)
sd(df$cagr)

df %>% ggplot() +
  geom_point(aes(x=retail, y=cagr))

df %>% ggplot() +
  geom_density(aes(x=cagr))