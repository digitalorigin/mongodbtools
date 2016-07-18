digorig::do.init()

# rmongodb ----
library(rmongodb)

connData = list()

mongo <- mongo.create(name="1.mongo.prod.quebueno.es", username = connData$IAM_user, password = connData$IAM_pass, db = "audit_prod")

mongo <- mongo.create(name="1.mongo.prod.quebueno.es/?ssl=true", username = connData$IAM_user, password = connData$IAM_pass, db = "audit_prod")

mongo <- mongo.create("52.50.194.158:8080/?ssl=true", username = connData$IAM_user, password = connData$IAM_pass, db = "audit_prod")
