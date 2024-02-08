library(ggplot2)
library(dplyr)

df <- read.csv('new-data/dataframe_appended.csv')

head(df)

df <- df %>% filter(X..of.pieces>200)
df_filtered <- df

df %>% ggplot() +
  geom_point(aes(x=X..of.pieces, y=Yearly.Average.Returns, color=age))


sum(df_filtered$Yearly.Average.Returns[!is.na(df_filtered$Yearly.Average.Returns)]) / length(df_filtered$Yearly.Average.Returns[!is.na(df_filtered$Yearly.Average.Returns)])
length(df_filtered$Yearly.Average.Returns[!is.na(df_filtered$Yearly.Average.Returns)])

df %>% 
  group_by(theme) %>%
  summarize(Avg_Return = mean(Yearly.Average.Returns, na.rm = TRUE), Count = sum(Yearly.Average.Returns>=0, na.rm = TRUE)) %>%
  filter(Count>0) %>%
  arrange(desc(Avg_Return))