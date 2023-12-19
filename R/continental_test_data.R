#' Test the continental DAISIE model with empirical data
#'
#' @description Runs a test of the continental DAISIE model by fitting a
#' continental DAISIE MLE model to empirical data and estimating all parameters,
#' except the probability of initial presence which is fixed.
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
continental_test_data <- function(data,
                                  prob_init_species,
                                  prob_init_endemic,
                                  verbose) {
  browser()

  mls <- list()
  for (i in seq_len(data)) {

    mls[[i]] <- DAISIE::DAISIE_ML_CS(
      datalist = data[[i]],
      initparsopt = c(0.1, 0.1, 200, 0.01, 0.1),
      idparsopt = 1:5,
      parsfix = 0.5,
      idparsfix = 6,
      ddmodel = 11,
      methode = "lsodes",
      optimmethod = "simplex"
    )
  }

  out <- list(mls = mls, data = data)
  return(out)
}
