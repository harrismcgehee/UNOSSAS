# usethis::use_package("rJava")
# usethis::use_package("magrittr")

# https://github.com/CeON/rJavaPackageExample/blob/75ec9679d0c1f8ddd67ac84d2cf16c0680f712f5/R/onLoad.R

## Hook function that will be run immediately after loading the package
onLoad <- function(libname, pkgname) {
  options(java.parameters = "-Xmx10g")
  # requireNamespace("rJava", quietly = TRUE)

  ## Initilize JVM and add all jar files in the "java" directory
  ## to the classpath. The "java" directory is where jar files are copied to
  ## from "inst/java" directory in the binary package version of the project.
  rJava::.jpackage(pkgname, lib.loc = libname)
  ## Add all jar files in the "inst/java" directory to the classpath as
  ## well. This is a kind of workaround for the source package and
  ## bundle package version of the project where jar files are in
  ## "inst/java" directory.
  ##
  ## The source and bundle package directory structure is used when two useful
  ## functions: `devtools::load_all()` and `devtools::test()` are executed.
  ## This workaround is not needed however when you run `devtools::check()` or
  ## `R CMD check` from command line or when you use this package from a
  ## third-party code when it is already installed in the system.
  ## It is not needed in these cases because the binary package directory
  ## structure is used.
  rJava::.jaddClassPath(dir(file.path(getwd(), "inst/java"), full.names = TRUE))
  rJava::.jaddClassPath(file.path(getwd(), "inst/java"))

}


#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
