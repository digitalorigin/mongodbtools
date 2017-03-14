# https://jeroen.github.io/mongolite
# https://cran.r-project.org/web/packages/mongolite/vignettes/intro.html
# https://github.com/jeroenooms/mongolite

# Example ----
digorig::do.init()
library("mongolite")

strURIBase <- mongodbtools::mdb.getURI(ip = connData$db_mongodb_pmt_ip, 
                     port = connData$db_mongodb_pmt_port, 
                     database = connData$db_mongodb_pmt_database, 
                     user = connData$IAM_user, 
                     pass = connData$IAM_pass)
strURI <- paste0(strURIBase, "&ssl=true")
mdb <- mongolite::mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI, options = ssl_options(weak_cert_validation = "true"))

mdb$count()

# Other tests ----
?ssl_options
ssl_options()

strURI <- paste0(strURIBase)
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI, options = ssl_options(weak_cert_validation = TRUE))

strURI <- paste0(strURIBase)
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI, options = ssl_options(weak_cert_validation = "true"))

strURI <- paste0(strURIBase, "&ssl=true")
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI)

strURI <- paste0(strURIBase, "&ssl=true&sslWeakCertificateValidation=true")
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI, options = ssl_options(weak_cert_validation = "true"))


strURI <- paste0(strURIBase, "&sslWeakCertificateValidation=true")
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI)

strURI <- paste0(strURIBase, "&ssl=true&sslInvalidHostNameAllowed=true")
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI)

strURI <- paste0(strURIBase, "&sslWeakCertificateValidation=true&sslInvalidHostNameAllowed=true")
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI)

strURI = "mongodb://ralabern:Laptop11@1.db.back.prod.pagantis.com:8080/?pmt_cre2_prod?sslWeakCertificateValidation=true&serverSelectionTryOnce=false"
con <- mongo(collection = "evaluation", db = connData$db_mongodb_pmt_database, url = strURI)
