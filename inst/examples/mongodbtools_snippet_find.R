# Init ----
# options(java.parameters="-Xmx4g")
library(mongodbtools)
digorig::do.init()

# Set query ----
strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL.score":{"$exists":true}}'
strProjection = '{
  "_id":0,
  "refId":1,
  "createDate":1,
  "contexts.BASKET_MODEL.score":1,
  "contexts.BASKET_MODEL.items_number":1,
  "contexts.BASKET_MODEL.normalizedItems":1
}'

# Create connection ----
mdb = mdb.rmongodb(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)

mdb$showCollections()
mdb$setColletion("evaluation")

# Iterate over all documents ----
mdb$find(strFind)
mdb$projection(strProjection)

all_results = list()
i = 1
while (mdb$hasNext() && i <= 10) {
  json = mdb$getNext()
  print(json)
  all_results[[1+length(all_results)]] = json
  i = i + 1
}

# Path to array ----
array_score = mdb$pathToField(all_results, c("contexts", "BASKET_MODEL", "score"))
array_score
array_score = unlist(array_score)
array_score

# Expor to CSV ----
strFile = "data_output/mongodbtools_snippet_toCSV.csv"

listvars = c(
  "refId",
  "createDate",
  "contexts.BASKET_MODEL.score",
  "contexts.BASKET_MODEL.items_number",
  "contexts.BASKET_MODEL.normalizedItems")

mdb$find(strFind)
mdb$projection(strProjection)

mdb$getMaxRows()
mdb$setMaxRows(1000)
mdb$toCSV(strFile, listvars)

df = data.table::fread(strFile)
df

# Expor to CSV (raw) ----
strFile = "data_output/mongodbtools_snippet_toCSVRaw.csv"

mdb$find(strFind)
mdb$projection(strProjection)

mdb$getMaxRows()
mdb$setMaxRows(1000)
mdb$toCSVRaw(strFile)

df = data.table::fread(strFile)
df

# Expor to JSON ----
strFile = "data_output/mongodbtools_snippet_toJSON.json"

mdb$find(strFind)
mdb$projection(strProjection)

mdb$getMaxRows()
mdb$setMaxRows(1000)
mdb$toJSON(strFile)

all_json = readLines(strFile)
all_results = list()
for (json in all_json) {
  all_results[[1+length(all_results)]] = mdb$parseJSON(json)
}

# Close connection ----
mdb$close()
