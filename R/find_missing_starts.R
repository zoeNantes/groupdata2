
## find_missing_starts
#' @title Find start positions that cannot be found in data.
#' @description Tells you which values and (optionally) skip_to numbers that are
#'  recursively removed when using the \code{l_starts} method with remove_missing_starts
#'  set to TRUE.
#' @author Ludvig Renbo Olsen, \email{r-pkgs@ludvigolsen.dk}
#' @export
#' @param data Dataframe or Vector
#' @param n List of starting positions.
#'
#' Skip values by c(value, skip_to_number) where skip_to_number is the nth appearance of the value in the vector.
#'
#' See \link{group_factor} for explanations and examples of using the \code{l_starts} method.
#' @param starts_col Name of column with values to match
#'  when data is a dataframe. Pass 'index' to use row names. (Character)
#' @param return_skip_numbers Return skip_to numbers along with values (Logical).
#' @return List of start values and skip_to numbers or vector of the start values.
#'  Returns NULL if no values found.
#' @family l_starts tools
#' @examples
#' # Attach packages
#' library(groupdata2)
#'
#' # Create a dataframe
#' df <- data.frame('a' = c('a','a','b',
#'                          'b','c','c'))
#'
#' # Create list of starts
#' starts <- c("a", "e", "b", "d", "c")
#'
#' # Find missing starts with skip_to numbers
#' find_missing_starts(df, starts, starts_col = 'a')
#'
#' # Find missing starts without skip_to numbers
#' find_missing_starts(df, starts, starts_col = 'a',
#'                     return_skip_numbers = FALSE)
find_missing_starts <- function(data, n, starts_col = NULL,
                                return_skip_numbers = TRUE){

  # Check arguments
  stopifnot(is.data.frame(data) && !is.null(starts_col) ||
            !is.data.frame(data) && is.null(starts_col))
  stopifnot(is.list(n) || is.vector(n))
  stopifnot(is.logical(return_skip_numbers))

  starts_col <- assign_starts_col(data, starts_col)

  if (is.data.frame(data)){

    missing <- l_starts_group_factor_(starts_col, n,
                           remove_missing_starts = FALSE,
                           return_missing_starts = TRUE,
                           return_missing_starts_skip_numbers = return_skip_numbers)

  } else {

    missing <- l_starts_group_factor_(data, n,
                           remove_missing_starts = FALSE,
                           return_missing_starts = TRUE,
                           return_missing_starts_skip_numbers = return_skip_numbers)

  }

  return(missing)


}


