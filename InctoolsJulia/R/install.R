# Incidence Estimation Tools (Julia implementation with R interface).
# Copyright (C) 2015-2025, Stellenbosch University, Vitalant,
# Eduard Grebe, and other inddividual contributors.
# Primary author and maintainer: Eduard Grebe <eduard@grebe.consulting>
# Alternative email addresses: <egrebe@vitalant.org> <eduard.grebe@ucsf.edu>
# AI coding assistance by Claude AI (Anthropic)
# Based on original implementation of incidence estimation methods in the
# R package inctools by Alex Welte, Eduard Grebe, Avery McIntosh,
# Petra Bäumler, Simon Daniel and Yuruo Li, with contributions by
# Cari van Schalkwyk, Reshma Kassanjee, Hilmarie Brand,
# Stefano Ongarello and Yusuke Asai.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.  This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.  You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Install r_inctools_julia from GitHub
#'
#' Streamlined installation of the r_inctools_julia R package from GitHub.
#' This function handles installation of the R package and initialization of
#' the Julia backend with all dependencies.
#'
#' @param repo GitHub repository in format "username/repo".
#'   Default: "eduardgrebe/inctools_julia"
#' @param ref Git reference (branch, tag, or commit). Default: "main"
#' @param upgrade Whether to upgrade dependencies. Default: "default"
#' @param force Force reinstallation even if already installed. Default: FALSE
#' @param ... Additional arguments passed to devtools::install_github()
#'
#' @details
#' This function performs the following steps:
#' \enumerate{
#'   \item Checks that Julia is installed and accessible
#'   \item Installs/upgrades the devtools package if needed
#'   \item Installs the r_inctools_julia R package from GitHub
#'   \item Loads the package and initializes the Julia environment
#'   \item Installs all Julia package dependencies (Distributions, DataFrames, etc.)
#'   \item Runs a quick test to verify the installation
#' }
#'
#' @section Requirements:
#' \itemize{
#'   \item R >= 3.5.0
#'   \item Julia >= 1.6
#'   \item Julia must be in your system PATH (run `julia --version` in terminal to verify)
#' }
#'
#' @return Invisible TRUE if installation succeeds, otherwise throws an error
#' @export
#'
#' @examples
#' \dontrun{
#' # Install from default repository (main branch)
#' install_inctools_julia()
#'
#' # Install from a specific branch
#' install_inctools_julia(ref = "develop")
#'
#' # Install from a fork
#' install_inctools_julia(repo = "username/inctools_julia")
#'
#' # Force reinstallation
#' install_inctools_julia(force = TRUE)
#' }
install_inctools_julia <- function(repo = "eduardgrebe/inctools_julia",
                                    ref = "main",
                                    upgrade = "default",
                                    force = FALSE,
                                    ...) {

  cat("\n")
  cat("========================================\n")
  cat("r_inctools_julia Installation\n")
  cat("========================================\n\n")

  # Step 1: Check Julia installation
  cat("Step 1/5: Checking Julia installation...\n")
  julia_path <- Sys.which("julia")
  if (julia_path == "") {
    stop(
      "Julia not found in PATH.\n",
      "Please install Julia from https://julialang.org/downloads/\n",
      "After installation, make sure 'julia' is in your system PATH.\n",
      "Test by running: julia --version"
    )
  }

  julia_version <- system("julia --version", intern = TRUE)
  cat("  \u2713 Found:", julia_version, "\n")
  cat("  \u2713 Path:", julia_path, "\n\n")

  # Step 2: Check/install devtools
  cat("Step 2/5: Checking devtools package...\n")
  if (!requireNamespace("devtools", quietly = TRUE)) {
    cat("  Installing devtools...\n")
    install.packages("devtools")
  }
  cat("  \u2713 devtools available\n\n")

  # Step 3: Install r_inctools_julia from GitHub
  cat("Step 3/5: Installing r_inctools_julia R package from GitHub...\n")
  cat("  Repository:", repo, "\n")
  cat("  Reference:", ref, "\n")

  tryCatch({
    devtools::install_github(
      repo,
      subdir = "r_inctools_julia",
      ref = ref,
      upgrade = upgrade,
      force = force,
      ...
    )
    cat("  \u2713 R package installed successfully\n\n")
  }, error = function(e) {
    stop("Failed to install R package from GitHub:\n  ", e$message)
  })

  # Step 4: Load package and initialize Julia
  cat("Step 4/5: Initializing Julia environment...\n")
  cat("  (This may take 1-2 minutes on first run)\n")

  tryCatch({
    # Load the package
    library(r_inctools_julia)

    # Initialize Julia
    inctools_setup()

    cat("  \u2713 Julia environment initialized\n")
    cat("  \u2713 Inctools.jl package loaded\n")
    cat("  \u2713 All Julia dependencies installed\n\n")
  }, error = function(e) {
    stop("Failed to initialize Julia environment:\n  ", e$message)
  })

  # Step 5: Run verification test
  cat("Step 5/5: Verifying installation...\n")

  verification_passed <- tryCatch({
    # Run a simple test
    test_result <- prevalence(100, 1000)

    # Check if we got a valid result (any non-null result with numeric data)
    if (!is.null(test_result) &&
        (is.numeric(test_result) ||
         (is.list(test_result) && length(test_result) > 0))) {
      cat("  \u2713 Installation verified successfully!\n\n")
      TRUE
    } else {
      cat("  \u26A0 Warning: Verification test returned unexpected result\n\n")
      FALSE
    }
  }, error = function(e) {
    cat("  \u26A0 Warning: Verification test failed:\n")
    cat("    ", e$message, "\n\n")
    FALSE
  })

  # Don't throw warning if verification passed
  if (!verification_passed) {
    message("Note: Installation may have completed successfully despite verification warning.")
    message("Try running: library(r_inctools_julia); prevalence(100, 1000)")
  }

  # Success message
  cat("========================================\n")
  cat("Installation Complete!\n")
  cat("========================================\n\n")
  cat("You can now use r_inctools_julia functions:\n")
  cat("  - prevalence(pos, n, ...)\n")
  cat("  - incprops(...)\n")
  cat("  - inccounts(...)\n")
  cat("  - incdif(...)\n\n")
  cat("For help, see: ?r_inctools_julia or ?prevalence\n\n")

  invisible(TRUE)
}


