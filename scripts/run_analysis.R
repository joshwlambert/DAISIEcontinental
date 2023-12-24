args <- commandArgs(TRUE)

args <- as.numeric(args)

data("param_space")

island_clado <- param_space$island_clado[args]
island_ex <- param_space$island_ex[args]
island_k <- param_space$island_k[args]
island_immig <- param_space$island_immig[args]
island_ana <- param_space$island_ana[args]
prob_init_pres <- param_space$prob_init_pres[args]
prob_init_nonendemic <- 1

daisie_continental_data <- DAISIEcontinental::sim_continental_island(
  total_time = param_space$total_time[[args]],
  m = param_space$m[args],
  island_pars = c(island_clado,
                  island_ex,
                  island_k,
                  island_immig,
                  island_ana),
  nonoceanic_pars = c(prob_init_pres, prob_init_nonendemic),
  replicates = param_space$replicates[args],
  seed = param_space$seed[args],
  verbose = TRUE
)

ml <- lapply(
  seq_along(param_space$total_time[[args]]),
  function(x) vector("list", param_space$replicates[args])
)

message("Number of likelihood integration steps permitted:")
DAISIE::DAISIE_CS_max_steps(1e8)

for (i in seq_along(daisie_continental_data)) {
  for (j in seq_len(param_space$replicates[args])) {
    ml_failure <- TRUE
    while (ml_failure) {
      optim_ana <- DAISIEcontinental::any_nonendemics(
        daisie_data_list = daisie_continental_data[[i]][[j]]
      )
      if (optim_ana) {
        ml[[i]][[j]] <- DAISIE::DAISIE_ML_CS(
          datalist = daisie_continental_data[[i]][[j]],
          initparsopt = c(island_clado,
                          island_ex,
                          island_k,
                          island_immig,
                          island_ana,
                          prob_init_pres),
          idparsopt = 1:6,
          parsfix = NULL,
          idparsfix = NULL,
          ddmodel = 11,
          methode = "odeint::runge_kutta_fehlberg78",
          optimmethod = "simplex",
          jitter = 1e-5
        )
      } else {
        ml[[i]][[j]] <- DAISIE::DAISIE_ML_CS(
          datalist = daisie_continental_data[[i]][[j]],
          initparsopt = c(island_clado,
                          island_ex,
                          island_k,
                          island_immig,
                          prob_init_pres),
          idparsopt = c(1:4, 6),
          parsfix = 0.5,
          idparsfix = 5,
          ddmodel = 11,
          methode = "odeint::runge_kutta_fehlberg78",
          optimmethod = "simplex",
          jitter = 1e-5
        )
      }
      if (ml[[i]][[j]]$conv == -1) {
        ml_failure <- TRUE
        message("Likelihood optimisation failed retrying with new initial values")
        island_clado <- stats::runif(n = 1,
                                     min = island_clado / 2,
                                     max = island_clado * 2)
        island_ex <- stats::runif(n = 1,
                                  min = island_ex / 2,
                                  max = island_ex * 2)
        island_k <- stats::runif(n = 1,
                                 min = island_k / 2,
                                 max = island_k * 2)
        island_immig <- stats::runif(n = 1,
                                     min = island_immig / 2,
                                     max = island_immig * 2)
        island_ana <- stats::runif(n = 1,
                                   min = island_ana / 2,
                                   max = island_ana * 2)
      } else if (ml[[i]][[j]]$conv == 0) {
        ml_failure <- FALSE
      } else {
        stop("Convergence error in likelihood optimisation")
      }
    }
  }
}

param_diffs <- DAISIEcontinental::calc_param_diffs(
  ml = ml,
  param_set = param_space[args, ]
)

output <- list(
  daisie_continental_data = daisie_continental_data,
  ml = ml,
  param_diffs = param_diffs,
  sim_params = list(
    island_clado = param_space$island_clado[args],
    island_ex = param_space$island_ex[args],
    island_k = param_space$island_k[args],
    island_immig = param_space$island_immig[args],
    island_ana = param_space$island_ana[args],
    prob_init_pres = param_space$prob_init_pres[args]
  )
)

output_name <- paste0("param_set_", args, ".rds")

output_folder <- file.path("results")

output_file_path <- file.path(output_folder, output_name)

saveRDS(object = output, file = output_file_path)

message("Finished")
