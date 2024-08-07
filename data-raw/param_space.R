## code to prepare `param_space` dataset goes here

# consider varying probability varicariant species in endemic (prob_init_endemic = c(0.1, 0.5, 0.9)) # nolint comment

# species source islands parameter space
species_source_param_space <- expand.grid(
  total_time = list(c(5, 10, 50)),
  m = c(250),
  island_clado = c(0.5),
  island_ex = c(1e-15, 0.25, 0.5),
  island_k = c(10, 50),
  island_immig = c(0.01),
  island_ana = c(0.5),
  prob_init_pres = c(0.1, 0.5, 0.9),
  stringsAsFactors = FALSE
)

# species sink islands parameter space
species_sink_param_space <- expand.grid(
  total_time = list(c(5, 10, 50)),
  m = c(250),
  island_clado = c(0.25),
  island_ex = c(0.5),
  island_k = c(Inf),
  island_immig = c(0.05),
  island_ana = c(0.5),
  prob_init_pres = c(0.1, 0.5, 0.9),
  stringsAsFactors = FALSE
)

continental_test_param_space <- rbind(
  species_source_param_space,
  species_sink_param_space
)

seed <- sample(x = 1:100000, size = nrow(continental_test_param_space))
param_space <- cbind(continental_test_param_space, seed)

usethis::use_data(param_space, overwrite = TRUE)
