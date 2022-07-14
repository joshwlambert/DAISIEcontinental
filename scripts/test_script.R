island_age = 0.1
num_mainland_species = 100
clado_rate = 0.1
ext_rate = 0.1
carrying_cap = 50
immig_rate = 0.001
ana_rate = 0.1
replicates = 1
prob_init_species = 0.9
prob_init_endemic = 0.01
verbose = TRUE

sims <- DAISIE::DAISIE_sim_cr(
  time = island_age,
  M = num_mainland_species,
  pars = c(clado_rate, ext_rate, carrying_cap, immig_rate, ana_rate),
  replicates = replicates,
  divdepmodel = "CS",
  nonoceanic_pars = c(prob_init_species, 1 - prob_init_endemic),
  plot_sims = FALSE,
  verbose = verbose
)

sims_precise <- sims

for (i in seq_along(sims)) {
  for (j in 2:length(sims[[i]])) {
    vicariant_species <-
      sims[[i]][[j]]$branching_times[1] == sims[[i]][[j]]$branching_times[2]
    species_endemism <-  sims[[i]][[j]]$stac
    num_clado_events <- length(sims[[i]][[j]]$branching_times) - 1
    if (vicariant_species && species_endemism == 4) {
      sims[[i]][[j]]$stac <- 1
    } else if (vicariant_species && species_endemism == 2 && num_clado_events >= 1) {
      sims[[i]][[j]]$stac <- 6
    } else if (vicariant_species && species_endemism == 2) {
      sims[[i]][[j]]$stac <- 5
    } else if (vicariant_species && species_endemism == 3) {
      sims[[i]][[j]]$stac <- 7
    }
  }
}

sims_max_age <- sims

mls <- DAISIE::DAISIE_ML_CS(
  datalist = sims_precise[[i]],
  datatype = "single",
  initparsopt = c(
    clado_rate,
    ext_rate,
    carrying_cap,
    immig_rate,
    ana_rate,
    prob_init_species
  ),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  methode = "lsodes",
  optimmethod = "simplex"
)

mls <- DAISIE::DAISIE_ML_CS(
  datalist = sims_max_age[[i]],
  datatype = "single",
  initparsopt = c(
    clado_rate,
    ext_rate,
    carrying_cap,
    immig_rate,
    ana_rate,
    prob_init_species
  ),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  methode = "lsodes",
  optimmethod = "simplex"
)

