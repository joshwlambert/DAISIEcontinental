total_time <- c(1, 2, 3)
replicates <- 2
ml <- vector("list", length(total_time))

for (i in seq_along(ml)) {
  ml[[i]] <- data.frame(
    lambda_c = runif(n = 1, 0.5, 2),
    mu = runif(n = 1, 0.5, 2),
    K = runif(n = 1, 1, 20),
    gamma = runif(n = 1, 0.001, 0.1),
    lambda_a = runif(n = 1, 0.5, 2),
    prob_init_pres = runif(n = 1, 0.01, 1),
    loglik = runif(n = 1, -100, -50),
    df = 6,
    conv = 0
  )
}

test_that("calc_param_diffs works as expected", {
  param_diffs <- DAISIEcontinental::calc_param_diffs(
    ml = ml,
    param_set = param_space[1, ]
  )
  expect_length(param_diffs, 6)
  expect_type(param_diffs, "list")
  expect_named(
    param_diffs,
    c("clado_diffs", "ext_diffs", "k_diffs", "immig_diffs", "ana_diffs",
      "prob_init_pres_diffs")
  )
  expect_true(all(sapply(param_diffs, length) == 3))
})
