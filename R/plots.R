#' @importFrom rlang .data
#' @importFrom stats cor median aggregate sd
NULL

# input checking

.check_col <- function(data, col, numeric = FALSE) {
  if (!col %in% names(data))
    stop(sprintf("Column '%s' not found in data.", col), call. = FALSE)
  if (numeric && !is.numeric(data[[col]]))
    stop(sprintf("Column '%s' must be numeric.", col), call. = FALSE)
}

# basic wrappers

#' Histogram wrapper
#'
#' Makes a ggplot2 histogram for a numeric column.
#'
#' @param data a data frame
#' @param col column to plot (unquoted)
#' @param bins number of bins, default 30
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_hist(mtcars, mpg)
quick_hist <- function(data, col, bins = 30) {
  col <- deparse(substitute(col))
  .check_col(data, col, numeric = TRUE)
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[col]])) +
    ggplot2::geom_histogram(bins = bins, fill = "steelblue", color = "white") +
    ggplot2::labs(title = paste("Distribution of", col), x = col, y = "Count") +
    ggplot2::theme_minimal()
  new_friedman_plot(p, data, type = "histogram", vars = col)
}

#' Scatter plot wrapper
#'
#' Scatter plot with a linear trend line using ggplot2.
#'
#' @param data a data frame
#' @param x x-axis column (unquoted)
#' @param y y-axis column (unquoted)
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_scatter(mtcars, wt, mpg)
quick_scatter <- function(data, x, y) {
  x <- deparse(substitute(x))
  y <- deparse(substitute(y))
  .check_col(data, x, numeric = TRUE)
  .check_col(data, y, numeric = TRUE)
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[x]], y = .data[[y]])) +
    ggplot2::geom_point(color = "steelblue", alpha = 0.7) +
    ggplot2::geom_smooth(method = "lm", se = FALSE, color = "salmon") +
    ggplot2::labs(title = paste(y, "vs", x), x = x, y = y) +
    ggplot2::theme_minimal()
  new_friedman_plot(p, data, type = "scatter", vars = c(x, y))
}

#' Box plot wrapper
#'
#' Box-and-whisker plot grouped by a categorical variable, using ggplot2.
#'
#' @param data a data frame
#' @param x grouping column name (string)
#' @param y numeric column name (string)
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_box(mtcars, "cyl", "mpg")
quick_box <- function(data, x, y) {
  .check_col(data, x)
  .check_col(data, y, numeric = TRUE)
  p <- ggplot2::ggplot(data,
         ggplot2::aes(x = factor(.data[[x]]), y = .data[[y]],
                      fill = factor(.data[[x]]))) +
    ggplot2::geom_boxplot(alpha = 0.7, show.legend = FALSE) +
    ggplot2::labs(title = paste(y, "by", x), x = x, y = y) +
    ggplot2::theme_minimal()
  new_friedman_plot(p, data, type = "boxplot", vars = c(x, y))
}

# more involved functions

#' Correlation heatmap
#'
#' Computes pairwise Pearson correlations for all numeric columns in
#' \code{data} and renders them as a colour-coded heatmap. Cells are
#' annotated with the rounded correlation coefficient.
#'
#' @param data a data frame; non-numeric columns are silently dropped
#' @param method correlation method passed to \code{cor()}: one of
#'   \code{"pearson"}, \code{"kendall"}, or \code{"spearman"}
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_cor(mtcars)
quick_cor <- function(data, method = "pearson") {
  num_data <- data[sapply(data, is.numeric)]
  if (ncol(num_data) < 2)
    stop("Need at least 2 numeric columns to compute a correlation matrix.",
         call. = FALSE)
  cor_mat  <- round(cor(num_data, use = "pairwise.complete.obs",
                        method = method), 2)
  cor_df   <- as.data.frame(as.table(cor_mat))
  names(cor_df) <- c("Var1", "Var2", "value")
  p <- ggplot2::ggplot(cor_df,
         ggplot2::aes(x = .data[["Var1"]], y = .data[["Var2"]],
                      fill = .data[["value"]])) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::geom_text(ggplot2::aes(label = .data[["value"]]),
                       size = 3, color = "black") +
    ggplot2::scale_fill_gradient2(low = "salmon", mid = "white",
                                  high = "steelblue", midpoint = 0,
                                  limits = c(-1, 1), name = method) +
    ggplot2::labs(title = paste("Correlation Heatmap (", method, ")",
                                sep = ""),
                  x = NULL, y = NULL) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       hjust = 1))
  new_friedman_plot(p, data, type = "correlation", vars = names(num_data))
}

