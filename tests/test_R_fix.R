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

# Quick test of the R API fix
# Run from repository root: Rscript tests/test_R_fix.R
source("r_inctools_julia/R/zzz.R")
source("r_inctools_julia/R/inctools.R")

cat("Initializing Julia...\n")
inctools_setup()

cat("\nTest 1: prevalence\n")
result1 <- prevalence(100, 1000)
print(result1)

cat("\nTest 2: prevalence with CI\n")
result2 <- prevalence(100, 1000, ci = TRUE)
print(result2)

cat("\n✓ Tests passed!\n")
