digorig::do.init()

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-09-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'
listvars = c(
  "_id",
  "contexts.BASKET_MODEL.score",
  "contexts.BASKET_MODEL.items_number",
  "contexts.BASKET_MODEL.normalizedItems")
strFile = "C:/workspace/prova_mongodbtools_snippet.csv"

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
con <- mdb.connect(strURI)
mdb.findVars(con, "evaluation", strFind, listvars, strFile, "pmt_cre2_prod")
mdb.close(con)

df = fread(strFile)
df
