# Inctools - Julia and R Implementations

This repository contains two packages for HIV incidence estimation using the Kassanjee method:

1. **Inctools.jl** - Native Julia package
2. **inctools.julia** - R package that wraps Inctools.jl

Both packages provide identical functionality. Choose based on your environment and needs.

---

## Directory Structure

```
inctools_julia/         # Repository root
├── Inctools/           # Julia package
│   ├── Project.toml    # Julia package manifest
│   ├── src/
│   │   └── Inctools.jl # Main Julia code
│   └── ...
│
├── inctools.julia/   # R package
│   ├── R/              # R wrapper functions
│   ├── inst/           # Installed files
│   │   └── Inctools/   # Symlink to ../Inctools
│   ├── DESCRIPTION     # R package metadata
│   ├── NAMESPACE       # Exported R functions
│   ├── README.md       # R package documentation
│   └── install_R_package.R
│
├── tests/              # Test scripts
│   ├── test_comprehensive.jl
│   ├── test_R_api.R
│   └── ...
│
└── README.md           # This file
```

---

## Quick Start

### For Julia Users

```julia
# From repository root
using Pkg
Pkg.activate("./Inctools")
using Inctools

# Use the package
result = inccounts(1000, 200, 180, 20, 130.0, 0.01,
                   σ_mdri=15.0, σ_frr=0.005, bs=2000)
```

### For R Users

```r
# Option 1: Install from GitHub (recommended)
# First, source the installation function
source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/inctools.julia/R/install.R")
install_inctools_julia()  # Handles everything automatically

# Option 2: Manual installation from local repository (from repository root)
# IMPORTANT: JuliaCall must be installed FIRST when installing from local source
# R does NOT automatically install dependencies when repos = NULL
install.packages("JuliaCall")  # REQUIRED: Install this first!
install.packages("inctools.julia", repos = NULL, type = "source")
library(inctools.julia)

# Use the package
result <- inccounts(1000, 200, 180, 20, 130, 0.01,
                    sigma_mdri = 15, sigma_frr = 0.005, bs = 2000)
```

---

## Package Comparison

| Feature | Inctools.jl (Julia) | inctools.julia (R) |
|---------|---------------------|----------------------|
| **Language** | Pure Julia | R wrapper for Julia |
| **Speed** | Very fast | Very fast (uses Julia) |
| **Installation** | Julia only | Requires Julia + R |
| **API** | Julia syntax | R syntax |
| **Use Case** | Julia projects | R projects |

---

## Package Details

### 1. Inctools.jl (Julia Package)

**Version:** 0.2.0

**Features:**
- Fast Gibbs sampling for diagonal covariance (10-100x faster)
- Rejection sampling for correlated variables
- Bootstrap and Delta method uncertainty estimation
- Arbitrary dimensions support with Gibbs

**Documentation:** See `Inctools/src/Inctools.jl` for comprehensive docstrings

**Key Functions:**
- `prevalence(pos, n, de; ci, α)` - Prevalence estimation
- `incprops(prev, σ_prev, prevR, σ_prevR, mdri, σ_mdri, frr, σ_frr; ...)` - Incidence from proportions
- `inccounts(n, npos, ntestR, nR, mdri, frr; ...)` - Incidence from counts
- `incdif(prev, σ_prev, prevR, σ_prevR, mdri, σ_mdri, frr, σ_frr; ...)` - Test difference between populations
- `rtmvnorm(n, μ, Σ, lower, upper; method)` - Truncated multivariate normal sampling

### 2. inctools.julia (R Package)

**Version:** 0.2.0

**Features:**
- Complete R wrapper for Inctools.jl
- Native R feel with automatic Julia management
- Same performance as Julia (calls Julia backend)
- Familiar R syntax and conventions

**Documentation:** See `inctools.julia/README.md`

**Key Functions:**
- `prevalence(pos, n, de, ci, alpha)` - Prevalence estimation
- `incprops(prev, sigma_prev, prevR, sigma_prevR, mdri, sigma_mdri, frr, sigma_frr, ...)` - Incidence from proportions
- `inccounts(n, npos, ntestR, nR, mdri, frr, ...)` - Incidence from counts
- `incdif(prev, sigma_prev, prevR, sigma_prevR, mdri, sigma_mdri, frr, sigma_frr, ...)` - Test difference between populations

---

## Testing

### Run Julia Tests

```bash
cd tests
julia test_comprehensive.jl
```

### Run R Tests

```bash
cd tests
Rscript test_R_api.R
```

---

## Installation

### Julia Package

```julia
# From repository root
using Pkg
Pkg.activate("./Inctools")
Pkg.instantiate()
```

### R Package

**Option 1: Install from GitHub (Recommended)**

```r
# Source the installation function
source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/inctools.julia/R/install.R")

# Run streamlined installation (handles R package + Julia dependencies)
install_inctools_julia()
```

This automatically:
- Installs the R package from GitHub
- Initializes Julia environment
- Installs all Julia dependencies
- Verifies the installation

**Option 2: Install from local repository**

> **⚠️ IMPORTANT**: When installing from local source with `repos = NULL`, R does **NOT** automatically install dependencies from CRAN. You **MUST** install JuliaCall first, or the installation will fail.

```r
# From repository root
# Step 1: Install JuliaCall from CRAN (REQUIRED!)
install.packages("JuliaCall")

# Step 2: Install inctools.julia from local source
install.packages("inctools.julia", repos = NULL, type = "source")
```

**Option 3: Use installation script**

```bash
cd inctools.julia
Rscript install_R_package.R
```

---

## Requirements

### For Inctools.jl
- Julia ≥ 1.6
- Dependencies: DataFrames, Distributions, LinearAlgebra, Statistics

### For inctools.julia
- Julia ≥ 1.6
- R ≥ 3.5.0
- R package: JuliaCall ≥ 0.17.0

---

## Version History

### 0.2.0 (2025-11-13)
- Refactored rtmvnorm to use Gibbs sampling by default
- Added comprehensive docstrings (378 lines)
- Fixed typos in error messages
- Standardized parameter naming (cov → covar)
- Fixed bugs in inccounts (parameter passing)
- Added R package wrapper (inctools.julia)
- Comprehensive test suite (9 tests)
- Updated author information

### 0.1.0
- Initial implementation

---

## Authors

- Eduard Grebe <eduard@grebe.consulting> <egrebe@vitalant.org>
- Claude AI (R wrapper implementation)

---

## License

GNU General Public License (v3)

---

## Citation

If you use these packages, please cite:

```
Grebe E. (2025). Inctools.jl: Incidence Estimation Tools (v0.2.0).
https://github.com/eduardgrebe/inctools_julia.
```

You could additionally cite the original R package:

```
Grebe E, Bäumler P, Juwara L, McIntosh AI, Ongarello S, Welte A. (2019).
inctools (v1.0.15). Zenodo. https://doi.org/10.5281/zenodo.3594197.
```

And for the underlying method you should cite:

```
Kassanjee R, McWalter TA, Bärnighausen T, Welte A. (2012).
A new general biomarker-based incidence estimator. Epidemiology.
23(5):721-8. https://doi.org/10.1097/EDE.0b013e3182576c07.
```

---

## Links

- R inctools (Github): https://github.com/SACEMA/inctools
- R inctools (CRAN): https://cran.r-project.org/package=inctools
