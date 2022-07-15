prob_init_presence <- 0.9

loglik_list <- list()

sims <- DAISIE::DAISIE_sim_cr(
  time = 1,
  M = 100,
  pars = c(0.1, 0.1, 50, 0.01, 0.1),
  replicates = 10,
  divdepmodel = "CS",
  nonoceanic_pars = c(prob_init_presence, 0),
  verbose = FALSE,
  plot_sims = FALSE
)

for (i in seq_along(sims)) {
  for (j in 2:length(sims[[i]])) {
    vicariant_species <-
      sims[[i]][[j]]$branching_times[1] == sims[[i]][[j]]$branching_times[2]
    species_endemism <-  sims[[i]][[j]]$stac
    num_clado_events <- length(sims[[i]][[j]]$branching_times) - 1
    if (vicariant_species && species_endemism == 4) {
      sims[[i]][[j]]$stac <- 1
    } else if (vicariant_species && species_endemism == 2 && num_clado_events >= 2) {
      sims[[i]][[j]]$stac <- 6
    } else if (vicariant_species && species_endemism == 2) {
      sims[[i]][[j]]$stac <- 5
    } else if (vicariant_species && species_endemism == 3) {
      sims[[i]][[j]]$stac <- 7
    }
  }
}

pip <- seq(0.1, 1.0, 0.05)
for (i in seq_along(pip)) {
  message("pip = ", pip[i])
  logliks <- c()
  for (j in seq_along(sim)) {
    message("replicate = ", j)
    loglik <- DAISIE::DAISIE_loglik_CS(
      pars1 = c(0.1, 0.1, 50, 0.01, 0.1, pip[i]),
      pars2 = c(1.0e+02, 1.1e+01, 0.0e+00, 0.0e+00, NA, 0.0e+00, 1.0e-04, 1.0e-05,
                1.0e-07, 4.0e+03, 9.5e-01, 9.8e-01),
      datalist = sim[[1]],
      methode = "lsodes",
      CS_version = 1,
      abstolint = 1e-16,
      reltolint = 1e-10
    )

    logliks <- c(logliks, loglik)
  }

  loglik_list[[i]] <- logliks
}

mean_loglik <- sapply(loglik_list, mean)

plot(
  seq(0.1, 1.0, 0.05),
  mean_loglik,
  ylab = "Loglikelihood",
  xlab = "Probability of Initial Presence")
