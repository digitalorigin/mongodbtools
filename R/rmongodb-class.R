# roxygen2::roxygenise()
library(R6)

#' @title mdb.help
#' @export
mdb.help <- function() {
  strFile = paste0(find.package("mongodbtools"), "/examples/mongodbtools_snippet_find.R")
  file.edit(unlist(strFile))
}

#' @title mdb.rmongodb
#' @description
#' \code{mdb.rmongodb} creates a rmongodb object connecto to a MongoDB database with all basic functionalities needed to work with the database.
#' @details
#' This package works well with SSL connections without certificates.
#' @param ip The IP of the MongoDB database to connect to.
#' @param port The port of the MongoDB database to connect to.
#' @param user The user of the credentials to access the MongoDB database.
#' @param pass The password of the credentials to access the MongoDB database.
#' @return A rmongodb object with a connection to the MongoDB specified in params. The object itself contains all basic functionalities needed.
#' @section Usage:
#' \preformatted{mdb = mdb.rmongodb(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
#'
#' mdb = rmongodb$new(ip, port, database, user, pass)
#'
#' }
#' \describe{
#' \item{\code{mdb$getIp}}{Returns the IP of the connection.}
#' \item{\code{mdb$getPort}}{Returns the port of the connection.}
#' \item{\code{mdb$getDatabase}}{Returns the databse name of the connection.}
#' \item{\code{mdb$getColletion}}{Returns the collection used right now, if any.}
#' \item{\code{mdb$setColletion}}{Set the collection to be used in following queries.}
#' \item{\code{mdb$getRow}}{Returns the number of rows read by \code{mdb$getNextRaw} or \code{mdb$getNext}}
#' \item{\code{mdb$showCollections}}{Show all collections in database.}
#' \item{\code{mdb$getMaxRows}}{Returns number of max rows set. This only applies if you use \code{mdb$toCSV} or \code{mdb$toJSON}. Use \code{-1} for no limitation.}
#' \item{\code{mdb$setMaxRows}}{Sets number of max rows set. This only applies if you use \code{mdb$toCSV} or \code{mdb$toJSON}. Use \code{-1} for no limitation.}
#' \item{\code{mdb$getDateFormat}}{Returns the format to be used to parse date. This only applies if you use \code{mdb$toCSV}.}
#' \item{\code{mdb$setDateFormat}}{Sets the format to be used to parse date. This only applies if you use \code{mdb$toCSV}.}
#' \item{\code{mdb$find}}{Specifies a find query. This resets the iterator.}
#' \item{\code{mdb$projection}}{Specifies a projection query. This resets the iterator.}
#' \item{\code{mdb$sort}}{Specifies a sort query. This resets the iterator.}
#' \item{\code{mdb$skip}}{Specifies a number of rows to skip. This resets the iterator.}
#' \item{\code{mdb$hasNext}}{Returns if the iterator has at least 1 more document.}
#' \item{\code{mdb$getNextRaw}}{Returns next document of the iterator. The result is not parsed to an R list.}
#' \item{\code{mdb$getNext}}{Returns next document of the iterator. The result is parsed to an R list using \code{jsonlite::fromJSON}.}
#' \item{\code{mdb$parseJSON}}{It just calls \code{jsonlite::fromJSON}. It can be used to parse string jsons into R lists.}
#' \item{\code{mdb$pathToField}}{Given an array of fields of an R list it will navigate into that path of fields to return the given values.}
#' \item{\code{mdb$toCSV}}{Exports an array of vars included in the iterator to a specified CSV file in disk in a very tabular way. In case \code{mdb$getMaxRows} is positive then only that number of rows (documents) is exported. It is very similar to \code{mdb.findVarsToCSV} function.} 
#' \item{\code{mdb$toCSVRaw}}{Exports the iterator to a specified CSV file in disk. In case \code{mdb$getMaxRows} is positive then only that number of rows (documents) is exported.}
#' \item{\code{mdb$toJSON}}{Exports the iterator to a specified JSON file in disk. In case \code{mdb$getMaxRows} is positive then only that number of rows (documents) is exported. It is very similar to \code{mdb.findVarsToJSON} function.}
#' \item{\code{mdb$close}}{Closes the database connection.}
#' }
#' @export
#' @examples 
#' digorig::do.init()
#' 
#' strFind = '{"createDate" : {"$gte" :  { "$date" : "2016-10-01T00:00:00.000Z"} }, "contexts.BASKET_MODEL.score":{"$exists":true}}'
#' strProjection = '{
#'   "_id":0,
#'   "refId":1,
#'   "createDate":1,
#'   "contexts.BASKET_MODEL.score":1,
#'   "contexts.BASKET_MODEL.items_number":1,
#'   "contexts.BASKET_MODEL.normalizedItems":1
#' }'
#' 
#' mdb = mdb.rmongodb(connData$db_mongodb_pmt_ip, connData$db_mongodb_pmt_port, connData$db_mongodb_pmt_database)
#' 
#' mdb$setColletion("evaluation")
#' 
#' mdb$find(strFind)
#' mdb$projection(strProjection)
#' 
#' i = 1
#' while (mdb$hasNext() && i <= 10) {
#'   json = mdb$getNext()
#'   print(json)
#'   i = i + 1
#' }
#' 
#' mdb$close()
mdb.rmongodb <- function(
  ip,
  port,
  database = NULL,
  user = connData$IAM_user,
  pass = connData$IAM_pass,
  use_log = TRUE
) {
  rmongodb = rmongodb$new(ip, port, database, user, pass, use_log)
  return(rmongodb)
}

