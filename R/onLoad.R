#' @import rJava
.onLoad <- function(libname, pkgname) {
  tryCatch({
    .jpackage(pkgname, lib.loc = libname)
  }, 
  error = function(e) {
    warning("Error onLoad")
    print(e)
  }
  )
}
