#' Simulate and format continental island DAISIE data
#'
#' @inheritParams default_params_doc
#'
#' @return A list of DAISIE data lists ([DAISIE::DAISIE_sim_cr()]).
#' @export
sim_continental_island <- function(total_time,
                                   m,
                                   island_pars,
                                   nonoceanic_pars,
                                   replicates,
                                   seed,
                                   verbose) {
  sims <- list()
  for (i in seq_along(total_time)) {

    # set seed for each island age sim to be as similar as possible
    set.seed(
      seed,
      kind = "Mersenne-Twister",
      normal.kind = "Inversion",
      sample.kind = "Rejection"
    )

    sims[[i]] <- DAISIE::DAISIE_sim_cr(
      time = total_time[i],
      M = m,
      pars = island_pars,
      replicates = replicates,
      divdepmodel = "CS",
      nonoceanic_pars = c(prob_init_pres, 1),
      plot_sims = FALSE,
      verbose = verbose
    )

    for (j in seq_along(sims[[1]])) {
      sim <- sims[[1]][[j]]
      for (k in 2:length(sim)) {
        vicariant_species <-
          sim[[k]]$branching_times[1] == sim[[k]]$branching_times[2]
        species_endemism <-  sim[[k]]$stac
        num_clado_events <- length(sim[[k]]$branching_times) - 1
        if (vicariant_species && species_endemism == 4) {
          sim[[k]]$stac <- 1
        } else if (vicariant_species && species_endemism == 2 && num_clado_events >= 1) {
          sim[[k]]$stac <- 6
        } else if (vicariant_species && species_endemism == 2) {
          sim[[k]]$stac <- 5
        } else if (vicariant_species && species_endemism == 3) {
          sim[[k]]$stac <- 7
        }
      }
      sims[[1]][[j]] <- sim
    }
  }

  return(sims)
}
