% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_sas.R
\name{run_sas}
\alias{run_sas}
\title{run_sas will execute SAS code on your workspace connection}
\usage{
run_sas(sas_conn, submitCode)
}
\arguments{
\item{sas_conn}{(SASConnection object) Connection to the SAS
server, retrieved from \code{UNOSSAS::conn_sas}.}

\item{submitCode}{(string) Code to send to the SAS server to run.}
}
\value{
Returns a \code{SAS iWorkspace} object
}
\description{
This function allows you to run SAS code on a SAS workspace
  connection using rJava and the SAS Java IOM libraries. The easiest thing to
  run is %include and %let style commands, but you can pass any
  string for SAS to execute.
}
\examples{
\dontrun{
sc <- conn_sas()
sas_log1 <- run_sas(sc, "\%let i = 1;")
sas_log2 <- run_sas(sc, "\%include 'C:/sourcelibs/include/initialize.sas'")
sas_disconnect(sc)
}
}
\author{
Harrison McGehee  <harrison.mcgehee@unos.org>
}
