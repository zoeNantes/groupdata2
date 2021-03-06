## Number of groups methods

n_last_group_factor_ <- function(v, n_windows, force_equal = FALSE, descending = FALSE){

  #
  # Takes a vector and the number of wanted splits
  # Returns a factor with 1's for window 1, 2's for window 2, etc.
  # This can be used for subsetting, group_by, etc.
  #
  # Notice: The last window will contain fewer OR more elements
  # if length of the vector isn't divisible with n_windows
  #


  ### Force equal ### Set window_size ###

  # If force_equal is set to TRUE,
  # and we don't already have equally sized windows,
  # remove values from v, until we get
  # largest possible equally sized windows

  if ( isTRUE(force_equal) && !(is_wholenumber_(length(v)/n_windows)) ){

    window_size <- floor(length(v)/n_windows)
    v <- v[1:(n_windows*window_size)]

  } else {

    # Calculate size of windows
    window_size <- ceiling(length(v)/n_windows)

  }


  ### Creating grouping factor ###

  # Try to use use greedy_group_factor_ and check
  # if it returns the right number of windows

  # Set grouping_factor with greedy_group_factor_
  window_grouping_factor <- greedy_group_factor_(v, window_size)

  # If it didn't return the right number of windows
  if (max(as.numeric(window_grouping_factor)) != n_windows ||
      !is_optimal_(window_grouping_factor, n_windows)){

    window_size <- floor(length(v)/n_windows)

    if (window_size < 1){

      message('window_size < 1. This should not be possible!')
      window_size <- 1

    }

    # Get the size of the last window
    size_last_window <- length(v)-(n_windows-1)*window_size

    window_grouping_factor <- rep(c(1:n_windows), each = window_size)

    # Add the missing values in the last window

    # Find the number of values to add
    n_to_add <- size_last_window-window_size

    window_grouping_factor <- append(window_grouping_factor, rep(n_windows, n_to_add))


  }

  return(as.factor(window_grouping_factor))


}


# Number of windows - equal windows - Fill up (find better name)
# The point is that first all windows are equally big, and then
# excess datapoints are distributed one at a time ascending/descending

n_fill_group_factor_ <- function(v, n_windows, force_equal = FALSE, descending = FALSE){

  #
  # Takes a vector and a number of windows to create
  # First creates equal groups
  # then fills the excess values into the windows
  # either from the first window up or last window down
  # .. So. 111 222 33 44 or 11 22 333 444
  # Returns grouping factor
  #

  # Create a grouping factor with the biggest possible equal windows
  equal_groups <- n_last_group_factor_(v, n_windows, force_equal=TRUE)

  # Find how many excess datapoints there are
  excess_data_points <- length(v)-length(equal_groups)


  # If there are no excess_data_points or force_equal
  # is set to TRUE, we simply return the equal groups
  if (excess_data_points == 0 || isTRUE(force_equal)){

    return(equal_groups)

  }

  # We create a vector the size of excess_data_points
  # If descending is set to TRUE the values will
  # correspond to the last windows, if set to FALSE
  # the values will correspond to the first windows

  if (isTRUE(descending)){

    # Find where to start the values from
    start_rep <- (n_windows-excess_data_points)+1

    # Create vector of values to add
    values_to_add <- c(start_rep:n_windows)

  } else {

    # Create vector of values to add
    values_to_add <- c(1:excess_data_points)

  }

  # Create grouping factor
  # .. Converts the equal groups factor to a numeric vector
  # .. Adds the values to the equal groups vector
  # .. Sorts the vector so 1s are together, 2s are together, etc.
  # .. Converts the vector to a factor

  grouping_factor <- factor(sort(c(as.numeric(equal_groups),values_to_add)))

  # Return grouping factor
  return(grouping_factor)

}


# number of windows random assign of excess values

n_rand_group_factor_ <- function(v, n_windows, force_equal = FALSE, descending = FALSE){

  #
  # Takes a vector and a number of windows to create
  # First creates equal groups
  # then fills the excess values into randomly chosen windows
  # .. E.g. 111 22 33 444, 11 222 333 44, etc.
  # .. Only adds one per window though!
  # Returns grouping factor
  #

  # Create a grouping factor with the biggest possible equal windows
  equal_groups <- n_last_group_factor_(v, n_windows, force_equal=TRUE)

  # Find how many excess datapoints there are
  excess_data_points <- length(v)-length(equal_groups)

  # If there are no excess_data_points or force_equal
  # is set to TRUE, we simply return the equal groups
  if (excess_data_points == 0 || isTRUE(force_equal)){

    # Return equal groups grouping factor
    return(equal_groups)

  }

  # Get values to add
  # .. Creates a vector with values from 1 to the number
  # .. of windows
  # .. Randomly picks a value for each excess data point
  values_to_add <- sample(c(1:n_windows), excess_data_points)

  # Create grouping factor
  # .. Converts the equal groups factor to a numeric vector
  # .. Adds the values to the equal groups vector
  # .. Sorts the vector so 1s are together, 2s are together, etc.
  # .. Converts the vector to a factor
  grouping_factor <- factor(sort(c(as.numeric(equal_groups),values_to_add)))

  # Return grouping factor
  return(grouping_factor)

}


# N distributed

n_dist_group_factor_ <- function(v, n_windows, force_equal = FALSE, descending = FALSE){

  #
  # Takes a vector and a number of windows to create
  # Distributes excess elements somewhat evenly across windows
  # Returns grouping factor
  #

  # If force_equal is set to TRUE
  # .. Create equal groups and return these
  if (isTRUE(force_equal)){

    # Create a grouping factor with the biggest possible equal windows
    equal_groups <- n_last_group_factor_(v, n_windows, force_equal=TRUE)

    return(equal_groups)

  } else {

    # Create grouping factor with distributed excess elements
    grouping_factor <- factor(ceiling(seq_along(v)/(length(v)/n_windows)))

    # Sometimes a value of e.g. 7.0000.. is rounded up to 8
    # in the above ceiling(). This means that we get 8 groups
    # instead of the specified 7. In this case we replace
    # the extra "8" with 7.
    # --> This should be tested! <--

    # If there are too many groups
    if (max_num_factor(grouping_factor) > n_windows){

      # Get the largest number in grouping factor
      max_value <- max_num_factor(grouping_factor)

      # Get the size of the last group
      last_group_size <- length(grouping_factor[grouping_factor == max_value])

      # If there is only one group too much and it only contains one element
      # put this element in the second last group instead
      if (max_value-1 == n_windows && last_group_size == 1){

        # Replace the level of the factor containing the max_value
        # with the value of the second last group instead (max_value - 1)
        grouping_factor <- replace_level(grouping_factor,
                                         max_value,
                                         max_value-1)


        # Else, stop the script as something has gone wrong
        # and I need to know about it!
      } else {

        stop(paste('Grouping factor contains too many groups! ',
                   max_value, ' groups in total with ',
                   last_group_size, ' elements in last group.', sep=''))

      }

    }

    return(grouping_factor)
  }

}
