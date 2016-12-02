library(plyr)

backblaze <- readRDS("data-raw/unit_summaries_ALL.rds")

backblaze$model <- as.factor(backblaze$model)

## subset by:
#### at least 1 failure..
num_failed <- ddply(backblaze, .(model), summarise, fails = sum(failed > 0))

model_names <- num_failed$model[num_failed$fails > 0]

id_1failure <- backblaze$model %in% model_names


#### logically possible
id_possible <- backblaze$end_time != backblaze$start_time & backblaze$end_time != 0

id_inc <- id_1failure & id_possible

#subset and refactor d!
backblaze <- backblaze[id_inc,]

backblaze <- droplevels(backblaze)

devtools::use_data(backblaze, overwrite = TRUE, compress = "xz")
