# Running Tests

## Julia Tests

Julia tests can be run from either **repository root** or **tests/** directory:

```bash
# From repository root
julia tests/test_comprehensive.jl
julia tests/test_rtmvnorm.jl
julia tests/test_gibbs_vs_rejection.jl
julia tests/test_covar_deprecation.jl

# OR from tests/ directory
cd tests
julia test_comprehensive.jl
julia test_rtmvnorm.jl
julia test_gibbs_vs_rejection.jl
julia test_covar_deprecation.jl
```

## R Tests

R tests must be run from the **repository root**:

```bash
# From repository root (required)
Rscript tests/test_R_api.R
Rscript tests/test_R_fix.R
```

## Test Files

- `test_comprehensive.jl` - Comprehensive Julia package tests (9 tests)
- `test_rtmvnorm.jl` - Tests for rtmvnorm refactoring
- `test_gibbs_vs_rejection.jl` - Statistical equivalence tests
- `test_covar_deprecation.jl` - Parameter deprecation tests
- `test_R_api.R` - Complete R API tests (6 tests)
- `test_R_fix.R` - Quick R API fix verification

## Directory Structure

The tests expect this directory structure:

```
inctools_julia/          # ← Run tests from here (repository root)
├── Inctools/            # Julia package
├── InctoolsJulia/       # R package
│   └── R/               # R source files
└── tests/               # Test files
    ├── test_*.jl
    └── test_*.R
```

## Notes

- **Julia tests** automatically detect their location and find the Inctools package
  - Work from repository root: uses `./Inctools`
  - Work from `tests/` directory: uses `../Inctools`
- **R tests** must be run from repository root
  - They source from `InctoolsJulia/R/`
  - Paths are relative to repository root
