library(RMongo)
source("C:/Alabern/Data/ConnData/init_conndata.R")

strURI = paste0(
  "mongodb://",
  connData$db_mongodb_qb_user,":",connData$db_mongodb_qb_pass, "@",
  connData$db_mongodb_qb_ip,":",connData$db_mongodb_qb_port,
  "/?authSource=audit_prod")

con <- mdb.connect(strURI)

mdb.useDatabase(con, "audit_prod")

mdb.showCollections(con)

strFind = "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-06-26T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}"
listvars = c(
  "_id",
  "contexts",
  "contexts.ONLINE_BANKING.OnlineBankingRules.account.sumAmountRule.amount")
strFile = "C:/workspace/prova.csv"

mdb.findVars(con, "flex_eval", strFind, listvars, strFile)

mdb.close(con)


library(data.table)

readLines("C:/workspace/prova.csv", n=2)

df = fread("C:/workspace/prova.csv")
df