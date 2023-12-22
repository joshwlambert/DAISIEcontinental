#' Creates the axis numbers (breaks) for plotting with an inverse hyperbolic
#' sine transformation
#'
#' @return A function that takes a numeric vector
create_ihs_breaks <- function() {
  function(breaks) sinh(scales::extended_breaks()(asinh(breaks)))
}

#' Creates labels for plots by calling `scientific`.
#'
#' @inheritParams default_params_doc
#'
#' @return A function that takes a numeric vector
create_labels <- function(signif, scientific) {
  function(breaks) {
    scientific(
      breaks,
      scientific = scientific,
      signif = signif
    )
  }
}

#' Creates the axis numbers (labels) for plotting with scientific form in
#' x10 notation
#'
#' @inheritParams default_params_doc
#'
#' @return Character vector
scientific <- function(breaks, scientific, signif) {
  if (scientific) {
    breaks <- gsub(
      pattern = "e\\+",
      replacement = "%*%10^",
      x = choose_scientific(breaks, signif)
    )
  } else {
    breaks <- gsub(
      pattern = "e\\+",
      replacement = "%*%10^",
      x = signif(breaks, digits = signif)
    )
  }
  parse(text = gsub(
    pattern = "e",
    replacement = "%*%10^",
    x = breaks
  ))
}

#' Decides whether number should be in normal or scientific form depending on
#' the magnitude of the number
#'
#' @inheritParams default_params_doc
#'
#' @return Character vector
choose_scientific <- function(breaks, signif) {
  ifelse(breaks > 1e3 | breaks < 1e-3,
         scales::scientific(breaks, digits = 1),
         scales::number(signif(breaks, digits = signif), big.mark = "")
  )
}
