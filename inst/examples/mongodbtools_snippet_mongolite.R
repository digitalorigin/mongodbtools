# https://jeroen.github.io/mongolite
# Init ----
digorig::do.init()
library(mongodbtools)
library(mongolite)

# Set query ----
strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "createDate" : {"$lte" :  { "$date" : "2016-10-02T00:00:00.000Z"} }, "contexts.BASKET_MODEL.score":{"$exists":true}}'

# Create connection ----
mdb = mdb.mongolite(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database, collection="evaluation")

# Help ----
?mongolite::mongo
browseURL("https://jeroen.github.io/mongolite")

# Count ----
mdb$count()

# Find : All data (DANGER!!) ----
df = mdb$find(strFind)
class(df)
head(df)

# Find : Iterator ----
it = mdb$iterate(strFind)
el = it$one()
while (!is.null(el)) {
  el = it$one()
  message(el$refId)
}