#' Percentage change by group
#'
#' For each unique value of \code{group_col}, computes the median percentage
#' change ((after - before) / before * 100) and plots the results as a
#' horizontal diverging bar chart. Works on any two numeric before/after
#' columns — salaries, scores, prices, etc.
#'
#' @param data a data frame
#' @param before_col name of the baseline numeric column (string)
#' @param after_col name of the comparison numeric column (string)
#' @param group_col name of the grouping column (string)
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_pct_change(ai_job_impact, "Salary_Before_AI",
#'                  "Salary_After_AI", "Job_Status")
quick_pct_change <- function(data, before_col, after_col, group_col) {
  .check_col(data, before_col, numeric = TRUE)
  .check_col(data, after_col,  numeric = TRUE)
  .check_col(data, group_col)
  pct <- (data[[after_col]] - data[[before_col]]) / data[[before_col]] * 100
  tmp <- data.frame(group = data[[group_col]], pct_change = pct)
  agg <- stats::aggregate(pct_change ~ group, data = tmp, FUN = median)
  agg <- agg[order(agg$pct_change), ]
  agg$group <- factor(agg$group, levels = agg$group)
  p <- ggplot2::ggplot(agg,
         ggplot2::aes(x = .data[["pct_change"]], y = .data[["group"]],
                      fill = .data[["pct_change"]] > 0)) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::scale_fill_manual(values = c("TRUE" = "steelblue",
                                          "FALSE" = "salmon")) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed", color = "grey40") +
    ggplot2::labs(title = paste("Median % Change by", group_col),
                  x = "Median % Change", y = group_col) +
    ggplot2::theme_minimal()
  new_friedman_plot(p, data, type = "pct_change",
                    vars = c(before_col, after_col, group_col))
}

# utility functions

#' Quick numeric summary
#'
#' Prints a tidy summary table of all numeric columns: mean, median,
#' standard deviation, min, and max.
#'
#' @param data a data frame
#'
#' @return a data frame with one row per numeric column (invisibly)
#' @export
#'
#' @examples
#' quick_summary(mtcars)
quick_summary <- function(data) {
  num_cols <- names(data)[sapply(data, is.numeric)]
  if (length(num_cols) == 0)
    stop("No numeric columns found.", call. = FALSE)
  result <- do.call(rbind, lapply(num_cols, function(v) {
    x <- data[[v]]
    data.frame(
      variable = v,
      mean     = round(mean(x, na.rm = TRUE), 3),
      median   = round(stats::median(x, na.rm = TRUE), 3),
      sd       = round(stats::sd(x, na.rm = TRUE), 3),
      min      = round(min(x, na.rm = TRUE), 3),
      max      = round(max(x, na.rm = TRUE), 3),
      stringsAsFactors = FALSE
    )
  }))
  print(result, row.names = FALSE)
  invisible(result)
}

#' Compare a numeric variable across groups
#'
#' Overlaid density curves for a numeric column split by a grouping variable.
#' Useful for visually comparing distributions without committing to a box plot.
#'
#' @param data a data frame
#' @param num_col numeric column name (string)
#' @param group_col grouping column name (string)
#'
#' @return a \code{friedman_plot} object
#' @export
#'
#' @examples
#' quick_compare(mtcars, "mpg", "cyl")
quick_compare <- function(data, num_col, group_col) {
  .check_col(data, num_col,   numeric = TRUE)
  .check_col(data, group_col)
  p <- ggplot2::ggplot(data,
         ggplot2::aes(x = .data[[num_col]],
                      fill  = factor(.data[[group_col]]),
                      color = factor(.data[[group_col]]))) +
    ggplot2::geom_density(alpha = 0.3) +
    ggplot2::labs(title = paste("Distribution of", num_col, "by", group_col),
                  x = num_col, y = "Density",
                  fill = group_col, color = group_col) +
    ggplot2::theme_minimal()
  new_friedman_plot(p, data, type = "compare", vars = c(num_col, group_col))
}