#' @export
rmongodb <- R6Class("rmongodb",
  private = list(
    java_rmongodb = NULL,
    java_dbCollection = NULL,
    java_iterable = NULL,
    java_it = NULL,
    row = NULL
  ),
  public = list(
    ip = NULL,
    port = NULL,
    database = NULL,
    collection = NULL,
    use_log = NULL,

    initialize = function(
       ip,
       port,
       database,
       user,
       pass,
       use_log
    ) {
      self$ip <- ip
      self$port <- port
      self$database <- database
      self$use_log <- use_log

      strURI <- mongodbtools::mdb.getURI(ip, port, database, user, pass)
      private$java_rmongodb <- mongodbtools::mdb.connect(strURI, silent=!self$use_log)
      if (!is.null(database)) mongodbtools::mdb.useDatabase(private$java_rmongodb, database, silent=TRUE)
    },

    getIp = function() {
      return(self$ip)
    },

    getPort = function() {
      return(self$port)
    },

    getDatabase = function() {
      return(self$database)
    },

    getColletion = function() {
      return(self$collection)
    },

    setColletion = function(collection) {
      self$collection <- collection
      private$java_dbCollection <- .jrcall(private$java_rmongodb, "getCollection", self$collection)
    },
    
    getRow = function() {
      return(private$row)
    },
    
    showCollections = function() {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]:\n Show Collections \n"))
      results <- .jcall(private$java_rmongodb, "[S", "showCollections")
      return(results)
    },
    
    getMaxRows = function() {
      maxRows <- .jrcall(private$java_rmongodb, "getMaxRows")
      return(maxRows)
    },
    
    setMaxRows = function(maxRows=-1) {
      .jrcall(private$java_rmongodb, "setMaxRows", as.integer(maxRows))
      invisible(NULL)
    },
    
    getDateFormat = function() {
      strDateFormat <- .jrcall(private$java_rmongodb, "getDateFormat")
      return(strDateFormat)
    },
    
    setDateFormat = function(strDateFormat="yyyy-MM-dd HH:mm:ss") {
      # strDateFormat="yyyy-mm-dd HH:mm:ss.SSSSSS"
      .jrcall(private$java_rmongodb, "setDateFormat", strDateFormat)
      invisible(NULL)
    },

    find = function(query, collection = NULL) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$find \n",query))
      if (!is.null(collection)) self$setColletion(collection)
      private$row <- 0
      private$java_iterable <- .jrcall(private$java_rmongodb, "find", private$java_dbCollection, query)
      private$java_it <- .jrcall(private$java_rmongodb, "iterator", private$java_iterable)
    },

    projection = function(query) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$projection \n",query))
      private$row <- 0
      private$java_iterable <- .jrcall(private$java_rmongodb, "projection", private$java_iterable, query)
      private$java_it <- .jrcall(private$java_rmongodb, "iterator", private$java_iterable)
    },

    sort = function(query) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$sort \n",query))
      private$row <- 0
      private$java_iterable <- .jrcall(private$java_rmongodb, "sort", private$java_iterable, query)
      private$java_it <- .jrcall(private$java_rmongodb, "iterator", private$java_iterable)
    },

    skip = function(nSkip) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$skip \n",nSkip))
      private$row <- 0
      private$java_iterable <- .jrcall(private$java_rmongodb, "skip", private$java_iterable, as.integer(nSkip))
      private$java_it <- .jrcall(private$java_rmongodb, "iterator", private$java_iterable)
    },

    hasNext = function() {
      return(.jrcall(private$java_rmongodb, "hasNext", private$java_it))
    },

    getNextRaw = function() {
      private$row <- private$row + 1
      return(.jrcall(private$java_rmongodb, "next", private$java_it))
    },
    
    getNext = function() {
      private$row <- private$row + 1
      # str_json <- .jrcall(private$java_rmongodb, "next", private$java_it)
      # list_json = jsonlite::fromJSON(str_json)
      return(jsonlite::fromJSON(.jrcall(private$java_rmongodb, "next", private$java_it)))
    },
    
    parseJSON = function(json) {
      return(jsonlite::fromJSON(json))
    },
    
    pathToField = function(list_json, path) {
      output = list_json
      for (field in path) output %<>% purrr::map(field)
      return(output)
    },
    
    toCSV = function(strFile, listVars) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$toCSV \n",strFile))
      .jrcall(private$java_rmongodb, "toCSV", private$java_it, as.vector(listVars), strFile)
    },
    
    toCSVRaw = function(strFile) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$toCSVRaw \n",strFile))
      .jrcall(private$java_rmongodb, "toCSV", private$java_it, strFile)
    },
    
    toJSON = function(strFile) {
      if (self$use_log) multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      if (self$use_log) multiplelines.message(paste0("[Query Input]: rmongodb$toJSON \n",strFile))
      .jrcall(private$java_rmongodb, "toJSON", private$java_it, strFile)
    },

    close = function() {
      mongodbtools::mdb.close(private$java_rmongodb, silent=!self$use_log)
    },
    
    finalize = function() {
      mongodbtools::mdb.close(private$java_rmongodb, silent=!self$use_log)
    }
  )
)