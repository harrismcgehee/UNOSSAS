testthat::context("run_sas")

testthat::test_that("run_sas returns tibble",{
  testthat::expect_error(sc <- conn_sas()) #requires username, password, domain, port


  testthat::expect_s3_class(run_sas(sc,"%let i = 1;"), "tbl_df")
  testthat::expect_equal(TRUE, sas_disconnect(sc))
  rm("sc")
})

# stopifnot(length(submitCode)==1L)
# stopifnot(length(sas_conn)==1L)
testthat::test_that("run_sas length error conditions",{
  testthat::expect_error(sc <- conn_sas()) #requires username, password, domain, port

  #0 length
  testthat::expect_error(run_sas(sc, character()),"1L is not TRUE")
  #2 length
  testthat::expect_error(run_sas(sc, c(';', ';')),"1L is not TRUE")

  #0 length
  testthat::expect_error(run_sas(submitCode = ";"),"is missing, with no default")
  #2 length
  testthat::expect_error(run_sas(c(sc,sc), submitCode = ";"),"!is.vector")

  #class(sas_conn)
  testthat::expect_error(run_sas('notconnection',";"),'is not TRUE')

  testthat::expect_equal(TRUE, sas_disconnect(sc))
  rm("sc")
})

# stopifnot(is.character(submitCode))
testthat::test_that("run_sas character parameter error conditions",{
  testthat::expect_error(sc <- conn_sas()) #requires username, password, domain, port

  #NA server
  testthat::expect_error(run_sas(sc,1L), "is.character")

  testthat::expect_equal(TRUE, sas_disconnect(sc))
  rm("sc")
})

#error returns
testthat::test_that("Syntax error returns warning",{
  testthat::expect_error(sc <- conn_sas()) #requires username, password, domain, port

  #NA server
  testthat::expect_message(run_sas(sc,"%lset;"),"Error or warning detected in SAS code.")

  testthat::expect_equal(TRUE, sas_disconnect(sc))
  rm("sc")
})

testthat::test_that("Examples run successfully",{
  testthat::expect_error(sc <- conn_sas()) #requires username, password, domain, port



  sl <- run_sas(sc, "%let i = 1;")
  testthat::expect_s3_class(sl, "tbl_df")
  testthat::expect_false(any(sl$line_type == "Error"))
  testthat::expect_false(any(sl$line_type == "Warning"))
  testthat::expect_equal(tail(sl$log_text,1L),"1          %let i = 1;")

  testthat::expect_error(sl <- run_sas(sc, "%include 'C:/initialize.sas';")) #need path to file that SAS server can read
  testthat::expect_s3_class(sl, "tbl_df")
  testthat::expect_false(any(sl$line_type == "Error"))
  testthat::expect_true(any(sl$line_type == "Warning"))
  testthat::expect_equal(tail(sl$log_text,1L),"NOTE: %INCLUDE (level 1) ending.")

  testthat::expect_equal(TRUE, sas_disconnect(sc))
  rm("sc")
  rm("sl")
})
