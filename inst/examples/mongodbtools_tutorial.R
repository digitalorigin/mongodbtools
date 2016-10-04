digorig::do.init()
library(mongodbtools)
library(data.table)

strURI = paste0(
  "mongodb://",
  connData$db_mongodb_qb_user,":",connData$db_mongodb_qb_pass, "@",
  connData$db_mongodb_qb_ip,":",connData$db_mongodb_qb_port,
  "/?authSource=audit_prod")

con <- mdb.connect(strURI)

mdb.useDatabase(con, "audit_prod")

mdb.showCollections(con)

strFind = "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-07-10T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}"
listvars = c(
  "_id",
  "contexts.ONLINE_BANKING.OnlineBankingRules.account.sumAmountRule.amount")
strFile = "C:/workspace/prova_mongodbtools.csv"

mdb.findVars(con, "flex_eval", strFind, listvars, strFile)

mdb.close(con)

readLines(strFile, n=2)

df = fread(strFile)
df
