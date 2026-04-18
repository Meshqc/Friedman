# Friedman

[![License: CC0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

ggplot2 shortcuts for exploratory plots.

## Why

Most EDA starts with the same few plots. These functions wrap them in one
call each, with defaults you can override via `$plot` if you need more control.

## Install

```r
devtools::install_github("Meshqc/Friedman")
```

## Functions

| Function | What it does |
|---|---|
| `quick_hist(data, col, bins=30)` | histogram of a numeric column |
| `quick_scatter(data, x, y)` | scatter plot with a trend line |
| `quick_box(data, x, y)` | box plot grouped by a category |
| `quick_cor(data, method="pearson")` | correlation heatmap for all numeric columns |
| `quick_pct_change(data, before, after, group)` | median % change by group, as a diverging bar chart |
| `quick_compare(data, num_col, group_col)` | overlaid density curves by group |
| `quick_summary(data)` | mean, median, sd, min, max for all numeric columns |

All the plotting functions return a `friedman_plot` S3 object. You can
call `summary()` on it to see metadata, or grab `$plot` to get the raw
ggplot and add your own layers.

## Example

```r
library(Friedman)

data(ai_job_impact)

quick_hist(ai_job_impact, Age)
quick_scatter(ai_job_impact, Years_Experience, Salary_After_AI)
quick_box(ai_job_impact, "Job_Status", "Salary_After_AI")
quick_cor(ai_job_impact)
quick_pct_change(ai_job_impact, "Salary_Before_AI", "Salary_After_AI", "Job_Status")

# extend a plot
p <- quick_hist(ai_job_impact, Age)
p$plot + ggplot2::labs(subtitle = "2000 employees")
```

## Dataset

Includes `ai_job_impact` — 2,000 employee records with salary, job role,
AI adoption level, automation risk, and more.

## License

CC0 — do whatever you want with it.
