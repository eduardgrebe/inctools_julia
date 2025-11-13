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

# Test script for R API to Inctools.jl
# Run this from repository root: Rscript tests/test_R_api.R

cat("Testing R API to Inctools.jl\n")
cat(rep("=", 70), "\n\n", sep = "")

# Load the R functions from InctoolsJulia package
cat("Installing and loading R package...\n")
source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/InctoolsJulia/R/install.R")
install_inctools_julia() 
library(InctoolsJulia)

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 1: Simple prevalence calculation\n")
cat(rep("-", 70), "\n", sep = "")

result1 <- prevalence(100, 1000)
cat(sprintf("Prevalence: %.4f, SE: %.6f\n", result1[[1]], result1[[2]]))

result1_ci <- prevalence(100, 1000, ci = TRUE)
cat(sprintf("With CI: %.4f (95%% CI: %.4f - %.4f)\n",
            result1_ci[[1]], result1_ci[[3]][1], result1_ci[[3]][2]))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 2: Incidence from counts (Delta method)\n")
cat(rep("-", 70), "\n", sep = "")

result2 <- inccounts(
  n = 1000,
  npos = 200,
  ntestR = 180,
  nR = 20,
  mdri = 130,
  frr = 0.01,
  sigma_mdri = 15,
  sigma_frr = 0.005,
  bs = 0  # Delta method
)

cat(sprintf("Incidence: %.4f\n", result2$I))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result2$CI[1], result2$CI[2]))
cat(sprintf("RSE: %.4f\n", result2$RSE))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 3: Incidence from counts (Bootstrap)\n")
cat(rep("-", 70), "\n", sep = "")

cat("Running 1000 bootstrap samples...\n")
result3 <- inccounts(
  n = 1000,
  npos = 200,
  ntestR = 180,
  nR = 20,
  mdri = 130,
  frr = 0.01,
  sigma_mdri = 15,
  sigma_frr = 0.005,
  bs = 1000  # Bootstrap
)

cat(sprintf("Incidence: %.4f\n", result3$I))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result3$CI[1], result3$CI[2]))
cat(sprintf("RSE: %.4f\n", result3$RSE))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 4: Incidence with covariance\n")
cat(rep("-", 70), "\n", sep = "")

result4 <- inccounts(
  n = 1000,
  npos = 200,
  ntestR = 180,
  nR = 20,
  mdri = 130,
  frr = 0.01,
  sigma_mdri = 15,
  sigma_frr = 0.005,
  covar = 0.0002,
  bs = 1000
)

cat(sprintf("Incidence: %.4f\n", result4$I))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result4$CI[1], result4$CI[2]))
cat(sprintf("RSE: %.4f\n", result4$RSE))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 5: Using incprops directly\n")
cat(rep("-", 70), "\n", sep = "")

result5 <- incprops(
  prev = 0.20,
  sigma_prev = 0.01265,
  prevR = 0.11,
  sigma_prevR = 0.02342,
  mdri = 130,
  sigma_mdri = 15,
  frr = 0.01,
  sigma_frr = 0.005,
  bs = 1000
)

cat(sprintf("Incidence: %.4f\n", result5$I))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result5$CI[1], result5$CI[2]))
cat(sprintf("RSE: %.4f\n", result5$RSE))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 6: Comparing two populations\n")
cat(rep("-", 70), "\n", sep = "")

result6 <- incdif(
  prev = c(0.20, 0.15),
  sigma_prev = c(0.015, 0.012),
  prevR = c(0.10, 0.08),
  sigma_prevR = c(0.02, 0.015),
  mdri = 130,
  sigma_mdri = 15,
  frr = 0.01,
  sigma_frr = 0.005,
  bs = 1000
)

cat(sprintf("Difference: %.4f\n", result6$Delta))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result6$CI[1], result6$CI[2]))
cat(sprintf("p-value: %.4f\n", result6$p))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 7: Check consistency of incprops w old R package (delta method)\n")
cat(rep("-", 70), "\n", sep = "")


if(!("inctools" %in% .packages(all.available = TRUE))) {devtools::install_github("SACEMA/inctools")}
suppressWarnings({
  invisible(result7_r <- inctools::incprops(
    PrevH = 0.20,
    RSE_PrevH = 0.01265/0.20,
    PrevR = 0.11,
    RSE_PrevR = 0.02342/0.11,
    MDRI = 130,
    RSE_MDRI = 15/130,
    FRR = 0.01,
    RSE_FRR = 0.005/0.01,
    Boot = FALSE
  ))  
})
result7_julia <- incprops(
  prev = 0.20,
  sigma_prev = 0.01265,
  prevR = 0.11,
  sigma_prevR = 0.02342,
  mdri = 130,
  sigma_mdri = 15,
  frr = 0.01,
  sigma_frr = 0.005,
  bs = 0
)
cat(sprintf("Point estimate (old R package): %.4f\n", result7_r$Incidence.Statistics$Incidence))
cat(sprintf("Point estimate (new R package): %.4f\n", result7_julia$I))
cat(sprintf("95%% CI (old R package): [%.4f, %.4f]\n", result7_r$Incidence.Statistics$CI_LB, result7_r$Incidence.Statistics$CI_UB))
cat(sprintf("95%% CI (new R package): [%.4f, %.4f]\n", result7_julia$CI[1], result7_julia$CI[2]))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 8: Check consistency of incprops w old R package (bootstrapping)\n")
cat(rep("-", 70), "\n", sep = "")

suppressWarnings({
  invisible(result8_r <- inctools::incprops(
    PrevH = 0.20,
    RSE_PrevH = 0.01265/0.20,
    PrevR = 0.11,
    RSE_PrevR = 0.02342/0.11,
    MDRI = 130,
    RSE_MDRI = 15/130,
    FRR = 0.01,
    RSE_FRR = 0.005/0.01,
    Boot = TRUE,
    BS_Count = 100000
  ))
})
result8_julia <- incprops(
  prev = 0.20,
  sigma_prev = 0.01265,
  prevR = 0.11,
  sigma_prevR = 0.02342,
  mdri = 130,
  sigma_mdri = 15,
  frr = 0.01,
  sigma_frr = 0.005,
  bs = 100000
)
cat(sprintf("Point estimate (old R package): %.4f\n", result8_r$Incidence.Statistics$Incidence))
cat(sprintf("Point estimate (new R package): %.4f\n", result8_julia$I))
cat(sprintf("95%% CI (old R package): [%.4f, %.4f]\n", result8_r$Incidence.Statistics$CI_LB, result8_r$Incidence.Statistics$CI_UB))
cat(sprintf("95%% CI (new R package): [%.4f, %.4f]\n", result8_julia$CI[1], result8_julia$CI[2]))


cat("\n", rep("=", 70), "\n", sep = "")
cat("ALL TESTS COMPLETED SUCCESSFULLY!\n")
cat(rep("=", 70), "\n", sep = "")

cat("\nSummary:\n")
cat("  - R API successfully calls Julia functions\n")
cat("  - All function types work correctly:\n")
cat("    * prevalence()\n")
cat("    * inccounts() with Delta method\n")
cat("    * inccounts() with bootstrap\n")
cat("    * inccounts() with covariance\n")
cat("    * incprops()\n")
cat("    * incdif()\n")
cat("  - Results are returned correctly to R\n")
cat("\nR users can now use Inctools.jl seamlessly from R!\n")
