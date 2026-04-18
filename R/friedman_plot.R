# internal constructor - not exported
new_friedman_plot <- function(plot, data, type, vars) {
  structure(
    list(
      plot  = plot,
      data  = data,
      type  = type,
      vars  = vars,
      nrow  = nrow(data),
      ncol  = ncol(data)
    ),
    class = "friedman_plot"
  )
}

#' Print a friedman_plot object
#'
#' Displays the plot and prints a one-line summary to the console.
#'
#' @param x a \code{friedman_plot} object
#' @param ... ignored
#'
#' @return invisibly returns \code{x}
#' @export
print.friedman_plot <- function(x, ...) {
  cat(sprintf("<friedman_plot> type: %s | vars: %s | n = %d\n",
              x$type, paste(x$vars, collapse = ", "), x$nrow))
  print(x$plot)
  invisible(x)
}

#' Summary of a friedman_plot object
#'
#' Prints metadata about the plot and the variables used.
#'
#' @param object a \code{friedman_plot} object
#' @param ... ignored
#'
#' @return invisibly returns \code{object}
#' @export
summary.friedman_plot <- function(object, ...) {
  cat("friedman_plot summary\n")
  cat("---------------------\n")
  cat(sprintf("  Plot type : %s\n", object$type))
  cat(sprintf("  Variables : %s\n", paste(object$vars, collapse = ", ")))
  cat(sprintf("  Rows      : %d\n", object$nrow))
  cat(sprintf("  Columns   : %d\n", object$ncol))
  cat("\nVariable summaries:\n")
  numeric_vars <- object$vars[sapply(object$vars, function(v) is.numeric(object$data[[v]]))]
  if (length(numeric_vars) > 0) {
    print(summary(object$data[numeric_vars]))
  }
  invisible(object)
}

#' Plot method for a friedman_plot object
#'
#' Re-renders the stored plot.
#'
#' @param x a \code{friedman_plot} object
#' @param ... ignored
#'
#' @return invisibly returns \code{x}
#' @export
plot.friedman_plot <- function(x, ...) {
  print(x$plot)
  invisible(x)
}