#' Check r_inctools_julia Installation Status
#'
#' Checks whether r_inctools_julia is properly installed and configured.
#'
#' @param verbose Whether to print detailed status information. Default: TRUE
#'
#' @return Invisible list with status information:
#'   \itemize{
#'     \item \code{r_package_installed}: Logical, whether R package is installed
#'     \item \code{julia_available}: Logical, whether Julia is in PATH
#'     \item \code{julia_version}: Character, Julia version string (or NA)
#'     \item \code{julia_initialized}: Logical, whether Julia environment is initialized
#'     \item \code{inctools_loaded}: Logical, whether Inctools.jl is loaded
#'   }
#' @export
#'
#' @examples
#' \dontrun{
#' # Check installation status
#' check_inctools_installation()
#'
#' # Get status without printing
#' status <- check_inctools_installation(verbose = FALSE)
#' }
check_inctools_installation <- function(verbose = TRUE) {

  status <- list(
    r_package_installed = FALSE,
    julia_available = FALSE,
    julia_version = NA_character_,
    julia_initialized = FALSE,
    inctools_loaded = FALSE
  )

  if (verbose) {
    cat("\n")
    cat("r_inctools_julia Installation Status\n")
    cat("==================================\n\n")
  }

  # Check R package
  status$r_package_installed <- requireNamespace("r_inctools_julia", quietly = TRUE)
  if (verbose) {
    cat("R package (r_inctools_julia):  ",
        ifelse(status$r_package_installed, "\u2713 Installed", "\u2717 Not installed"),
        "\n")
  }

  # Check Julia
  julia_path <- Sys.which("julia")
  status$julia_available <- julia_path != ""
  if (status$julia_available) {
    status$julia_version <- tryCatch(
      system("julia --version", intern = TRUE),
      error = function(e) NA_character_
    )
  }
  if (verbose) {
    cat("Julia executable:           ",
        ifelse(status$julia_available,
               paste0("\u2713 Found (", status$julia_version, ")"),
               "\u2717 Not found in PATH"),
        "\n")
  }

  # Check Julia initialization
  status$julia_initialized <- exists(".inctools_julia_initialized", envir = .GlobalEnv)
  if (verbose) {
    cat("Julia environment:          ",
        ifelse(status$julia_initialized,
               "\u2713 Initialized",
               "\u2717 Not initialized"),
        "\n")
  }

  # Check if Inctools.jl is loaded
  if (status$r_package_installed && status$julia_initialized) {
    status$inctools_loaded <- tryCatch({
      library(r_inctools_julia)
      result <- prevalence(10, 100)
      !is.null(result)
    }, error = function(e) FALSE)
  }

  if (verbose) {
    cat("Inctools.jl package:        ",
        ifelse(status$inctools_loaded,
               "\u2713 Loaded and working",
               "\u2717 Not loaded or not working"),
        "\n\n")

    # Overall status
    all_ok <- all(unlist(status[c("r_package_installed", "julia_available",
                                   "julia_initialized", "inctools_loaded")]))
    if (all_ok) {
      cat("\u2713 All systems operational!\n\n")
    } else {
      cat("\u2717 Some issues detected. Run install_inctools_julia() to fix.\n\n")
    }
  }

  invisible(status)
}
