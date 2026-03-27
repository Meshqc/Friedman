\name{quick_scatter}
\alias{quick_scatter}
\title{scatter plot wrapper}
\usage{
quick_scatter(data, x, y)
}
\arguments{
\item{data}{a data frame}
\item{x}{x-axis column (unquoted)}
\item{y}{y-axis column (unquoted)}
}
\value{
ggplot object
}
\description{
scatter plot with a lm trend line using ggplot2
}
\examples{
quick_scatter(mtcars, wt, mpg)
}
