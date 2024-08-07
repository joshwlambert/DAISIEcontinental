#' Parameter space for the analysis of the DAISIE continental model.
#'
#' A dataset containing the parameter sets (rows) for the simulation of the
#' DAISIE continental model for the analysis of the error inferred by
#' DAISIE's maximum likelihood model.
#'
#' @format A data frame with 21 rows and 9 variables:
#' \describe{
#'   \item{total_time}{Duration of simulation (million years)}
#'   \item{m}{Number of species on the mainland}
#'   \item{island_clado}{Rate of cladogenesis on the island}
#'   \item{island_ex}{Rate of extinction on the island}
#'   \item{island_k}{Carrying capacity for each island clade}
#'   \item{island_immig}{Rate of immigration on the island}
#'   \item{island_ana}{Rate of anagenesis on the island}
#'   \item{prob_init_pres}{Probability of a mainland species being initially
#'     present on the island when it forms}
#'   \item{seed}{Sets the random number generator seed}
#' }
#' @usage data("param_space", package = "DAISIEcontinental")
"param_space"
