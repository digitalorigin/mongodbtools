# https://github.com/r-pkgs/processx/blob/bc7483237b0fbe723390cbb74951221968fdb963/R/process.R#L2 
# library(processx)
# ?process

options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL.score":{"$exists":true}}'
strProjection = '{
  "_id":0,
  "refId":1,
  "createDate":1,
  "contexts.BASKET_MODEL.score":1,
  "contexts.BASKET_MODEL.items_number":1,
  "contexts.BASKET_MODEL.normalizedItems":1
}'

strURI = mdb.getURI(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)

con <- mdb.connect(strURI)

rmongodb = con
strCollection = "evaluation"
strQuery = strFind

# java_it <- .jrcall(rmongodb, "debug", strCollection, strQuery)

java_dbCollection <- .jrcall(rmongodb, "getCollection", strCollection)
java_iterable <- .jrcall(rmongodb, "find", java_dbCollection, strQuery)
java_it <- .jrcall(rmongodb, "iterator", java_iterable)

i = 1
while (.jrcall(rmongodb, "hasNext", java_it) && i <= 10) {
  str_json <- .jrcall(rmongodb, "next", java_it)
  json = jsonlite::fromJSON(str_json)
  print(json)
  i = i + 1
}

mdb.close(con)
