data <- readRDS("data/tj_detail.rds")
write.csv(data, "tj_detail.csv", row.names = F)