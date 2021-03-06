#' groupdata2: A package for creating groups from data
#'
#' Subsetting methods for balanced cross-validation, time series windowing,
#' and general grouping and splitting of data.
#'
#' The groupdata2 package provides five main functions:
#' \code{group}, \code{group_factor}, \code{splt}, \code{partition} and \code{fold}
#'
#' @section group:
#' Create groups from your data.
#'
#' Divides data into groups by a range of methods.
#' Creates a grouping factor with 1s for group 1, 2s for group 2, etc.
#' Returns a dataframe grouped by the grouping factor for easy use in dplyr pipelines.
#'
#' Go to \code{\link{group}}
#'
#' @section group_factor:
#' Create grouping factor for subsetting your data.
#'
#' Divides data into groups by a range of methods.
#' Creates and returns a grouping factor
#' with 1s for group 1, 2s for group 2, etc.
#'
#' Go to \code{\link{group_factor}}
#'
#' @section splt:
#' Split data by a range of methods.
#'
#' Divides data into groups by a range of methods.
#' Splits data by these groups.
#'
#' Go to \code{\link{splt}}
#'
#' @section partition:
#' Create balanced partitions (e.g. training/test sets).
#'
#' Splits data into partitions.
#' Balances a given categorical variable between partitions
#' and keeps (if possible) all data points with a shared ID
#' (e.g. participant_id) in the same partition.
#'
#' Go to \code{\link{partition}}
#'
#' @section fold:
#' Create balanced folds for cross-validation.
#'
#' Divides data into groups (folds) by a range of methods.
#' Balances a given categorical variable between folds and keeps (if possible)
#' all data points with the same ID (e.g. participant_id) in the same fold.
#'
#' Go to \code{\link{fold}}
#' @author Ludvig Renbo Olsen, \email{r-pkgs@@ludvigolsen.dk}
#' @docType package
#' @name groupdata2
NULL
