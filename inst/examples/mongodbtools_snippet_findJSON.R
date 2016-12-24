options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

strFile = "data/mongodbtools_snippet_findJSON.json"

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
con <- mdb.connect(strURI)
mdb.setMaxRows(con, 10)
mdb.findJSON(con, "evaluation", strFind, strFile)
mdb.close(con)

strJSON = read_lines(strFile)
strJSON
