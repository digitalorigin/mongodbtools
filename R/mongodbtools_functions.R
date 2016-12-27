# roxygen2::roxygenise()

#' @title mdb.findVars
#' @export
#' @keywords internal
#' @rdname deprecated_function
mdb.findVars <- function(rmongodb, strCollection, strQuery, listVars, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findVarsToCSV \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVarsToCSV", strCollection, strQuery, as.vector(listVars), strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.findVarsToCSV
#' @export
mdb.findVarsToCSV <- function(rmongodb, strCollection, strQuery, listVars, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findVarsToCSV \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVarsToCSV", strCollection, strQuery, as.vector(listVars), strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.findVarsToJSON
#' @export
mdb.findVarsToJSON <- function(rmongodb, strCollection, strQuery, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findVarsToJSON \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVarsToJSON", strCollection, strQuery, strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}