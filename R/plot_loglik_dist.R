#' Plots a grid of violin plots of the distribution of loglik values from the
#' DAISIE inference model across values of probability of initial presence
#'
#' @inheritParams default_params_doc
#'
#' @return Void (saves plot)
#' @export
plot_loglik_dist <- function(data_folder_path,
                             output_file_path,
                             signif,
                             scientific = FALSE,
                             transform = NULL) {

  files <- list.files(data_folder_path, pattern = "empirical_")

  if (length(files) == 0) {
    stop("No results are in the results directory")
  } else {
    file_paths <- as.list(paste0(data_folder_path, "/", files))
    results_list <- lapply(file_paths, readRDS)
  }

  loglik <- unlist(lapply(
    results_list,
    function(x) {
      vapply(x, "[[", FUN.VALUE = numeric(1), "loglik")
    }
  ))

  prob_init_pres <- unlist(lapply(
    results_list,
    function(x) {
      vapply(results_list[[1]], "[[", FUN.VALUE = numeric(1), "prob_init_pres")
    }
  ))

  # temp line until results are in
  # for (i in seq_len(nrow(param_space))) prob_init_pres[[i]] <- rep(param_space$prob_init_pres[i], 20)

  # temp code until results are in
  taxonomic_group <- rep(c(
    "amphibian", "bird", "nonvolant_mammal", "squamate", "volant_mammal"
  ), each = 20, times = 9)

  plotting_data <- data.frame(
    prob_init_pres = prob_init_pres,
    loglik = loglik,
    taxonomic_group
  )

  loglik_dist <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_violin(
      mapping = ggplot2::aes(
        x = as.factor(prob_init_pres),
        y = loglik,
        fill = taxonomic_group
      )
    ) +
    ggplot2::facet_wrap(
      facets = ggplot2::vars(taxonomic_group),
      labeller = ggplot2::as_labeller(c(
        "amphibian" = "Amphibians",
        "bird" = "Birds",
        "nonvolant_mammal" = "NV Mammals",
        "squamate" = "Squamates",
        "volant_mammal" = "V Mammals"
      ))) +
    ggplot2::scale_y_continuous(name = expression(DAISIE ~ log ~ likelihood ~ hat(L))) +
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
      plot = loglik_dist,
      filename = output_file_path,
      device = "png",
      width = 180,
      height = 180,
      units = "mm",
      dpi = 600
    )
  } else {
    return(loglik_dist)
  }
}
