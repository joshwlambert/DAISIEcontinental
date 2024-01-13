test_that("sim_continental_island works as expected", {
  sims <- sim_continental_island(
    total_time = 5,
    m = 100,
    island_pars = c(0.5, 0.5, 50, 0.01, 0.5),
    nonoceanic_pars = c(0.1, 1),
    replicate = 1,
    seed = 123,
    verbose = FALSE,
    sim_max_age = TRUE
  )
  expect_length(sims, 1)
  expect_length(sims[[1]][[1]], 6)
})

test_that("sim_continental_island works with multiple total_times", {
  sims <- sim_continental_island(
    total_time = c(1, 5),
    m = 100,
    island_pars = c(0.5, 0.5, 50, 0.01, 0.5),
    nonoceanic_pars = c(0.1, 1),
    replicate = 1,
    seed = 123,
    verbose = FALSE,
    sim_max_age = TRUE
  )
  expect_length(sims, 2)
  expect_length(sims[[1]][[1]], 5)
})

test_that("sim_continental_island works with sim_max_age = FALSE", {
  sims <- sim_continental_island(
    total_time = c(1, 5),
    m = 100,
    island_pars = c(0.5, 0.5, 50, 0.01, 0.5),
    nonoceanic_pars = c(0.1, 1),
    replicate = 1,
    seed = 123,
    verbose = FALSE,
    sim_max_age = FALSE
  )
  expect_length(sims, 2)
  expect_length(sims[[1]][[1]], 5)
})
