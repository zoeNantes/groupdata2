library(groupdata2)
context("group_factor()")


test_that("group sizes works with group_factor with method greedy", {

  group_counts <- function(v, n){

    gf <- group_factor(v, n, method = 'greedy')
    counts <- plyr::count(gf)
    return(counts$freq)

  }

  v <- c(1:57)

  expect_equal(group_counts(v, 17), c(17,17,17,6))
  expect_equal(group_counts(v, 10), c(10,10,10,10,10,7))
  expect_equal(group_counts(v, 8), c(8,8,8,8,8,8,8,1))
  expect_equal(group_counts(v, 3), c(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3))
  expect_equal(group_counts(v, 0.2), c(11,11,11,11,11,2))
  expect_equal(group_counts(v, 0.25), c(14,14,14,14,1))

  expect_equal(length(group_counts(v, 1)), 57)

  v <- c(1:100)

  expect_equal(group_counts(v, 0.25), c(25,25,25,25))

  expect_error(group_counts(v, 0.003), "n > 0 is not TRUE", fixed=TRUE)

  v <- c(1:3)

  expect_error(group_counts(v, 17), "length(data) >= n is not TRUE", fixed=TRUE)
  expect_error(group_counts(v, 0), "n > 0 is not TRUE", fixed=TRUE)


})

test_that("group sizes works with group_factor with method n_dist", {

  group_counts <- function(v, n){

    gf <- group_factor(v, n, method = 'n_dist')
    counts <- plyr::count(gf)
    return(counts$freq)

  }

  v <- c(1:57)

  expect_equal(group_counts(v, 1), 57)
  expect_equal(group_counts(v, 2), c(28,29))
  expect_equal(group_counts(v, 3), c(19,19,19))
  expect_equal(group_counts(v, 4), c(14,14,14,15))
  expect_equal(group_counts(v, 5), c(11,11,12,11,12))
  expect_equal(group_counts(v, 17), c(3,3,4,3,3,4,3,3,4,3,3,4,3,3,4,3,4))
  expect_equal(group_counts(v, 0.2), c(5,5,5,5,5,6,5,5,5,5,6))
  expect_equal(group_counts(v, 0.25), c(4,4,4,4,4,4,4,4,4,4,4,4,4,5))

  expect_equal(length(group_counts(v, 1)), 1)

  v <- c(1:100)

  expect_error(group_counts(v, 0.003), "n > 0 is not TRUE", fixed=TRUE)

  v <- c(1:3)

  expect_error(group_counts(v, 4), "length(data) >= n is not TRUE", fixed=TRUE)
  expect_error(group_counts(v, 0), "n > 0 is not TRUE", fixed=TRUE)


})

test_that("group sizes works with group_factor with method n_fill", {

  group_counts <- function(v, n){

    gf <- group_factor(v, n, method = 'n_fill')
    counts <- plyr::count(gf)
    return(counts$freq)

  }

  v <- c(1:57)

  expect_equal(group_counts(v, 1), 57)
  expect_equal(group_counts(v, 2), c(29,28))
  expect_equal(group_counts(v, 3), c(19,19,19))
  expect_equal(group_counts(v, 4), c(15,14,14,14))
  expect_equal(group_counts(v, 5), c(12,12,11,11,11))
  expect_equal(group_counts(v, 17), c(4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3))
  expect_equal(group_counts(v, 0.2), c(6,6,5,5,5,5,5,5,5,5,5))
  expect_equal(group_counts(v, 0.25), c(5,4,4,4,4,4,4,4,4,4,4,4,4,4))

  expect_equal(length(group_counts(v, 1)), 1)
  expect_equal(length(group_counts(v, 9)), 9)
  expect_equal(length(group_counts(v, 57)), 57)

  v <- c(1:100)

  expect_error(group_counts(v, 0.003), "n > 0 is not TRUE", fixed=TRUE)

  v <- c(1:3)

  expect_error(group_counts(v, 4), "length(data) >= n is not TRUE", fixed=TRUE)
  expect_error(group_counts(v, 0), "n > 0 is not TRUE", fixed=TRUE)


})

