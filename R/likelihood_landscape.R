likelihood_landscape <- function(prob_init_presence_range = c(0, 1),
                                 prob_init_presence_increment = 0.01) {

  prob_init_presence <- seq(
    from = prob_init_presence_range[1],
    to = prob_init_presence_range[2],
    by = prob_init_presence_increment
  )

  logliks <- c()

  true_prob_init_presence <- c(0.1, 0.9)

  for (j in seq_along(true_prob_init_presence)) {
    sim <- DAISIE::DAISIE_sim_cr(
      time = 5,
      M = 1000,
      pars = c(1, 1, 50, 0.01, 1),
      replicates = 1,
      divdepmodel = "CS",
      nonoceanic_pars = c(true_prob_init_presence[j], 0.5),
      verbose = FALSE,
      plot_sims = FALSE
    )

    message(
      "True probability of initial presence = ", mean(prob_init_presence_range)
    )

    for (i in seq_along(prob_init_presence)) {

      message("i = ", i)

      loglik <- DAISIE::DAISIE_loglik_CS(
        pars1 = c(1, 1, 50, 0.01, 1, prob_init_presence[i]),
        pars2 = c(
          1.0e+02, 1.1e+01, 0.0e+00, 0.0e+00, NA, 0.0e+00, 1.0e-04, 1.0e-05,
          1.0e-07, 4.0e+03, 9.5e-01, 9.8e-01
        ),
        datalist = sim[[1]],
        methode = "lsodes",
        CS_version = 1,
        abstolint = 1e-16,
        reltolint = 1e-10
      )

      logliks[i] <- loglik
    }

    list(logliks = logliks, prob_init_presence = prob_init_presence)
  }

  plot(
    prob_init_presence,
    logliks,
    ylab = "Loglikelihood",
    xlab = "Probability of Initial Presence"
  )
}
