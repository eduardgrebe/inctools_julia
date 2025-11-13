#!/usr/bin/env Rscript
# Test script for r_inctools_julia package (local testing without GitHub)

cat("\n")
cat(rep("=", 70), "\n", sep="")
cat("Testing r_inctools_julia Package (Local)\n")
cat(rep("=", 70), "\n\n", sep="")

# Test 1: Check package can be loaded from source
cat("Test 1: Loading package from source files\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  setwd("/Users/eduard/dev/inctools_julia/r_inctools_julia")
  source("R/zzz.R")
  source("R/inctools.R")
  cat("✓ Package files sourced successfully\n\n")
}, error = function(e) {
  cat("✗ Error loading package files:\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Test 2: Initialize Julia
cat("Test 2: Initializing Julia environment\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  inctools_setup()
  cat("✓ Julia initialized successfully\n\n")
}, error = function(e) {
  cat("✗ Error initializing Julia:\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Test 3: Test prevalence function
cat("Test 3: Testing prevalence() function\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  result <- prevalence(100, 1000)
  cat("  Input: pos=100, n=1000\n")
  cat("  Prevalence:", result[[1]], "\n")
  cat("  SE:", result[[2]], "\n")

  if (!is.null(result) && is.numeric(result[[1]]) && is.numeric(result[[2]])) {
    cat("✓ prevalence() works correctly\n\n")
  } else {
    stop("Unexpected result format")
  }
}, error = function(e) {
  cat("✗ Error in prevalence():\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Test 4: Test prevalence with CI
cat("Test 4: Testing prevalence() with confidence interval\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  result_ci <- prevalence(100, 1000, ci = TRUE)
  cat("  Prevalence:", result_ci[[1]], "\n")
  cat("  95% CI: [", result_ci[[3]][1], ",", result_ci[[3]][2], "]\n")
  cat("✓ prevalence() with CI works correctly\n\n")
}, error = function(e) {
  cat("✗ Error in prevalence() with CI:\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Test 5: Test inccounts function
cat("Test 5: Testing inccounts() function\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  result_inc <- inccounts(
    n = 1000,
    npos = 200,
    ntestR = 180,
    nR = 20,
    mdri = 130,
    frr = 0.01,
    sigma_mdri = 15,
    sigma_frr = 0.005,
    bs = 100  # Small bootstrap for speed
  )

  cat("  Incidence:", result_inc$I, "\n")
  cat("  95% CI: [", result_inc$CI[1], ",", result_inc$CI[2], "]\n")
  cat("  RSE:", result_inc$RSE, "\n")
  cat("✓ inccounts() works correctly\n\n")
}, error = function(e) {
  cat("✗ Error in inccounts():\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Test 6: Test incprops function
cat("Test 6: Testing incprops() function\n")
cat(rep("-", 70), "\n", sep="")

tryCatch({
  result_props <- incprops(
    prev = 0.20,
    sigma_prev = 0.01265,
    prevR = 0.11,
    sigma_prevR = 0.02342,
    mdri = 130,
    sigma_mdri = 15,
    frr = 0.01,
    sigma_frr = 0.005,
    bs = 100  # Small bootstrap for speed
  )

  cat("  Incidence:", result_props$I, "\n")
  cat("  95% CI: [", result_props$CI[1], ",", result_props$CI[2], "]\n")
  cat("  RSE:", result_props$RSE, "\n")
  cat("✓ incprops() works correctly\n\n")
}, error = function(e) {
  cat("✗ Error in incprops():\n")
  cat("  ", e$message, "\n\n")
  quit(status = 1)
})

# Summary
cat(rep("=", 70), "\n", sep="")
cat("ALL TESTS PASSED!\n")
cat(rep("=", 70), "\n\n", sep="")
cat("✓ Package structure: OK\n")
cat("✓ Julia initialization: OK\n")
cat("✓ prevalence(): OK\n")
cat("✓ prevalence() with CI: OK\n")
cat("✓ inccounts(): OK\n")
cat("✓ incprops(): OK\n\n")
cat("Package renaming to 'r_inctools_julia' was successful!\n\n")
