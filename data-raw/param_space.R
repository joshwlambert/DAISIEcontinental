## code to prepare `param_space` dataset goes here

continental_test_param_space <- expand.grid(
  total_time = c(5, 10, 50),
  m = c(500),
  island_clado = c(0.5, 1.0),
  island_ex = c(0.25, 0.5),
  island_k = c(5, 50),
  island_immig = c(0.01),
  island_ana = c(0.5),
  prob_init_pres = c(0.1, 0.5, 0.9),
  replicates = c(500),
  stringsAsFactors = FALSE
)
seed <- sample(x = 1:100000, size = nrow(continental_test_param_space))
param_space <- cbind(continental_test_param_space, seed)

usethis::use_data(param_space, overwrite = TRUE)
