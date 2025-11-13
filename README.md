# Inctools - Julia and R Implementations

This repository contains two packages for HIV incidence estimation using the Kassanjee method:

1. **Inctools.jl** - Native Julia package
2. **r_inctools_julia** - R package that wraps Inctools.jl

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
├── r_inctools_julia/   # R package
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
source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/r_inctools_julia/R/install.R")
install_inctools_julia()  # Handles everything automatically

# Option 2: Manual installation from local repository (from repository root)
install.packages("r_inctools_julia", repos = NULL, type = "source")
library(r_inctools_julia)

# Use the package
result <- inccounts(1000, 200, 180, 20, 130, 0.01,
                    sigma_mdri = 15, sigma_frr = 0.005, bs = 2000)
```

---

## Package Comparison

| Feature | Inctools.jl (Julia) | r_inctools_julia (R) |
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

### 2. r_inctools_julia (R Package)

**Version:** 0.2.0

**Features:**
- Complete R wrapper for Inctools.jl
- Native R feel with automatic Julia management
- Same performance as Julia (calls Julia backend)
- Familiar R syntax and conventions

**Documentation:** See `r_inctools_julia/README.md`

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
source("https://raw.githubusercontent.com/eduardgrebe/inctools_julia/main/r_inctools_julia/R/install.R")

# Run streamlined installation (handles R package + Julia dependencies)
install_inctools_julia()
```

This automatically:
- Installs the R package from GitHub
- Initializes Julia environment
- Installs all Julia dependencies
- Verifies the installation

**Option 2: Install from local repository**

```r
# From repository root
install.packages("r_inctools_julia", repos = NULL, type = "source")
```

**Option 3: Use installation script**

```bash
cd r_inctools_julia
Rscript install_R_package.R
```

---

## Requirements

### For Inctools.jl
- Julia ≥ 1.6
- Dependencies: DataFrames, Distributions, LinearAlgebra, Statistics

### For r_inctools_julia
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
- Added R package wrapper (r_inctools_julia)
- Comprehensive test suite (9 tests)
- Updated author information

### 0.1.0
- Initial implementation

---

## Citation

If you use these packages, please cite:

```
Kassanjee R, et al. (2012). A new general biomarker-based incidence estimator.
Epidemiology, 23(5), 721-728.
```

---

## Authors

- Eduard Grebe <eduard@grebe.consulting> <egrebe@vitalant.org>
- Claude AI (R wrapper implementation)

---

## License

MIT License

---

## Links

- GitHub: https://github.com/SACEMA/inctools
- R inctools (CRAN): https://cran.r-project.org/package=inctools
