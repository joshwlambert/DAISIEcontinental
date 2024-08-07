#' Plots a the estimated probability of initial presence across vicariance
#' simulation scenarios
#'
#' @description
#' Creates 2x2 facetted plot with the estimated vicariance parameter
#' (`prob_init_pres`) across optimisation methods, and `epss` values (i.e.
#' the difference between island age and maximum colonisation time).
#' Differences in simulated cladogenesis and anagensis rate are also plotted.
#'
#' @inheritParams default_params_doc
#' @param parameter A `character` string with either: `"prob_init_pres"` or
#' `"loglik"`.
#'
#' @return Void (saves plot)
#' @export
plot_vicariance_scatter <- function(data_folder_path,
                                    output_file_path,
                                    parameter) {

  parameter <- match.arg(parameter, choices = c("prob_init_pres", "loglik"))
  file <- list.files(data_folder_path, pattern = "param_sets")

  if (length(file) == 0) {
    stop("No results are in the results directory")
  } else {
    file_path <- paste0(data_folder_path, "/", file)
    results <- readRDS(file_path)
  }

  # Fix build warnings
  total_time <- NULL; rm(total_time) # nolint start
  prob_init_pres <- NULL; rm(prob_init_pres)
  island_clado <- NULL; rm(island_clado)
  island_ana <- NULL; rm(island_ana)
  loglik <- NULL; rm(loglik)
  optimmethod <- NULL; rm(optimmethod)
  epss <- NULL; rm(epss) # nolint end

  vicariance_scatter <- ggplot2::ggplot(data = results)

  if (parameter == "prob_init_pres") {
    vicariance_scatter <- vicariance_scatter +
      ggplot2::geom_point(mapping = ggplot2::aes(
        x = total_time, y = prob_init_pres, colour = as.factor(island_clado),
        shape = as.factor(island_ana))) +
      ggplot2::scale_y_continuous(
        name = "Probability of initial presence (p)",
        limits = c(0, 1)
      )
  } else {
    vicariance_scatter <- vicariance_scatter +
      ggplot2::geom_point(mapping = ggplot2::aes(
        x = total_time, y = loglik, colour = as.factor(island_clado),
        shape = as.factor(island_ana))) +
      ggplot2::scale_y_continuous(
        name = expression(DAISIE ~ log ~ likelihood ~ hat(L))
      )
  }

  vicariance_scatter  <- vicariance_scatter +
    ggplot2::scale_x_continuous(name = "Island Age (Million of years)") +
    ggplot2::scale_color_manual(
      name = "Cladogensis Rate",
      values = c("#228B22", "#F87217")) +
    ggplot2::scale_shape_manual(
      name = "Anagensis Rate",
      values = c(19, 1)) +
    ggplot2::facet_wrap(
      facets = ggplot2::vars(optimmethod, epss),
      labeller = ggplot2::label_both
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = 10, face = "bold")
    )

  if (!is.null(output_file_path)) {
    ggplot2::ggsave(
      plot = vicariance_scatter,
      filename = output_file_path,
      device = "png",
      width = 250,
      height = 150,
      units = "mm",
      dpi = 300
    )
  } else {
    return(vicariance_scatter)
  }
}
