#' Determine if the island community (DAISIE data) contains any non-endemic
#' lineages
#'
#' @details This basic function assumes recolonists have at least one
#' non-endemic species, which may not be the case. For the purposes of using
#' `any_nonendemics()` in `DAISIEcontinental` this does not matter, but **do
#' not use this function to precisely determine whether DAISIE data contains
#' non-endemic species.**
#'
#' @inheritParams default_params_doc
#'
#' @return A single logical.
#' @export
any_nonendemics <- function(daisie_data_list) {
  ddl <- daisie_data_list
  nonendemic_stacs <- c(1, 3, 4, 7, 8)
  any_nonendemics <- any(
    unlist(lapply(ddl, "[[", "stac")) %in% nonendemic_stacs
  )
  return(any_nonendemics)
}
