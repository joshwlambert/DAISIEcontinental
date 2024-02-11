#' Simulate and format continental island DAISIE data
#'
#' @description Simulated DAISIE data (from [DAISIE::DAISIE_sim_cr()]) is
#' augmented/formatted after the simulation in `sim_max_age = TRUE` which
#' changes the endemicity status (stac) of the simulated DAISIE data. This is
#' in order to be analysed by the continental DAISIE inference model.
#' `sim_max_age = FALSE` leaves the simulated data with the precise ages.
#'
#' @inheritParams default_params_doc
#'
#' @return A list of DAISIE data lists ([DAISIE::DAISIE_sim_cr()]).
#' @export
sim_continental_island <- function(total_time, # nolint cyclocomp
                                   m,
                                   island_pars,
                                   nonoceanic_pars,
                                   replicate,
                                   seed,
                                   verbose,
                                   sim_max_age = TRUE) {
  sims <- list()
  seed <- replicate * seed
  for (i in seq_along(total_time)) {
    # set seed for each island age sim to be as similar as possible
    message("Replicate seed: ", seed)
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
      replicates = 1,
      divdepmodel = "CS",
      nonoceanic_pars = c(nonoceanic_pars[1], 1),
      plot_sims = FALSE,
      verbose = verbose
    )

    # augment DAISIE data list to make vicariant species max ages
    if (sim_max_age) {
      for (j in seq_along(sims[[1]])) {
        sim <- sims[[1]][[j]]
        for (k in 2:length(sim)) {
          vicariant_species <-
            sim[[k]]$branching_times[1] == sim[[k]]$branching_times[2]
          species_endemism <-  sim[[k]]$stac
          num_clado_events <- length(sim[[k]]$branching_times) - 1
          if (vicariant_species && species_endemism == 4) {
            sim[[k]]$stac <- 1
          } else if (vicariant_species && species_endemism == 2 &&
                       num_clado_events >= 1) {
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
  }

  return(sims)
}
