# roxygen2::roxygenise()

#' @title mdb.mongolite
#' @export
mdb.mongolite <- function(
  ip, 
  port, 
  database, 
  collection,
  user = connData$IAM_user,
  pass = connData$IAM_pass,
  use_ssl = TRUE,
  use_weak_cert_validation = TRUE
) {
  if (mongodbtools:::use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  if (mongodbtools:::use_log) multiplelines.message(paste0("[Query Input]:\n Connect mongolite \n"))
  strURI <- mongodbtools::mdb.getURI(
    ip = ip, 
    port = port, 
    database = database, 
    user = user, 
    pass = pass)
  if (use_ssl) strURI <- paste0(strURI, "&ssl=true")
  if (use_weak_cert_validation) mdb <- mongolite::mongo(collection = collection, db = database, url = strURI, options = ssl_options(weak_cert_validation = "true"))
  else mdb <- mongolite::mongo(collection = collection, db = database, url = strURI)
  return(mdb)
}