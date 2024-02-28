#' Plots a grid of violin plots of the distribution of loglik values from the
#' DAISIE inference model across values of probability of initial presence
#'
#' @inheritParams default_params_doc
#'
#' @return Void (saves plot)
#' @export
plot_loglik_dist <- function(data_folder_path,
                             output_file_path,
                             parameter) {
  parameter <- match.arg(
    parameter,
    choices = c("lambda_c", "mu", "K", "gamma", "lambda_a", "loglik")
  )

  files <- list.files(data_folder_path, pattern = "empirical_")

  if (length(files) == 0) {
    stop("No results are in the results directory")
  } else {
    file_paths <- as.list(paste0(data_folder_path, "/", files))
    results_list <- lapply(file_paths, readRDS)
  }

  taxonomic_group <- vapply(
    results_list, "[[",
    FUN.VALUE = character(1), "taxonomic_group"
  )

  ml <- lapply(results_list, "[[", "ml")

  taxonomic_group <- rep(taxonomic_group, times = lengths(ml))

  param <- unlist(lapply(
    ml,
    function(x) {
      vapply(x, "[[", FUN.VALUE = numeric(1), parameter)
    }
  ))

  prob_init_pres <- unlist(lapply(
    ml,
    function(x) {
      vapply(x, "[[", FUN.VALUE = numeric(1), "prob_init_pres")
    }
  ))

  plotting_data <- data.frame(
    prob_init_pres = prob_init_pres,
    param = param,
    taxonomic_group = taxonomic_group
  )

  y_axis_lab <- switch(parameter,
    lambda_c = expression(Cladogenesis ~ rate ~ lambda^c),
    mu = expression(Extinction ~ rate ~ mu),
    K = "Carrying Capacity K'",
    gamma = expression(Colonisation ~ rate ~ gamma),
    lambda_a = expression(Anagenesis ~ rate ~ lambda^a),
    loglik = expression(DAISIE ~ log ~ likelihood ~ hat(L))
  )

  param_dist <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_violin(
      mapping = ggplot2::aes(
        x = as.factor(prob_init_pres),
        y = param,
        fill = taxonomic_group
      )
    ) +
    ggplot2::facet_wrap(
      facets = ggplot2::vars(taxonomic_group),
      scales = "free",
      labeller = ggplot2::as_labeller(c(
        "amphibian" = "Amphibians",
        "bird" = "Birds",
        "nonvolant_mammal" = "NV Mammals",
        "squamate" = "Squamates",
        "volant_mammal" = "V Mammals"
      ))
    ) +
    ggplot2::scale_y_continuous(name = y_axis_lab) +
    ggplot2::scale_x_discrete(name = "Probability of initial presence (p)") +
    ggplot2::scale_fill_manual(
      name = "Taxonomic group",
      labels = c(
        amphibian = "Amphibians",
        nonvolant_mammal = "NV Mammals",
        volant_mammal = "V Mammals",
        squamate = "Squamates",
        bird = "Birds"
      ),
      values = c("#7fbd2d", "#073dfd", "#a8856e", "#01783f", "#3d3d3d")
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(strip.background = ggplot2::element_blank())


  if (!is.null(output_file_path)) {
    ggplot2::ggsave(
      plot = param_dist,
      filename = output_file_path,
      device = "png",
      width = 250,
      height = 150,
      units = "mm",
      dpi = 300
    )
  } else {
    return(param_dist)
  }
}
