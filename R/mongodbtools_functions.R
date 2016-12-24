# roxygen2::roxygenise()

#' @title mdb.findVarsJSON
#' @export
mdb.findVarsJSON <- function(rmongodb, strCollection, strQuery, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findVarsSimple \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVarsJSON", strCollection, strQuery, strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.findVars
#' @export
mdb.findVars <- function(rmongodb, strCollection, strQuery, listVars, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findVars \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findVars", strCollection, strQuery, as.vector(listVars), strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}

#' @title mdb.findJSON
#' @export
mdb.findJSON <- function(rmongodb, strCollection, strQuery, strFile, strDatabase = NULL) {
  if (!is.null(strDatabase)) mdb.useDatabase(rmongodb, strDatabase)
  multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
  multiplelines.message(paste0("[Query Input]: findJSON \n",strQuery))
  multiplelines.message(paste0("[Query Output]:\n File: ",strFile," \n"))
  timer = proc.time()
  results <- .jcall(rmongodb, "V", "findJSON", strCollection, strQuery, strFile)
  timer = round(proc.time() - timer)
  message(paste0("[Query Execution Time: ",timer[3]," seconds.]\n"))
  invisible(NULL)
}
