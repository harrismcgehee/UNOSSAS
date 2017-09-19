devtools::use_package("rJava")

#' @title conn_sas will create a SAS connection
#' @name conn_sas
#' @description This function allows you to create a SAS workspace using rJava
#'   and the SAS Java IOM libraries. Once you have the workspace object, you are
#'   able to execute SAS code, read logs, and retrieve results.
#'
#' @param username (string, optional) Name of the user to login to the SAS
#'   server. Default = Sys.getenv("USER")
#' @param host (string) Address to the SAS server.
#' @param password (string) Password for the user.
#' @param domain (string) domain of user for SAS connection
#' @param port (Integer) Port to the SAS Server
#'
#' @author  Harrison McGehee  <harrison.mcgehee@unos.org>
#'
#' @examples
#' \dontrun{
#' sas <- conn_sas()
#' }
#' @return  Returns a \code{SASConnection} object
#' @export
#'
conn_sas <-  function(username = Sys.getenv("USER")
                      , password
                      , domain
                      , host
                      , port){

  onLoad(.libPaths(),"UNOSSAS")


  jclassID = rJava::.jnew("java/lang/String", rJava::.jfield("com/sas/services/connection/Server","S","CLSID_SAS"))

  jhost = rJava::.jnew("java/lang/String", host)
  jserver <- rJava::.jnew("com/sas/services/connection/BridgeServer",jclassID,jhost,port)

  jcxfConfig =  rJava::.jnew("com/sas/services/connection/ManualConnectionFactoryConfiguration",
                             rJava::.jcast(jserver,"com/sas/services/connection/Server" ))

  jcxfManager = rJava::.jnew("com/sas/services/connection/ConnectionFactoryManager")

  jcxf = jcxfManager$getFactory(jcxfConfig)

  jadmin = jcxf$getAdminInterface()
  juserName = rJava::.jnew("java/lang/String",username)

  username <- tolower(username)
  domain <- tolower(domain)

  jpassword = rJava::.jnew("java/lang/String", password)
  jcx = jcxf$getConnection(juserName,jpassword)

  jobj = jcx$getObject()


  jiWorkspace <- c(iWorkspace = rJava::.jcall("com.sas.iom.SAS.IWorkspaceHelper",
                                              "Lcom/sas/iom/SAS/IWorkspace;",
                                              "narrow",
                                              rJava::.jcast(jobj,"org.omg.CORBA.Object"))
                   ,connection = jcx
                   ,admin = jadmin)
  class(jiWorkspace) <- "SASConnection"
  jiWorkspace
}

#' @title sas_disconnect will disconnect a SAS connection
#' @name sas_disconnect
#' @description This function allows you to disconnect a SAS workspace using
#'   rJava and the SAS Java IOM libraries. Once you have the workspace object,
#'   you need to disconnect it from the SAS server after you are done.
#' @param sas_conn (\code{SASConnection}) The connection you want to close.
#' @author  Harrison McGehee  <harrison.mcgehee@unos.org>
#'
#' @examples
#' \dontrun{
#' sas_con <- conn_sas()
#' sas_disconnect(sas_con)
#' }
#' @return  Returns a \code{boolean} of whether it succeeded or failed.
#' @export
#'
sas_disconnect <- function(sas_conn){
  sas_conn$iWorkspace$Close()
  sas_conn$connection$close()
  sas_conn$admin$shutdown()
  sas_conn$admin$destroy()
  TRUE
}
