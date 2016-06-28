# roxygen2::roxygenise()

library('rJava')
.jinit()
.jaddClassPath("inst/java/mongo-java-driver-3.2.2.jar")
.jaddClassPath("inst/java/rmongo.jar")

#' @title mdb.connect
#' @export
mdb.connect <- function(strURI) {
  rmongo <- .jnew("rmongo/RMongo", strURI)
  rmongo
}

#' @title mdb.useDatabase
#' @export
mdb.useDatabase <- function(rmongo, strDatabase) {
  results <- .jcall(rmongo, "V", "connectDatabase", strDatabase)
  results
}

#' @title mdb.showCollections
#' @export
mdb.showCollections <- function(rmongo) {
  results <- .jcall(rmongo, "[S", "showCollections")
  results
}

#' @title mdb.find
#' @export
mdb.find <- function(rmongo, strQuery) {
  results <- .jcall(rmongo, "[S", "find", strQuery)
  
  if (results == "") {
    data.frame()
  } else {
    con <- textConnection(results)
    data.frame.results <- read.csv(con, sep="", stringsAsFactors=FALSE, quote="")
    close(con)
    
    data.frame.results
  }
}

#' @title mdb.close
#' @export
mdb.close <- function(rmongo) {
  .jcall(rmongo, "V", "close")
}
