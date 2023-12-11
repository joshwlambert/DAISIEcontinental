#' Format the continental data simulated with DAISIE::DAISIE_sim_cr()
#'
#' @description Changes the endemicity status (stac) of the simulated DAISIE data
#' in order to be analysed by the continental DAISIE inference model.
#'
#' @param sims List of DAISIE data, output by [DAISIE::DAISIE_sim_cr()].
#' **Must have >= 1 replicate**.
#'
#' @return DAISIE data list.
#' @keywords internal
format_continental_data <- function(sims) {
  for (i in seq_along(sims)) {
    for (j in 2:length(sims[[i]])) {
      vicariant_species <-
        sims[[i]][[j]]$branching_times[1] == sims[[i]][[j]]$branching_times[2]
      species_endemism <-  sims[[i]][[j]]$stac
      num_clado_events <- length(sims[[i]][[j]]$branching_times) - 1
      if (vicariant_species && species_endemism == 4) {
        sims[[i]][[j]]$stac <- 1
      } else if (vicariant_species && species_endemism == 2 && num_clado_events >= 1) {
        sims[[i]][[j]]$stac <- 6
      } else if (vicariant_species && species_endemism == 2) {
        sims[[i]][[j]]$stac <- 5
      } else if (vicariant_species && species_endemism == 3) {
        sims[[i]][[j]]$stac <- 7
      }
    }
  }

  return(sims)
}
