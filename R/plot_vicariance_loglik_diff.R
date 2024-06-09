#' Plots a the difference in estimated maxmimum log likelihood between the
#' optimisation algorithms (`optimmethod`) for each parameter set
#'
#' @inheritParams default_params_doc
#'
#' @return Void (saves plot)
#' @export
plot_vicariance_loglik_diff <- function(data_folder_path,
                                        output_file_path,
                                        prob_init_pres_diff_threshold = NULL,
                                        x_axis = c(
                                          "total_time",
                                          "prob_init_pres_diff")) {

  x_axis <- match.arg(x_axis)
  stopifnot(is.null(prob_init_pres_diff_threshold) ||
              is.numeric(prob_init_pres_diff_threshold))
  file <- list.files(data_folder_path, pattern = "param_sets")

  if (length(file) == 0) {
    stop("No results are in the results directory")
  } else {
    file_path <- paste0(data_folder_path, "/", file)
    results <- readRDS(file_path)
  }

  loglik_diff <- c()
  total_time <- c()
  prob_init_pres_diff <- c()
  for (i in unique(results$total_time)) {
    for (j in unique(results$island_clado)) {
      for (k in unique(results$island_ana)) {
        for (l in unique(results$epss)) {
          idx <- results$total_time == i &
            results$island_clado == j &
            results$island_ana == k &
            results$epss == l
          stopifnot(
            # check that only two rows are selected
            sum(idx) == 2,
            # check that it is simplex and subplex
            all(results[idx, "optimmethod"] %in% c("simplex", "subplex"))
          )
          subplex_idx <- results[idx, "optimmethod"] == "subplex"
          simplex_idx <- results[idx, "optimmethod"] == "simplex"
          loglik_diff <- c(
            loglik_diff,
            results[idx, "loglik"][simplex_idx] -
              results[idx, "loglik"][subplex_idx]
          )
          total_time <- c(total_time, results[idx, "total_time"][1])
          prob_init_pres_diff <- c(
            prob_init_pres_diff,
            abs(
              results[idx, "prob_init_pres"][simplex_idx] -
                results[idx, "prob_init_pres"][subplex_idx]
            )
          )
        }
      }
    }
  }
  df <- data.frame(
    total_time = total_time,
    loglik_diff = loglik_diff,
    prob_init_pres_diff = prob_init_pres_diff
  )

  # subset if prob_init_pres_diff_threshold is given
  if (!is.null(prob_init_pres_diff_threshold)) {
    idx <- df$prob_init_pres_diff > prob_init_pres_diff_threshold
    df <- df[idx, ]
  }


  vicariance_loglik_diff <- ggplot2::ggplot(data = df)

    if (x_axis == "total_time") {
      vicariance_loglik_diff <- vicariance_loglik_diff +
        ggplot2::geom_point(
          mapping = ggplot2::aes(
            x = total_time,
            y = loglik_diff
          )
        ) +
        ggplot2::scale_x_continuous(name = "Island Age (Million of years)")
    } else {
      vicariance_loglik_diff <- vicariance_loglik_diff +
        ggplot2::geom_point(
          mapping = ggplot2::aes(
            x = prob_init_pres_diff,
            y = loglik_diff
          )
        ) +
        ggplot2::scale_x_continuous(name = "Absolute difference in p")
    }
  vicariance_loglik_diff <- vicariance_loglik_diff +
    ggplot2::scale_y_continuous(
      name = "Difference in loglik (simplex - subplex)"
    ) +
    ggplot2::theme_classic()

  if (!is.null(output_file_path)) {
    ggplot2::ggsave(
      plot = vicariance_loglik_diff,
      filename = output_file_path,
      device = "png",
      width = 150,
      height = 150,
      units = "mm",
      dpi = 300
    )
  } else {
    return(vicariance_loglik_diff)
  }
}



