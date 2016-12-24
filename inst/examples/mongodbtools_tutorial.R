options(java.parameters="-Xmx4g")
library(mongodbtools)
library(data.table)
digorig::do.init()

strURI = paste0(
  "mongodb://",
  connData$db_mongodb_qb_user,":",connData$db_mongodb_qb_pass, "@",
  connData$db_mongodb_qb_ip,":",connData$db_mongodb_qb_port,
  "/?authSource=audit_prod")

con <- mdb.connect(strURI)

mdb.getMaxRows(con)
mdb.setMaxRows(con, 1000)
mdb.getMaxRows(con)

mdb.useDatabase(con, "audit_prod")

mdb.showCollections(con)

strFile = "data/mongodbtools_tutorial.csv"

strFind = "{\"createDate\" : {\"$gte\" :  { \"$date\" : \"2016-07-10T00:00:00.000Z\"} }, \"contexts.ONLINE_BANKING\":{\"$exists\":true}}"
listvars = c(
  "_id",
  "contexts.ONLINE_BANKING.OnlineBankingRules.account.sumAmountRule.amount")

mdb.findVars(con, "flex_eval", strFind, listvars, strFile)

mdb.close(con)

readLines(strFile, n=2)

df = fread(strFile)
df
