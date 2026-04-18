test_that("quick_hist returns a friedman_plot", {
  result <- quick_hist(mtcars, mpg)
  expect_s3_class(result, "friedman_plot")
  expect_s3_class(result$plot, "gg")
  expect_equal(result$type, "histogram")
  expect_equal(result$vars, "mpg")
  expect_equal(result$nrow, nrow(mtcars))
})

test_that("quick_scatter returns a friedman_plot", {
  result <- quick_scatter(mtcars, wt, mpg)
  expect_s3_class(result, "friedman_plot")
  expect_s3_class(result$plot, "gg")
  expect_equal(result$type, "scatter")
  expect_equal(result$vars, c("wt", "mpg"))
})

test_that("quick_box returns a friedman_plot", {
  result <- quick_box(mtcars, "cyl", "mpg")
  expect_s3_class(result, "friedman_plot")
  expect_s3_class(result$plot, "gg")
  expect_equal(result$type, "boxplot")
})

test_that("quick_cor returns a friedman_plot", {
  result <- quick_cor(mtcars)
  expect_s3_class(result, "friedman_plot")
  expect_s3_class(result$plot, "gg")
  expect_equal(result$type, "correlation")
})

test_that("quick_compare returns a friedman_plot", {
  result <- quick_compare(mtcars, "mpg", "cyl")
  expect_s3_class(result, "friedman_plot")
  expect_equal(result$type, "compare")
})

test_that("quick_pct_change returns a friedman_plot", {
  result <- quick_pct_change(ai_job_impact,
                             "Salary_Before_AI", "Salary_After_AI",
                             "Job_Status")
  expect_s3_class(result, "friedman_plot")
  expect_equal(result$type, "pct_change")
})

test_that("print.friedman_plot returns object invisibly", {
  result <- quick_hist(mtcars, mpg)
  expect_invisible(print(result))
})

test_that("summary.friedman_plot returns object invisibly", {
  result <- quick_scatter(mtcars, wt, mpg)
  expect_invisible(summary(result))
})
