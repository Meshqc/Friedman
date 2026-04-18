test_that("quick_hist errors on missing column", {
  expect_error(quick_hist(mtcars, nonexistent_col),
               "Column 'nonexistent_col' not found")
})

test_that("quick_hist errors on non-numeric column", {
  df <- data.frame(name = c("a", "b"), val = c(1, 2))
  expect_error(quick_hist(df, name), "must be numeric")
})

test_that("quick_scatter errors on missing x column", {
  expect_error(quick_scatter(mtcars, bad_col, mpg),
               "Column 'bad_col' not found")
})

test_that("quick_scatter errors on missing y column", {
  expect_error(quick_scatter(mtcars, wt, bad_col),
               "Column 'bad_col' not found")
})

test_that("quick_box errors on missing group column", {
  expect_error(quick_box(mtcars, "bad_col", "mpg"),
               "Column 'bad_col' not found")
})

test_that("quick_cor errors when fewer than 2 numeric columns", {
  df <- data.frame(x = c(1, 2, 3), label = c("a", "b", "c"))
  expect_error(quick_cor(df), "at least 2 numeric columns")
})

test_that("quick_summary errors on non-numeric data", {
  df <- data.frame(a = c("x", "y"), b = c("p", "q"))
  expect_error(quick_summary(df), "No numeric columns found")
})

test_that("quick_summary returns a data frame invisibly", {
  result <- quick_summary(mtcars)
  expect_s3_class(result, "data.frame")
  expect_true("variable" %in% names(result))
  expect_true("mean"     %in% names(result))
})
