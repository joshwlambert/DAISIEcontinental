#' Calculates the differences in parameter estimates (cladogenesis, extinction,
#' carrying capacity, colonisation, and anagenesis) from the DAISIE maximum
#' likelihood model fitted to the ideal and empirical data sets simulated from
#' [sim_continental_island()]
#'
#' @inheritParams default_params_doc
#'
#' @return A list of five numeric vectors
#' @export
calc_param_diffs <- function(ml, param_set) {
  clado_diffs <- c()
  ext_diffs <- c()
  k_diffs <- c()
  immig_diffs <- c()
  ana_diffs <- c()
  prob_init_pres_diffs <- c()

  for (i in seq_along(ml)) {
    clado_diffs[i] <- ml[[i]]$lambda_c - param_set$island_clado
    ext_diffs[i] <- ml[[i]]$mu - param_set$island_ex
    k_diffs[i] <- ml[[i]]$K - param_set$island_k
    immig_diffs[i] <- ml[[i]]$gamma - param_set$island_immig
    ana_diffs[i] <- ml[[i]]$lambda_a - param_set$island_ana
    prob_init_pres_diffs[i] <- ml[[i]]$prob_init_pres - param_set$prob_init_pres
  }

  param_diffs <- list(
    clado_diffs = clado_diffs,
    ext_diffs = ext_diffs,
    k_diffs = k_diffs,
    immig_diffs = immig_diffs,
    ana_diffs = ana_diffs,
    prob_init_pres_diffs = prob_init_pres_diffs
  )

  return(param_diffs)
}
