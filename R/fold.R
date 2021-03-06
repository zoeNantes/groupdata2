# R CMD check NOTE handling
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))

## fold
#' @title Create balanced folds for cross-validation.
#' @description Divides data into groups by a range of methods.
#'  Balances a given categorical variable between folds and keeps (if possible)
#'  all data points with a shared ID (e.g. participant_id) in the same fold.
#' @details
#'  \code{cat_col}: data is first subset by \code{cat_col}.
#'  Subsets are folded/grouped and merged.
#'
#'  \code{id_col}: folds are created from unique IDs.
#'
#'  \code{cat_col} AND \code{id_col}: data is subset by \code{cat_col}
#'  and folds are created from unique IDs in each subset.
#'  Subsets are merged.
#' @author Ludvig Renbo Olsen, \email{r-pkgs@ludvigolsen.dk}
#' @export
#' @param k \emph{Dependent on method.}
#'
#'  Number of folds (default), fold size, with more (see \code{method}).
#'
#'  Given as whole number(s) and/or percentage(s) (0 < n < 1).
#' @param cat_col Categorical variable to balance between folds.
#'
#'  E.g. when predicting a binary variable (a or b), it is necessary to have
#'  both represented in every fold
#'
#'  N.B. If also passing an id_col, cat_col should be constant within each ID.
#' @param id_col Factor with IDs.
#'  This will be used to keep all rows that share an ID in the same fold
#'  (if possible).
#'
#'  E.g. If we have measured a participant multiple times and want to see the
#'  effect of time, we want to have all observations of this participant in
#'  the same fold.
#' @inheritParams group_factor
#' @return Dataframe with grouping factor for subsetting in cross-validation.
#' @examples
#' # Attach packages
#' library(groupdata2)
#' library(dplyr)
#'
#' # Create dataframe
#' df <- data.frame(
#'  "participant" = factor(rep(c('1','2', '3', '4', '5', '6'), 3)),
#'  "age" = rep(sample(c(1:100), 6), 3),
#'  "diagnosis" = rep(c('a', 'b', 'a', 'a', 'b', 'b'), 3),
#'  "score" = sample(c(1:100), 3*6))
#' df <- df[order(df$participant),]
#' df$session <- rep(c('1','2', '3'), 6)
#'
#' # Using fold()
#' # Without cat_col and id_col
#' df_folded <- fold(df, 3, method = 'n_dist')
#'
#' # With cat_col
#' df_folded <- fold(df, 3, cat_col = 'diagnosis',
#'  method = 'n_dist')
#'
#' # With id_col
#' df_folded <- fold(df, 3, id_col = 'participant',
#'  method = 'n_dist')
#'
#' # With cat_col and id_col
#' df_folded <- fold(df, 3, cat_col = 'diagnosis',
#'  id_col = 'participant', method = 'n_dist')
#'
#' # Order by folds
#' df_folded <- df_folded[order(df_folded$.folds),]
#'
#' @importFrom dplyr group_by_ do %>%
fold <- function(data, k=5, cat_col = NULL, id_col = NULL,
                 starts_col = NULL, method = 'n_dist',
                 remove_missing_starts = FALSE){

  #
  # Takes:
  # .. dataframe
  # .. number of folds
  # .. a categorical variable to balance in folds
  # .... e.g. to predict between 2 diagnoses,
  # ..... you need both of them in the fold
  # .. an id variable for keeping a subject in the same fold
  # .. method for creating grouping factor
  #
  # Returns:
  # .. dataframe with grouping factor (folds)
  #

  # Convert k to wholenumber if given as percentage
  if(!arg_is_wholenumber_(k) && is_between_(k,0,1)){

    k = convert_percentage_(k, data)

  }

  # Stop if k is not a wholenumber
  stopifnot(arg_is_wholenumber_(k))

  # If method is either greedy or staircase and cat_col is not NULL
  # we don't want k elements per level in cat_col
  # so we divide k by the number of levels in cat_col
  if(method %in% c('greedy', 'staircase') && !is.null(cat_col)){

    n_levels_cat_col = length(unique(data[[cat_col]]))
    k = ceiling(k/n_levels_cat_col)

  }


  # If cat_col is not NULL
  if (!is.null(cat_col)){

    # If id_col is not NULL
    if (!is.null(id_col)){

      # Group by cat_col
      # For each group:
      # .. create groups of the unique IDs (e.g. subjects)
      # .. add grouping factor to data
      # Group by new grouping factor '.folds'

      data <- data %>%
        group_by(!! as.name(cat_col)) %>%
        do(group_uniques_(., k, id_col, method,
                          col_name = '.folds',
                          starts_col = starts_col,
                          remove_missing_starts = remove_missing_starts)) %>%
        group_by(!! as.name('.folds'))


      # If id_col is NULL
    } else {

      # Group by cat_col
      # Create groups from data
      # .. and add grouping factor to data

      data <- data %>%
        group_by(!! as.name(cat_col)) %>%
        do(group(., k, method = method,
                 randomize = TRUE,
                 col_name = '.folds',
                 starts_col = starts_col,
                 remove_missing_starts = remove_missing_starts))


    }


    # If cat_col is NULL
  } else {

    # If id_col is not NULL
    if (!is.null(id_col)){

      # Create groups of unique IDs
      # .. and add grouping factor to data

      data <- data %>%
        group_uniques_(k, id_col, method,
                       col_name = '.folds',
                       starts_col = starts_col,
                       remove_missing_starts = remove_missing_starts)


      # If id_col is NULL
    } else {

      # Create groups from all the data points
      # .. and add grouping factor to data

      data <- group(data, k,
                    method = method,
                    randomize = TRUE,
                    col_name = '.folds',
                    starts_col = starts_col,
                    remove_missing_starts = remove_missing_starts)

    }

  }


  # Return data
  return(data)


}

