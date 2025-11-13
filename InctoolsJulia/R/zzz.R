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

# Package initialization
.onLoad <- function(libname, pkgname) {
  # Check if JuliaCall is available
  if (!requireNamespace("JuliaCall", quietly = TRUE)) {
    stop("Package 'JuliaCall' is required but not installed. Install it with: install.packages('JuliaCall')")
  }

  packageStartupMessage("Loading Inctools.jl Julia package...")
  packageStartupMessage("Note: First run may take time to precompile Julia packages.")
}

# Initialize Julia and load Inctools package
.inctools_julia_setup <- function() {
  if (!exists(".inctools_julia_initialized", envir = .GlobalEnv)) {
    # Initialize Julia
    julia <- JuliaCall::julia_setup()

    # Get the path to the Inctools.jl package
    # When installed: inst/Inctools becomes <package-root>/Inctools
    pkg_path <- system.file("Inctools", package = "InctoolsJulia", mustWork = FALSE)

    if (pkg_path == "") {
      # If not installed as R package, try common development locations
      # 1. Try ../Inctools (from InctoolsJulia/ directory)
      # 2. Try ../../Inctools (from InctoolsJulia/R/ when sourcing)
      possible_paths <- c(
        file.path(getwd(), "..", "Inctools"),
        file.path(getwd(), "Inctools"),
        file.path(dirname(getwd()), "Inctools")
      )

      for (path in possible_paths) {
        if (dir.exists(path)) {
          pkg_path <- normalizePath(path)
          break
        }
      }

      if (pkg_path == "" || !dir.exists(pkg_path)) {
        stop("Cannot find Inctools.jl package directory. ",
             "Make sure you are in the repository root or install the package properly.")
      }
    }

    # Activate the Inctools.jl project
    JuliaCall::julia_eval(sprintf('using Pkg; Pkg.activate("%s")', pkg_path))

    # Install all Julia dependencies (if not already installed)
    message("Installing Julia dependencies (first run only)...")
    JuliaCall::julia_eval("using Pkg; Pkg.instantiate()")

    # Load Inctools.jl
    JuliaCall::julia_eval("using Inctools")

    assign(".inctools_julia_initialized", TRUE, envir = .GlobalEnv)
    message("Inctools.jl loaded successfully!")
  }
}
