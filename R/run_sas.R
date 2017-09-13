devtools::use_package("utils")
devtools::use_package("rJava")


#' @title run_sas will execute SAS code on your workspace connection
#' @name run_sas
#' @description This function allows you to run SAS code on a SAS workspace
#'   connection using rJava and the SAS Java IOM libraries. The easiest thing to
#'   run is %include and %let style commands, but you can pass any
#'   string for SAS to execute.
#' @param sas_conn (SASConnection object) Connection to the SAS
#'   server, retrieved from \code{UNOSSAS::conn_sas}.
#' @param submitCode (string) Code to send to the SAS server to run.
#' @author  Harrison McGehee  <harrison.mcgehee@unos.org>
#'
#' @examples
#' \dontrun{
#' sc <- conn_sas()
#' sas_log1 <- run_sas(sc, "%let i = 1;")
#' sas_log2 <- run_sas(sc, "%include 'C:/sourcelibs/include/initialize.sas'")
#' sas_disconnect(sc)
#' }
#' @return  Returns a \code{SAS iWorkspace} object
#' @export
#'
run_sas <-  function(sas_conn
                     , submitCode
){
  stopifnot(length(submitCode)==1L)
  stopifnot(!is.vector(sas_conn))
  stopifnot(class(sas_conn) == "SASConnection")
  stopifnot(is.character(submitCode))

  onLoad(.libPaths(),"UNOSSAS")
  # rJava::.jpackage("UNOS")

  jsasLanguage <- sas_conn$iWorkspace$LanguageService()
  jsasLanguage$Submit(submitCode)
  sl <- get_sas_log(jsasLanguage)

  if(any(sl$line_type=="Error")){
    warning("Error detected in SAS code.")
    utils::View(sl)
  }
  if(any(sl$line_type=="Warning")){
    message("Error or warning detected in SAS code.")
  }
  sl
}

devtools::use_package("purrr")
devtools::use_package("dplyr")

#' @title get_sas_log will retrieve the log of the statements just run
#' @name get_sas_log
#' @description This function gets the SAS log
#' @param jsasLanguage (SAS iWorkspace Connection object) Connection to the SAS
#'   server, passed from \code{UNOSSAS::run_sas}.
#' @author  Harrison McGehee  <harrison.mcgehee@unos.org>
#'
#' @examples
#' \dontrun{
#' sas_conn <- conn_sas()
#' sas_log <- get_sas_log(conn_sas())
#' }
#' @return  Returns a \code{dplyr::data_frame} object of the SAS log
#'
get_sas_log <- function(jsasLanguage){
  onLoad(.libPaths(),"UNOSSAS")
  ccsh = rJava::.jnew("com.sas.iom.SAS.ILanguageServicePackage.CarriageControlSeqHolder")
  ltsh = rJava::.jnew("com.sas.iom.SAS.ILanguageServicePackage.LineTypeSeqHolder")
  ssh = rJava::.jnew("com.sas.iom.SASIOMDefs.StringSeqHolder")

  jsasLanguage$FlushLogLines(1E7L, ccsh, ltsh, ssh)

  lineLookup <- c(
    "Normal"
    ,"Hilighted"
    ,"Source"
    ,"Title"
    ,"Byline"
    ,"Error"
    ,"Warning"
    ,"Note"
    ,"Message")

  spaceTypeLookup <- c(
    "Normal"
    ,	"NewPage"
    ,	"OverPrint"
    ,	"SkipLine"
    ,	"SkipTwoLines")


  # add 1 because the Java values start at 0 and R vector starts at 1.
  dplyr::data_frame(cc=ccsh$value, lt=ltsh$value, log_text= ssh$value) %>%
    dplyr::mutate(space_type = spaceTypeLookup[purrr::map_int(cc, ~rJava::.jcall(.x,"I","value"))+1]
                  , line_type = lineLookup[purrr::map_int(lt, ~rJava::.jcall(.x,"I","value"))+1]) %>%
    dplyr::select(space_type, line_type, log_text)
}
