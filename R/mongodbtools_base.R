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
mdb.connect <- function(strURI, silent = FALSE, java_log = FALSE) {
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Input]:\n Connect \n"))
  rmongodb <- .jnew("rmongodbtools/RMongoDB", strURI, !java_log)
  tryCatch(
    {
      strDatabase = unlist(strsplit(strURI, "authSource="))[2]
      mongodbtools::mdb.useDatabase(rmongodb, strDatabase, silent=TRUE)
    },
  error = function(e) {})
  return(rmongodb)
}

#' @title mdb.useDatabase
#' @export
mdb.useDatabase <- function(rmongodb, strDatabase, silent = FALSE) {
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Input]:\n USE ",strDatabase," \n"))
  results <- .jcall(rmongodb, "V", "connectDatabase", strDatabase)
  invisible(results)
}

#' @title mdb.showCollections
#' @export
mdb.showCollections <- function(rmongodb) {
  if (mongodbtools:::use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  if (mongodbtools:::use_log) multiplelines.message(paste0("[Query Input]:\n Show Collections \n"))
  results <- .jcall(rmongodb, "[S", "showCollections")
  return(results)
}

#' @title mdb.getMaxRows
#' @export
mdb.getMaxRows <- function(rmongodb) {
  maxRows <- .jcall(rmongodb, "I", "getMaxRows")
  return(maxRows)
}

#' @title mdb.setMaxRows
#' @param maxRows Set to -1 to disable maximum rows limitation.
#' @export
mdb.setMaxRows <- function(rmongodb, maxRows=-1) {
  .jcall(rmongodb, "V", "setMaxRows", as.integer(maxRows))
  invisible(NULL)
}

#' @title mdb.getDateFormat
#' @export
mdb.getDateFormat <- function(rmongodb) {
  strDateFormat <- .jcall(rmongodb, "S", "getDateFormat")
  return(strDateFormat)
}

#' @title mdb.setDateFormat
#' @export
mdb.setDateFormat <- function(rmongodb, strDateFormat="yyyy-MM-dd HH:mm:ss") {
  # strDateFormat="yyyy-mm-dd HH:mm:ss.SSSSSS"
  .jcall(rmongodb, "V", "setDateFormat", strDateFormat)
  invisible(NULL)
}

#' @title mdb.close
#' @export
mdb.close <- function(rmongodb, silent = FALSE) {
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  if (!silent & mongodbtools:::use_log) multiplelines.message(paste0("[Query Input]:\n Close Connection \n"))
  .jcall(rmongodb, "V", "close")
  invisible(NULL)
}