#!/usr/bin/env Rscript

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

# Installation script for inctools.julia R package

cat("inctools.julia - R Interface to Inctools.jl\n")
cat("Package Installation\n")
cat(rep("=", 70), "\n\n", sep = "")

# Check R version
cat("Checking R version...\n")
r_version <- getRversion()
if (r_version < "3.5.0") {
  stop("R version 3.5.0 or higher is required. You have: ", R.version.string)
}
cat("  OK: ", R.version.string, "\n\n")

# Install JuliaCall if needed
cat("Checking for JuliaCall package...\n")
if (!requireNamespace("JuliaCall", quietly = TRUE)) {
  cat("  Installing JuliaCall...\n")
  install.packages("JuliaCall")
  cat("  OK: JuliaCall installed\n\n")
} else {
  cat("  OK: JuliaCall already installed\n\n")
}

# Check Julia installation
cat("Checking for Julia...\n")
julia_path <- Sys.which("julia")
if (julia_path == "") {
  cat("  WARNING: Julia not found in PATH\n")
  cat("  Please install Julia from: https://julialang.org/downloads/\n")
  cat("  After installation, make sure 'julia' is in your PATH\n\n")
  cat("  To test if Julia is accessible, run in terminal:\n")
  cat("    julia --version\n\n")
  stop("Julia not found. Please install Julia and try again.")
} else {
  # Get Julia version
  julia_version <- system("julia --version", intern = TRUE)
  cat("  OK: ", julia_version, "\n")
  cat("  Path: ", julia_path, "\n\n")
}

# Initialize JuliaCall to verify it works
cat("Testing JuliaCall connection to Julia...\n")
tryCatch({
  julia <- JuliaCall::julia_setup()
  julia_ver <- JuliaCall::julia_eval("VERSION")
  cat("  OK: Successfully connected to Julia v", as.character(julia_ver), "\n\n")
}, error = function(e) {
  cat("  ERROR: Failed to connect to Julia\n")
  cat("  Error message: ", e$message, "\n\n")
  stop("JuliaCall setup failed")
})

# Check if Inctools.jl package exists
cat("Checking for Inctools.jl package...\n")
# Try to find Inctools in common locations
possible_paths <- c(
  file.path(getwd(), "..", "Inctools"),  # From inctools.julia/ directory
  file.path(getwd(), "Inctools"),        # From repository root
  file.path(dirname(getwd()), "Inctools") # From subdirectory
)

inctools_path <- NULL
for (path in possible_paths) {
  if (dir.exists(path)) {
    inctools_path <- normalizePath(path)
    break
  }
}

if (is.null(inctools_path)) {
  cat("  ERROR: Inctools.jl directory not found\n")
  cat("  Tried locations:\n")
  for (p in possible_paths) {
    cat("    - ", p, "\n")
  }
  cat("\n  Please run this script from repository root or inctools.julia/ directory\n\n")
  stop("Inctools.jl package not found")
}
cat("  OK: Found Inctools.jl at: ", inctools_path, "\n\n")

# Activate and precompile Inctools.jl
cat("Activating and precompiling Inctools.jl...\n")
cat("  (This may take 1-2 minutes on first run)\n")
tryCatch({
  JuliaCall::julia_eval(sprintf('using Pkg; Pkg.activate("%s")', inctools_path))
  cat("  Installing Julia dependencies...\n")
  JuliaCall::julia_eval("using Pkg; Pkg.instantiate()")
  cat("  Loading Inctools.jl...\n")
  JuliaCall::julia_eval("using Inctools")
  cat("  OK: Inctools.jl loaded successfully\n\n")
}, error = function(e) {
  cat("  ERROR: Failed to load Inctools.jl\n")
  cat("  Error message: ", e$message, "\n\n")
  stop("Inctools.jl loading failed")
})

cat(rep("=", 70), "\n", sep = "")
cat("INSTALLATION SUCCESSFUL!\n")
cat(rep("=", 70), "\n\n", sep = "")

cat("Next steps:\n")
cat("  1. To use the package, source the R files (from inctools.julia/ directory):\n")
cat("       source('R/zzz.R')\n")
cat("       source('R/inctools.R')\n\n")
cat("  2. Or install as an R package (from repository root):\n")
cat("       install.packages('inctools.julia', repos = NULL, type = 'source')\n\n")
cat("  3. Run the test script (from repository root):\n")
cat("       Rscript tests/test_R_api.R\n\n")
cat("  4. See inctools.julia/README.md for usage examples\n\n")

cat("Happy analyzing!\n")
