#' Iteratively removes all rows and columns of a matrix or dataframe with less than a given
#' number of non zero elements
#'
#' @details A matrix or data.frame with numeric values often contains rows and columns with an
#' insufficient amount of values > 0 for a certain task. For example correspondence analysis
#' or bivariate correlation analysis requires a minimum amount of usable values.
#' In an archaeological context this could apply for example, if certain find categories
#' are particularly rare in a burial site context.
#'
#' \code{delrc} allows to remove rows and columns, that don't fulfill the requirements.
#'
#' @param x matrix or data.frame. Table with only numeric values.
#' @param minnumber integer. A number of minimum non zero elements. How many values > 0 have to be
#' present to consider a row/column sufficiently linked to perform further analysis?
#' Every column with less values > 0 will be removed. Either \code{minnumber} or \code{cmin} and
#' \code{rmin} must be given.
#' @param cmin integer. Same as \code{minnumber}, but specifically for columns.
#' @param rmin integer. Same as \code{minnumber}, but specifically for rows.
#'
#' @return A matrix or dataframe with all rows and columns removed that had less than
#' the given number of non zero elements. If \code{minnumber} or \code{cmin} and
#' \code{rmin} are too restrictive and no content remains in the table, than the result is
#' \code{NA}.
#'
#' @examples
#' testmatrix <- data.frame(
#' c1 = c(0,3,8,2),
#' c2 = c(0,6,7,0),
#' c3 = c(0,0,0,0),
#' c4 = c(0,3,8,2),
#' c5 = c(0,6,7,0),
#' c6 = c(1,0,0,1)
#' )
#'
#' # The following code removes every column with less than 3 values > 0.
#' # That will remove the columns c2, c3, c5 and c6.
#' # Further, every row with less than 2 values gets removed.
#' # That will delete row 1.
#' itremove(testmatrix, cmin = 3, rmin = 2)
#'
#'@export
itremove <- function(x, minnumber = NA, cmin = NA, rmin = NA) {

  # check input parameters
  if (!any(c("matrix", "data.frame") %in% class(x))) {
    stop("x is neither a matrix nor a data.frame")
  }
  if (is.na(minnumber) & (is.na(cmin) | is.na(rmin))) {
    stop("minnumber is missing")
  } else if (!is.na(minnumber) & (!is.na(cmin) | !is.na(rmin))) {
    stop("use either min or cmin + rmin")
  } else if (!is.na(minnumber) & (is.na(cmin) & is.na(rmin))) {
    cmin <- rmin <- minnumber
  }

  return(itremove_algorithm(x, cmin, rmin))

}

itremove_algorithm <- function(x, cmin, rmin) {
  if (!any(c("matrix", "data.frame") %in% class(x))) {
    return(NA)
  }
  # search for zero values
  enough_non_zero_elements_x <- apply(
    x,
    MARGIN = 1,
    FUN = check_num_nonzero,
    minnumber = rmin
  )
  enough_non_zero_elements_y <- apply(
    x,
    MARGIN = 2,
    FUN = check_num_nonzero,
    minnumber = cmin
  )
  # check if the function ends or if it has to be called again (recursion)
  if (any(!c(enough_non_zero_elements_x, enough_non_zero_elements_y))) {
    return(
      itremove_algorithm(
        x[enough_non_zero_elements_x, enough_non_zero_elements_y],
        cmin, rmin
      )
    )
  } else {
    return(if (length(x) > 0) x else NA)
  }
}
check_num_nonzero <- function(x, minnumber) (sum(x == 0) + (minnumber - 1)) < length(x)

#' Reduce the numeric values of a data.frame to boolean values
#'
#' \code{booleanize} returns an other version of the input data.frame with
#' simple, definable present-absent information instead of numeric values.
#' Absent means zero.
#'
#' @param x matrix or data.frame. Table with only numeric values.
#' @param present any atomic type. Replacement values for cells with numeric value >0.
#' default: TRUE
#' @param absent any atomic type. Replacement values for cells with numeric value 0.
#' default: FALSE
#'
#' @return A matrix or data.frame with present-absent values.
#'
#' @examples
#' testmatrix <- data.frame(c1 = c(0,2,0,8), c2 = c(5,6,7,0), c3 = c(5,6,7,0))
#'
#' booleanize(testmatrix)
#' booleanize(x = testmatrix, present = "cake", absent = "no cake")
#'
#' @export
booleanize <- function(x, present = TRUE, absent = FALSE) {

  absent_elements <- which(x == 0, arr.ind = T)
  present_elements <- which(x > 0, arr.ind = T)
  x[absent_elements] <- absent
  x[present_elements] <- present

  return(x)
}
