digorig::do.init()

# RMongo ----
library(RMongo)
mg1 <- mongoDbConnect("audit_prod", connData$db_mongodb_qb_ip, port=connData$db_mongodb_qb_port)
print(dbShowCollections(mg1))

query <- dbGetQuery(mg1, 'test', "{'AGE': {'$lt': 10}, 'LIQ': {'$gte': 0.1}, 'IND5A': {'$ne': 1}}")
data1 <- query
summary(data1)
