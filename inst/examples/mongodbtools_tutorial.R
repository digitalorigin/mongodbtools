# source("C:/Alabern/Data/ConnData/init_conndata.R")
detach("package:mongodbtools", unload=TRUE)
detach("package:rJava", unload=TRUE)
library(rJava)
.jinit()
  
strPackageFolder = paste0(find.package("mongodbtools"), "/")

.jaddClassPath(paste0(strPackageFolder, "java/rmongodbtools.jar"))
.jaddClassPath(paste0("C:/Alabern/Material/RPackages/mongodbtools/java/code/libs/", "mongo-java-driver-3.2.2.jar"))

digorig::do.init()
library(mongodbtools)
library(data.table)

.jclassPath()

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
strFile = "C:/workspace/prova_rmongodb.csv"

mdb.findVars(con, "flex_eval", strFind, listvars, strFile)

mdb.close(con)

readLines(strFile, n=2)

df = fread(strFile)
df
