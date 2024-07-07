# The .First function is called after everything else in .Rprofile is executed
.First <- function() {
  # Print a welcome message
  message("Welcome back ", Sys.getenv("USER"), "!\n", "working directory is:", getwd())
}

Sys.setenv(TZ = "Europe/Stockholm")

options(digits = 4) # Number of digits to print. Default is 7, max is 15
options(scipen = 2) # Penalty applied to inhibit the use of scientific notation
options(prompt = "R> ") # change default prompt
options(show.signif.stars = FALSE) # Do not show stars indicating statistical significance in model outputs
options(pkgType = "source") # compile from source
options("pdfviewer" = "xpdf") # change default pdf viewer
options("repos" = c(CRAN = "https://cran.rstudio.com"))

# styler options
options(
  styler.addins_style_transformer = "styler::tidyverse_style(indent_by = 2L, scope = 'spaces')"
)

local({
  n <- parallel::detectCores() # Detect number of CPU cores
  options(Ncpus = n) # Parallel package installation in install.packages()
  options(mc.cores = n) # Parallel apply-type functions via 'parallel' package
})

error <- quote(dump.frames("${R_HOME_USER}/testdump", TRUE)) # Post-mortem debugging facilities
