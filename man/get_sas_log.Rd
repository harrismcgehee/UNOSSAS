% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_sas.R
\name{get_sas_log}
\alias{get_sas_log}
\title{get_sas_log will retrieve the log of the statements just run}
\usage{
get_sas_log(jsasLanguage)
}
\arguments{
\item{jsasLanguage}{(SAS iWorkspace Connection object) Connection to the SAS
server, passed from \code{UNOSSAS::run_sas}.}
}
\value{
Returns a \code{dplyr::data_frame} object of the SAS log
}
\description{
This function gets the SAS log
}
\examples{
\dontrun{
sas_conn <- conn_sas()
sas_log <- get_sas_log(conn_sas())
}
}
\author{
Harrison McGehee  <harrison.mcgehee@unos.org>
}