test_that("group sizes works with group_factor with method n_rand", {

  count_groups <- function(v, n){

    gf <- group_factor(v, n, method = 'n_rand')
    counts <- plyr::count(gf)
    return(length(counts$freq))

  }

  group_counts_sum <- function(v, n){

    gf <- group_factor(v, n, method = 'n_fill')
    counts <- plyr::count(gf)
    return(sum(counts$freq))

  }

  v <- c(1:57)

  expect_equal(count_groups(v, 1), 1)
  expect_equal(count_groups(v, 2), 2)
  expect_equal(count_groups(v, 3), 3)
  expect_equal(count_groups(v, 4), 4)
  expect_equal(count_groups(v, 5), 5)
  expect_equal(count_groups(v, 11), 11)
  expect_equal(count_groups(v, 57), 57)

  expect_equal(group_counts_sum(v, 2), 57)
  expect_equal(group_counts_sum(v, 3), 57)
  expect_equal(group_counts_sum(v, 4), 57)
  expect_equal(group_counts_sum(v, 5), 57)
  expect_equal(group_counts_sum(v, 17), 57)
  expect_equal(group_counts_sum(v, 0.2), 57)
  expect_equal(group_counts_sum(v, 0.25), 57)

  v <- c(1:100)

  expect_error(group_counts_sum(v, 0.003), "n > 0 is not TRUE", fixed=TRUE)

  v <- c(1:3)

  expect_error(group_counts_sum(v, 4), "length(data) >= n is not TRUE", fixed=TRUE)
  expect_error(group_counts_sum(v, 0), "n > 0 is not TRUE", fixed=TRUE)


})

test_that("group sizes works with group_factor with method staircase", {

  group_counts <- function(v, n){

    gf <- group_factor(v, n, method = 'staircase')
    counts <- plyr::count(gf)
    return(counts$freq)

  }

  count_groups <- function(v, n){

    gf <- group_factor(v, n, method = 'staircase')
    counts <- plyr::count(gf)
    return(length(counts$freq))

  }

  group_counts_sum <- function(v, n){

    gf <- group_factor(v, n, method = 'staircase')
    counts <- plyr::count(gf)
    return(sum(counts$freq))

  }

  v <- c(1:57)

  expect_equal(group_counts(v, 4), c(4,8,12,16,17))
  expect_equal(group_counts(v, 5), c(5,10,15,20,7))
  expect_equal(group_counts(v, 10), c(10,20,27))
  expect_equal(group_counts(v, 11), c(11,22,24))


  expect_equal(count_groups(v, 1), 11)
  expect_equal(count_groups(v, 2), 8)
  expect_equal(count_groups(v, 3), 6)
  expect_equal(count_groups(v, 4), 5)
  expect_equal(count_groups(v, 5), 5)
  expect_equal(count_groups(v, 11), 3)
  expect_equal(count_groups(v, 56), 2)
  expect_equal(count_groups(v, 57), 1)

  expect_equal(group_counts_sum(v, 1), 57)
  expect_equal(group_counts_sum(v, 2), 57)
  expect_equal(group_counts_sum(v, 3), 57)
  expect_equal(group_counts_sum(v, 4), 57)
  expect_equal(group_counts_sum(v, 5), 57)
  expect_equal(group_counts_sum(v, 17), 57)
  expect_equal(group_counts_sum(v, 0.2), 57)
  expect_equal(group_counts_sum(v, 0.25), 57)

  v <- c(1:100)

  expect_error(group_counts_sum(v, 0.003), "n > 0 is not TRUE", fixed=TRUE)

  v <- c(1:3)

  expect_error(group_counts(v, 4), "length(data) >= n is not TRUE", fixed=TRUE)
  expect_error(group_counts(v, 0), "n > 0 is not TRUE", fixed=TRUE)
  expect_equal(group_counts(v, 2), c(2,1))
  expect_equal(group_counts(v, 0.5), c(1,2))


})

