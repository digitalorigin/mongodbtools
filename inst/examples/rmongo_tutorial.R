library(RMongo)
source("C:/Alabern/Data/ConnData/init_conndata.R")

connData$db_mongodb_qb_ip = "1.mongo.prod.quebueno.es"
connData$db_mongodb_qb_port = "8080"

strURI = paste0(
  "mongodb://",
  connData$IAM_user,":",connData$IAM_pass, "@",
  connData$db_mongodb_qb_ip,":",connData$db_mongodb_qb_port,
  "/?authSource=audit_prod")

con <- mdb.connect(strURI)

mdb.useDatabase(con, "audit_prod")

mdb.showCollections(con)

mdb.close(con)
