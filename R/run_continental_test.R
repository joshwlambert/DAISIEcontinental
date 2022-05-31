#' Runs a DAISIE simulation and maximum likelihood model
#'
#' @param island_age Duration of the island in millions of years
#' @param num_mainland_species NUmber of species in the mainland pool that can
#' colonise the island
#' @param clado_rate Rate of cladogenesis (cladogenetic speciation) (per species
#' per million years)
#' @param ext_rate Rate of extinction (extinction rate) (per species
#' per million years)
#' @param carrying_cap Carrying capacity for the clade-specific diversity-
#' dependence of cladogenesis and colonisation (immigration) rate
#' @param immig_rate Rate of immigration (colonisation) (per species
#' per million years)
#' @param ana_rate Rate of anagenesis (per species per million years)
#' @param replicates Number of replicates to run the simulation and maximum
#' likelihood DAISIE model
#' @param prob_init_species Probability of a species in the mainland species
#' pool being initially on the island (i.e. vicariant species).
#' @param prob_init_endemic Probability of a vicariant species being endemic. If
#' a species is not endemic it is non-endemic.
#' @param verbose Boolean determining whether to print to the console while
#' function runs.
#'
#' @return A list of two elements, the first with the simulated data and the
#' second with the maximum likelihood parameter estimates.
#' @export
#'
#' @examples
#' \dontrun{
#' example <- run_continental_test(
#'   island_age = 1,
#'   num_mainland_species = 100,
#'   clado_rate = 0.5,
#'   ext_rate = 0.1,
#'   carrying_cap = 50,
#'   immig_rate = 0.1,
#'   ana_rate = 0.5,
#'   replicates = 1,
#'   prob_init_species = 0.5,
#'   prob_init_endemic = 0.1,
#'   verbose = FALSE
#' }
run_continental_test <- function(island_age,
                                 num_mainland_species,
                                 clado_rate,
                                 ext_rate,
                                 carrying_cap,
                                 immig_rate,
                                 ana_rate,
                                 replicates,
                                 prob_init_species,
                                 prob_init_endemic,
                                 verbose) {

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

  mls <- list()
  for (i in seq_len(replicates)) {
    mls[[i]] <- DAISIE::DAISIE_ML_CS(
      datalist = sims[[i]],
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
  }

  list(sims = sims, mls = mls)
}
