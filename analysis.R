library(dplyr)

DIR_NAME_DATA = "data"

if(!dir.exists(DIR_NAME_DATA)){
  
}

data_list <- list()
files <- list.files(path=DIR_NAME_DATA)
for(file_name in files){
  data_list <- append(data_list, list(read.csv(file.path(DIR_NAME_DATA, file_name))))
}
data <- do.call("rbind", data_list)

data <- data[data$familiarization == 'false',]
data <- data[data$conf_type == "NEW" | data$conf_type == "OLD", c('rt', 'name', 'conf_type', 'epoch', 'correct')]
data$rt <- as.numeric(data$rt)
data$correct <- data$correct == "true"

data$epoch <- as.factor(data$epoch)

# analysis TODO: add more models from the paper
fit = aov(rt ~ epoch * conf_type, data)
summary(fit)


# create leaderboard
leaderboard <- data %>% 
  group_by(name) %>% 
  summarise(
    acc = sum(correct) / n(),
    acc_bracket = ceiling(sum(correct) / n()*20),
    mean_rt = mean(rt, na.rm = TRUE),
  )

leaderboard <- leaderboard[
  with(leaderboard, order(acc_bracket, mean_rt)),
]


# plot

data_plot_pre <- data %>% group_by(epoch, conf_type) %>% summarise(
  mean_rt = mean(rt),
  stdv = sd(rt))

index <- data_plot_pre$conf_type == "NEW"
data_plot_pre$mean_rt[index] <- data_plot_pre$mean_rt[index] * (-1)

data_plot <- data_plot_pre %>% group_by(epoch) %>% summarise(
  score_ms = sum(mean_rt),
  stdv = mean(stdv)
  )

View(data_plot)


ggplot(data_plot, aes(epoch,score_ms,fill=epoch)) + 
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=score_ms-stdv, ymax=score_ms+stdv), width=.2, position=position_dodge(.9))