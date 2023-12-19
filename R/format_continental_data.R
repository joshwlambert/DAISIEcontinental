#' Format the continental data simulated with DAISIE::DAISIE_sim_cr()
#'
#' @description Changes the endemicity status (stac) of the simulated DAISIE data
#' in order to be analysed by the continental DAISIE inference model.
#'
#' @param sim Single DAISIE data list (1 replicate), output by
#' [DAISIE::DAISIE_sim_cr()].
#'
#' @return DAISIE data list.
#' @keywords internal
format_continental_data <- function(sim) {

    for (j in 2:length(sim)) {
      vicariant_species <-
        sim[[j]]$branching_times[1] == sim[[j]]$branching_times[2]
      species_endemism <-  sim[[j]]$stac
      num_clado_events <- length(sim[[j]]$branching_times) - 1
      if (vicariant_species && species_endemism == 4) {
        sim[[j]]$stac <- 1
      } else if (vicariant_species && species_endemism == 2 && num_clado_events >= 1) {
        sim[[j]]$stac <- 6
      } else if (vicariant_species && species_endemism == 2) {
        sim[[j]]$stac <- 5
      } else if (vicariant_species && species_endemism == 3) {
        sim[[j]]$stac <- 7
      }
    }


  return(sim)
}
