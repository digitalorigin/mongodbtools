# options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

strFile = "data_output/mongodbtools_snippet_findVarsToJSON.json"

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
con <- mdb.connect(strURI)
mdb.setMaxRows(con, 10)
mdb.findVarsToJSON(con, "evaluation", strFind, strFile)
mdb.close(con)

library(texttools)
texttools::text.load_data()

all_json = read_lines(strFile)
all_results = list()
for (json in all_json) {
  # all_results[[1+length(all_results)]] = jsonlite::fromJSON(json)
  all_results[[1+length(all_results)]] = jsonlite::fromJSON(texttools::text.toASCII(json, FALSE, FALSE, listNonASCII, listASCII))
}
all_results
