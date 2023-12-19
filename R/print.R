#' Print method for continental testing
#'
#' @inheritParams base::print
#'
#' @return Invisibly returns and prints object.
#' @export
print.continental_test <- function(x, ...) {
  cat("<continental_testing object>\n")
  cat(sprintf("  %s DAISIE MLE\n", length(x$mls)))
  cat(sprintf("  %s DAISIE data sets", length(x$data)))
}
