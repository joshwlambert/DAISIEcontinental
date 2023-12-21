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

  clado_diffs <- list()
  ext_diffs <- list()
  k_diffs <- list()
  immig_diffs <- list()
  ana_diffs <- list()
  prob_init_pres_diffs <- list()

  for (i in seq_along(ml)) {
    clado_diffs_i <- c()
    ext_diffs_i <- c()
    k_diffs_i <- c()
    immig_diffs_i <- c()
    ana_diffs_i <- c()
    prob_init_pres_diffs_i <- c()

    for (j in seq_along(ml[[i]])) {
      clado_diffs_i[j] <- ml[[i]][[j]]$lambda_c - param_set$island_clado
      ext_diffs_i[j] <- ml[[i]][[j]]$mu - param_set$island_ex
      k_diffs_i[j] <- ml[[i]][[j]]$K - param_set$island_k
      immig_diffs_i[j] <- ml[[i]][[j]]$gamma - param_set$island_immig
      ana_diffs_i[j] <- ml[[i]][[j]]$lambda_a - param_set$island_ana
      prob_init_pres_diffs_i[j] <- ml[[i]][[j]]$prob_init_pres - param_set$prob_init_pres
    }

    clado_diffs[[i]] <- clado_diffs_i
    ext_diffs[[i]] <- ext_diffs_i
    k_diffs[[i]] <- k_diffs_i
    immig_diffs[[i]] <- immig_diffs_i
    ana_diffs[[i]] <- ana_diffs_i
    prob_init_pres_diffs[[i]] <- prob_init_pres_diffs_i

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
