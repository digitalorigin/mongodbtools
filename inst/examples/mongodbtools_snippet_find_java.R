options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)

con <- mdb.connect(strURI)

rmongodb = con
strCollection = "evaluation"
strQuery = strFind

cursor <- .jrcall(rmongodb, "debug", strCollection, strQuery)

cursor <- .jrcall(rmongodb, "find", strCollection, strQuery)

while (.jrcall(rmongodb, "hasNext", cursor)) {
  str_json <- .jrcall(rmongodb, "next", cursor)
  json = jsonlite::fromJSON(str_json)
}

mdb.close(con)
