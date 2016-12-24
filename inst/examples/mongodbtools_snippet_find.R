options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL":{"$exists":true}}'

mdb = mdb.rmongodb(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)

mdb$setColletion("evaluation")

mdb$find(strFind)

i = 1
while (mdb$hasNext() && i <= 10) {
  json = mdb$getNext()
  print(json)
  i = i + 1
}

mdb$close()
