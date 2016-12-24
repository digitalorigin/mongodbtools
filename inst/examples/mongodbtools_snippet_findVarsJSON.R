options(java.parameters="-Xmx4g")
library(mongodbtools)
library(data.table)
digorig::do.init()

strFile = "data/mongodbtools_snippet_findVarsJSON.csv"

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'
listvars = c(
  "_id",
  "refId",
  "createDate")

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
con <- mdb.connect(strURI)
mdb.setMaxRows(con, 10)
mdb.findVarsJSON(con, "evaluation", strFind, strFile)
mdb.close(con)

df = fread(strFile)
df