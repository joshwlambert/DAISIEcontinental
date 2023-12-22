suppressMessages({
  set.seed(
    1,
    kind = "Mersenne-Twister",
    normal.kind = "Inversion",
    sample.kind = "Rejection"
  )

  daisie_data_list_end <- DAISIE::DAISIE_sim_cr(
    time = 5,
    M = 100,
    pars = c(1.0, 0.5, 50, 0.01, 1000),
    replicates = 3,
    divdepmodel = "CS",
    nonoceanic_pars = c(0, 1),
    plot_sims = FALSE
  )

  daisie_data_list_nonend <- DAISIE::DAISIE_sim_cr(
    time = 5,
    M = 100,
    pars = c(0, 0.5, 50, 0.1, 0),
    replicates = 3,
    divdepmodel = "CS",
    nonoceanic_pars = c(0.5, 1),
    plot_sims = FALSE
  )
})

test_that("any_nonendemics works as expected", {
  expect_false(any_nonendemics(daisie_data_list = daisie_data_list_end[[1]]))
  expect_false(any_nonendemics(daisie_data_list = daisie_data_list_end[[2]]))
  expect_false(any_nonendemics(daisie_data_list = daisie_data_list_end[[3]]))

  expect_true(any_nonendemics(daisie_data_list = daisie_data_list_nonend[[1]]))
  expect_true(any_nonendemics(daisie_data_list = daisie_data_list_nonend[[2]]))
  expect_true(any_nonendemics(daisie_data_list = daisie_data_list_nonend[[3]]))
})
