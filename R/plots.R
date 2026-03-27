#' @importFrom rlang .data
NULL

#' histogram wrapper
#'
#' makes a ggplot2 histogram for a numeric column
#'
#' @param data a data frame
#' @param col column to plot (unquoted)
#' @param bins number of bins, default 30
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' quick_hist(mtcars, mpg)
quick_hist <- function(data, col, bins = 30) {
  col <- deparse(substitute(col))
  ggplot2::ggplot(data, ggplot2::aes(x = .data[[col]])) +
    ggplot2::geom_histogram(bins = bins, fill = "steelblue", color = "white") +
    ggplot2::labs(title = paste("Distribution of", col), x = col, y = "Count") +
    ggplot2::theme_minimal()
}

#' scatter plot wrapper
#'
#' scatter plot with a lm trend line using ggplot2
#'
#' @param data a data frame
#' @param x x-axis column (unquoted)
#' @param y y-axis column (unquoted)
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' quick_scatter(mtcars, wt, mpg)
quick_scatter <- function(data, x, y) {
  x <- deparse(substitute(x))
  y <- deparse(substitute(y))
  ggplot2::ggplot(data, ggplot2::aes(x = .data[[x]], y = .data[[y]])) +
    ggplot2::geom_point(color = "steelblue", alpha = 0.7) +
    ggplot2::geom_smooth(method = "lm", se = FALSE, color = "salmon") +
    ggplot2::labs(title = paste(y, "vs", x), x = x, y = y) +
    ggplot2::theme_minimal()
}

#' box plot wrapper
#'
#' lattice box-and-whisker plot, grouped by a categorical variable
#'
#' @param data a data frame
#' @param x grouping column name (string)
#' @param y numeric column name (string)
#'
#' @return lattice trellis object
#' @export
#'
#' @examples
#' quick_box(mtcars, "cyl", "mpg")
quick_box <- function(data, x, y) {
  f <- stats::as.formula(paste(y, "~ factor(", x, ")"))
  lattice::bwplot(f, data = data,
                  main = paste(y, "by", x),
                  xlab = x, ylab = y)
}
