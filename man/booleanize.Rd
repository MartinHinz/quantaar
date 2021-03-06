% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_preparation_functions.R
\name{booleanize}
\alias{booleanize}
\title{Reduce the numeric values of a data.frame to boolean values}
\usage{
booleanize(x, present = TRUE, absent = FALSE)
}
\arguments{
\item{x}{matrix or data.frame. Table with only numeric values.}

\item{present}{any atomic type. Replacement values for cells with numeric value >0.
default: TRUE}

\item{absent}{any atomic type. Replacement values for cells with numeric value 0.
default: FALSE}
}
\value{
A matrix or data.frame with present-absent values.
}
\description{
\code{booleanize} returns an other version of the input data.frame with
simple, definable present-absent information instead of numeric values.
Absent means zero.
}
\examples{
testmatrix <- data.frame(c1 = c(0,2,0,8), c2 = c(5,6,7,0), c3 = c(5,6,7,0))

booleanize(testmatrix)
booleanize(x = testmatrix, present = "cake", absent = "no cake")

}
