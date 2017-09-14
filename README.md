# UNOSSAS

UNOSSAS is an R package developed to connect our RStudio Server to our SAS Server. 

At the [United Network for Organ Sharing](https://www.unos.org/) (UNOS), we recognized a need to run legacy SAS code from RStudio Server as part of our data pipelines in reproducible workflows.  Our server-based platforms required us to develop a solution than didn't rely on a system command.  Our solution was to create a package that encapsulates the SAS-provided [SAS Foundation Services Java libraries](https://support.sas.com/downloads/package.htm?pid=305) with [rJava](https://cran.r-project.org/web/packages/rJava/index.html) to connect to the SAS Workspace Server. The package creates a connection to the Windows-based SAS server from our Linux-based RStudio Server, passes SAS code to the server using that connection, and returns the SAS log file to the user as a [tibble](http://tibble.tidyverse.org/) to aid error or warning detection.  Intermediate SAS data sets can be referenced until the workspace connection is closed, however the interface is best suited for batch execution.  SAS datasets can then be accessed in R by first writing to `csv`, `sas7bdat`, or database. Additional benefits of this setup are that our RStudio Server enables all users to schedule scripts using crontab via [cronR](https://github.com/bnosac/cronR) whereas our SAS Server does not. This enables all users to schedule both SAS and R jobs.  Also, with this setup we are able to utilize the Windows Active Directory of the SAS Server to perform file operations on drives that are inaccessible to the RStudio Server for security reasons.  Future improvements would allow SAS datasets to be directly available in the R environment and R `data.frames` available in the SAS workspace. We welcome any feedback or collaboration to prepare the package for public release.

# To use (an incomplete guide)
+ You will need to place 4 files in `inst/java`  
    + `sas.core.jar`
    + `sas.security.jar`
    + `sas.svc.connection.jar`
    + `log4j-1.2.17.jar`
+ You will also want to modify the `R/conn_sas.R` to set defaults for your environments.
+ You should update the `tests` folder
    + `tests/testthat/test_run_sas.R`  
        + `conn_sas()` calls need connection parameters  
        + `run_sas(sc, "%include 'C:/initialize.sas';")` needs an actual file that SAS Server can read  
    + `tests/testthat.R` is commented out
