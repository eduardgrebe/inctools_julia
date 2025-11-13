source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/inctools.julia/R/install.R")
install_inctools_julia()  # Handles everything automatically

library(inctools.julia)

# Compare results of new package and old package
# Compare inctools and inctools.julia (no bootstrapping)
result_julia <- incprops(
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

result_r <- inctools::incprops(
  PrevH = 0.20,
  RSE_PrevH = 0.01265/0.20,
  PrevR = 0.11,
  RSE_PrevR = 0.02342/0.11,
  MDRI = 130,
  RSE_MDRI = 15/130,
  FRR = 0.01,
  RSE_FRR = 0.005/0.01,
  Boot = FALSE
)

print(result_julia)
print(result_r)
# Pretty much the same

# Compare inctools and inctools.julia (with bootstrapping, no shared seed)
result_julia <- incprops(
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

result_r <- inctools::incprops(
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
)

print(result_julia)
print(result_r)
# Pretty much the same

# Run R test suite
setwd(paste0(getwd(), "/test/"))


# Test package
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
print(result2)

cat(sprintf("Incidence: %.4f\n", result2$I))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", result2$CI[1], result2$CI[2]))
cat(sprintf("RSE: %.4f\n", result2$RSE))

cat("\n", rep("=", 70), "\n", sep = "")
cat("Test 3: Incidence from counts (Bootstrap)\n")
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




