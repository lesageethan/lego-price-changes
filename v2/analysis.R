library(ggplot2)
library(dplyr)
library(ggcorrplot)

setwd('C:/Users/lesag/OneDrive - Cardiff University/Desktop/Github/lego-price-changes/v2')

df <- read.csv('output-brickset-ratings.csv')

head(df)

final_date = as.Date(paste0('01 ', 'January 2024'), format = '%d %B %Y')

df <- df %>% 
  filter(retail>0) %>% 
  filter(num_parts>=00) %>%
  filter(rating>=0) %>%
  mutate(total_returns = value/retail) %>%
  mutate(price_per_piece = retail/num_parts) %>%
  mutate(retire_date_object = as.Date(paste0('01 ', retire_month), format = '%d %B %Y')) %>%
  mutate(years_since_retirement = as.numeric(difftime(final_date, retire_date_object, units = 'days'))/365) %>% 
  filter(years_since_retirement>1) %>%
  mutate(cagr = total_returns**(1/years_since_retirement))

mean(df$cagr)
length(df$cagr)
sd(df$cagr)

df %>% ggplot() +
  geom_point(aes(x=rating, y=cagr))

df %>% 
  ggplot() +
  geom_boxplot(aes(group=brickset_rating, x=brickset_rating, y=cagr))

df %>% ggplot() +
  geom_point(aes(x=-price_per_piece, y=cagr, color=rating)) + 
  scale_colour_gradientn(colours=rainbow(4))

df_nums <- df %>% select(where(is.numeric))
corr <- round(cor(df_nums), 1)
ggcorrplot(corr)



# df %>% ggplot() +
#   geom_density(aes(x=cagr))