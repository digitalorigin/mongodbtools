# roxygen2::roxygenise()
library(R6)

#' @title mdb.rmongodb
#' @export
mdb.rmongodb <- function(
  ip,
  port,
  database = NULL,
  user = connData$IAM_user,
  pass = connData$IAM_pass
) {
  rmongodb = rmongodb$new(ip, port, database, user, pass)
  return(rmongodb)
}

#' @export
rmongodb <- R6Class("rmongodb",
  private = list(
    con = NULL,
    cursor = NULL,
    strFind = NULL
  ),
  public = list(
    ip = NULL,
    port = NULL,
    database = NULL,
    collection = NULL,
    
    initialize = function(
       ip,
       port,
       database,
       user,
       pass
    ) {
      self$ip <- ip
      self$port <- port
      self$database <- database
      
      strURI <- mongodbtools::mdb.getURI(ip, port, database, user, pass)
      private$con <- mongodbtools::mdb.connect(strURI)
      if (!is.null(database)) mongodbtools::mdb.useDatabase(private$con, database)
    },
    
    setColletion = function(collection) {
      self$collection <- collection
    },
    
    getColletion = function() {
      return(self$collection)
    },
    
    getQuery = function() {
      return(private$strFind)
    },
    
    find = function(query, collection = NULL) {
      multiplelines.message(paste0("[Query Time]: ",format(Sys.time(), "%Y%m%d_%H_%M_%S"),"\n"))
      multiplelines.message(paste0("[Query Input]: rmongodb$find \n",query))
      private$strFind <- query
      if (!is.null(collection)) self$collection <- collection
      private$cursor <- .jrcall(private$con, "find", self$collection, query)
    },
    
    hasNext = function() {
      return(.jrcall(private$con, "hasNext", private$cursor))
    },
    
    getNext = function(parse = TRUE) {
      str_json <- .jrcall(private$con, "next", private$cursor)
      if (!parse) {
        return(str_json)
      } else {
        list_json = jsonlite::fromJSON(str_json)
        return(list_json)
      }
    },
    
    close = function() {
      mongodbtools::mdb.close(private$con)
    }
  )
)