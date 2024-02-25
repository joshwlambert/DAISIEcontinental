# script to profile the likelihood of the probability of initial presence
# parameter for the continental DAISIE inference model on empirical data by
# estimating all parameters except the probability of initial presence which is
# fixed

args <- commandArgs(TRUE)

args <- as.numeric(args)

param_set_idx <- args[1]
replicate <- args[2]

taxonomic_group <- c(
  "amphibian", "bird", "nonvolant_mammal", "squamate", "volant_mammal"
)
prob_init_pres <- seq(0, 0.9, 0.1)

param_space <- expand.grid(
  taxonomic_group = taxonomic_group,
  prob_init_pres = prob_init_pres,
  stringsAsFactors = FALSE
)

param_set <- param_space[param_set_idx, ]

datalist <- switch(param_set$taxonomic_group,
  amphibian = readRDS(system.file("madagascar_data", "amp_ddl_dna_ds_asr.rds", package = "DAISIEcontinental")),
  bird = readRDS(system.file("madagascar_data", "bird_ddl_dna_ds_asr.rds", package = "DAISIEcontinental")),
  nonvolant_mammal = readRDS(system.file("madagascar_data", "nvm_ddl_dna_ds_asr.rds", package = "DAISIEcontinental")),
  squamate = readRDS(system.file("madagascar_data", "squa_ddl_dna_ds_asr.rds", package = "DAISIEcontinental")),
  volant_mammal = readRDS(system.file("madagascar_data", "vm_ddl_dna_ds_asr.rds", package = "DAISIEcontinental"))
)

datalist <- datalist[[replicate]]

island_clado <- 0.1
island_ext <- 0.1
island_k <- 500
island_immig <- 0.01
island_ana <- 0.1

# run a oceanic DAISIE model on the data to get initial parameter estimates
ml_failure <- TRUE
while (ml_failure) {
  init_params <- DAISIE::DAISIE_ML_CS(
    datalist = datalist,
    initparsopt = c(
      island_clado, island_ext, island_k, island_immig, island_ana
    ),
    idparsopt = 1:5,
    parsfix = NULL,
    idparsfix = NULL,
    ddmodel = 11,
    methode = "lsodes",
    optimmethod = "simplex",
    res = 500
  )
  if (init_params$conv == -1) {
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
  } else if (init_params$conv == 0) {
    ml_failure <- FALSE
  } else {
    stop("Convergence error in likelihood optimisation")
  }
}

ml_failure <- TRUE
while (ml_failure) {
  ml <- DAISIE::DAISIE_ML_CS(
    datalist = datalist,
    initparsopt = c(
      init_params$lambda_c,
      init_params$mu,
      init_params$K,
      init_params$gamma,
      init_params$lambda_a
    ),
    idparsopt = 1:5,
    parsfix = param_set$prob_init_pres,
    idparsfix = 6,
    ddmodel = 11,
    methode = "lsodes",
    optimmethod = "simplex",
    res = 500
  )
  if (ml$conv == -1) {
    ml_failure <- TRUE
    message("Likelihood optimisation failed retrying with new initial values")
    island_clado <- stats::runif(n = 1,
                                 min = init_params$lambda_c / 2,
                                 max = init_params$lambda_c * 2)
    island_ex <- stats::runif(n = 1,
                              min = init_params$mu / 2,
                              max = init_params$mu * 2)
    island_k <- stats::runif(n = 1,
                             min = init_params$K / 2,
                             max = init_params$K * 2)
    island_immig <- stats::runif(n = 1,
                                 min = init_params$gamma / 2,
                                 max = init_params$gamma * 2)
    island_ana <- stats::runif(n = 1,
                               min = init_params$lambda_a / 2,
                               max = init_params$lambda_a * 2)
  } else if (ml$conv == 0) {
    ml_failure <- FALSE
  } else {
    stop("Convergence error in likelihood optimisation")
  }
}

output <- list(
  ml = ml,
  daisie_continental_data = datalist,
  taxonomic_group = param_set$taxonomic_group
)

output_name <- paste0("empirical_param_set_", param_set_idx, "_", replicate, ".rds")

output_folder <- file.path("inst", "pre_processed_empirical_results")

output_file_path <- file.path(output_folder, output_name)

saveRDS(object = output, file = output_file_path)

message("Finished")

