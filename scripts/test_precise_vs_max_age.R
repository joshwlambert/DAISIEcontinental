oceanic_data <- DAISIE::DAISIE_sim_cr(
  time = 1,
  M = 100,
  pars = c(1, 1, 50, 0.2, 1),
  replicates = 1,
  divdepmodel = "CS",
  nonoceanic_pars = c(0, 0)
)

nonoceanic_data_precise <- DAISIE::DAISIE_sim_cr(
  time = 1,
  M = 100,
  pars = c(1, 1, 50, 0.2, 1),
  replicates = 1,
  divdepmodel = "CS",
  nonoceanic_pars = c(0.9, 0)
)

nonoceanic_data_max_age <- nonoceanic_data_precise

for (i in 2:length(nonoceanic_data_max_age[[1]])) {
  if (nonoceanic_data_max_age[[1]][[i]]$branching_times[1] ==
      nonoceanic_data_max_age[[1]][[i]]$branching_times[2]) {
    nonoceanic_data_max_age[[1]][[i]]$branching_times[2] <-
      nonoceanic_data_max_age[[1]][[i]]$branching_times[2] - 1.1e-5

    if (nonoceanic_data_max_age[[1]][[i]]$stac == 2) {
      nonoceanic_data_max_age[[1]][[i]]$stac <- 6
    }

    if (nonoceanic_data_max_age[[1]][[i]]$stac == 4) {
      nonoceanic_data_max_age[[1]][[i]]$stac <- 1
    }

    if (nonoceanic_data_max_age[[1]][[i]]$stac == 3) {
      nonoceanic_data_max_age[[1]][[i]]$stac <- 7
    }
  }
}

DAISIE::DAISIE_ML_CS(
  datalist = oceanic_data[[1]],
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)

DAISIE::DAISIE_ML_CS(
  datalist = nonoceanic_data_precise[[1]],
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)

DAISIE::DAISIE_ML_CS(
  datalist = nonoceanic_data_max_age[[1]],
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)
