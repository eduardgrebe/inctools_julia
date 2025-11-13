# Test Files Update for New Directory Structure

**Date:** 2025-11-13
**Status:** ✅ Complete

---

## Changes Made

Updated all test scripts to work with the new directory structure where:
- Julia package is in `Inctools/` subdirectory
- R package is in `InctoolsJulia/` subdirectory
- Test files are in `tests/` subdirectory
- Tests are run from repository root (or `tests/` for Julia)

---

## Files Updated

### Julia Test Files (4 files)

Added smart path detection to all Julia tests:

**Files:**
- `tests/test_comprehensive.jl`
- `tests/test_rtmvnorm.jl`
- `tests/test_gibbs_vs_rejection.jl`
- `tests/test_covar_deprecation.jl`

**Before:**
```julia
using Pkg
Pkg.activate("./Inctools")
using Inctools
```

**After:**
```julia
using Pkg

# Find Inctools package (works from repository root or tests/ directory)
inctools_path = isdir("./Inctools") ? "./Inctools" : "../Inctools"
if !isdir(inctools_path)
    error("Cannot find Inctools package. Run this from repository root.")
end
Pkg.activate(inctools_path)

using Inctools
```

**Result:** Julia tests now work from both repository root and `tests/` directories!

### R Test Files (2 files)

### 1. `tests/test_R_api.R`

**Before:**
```r
source("R/zzz.R")
source("R/inctools.R")
```

**After:**
```r
source("r_inctools_julia/R/zzz.R")
source("r_inctools_julia/R/inctools.R")
```

### 2. `tests/test_R_fix.R`

**Before:**
```r
source("R/zzz.R")
source("R/inctools.R")
```

**After:**
```r
source("r_inctools_julia/R/zzz.R")
source("r_inctools_julia/R/inctools.R")
```

---

## Usage

### Running Julia Tests

**Option 1: From repository root**
```bash
julia tests/test_comprehensive.jl
julia tests/test_rtmvnorm.jl
julia tests/test_gibbs_vs_rejection.jl
julia tests/test_covar_deprecation.jl
```

**Option 2: From tests/ directory**
```bash
cd tests
julia test_comprehensive.jl
julia test_rtmvnorm.jl
julia test_gibbs_vs_rejection.jl
julia test_covar_deprecation.jl
```

### Running R Tests

**From repository root (required):**
```bash
Rscript tests/test_R_api.R
Rscript tests/test_R_fix.R
```

---

## Directory Structure Expected by Tests

```
inctools_julia/                # ← Run all tests from here (repository root)
├── Inctools/                  # Julia package
│   ├── Project.toml
│   └── src/Inctools.jl
│
├── r_inctools_julia/          # R package
│   ├── R/
│   │   ├── zzz.R              # ← R tests source this
│   │   └── inctools.R         # ← R tests source this
│   ├── inst/
│   │   └── Inctools -> ../../Inctools
│   └── DESCRIPTION
│
└── tests/                     # All test files
    ├── test_comprehensive.jl
    ├── test_R_api.R           # ← Updated
    ├── test_R_fix.R           # ← Updated
    └── ...
```

---

## Path Resolution

### Julia Tests

**From repository root:**
- Checks `./Inctools` → Found ✓
- Activates `./Inctools`

**From tests/ directory:**
- Checks `./Inctools` → Not found
- Checks `../Inctools` → Found ✓
- Activates `../Inctools`

### R Tests

**From repository root (required):**
- `r_inctools_julia/R/zzz.R` → Resolves to correct file ✓
- `r_inctools_julia/R/inctools.R` → Resolves to correct file ✓

The R functions in `zzz.R` then find the Julia package:
- Checks `../Inctools` (from `r_inctools_julia/`)
- Finds `Inctools/Project.toml` ✓

---

## Verification

### Verify Julia Tests

```bash
# From repository root
$ julia tests/test_comprehensive.jl
  Activating project at `.../inctools_julia/Inctools`
Comprehensive Inctools Testing
======================================================================
[9 tests pass]

# From tests/ directory
$ cd tests
$ julia test_comprehensive.jl
  Activating project at `.../inctools_julia/Inctools`
Comprehensive Inctools Testing
======================================================================
[9 tests pass]
```

### Verify R Tests

```bash
# From repository root
$ Rscript tests/test_R_api.R
Testing R API to Inctools.jl
======================================================================
Loading R functions...
Initializing Julia...
[6 tests pass]
```

---

## Notes

- **Julia tests** now have smart path detection
  - Work from repository root (uses `./Inctools`)
  - Work from `tests/` directory (uses `../Inctools`)
  - Automatic detection with clear error if run from wrong location
- **R tests** must be run from repository root
  - They use relative paths to `InctoolsJulia/R/`
  - R's `zzz.R` also has smart path detection for finding Inctools

---

## Checklist

### Julia Tests
- [x] Added smart path detection to `test_comprehensive.jl`
- [x] Added smart path detection to `test_rtmvnorm.jl`
- [x] Added smart path detection to `test_gibbs_vs_rejection.jl`
- [x] Added smart path detection to `test_covar_deprecation.jl`
- [x] Verified tests work from repository root
- [x] Verified tests work from `tests/` directory

### R Tests
- [x] Updated `tests/test_R_api.R` source paths
- [x] Updated `tests/test_R_fix.R` source paths
- [x] Added usage comments in test files
- [x] Verified tests work from repository root

### Documentation
- [x] Created `tests/TEST_README.md`
- [x] Updated `tests/TEST_UPDATE_SUMMARY.md` (this file)
- [x] Documented all changes and usage patterns

---

## Summary

✅ **All test files updated for new directory structure**

### Julia Tests
- Smart path detection automatically finds `Inctools` package
- Work from both repository root and `tests/` directories
- Clear error messages if run from wrong location

### R Tests
- Source from `r_inctools_julia/R/` (updated from `R/`)
- Must run from repository root
- Work with reorganized file structure

### Documentation
- Clear usage instructions in `TEST_README.md`
- All changes documented in this file

**Status:** Ready to use from any supported location
