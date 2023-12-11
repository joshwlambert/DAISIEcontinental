parameter_space <- expand.grid(
  island_age = c(1, 5, 10),
  clado_rate = c(0.5, 1),
  ext_rate = c(0.1, 0.5),
  ana_rate = c(0.1, 0.5),
  prob_init_species = c(0.1, 0.5, 0.9),
  prob_init_endemic = c(0.1, 0.5, 0.9)
)

res <- list()
for (i in seq_len(nrow(parameter_space))) {
  res[[i]] <- ContinentalTesting::run_continental_test(
    island_age = parameter_space$island_age[i],
    num_mainland_species = 100,
    clado_rate = parameter_space$clado_rate[i],
    ext_rate = parameter_space$ext_rate[i],
    carrying_cap = 50,
    immig_rate = 0.1,
    ana_rate = parameter_space$ana_rate[i],
    replicates = 1,
    prob_init_species = parameter_space$prob_init_species[i],
    prob_init_endemic = parameter_space$prob_init_endemic[i],
    verbose = TRUE
  )
}

output_name <- paste0("continental_test.rds")

output_folder <- file.path("results")

output_file_path <- file.path(output_folder, output_name)

saveRDS(object = res, file = output_file_path)

message("Finished")

