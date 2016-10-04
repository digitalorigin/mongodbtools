# roxygen2::roxygenise()

multiplelines.message <- function (strText) {
  #   writeLines(strwrap(strText, width=73))
  #   strText = unlist(strsplit(strText, "\r\n"))
  strText = unlist(strsplit(strText, "\n"))
  for (line in strText) message(line)
  invisible(NULL)
}

#' @title mdb.getURI
#' @export
mdb.getURI <- function(
  ip,
  port,
  database = NULL,
  user = connData$IAM_user,
  pass = connData$IAM_pass
) {
  base = "mongodb://"
  strURI = paste0(
  base,
  user,":",pass, "@",
  ip,":",port)
  if (!is.null(database)) strURI = paste0(strURI,"/?authSource=",database)
  invisible(strURI)
}

#' @title mdb.connect
#' @export
mdb.connect <- function(strURI) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Connect \n"))
  rmongodb <- .jnew("rmongodbtools/RMongoDB", strURI)
  return(rmongodb)
}

#' @title mdb.useDatabase
#' @export
mdb.useDatabase <- function(rmongodb, strDatabase) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n USE ",strDatabase," \n"))
  results <- .jcall(rmongodb, "V", "connectDatabase", strDatabase)
  invisible(results)
}

#' @title mdb.showCollections
#' @export
mdb.showCollections <- function(rmongodb) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Show Collections \n"))
  results <- .jcall(rmongodb, "[S", "showCollections")
  return(results)
}

#' @title mdb.find
#' @export
mdb.find <- function(rmongodb, strCollection, strQuery, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(con, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Find \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "find", strCollection, strQuery, strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.find
#' @export
mdb.findVars <- function(rmongodb, strCollection, strQuery, listVars, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(con, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Find \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVars", strCollection, strQuery, as.vector(listVars), strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.close
#' @export
mdb.close <- function(rmongodb) {
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]:\n Close Connection \n"))
  .jcall(rmongodb, "V", "close")
  invisible(NULL)
}
