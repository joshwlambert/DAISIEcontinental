ct_sim <- function(island_age,
                   num_mainland_species,
                   clado_rate,
                   ext_rate,
                   carrying_cap,
                   immig_rate,
                   ana_rate,
                   replicates,
                   prob_init_pres,
                   prob_init_endemic,
                   verbose) {
    stopifnot(
      "replicates need to be an integer larger than 1" =
        replicates > 1
    )
    mls <- list()
    for (i in seq_along(prob_init_pres)) {
      sims <- DAISIE::DAISIE_sim_cr(
        time = island_age,
        M = num_mainland_species,
        pars = c(clado_rate, ext_rate, carrying_cap, immig_rate, ana_rate),
        replicates = replicates,
        divdepmodel = "CS",
        nonoceanic_pars = c(prob_init_pres[i], 1 - prob_init_endemic),
        plot_sims = FALSE,
        verbose = verbose
      )

      sims <- lapply(sims, format_continental_data)

      mls[[i]] <- data.frame(
        lambda_c = clado_rate,
        mu = ext_rate,
        K = carrying_cap,
        gamma = immig_rate,
        lambda_a = ana_rate,
        prob_init_pres = prob_init_pres[i],
        loglik = NA_real_,
        df = NA_real_,
        conv = NA_integer_
      )
      for (j in seq_along(sims)) {
        message("ML optimisation ", j, " of ", length(sims))
        ml <- DAISIE::DAISIE_ML_CS(
          datalist = sims[[j]],
          initparsopt = c(
            clado_rate,
            ext_rate,
            carrying_cap,
            immig_rate,
            ana_rate,
            prob_init_pres[i]
          ),
          idparsopt = 1:6,
          parsfix = NULL,
          idparsfix = NULL,
          ddmodel = 11,
          methode = "lsodes",
          optimmethod = "subplex",
          tol = c(1e-01, 1e-01, 1e-02)
        )
        mls[[i]] <- rbind(mls[[i]], ml)
      }
    }

    return(mls)
}

plot_pip_error <- function(res) {
  prob_init_pres <- unlist(lapply(res, \(x) vapply(x, "[[", FUN.VALUE = numeric(1), "prob_init_pres")))


  pip <- lapply(res, \(x) diff(x$prob_init_pres))
}

plot_pip_dist <- function(res) {
  # extract prob_init_pres values
  pip <- lapply(res, "[[", "prob_init_pres")
  # extract true prob_init_pres
  true_pip <- lapply(pip, "[[", 1)
  # extract estimated prob_init_pres
  estim_pip <- lapply(pip, \(x) x[-1])
  # replicate true prob_init_pres for each estimate


  df <- data.frame(true = unlist(true_pip), estim = unlist(estim_pip))
}

