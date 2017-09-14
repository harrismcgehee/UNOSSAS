# UNOSSAS

UNOSSAS is a package developed to connect RStudio Server to a SAS Server.

At the [United Network for Organ Sharing](https://www.unos.org/) (UNOS), we recognized a need to run legacy SAS code from RStudio Server as part of our data pipelines in reproducible workflows.  Our server-based platforms required us to develop a solution than didn't rely on a system command.  Our solution was to create a package that encapsulates the SAS-provided [SAS Foundation Services Java libraries](https://support.sas.com/downloads/package.htm?pid=305) with [rJava](https://cran.r-project.org/web/packages/rJava/index.html) to connect to the SAS Workspace Server. The package creates a connection to the Windows-based SAS server from our Linux-based RStudio Server; passes SAS code to the server using that connection; and returns the SAS log file to the user as a [tibble](http://tibble.tidyverse.org/) to aid error or warning detection.  Intermediate SAS data sets can be referenced until the connection is closed, however the interface is best suited for batch execution. SAS data sets can then be accessed in R by first writing to `csv`, `sas7bdat`, or database. Additionally, this solution enables all users to schedule R and SAS jobs using crontab via [cronR](https://github.com/bnosac/cronR) because our SAS Server does not allow users to schedule jobs. Also, with this setup we are able to utilize the Windows Active Directory of the SAS Server to perform file operations on drives that are inaccessible to the RStudio Server for security reasons. Future improvements would allow SAS data sets to be directly available in the R environment and R `data.frames` to be available to the SAS workspace. We welcome any feedback or collaboration to prepare the package for public release.

# To install
+ You will need to place 3 files in `inst/java` provided by SAS
    + `sas.core.jar`
    + `sas.security.jar`
    + `sas.svc.connection.jar`
+ You will need to place 1 file in `inst/java` available [here](https://logging.apache.org/log4j/1.2/download.html).
    + `log4j-1.2.17.jar`
+ You will also want to modify the `R/conn_sas.R` to set defaults for your environments.
+ You should update the `tests` folder
    + `tests/testthat/test_run_sas.R`  
        + `conn_sas()` calls need connection parameters  
        + `run_sas(sc, "%include 'C:/initialize.sas';")` needs an actual file that SAS Server can read  
    + `tests/testthat.R` is commented out
