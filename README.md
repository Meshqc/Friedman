# Friedman

[![License: CC0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)
[![R package version](https://img.shields.io/badge/version-0.0.0.9000-blue.svg)](https://github.com/Meshqc/Friedman)

**Friedman** is a lightweight R package that provides one-line wrappers for the
most common exploratory data analysis (EDA) plots like histograms, scatter plots,
and box plots so you can go from raw data to insight without writing the same
boilerplate `ggplot2` setup over and over.

---

## Motivation

Every EDA session starts the same way: load a data frame, write a histogram,
write a scatter plot, write a box plot, repeat. The `ggplot2` and `lattice`
APIs are powerful but verbose for quick looks. Friedman wraps those three
patterns into single, memorable calls with sensible defaults — giving you clean,
publication-ready plots in one line while staying fully compatible with the
underlying packages so you can extend them as needed.

---

## Installation

The package is in active development. Install directly from GitHub:

```r
# needs devtools
devtools::install_github("Meshqc/Friedman")
```

---

## Functions

| Function | What it does |
|---|---|
| `quick_hist(data, col, bins=30)` | ggplot2 histogram for any numeric column |
| `quick_scatter(data, x, y)` | scatter plot with a linear trend line |
| `quick_box(data, x, y)` | lattice box plot grouped by a categorical variable |

## Examples

```r
library(Friedman)
```

### Histogram — `quick_hist()`

```r
quick_hist(mtcars, mpg)
quick_hist(mtcars, mpg, bins = 15)
```

Produces a `ggplot2` histogram with a clean minimal theme and an automatic
title derived from the column name.

### Scatter plot — `quick_scatter()`

```r
quick_scatter(mtcars, wt, mpg)
```

Plots `mpg` on the y-axis against `wt` on the x-axis and overlays an `lm`
trend line so you can eyeball linear relationships immediately.

### Box plot — `quick_box()`

```r
quick_box(mtcars, "cyl", "mpg")
```

Renders a `lattice` box-and-whisker plot of `mpg` split by cylinder count.
The grouping variable is automatically coerced to a factor.

---

## Package Structure

```
Friedman/
├── DESCRIPTION
├── NAMESPACE
├── R/
│   └── plots.R
└── man/
    ├── quick_hist.Rd
    ├── quick_scatter.Rd
    └── quick_box.Rd
```

---

## Dependencies

- `ggplot2` — histograms and scatter plots
- `lattice` — box plots
- `rlang` — needed for the `.data` pronoun inside ggplot calls
- `stats` — `as.formula()` used in the box plot wrapper

## What's next

Bug reports and feature requests are welcome at the
[GitHub Issues page](https://github.com/Meshqc/Friedman/issues).

---

## License

CC0 — Use without restrictions.
