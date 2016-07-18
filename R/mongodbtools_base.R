# roxygen2::roxygenise()

multiplelines.message <- function (strText) {
  #   writeLines(strwrap(strText, width=73))
  #   strText = unlist(strsplit(strText, "\r\n"))
  strText = unlist(strsplit(strText, "\n"))
  for (line in strText) message(line)
}

#' @title mdb.connect
#' @export
mdb.connect <- function(strURI) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Connect \n"))
  rmongodb <- .jnew("rmongodbtools/RMongoDB", strURI)
  rmongodb
}

#' @title mdb.useDatabase
#' @export
mdb.useDatabase <- function(rmongodb, strDatabase) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n USE ",strDatabase," \n"))
  results <- .jcall(rmongodb, "V", "connectDatabase", strDatabase)
  results
}

#' @title mdb.showCollections
#' @export
mdb.showCollections <- function(rmongodb) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Show Collections \n"))
  results <- .jcall(rmongodb, "[S", "showCollections")
  results
}

#' @title mdb.find
#' @export
mdb.find <- function(rmongodb, strCollection, strQuery, strFile) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Find \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  results <- .jcall(rmongodb, "V", "find", strCollection, strQuery, strFile)
  
  # if (results == "") {
  #   return(data.frame())
  # } else {
  #   con <- textConnection(results)
  #   data.frame.results <- read.csv(con, sep="", stringsAsFactors=FALSE, quote="")
  #   close(con)
  #   
  #   return(data.frame.results)
  # }
  invisible(NULL)
}

#' @title mdb.find
#' @export
mdb.findVars <- function(rmongodb, strCollection, strQuery, listVars, strFile) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Find \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  results <- .jcall(rmongodb, "V", "findVars", strCollection, strQuery, as.vector(listVars), strFile)
  
  invisible(NULL)
}

#' @title mdb.close
#' @export
mdb.close <- function(rmongodb) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Close Connection \n"))
  .jcall(rmongodb, "V", "close")
}