test_that("force_equal works with group_factor with all methods",{

  group_counts <- function(v, n, method){

    gf <- group_factor(v, n, method, force_equal = TRUE)
    counts <- plyr::count(gf)
    return(counts$freq)

  }

  count_groups <- function(v, n, method){

    gf <- group_factor(v, n, method = method, force_equal = TRUE)
    counts <- plyr::count(gf)
    return(length(counts$freq))

  }


  v <- c(1:57)


  expect_equal(group_counts(v, 10, 'greedy'), c(10,10,10,10,10))
  expect_equal(group_counts(v, 8, 'greedy'), c(8,8,8,8,8,8,8))
  expect_equal(group_counts(v, 13, 'greedy'), c(13,13,13,13))
  expect_equal(group_counts(v, 0.5, 'greedy'), c(28,28))
  expect_equal(group_counts(v, 0.267, 'greedy'), c(15,15,15))

  expect_equal(count_groups(v, 2, 'greedy'), 28)
  expect_equal(count_groups(v, 7, 'greedy'), 8)
  expect_equal(count_groups(v, 5, 'greedy'), 11)

  expect_equal(group_counts(v, 10, 'n_dist'), c(5,5,5,5,5,5,5,5,5,5))
  expect_equal(group_counts(v, 8, 'n_dist'), c(7,7,7,7,7,7,7,7))
  expect_equal(group_counts(v, 5, 'n_dist'), c(11,11,11,11,11))

  expect_equal(count_groups(v, 2, 'n_dist'), 2)
  expect_equal(count_groups(v, 7, 'n_dist'), 7)
  expect_equal(count_groups(v, 5, 'n_dist'), 5)

  expect_equal(group_counts(v, 10, 'n_fill'), c(5,5,5,5,5,5,5,5,5,5))
  expect_equal(group_counts(v, 8, 'n_fill'), c(7,7,7,7,7,7,7,7))
  expect_equal(group_counts(v, 5, 'n_fill'), c(11,11,11,11,11))

  expect_equal(count_groups(v, 2, 'n_fill'), 2)
  expect_equal(count_groups(v, 7, 'n_fill'), 7)
  expect_equal(count_groups(v, 5, 'n_fill'), 5)

  expect_equal(group_counts(v, 10, 'n_last'), c(5,5,5,5,5,5,5,5,5,5))
  expect_equal(group_counts(v, 8, 'n_last'), c(7,7,7,7,7,7,7,7))
  expect_equal(group_counts(v, 5, 'n_last'), c(11,11,11,11,11))

  expect_equal(count_groups(v, 2, 'n_last'), 2)
  expect_equal(count_groups(v, 7, 'n_last'), 7)
  expect_equal(count_groups(v, 5, 'n_last'), 5)

  expect_equal(group_counts(v, 10, 'n_rand'), c(5,5,5,5,5,5,5,5,5,5))
  expect_equal(group_counts(v, 8, 'n_rand'), c(7,7,7,7,7,7,7,7))
  expect_equal(group_counts(v, 5, 'n_rand'), c(11,11,11,11,11))

  expect_equal(count_groups(v, 2, 'n_rand'), 2)
  expect_equal(count_groups(v, 7, 'n_rand'), 7)
  expect_equal(count_groups(v, 5, 'n_rand'), 5)

  expect_equal(group_counts(v, 10, 'staircase'), c(10,20))
  expect_equal(group_counts(v, 8, 'staircase'), c(8,16,24))
  expect_equal(group_counts(v, 13, 'staircase'), c(13,26))
  expect_equal(group_counts(v, 3, 'staircase'), c(3,6,9,12,15))

})

test_that("allow_zero works with group_factor", {

  v = c(1:3)

  expect_equal(group_factor(v, 0, allow_zero = TRUE), c(NA,NA,NA))
  expect_is(group_factor(v, 0, allow_zero = TRUE), 'logical')
  expect_equal(group_factor(1, 0, allow_zero = TRUE), NA)

})

# Test descending when it has been implemented in all relevant methods

# I don't yet know how to test random functions - e.g. randomize = TRUE

# group_factor(data, n, method = "n_dist", force_equal = FALSE,
# allow_zero = FALSE, descending = FALSE, randomize = FALSE)
