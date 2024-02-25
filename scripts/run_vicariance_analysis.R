args <- commandArgs(TRUE)

args <- as.numeric(args)

param_set_idx <- args[1]

param_space <- expand.grid(
  total_time = 1:50,
  m = 50,
  island_clado = c(0, 0.5),
  island_ex = 1e-30,
  island_k = 10,
  island_immig = 0,
  island_ana = c(0, 0.5),
  prob_init_pres = 1,
  prob_init_nonendemic = 1,
  optimmethod = c("simplex", "subplex"),
  epss = c(0, 1e-5),
  stringsAsFactors = FALSE
)

daisie_continental_data <- DAISIEcontinental::sim_continental_island(
  total_time = param_space$total_time[[param_set_idx]],
  m = param_space$m[[param_set_idx]],
  island_pars = c(param_space$island_clado[[param_set_idx]],
                  param_space$island_ex[[param_set_idx]],
                  param_space$island_k[[param_set_idx]],
                  param_space$island_immig[[param_set_idx]],
                  param_space$island_ana[[param_set_idx]]),
  nonoceanic_pars = c(param_space$prob_init_pres[[param_set_idx]],
                      param_space$prob_init_nonendemic[[param_set_idx]]),
  replicate = 1,
  seed = 1,
  verbose = TRUE,
  epss = param_space$epss[[param_set_idx]]
)

ml <- DAISIE::DAISIE_ML_CS(
  datalist = daisie_continental_data[[1]][[1]],
  initparsopt = c(param_space$island_clado[[param_set_idx]] + 1e-5,
                  param_space$island_ex[[param_set_idx]] + 1e-5,
                  param_space$island_k[[param_set_idx]] + 1e-5,
                  param_space$island_immig[[param_set_idx]] + 1e-5,
                  param_space$island_ana[[param_set_idx]] + 1e-5,
                  param_space$prob_init_pres[[param_set_idx]] - 1e-5),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  methode = "lsodes",
  optimmethod = param_space$optimmethod[[param_set_idx]],
  jitter = 1e-5
)

output <- list(
  ml = ml,
  sim_params = list(
    total_time = param_space$total_time[param_set_idx],
    island_clado = param_space$island_clado[param_set_idx],
    island_ex = param_space$island_ex[param_set_idx],
    island_k = param_space$island_k[param_set_idx],
    island_immig = param_space$island_immig[param_set_idx],
    island_ana = param_space$island_ana[param_set_idx],
    prob_init_pres = param_space$prob_init_pres[param_set_idx],
    optimmethod = param_space$optimmethod[param_set_idx],
    epss = param_space$epss[param_set_idx]
  )
)

output_name <- paste0("param_set_", param_set_idx, ".rds")

output_folder <- file.path("inst", "pre_processed_vicariance_results")

output_file_path <- file.path(output_folder, output_name)

saveRDS(object = output, file = output_file_path)

message("Finished")
