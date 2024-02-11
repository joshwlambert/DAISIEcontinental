#' Plots a grid of density plots of parameter estimates on the diagonal,
#' scatter plots of parameter estimates under the diagonal and scatter plots
#' of differences between ideal and empirical parameter estimates above the
#' diagonal.
#'
#' @inheritParams default_params_doc
#'
#' @return Void (saves plot)
#' @export
plot_param_diffs <- function(param_set,
                             data_folder_path,
                             output_file_path,
                             signif,
                             scientific = FALSE,
                             transform = NULL) {
  param_space_name <- paste0("param_set_", param_set, ".rds")
  files <- list.files(data_folder_path, pattern = param_space_name)

  if (length(files) == 0) {
    stop("No results are in the results directory")
  } else {
    file_paths <- as.list(paste0(data_folder_path, "/", files))
    results_list <- lapply(file_paths, readRDS)
    results_list <- results_list[[1]]
  }

  # this is hardcoded to assume three island ages
  young_ml <- results_list$ml[[1]]
  old_ml <- results_list$ml[[2]]
  ancient_ml <- results_list$ml[[3]]

  group <- c(
    rep("young", length(unlist(lapply(young_ml, "[[", "lambda_c")))),
    rep("old", length(unlist(lapply(old_ml, "[[", "lambda_c")))),
    rep("ancient", length(unlist(lapply(ancient_ml, "[[", "lambda_c"))))
  )

  clado <- c(
    unlist(lapply(young_ml, "[[", "lambda_c")),
    unlist(lapply(old_ml, "[[", "lambda_c")),
    unlist(lapply(ancient_ml, "[[", "lambda_c"))
  )
  ext <- c(
    unlist(lapply(young_ml, "[[", "mu")),
    unlist(lapply(old_ml, "[[", "mu")),
    unlist(lapply(ancient_ml, "[[", "mu"))
  )
  immig <- c(
    unlist(lapply(young_ml, "[[", "gamma")),
    unlist(lapply(old_ml, "[[", "gamma")),
    unlist(lapply(ancient_ml, "[[", "gamma"))
  )
  ana <- c(
    unlist(lapply(young_ml, "[[", "lambda_a")),
    unlist(lapply(old_ml, "[[", "lambda_a")),
    unlist(lapply(ancient_ml, "[[", "lambda_a"))
  )
  prob_init_pres <- c(
    unlist(lapply(young_ml, "[[", "prob_init_pres")),
    unlist(lapply(old_ml, "[[", "prob_init_pres")),
    unlist(lapply(ancient_ml, "[[", "prob_init_pres"))
  )

  # param diffs no longer used in the plot
  param_diffs_list <- lapply(results_list$param_diffs, unlist)

  sim_params <- results_list$sim_params
  sim_clado <- sim_params$island_clado
  sim_ext <- sim_params$island_ex
  sim_immig <- sim_params$island_immig
  sim_ana <- sim_params$island_ana
  sim_prob_init_pres <- sim_params$prob_init_pres

  plotting_data <- data.frame(
    group = group,
    clado = clado,
    ext = ext,
    immig = immig,
    ana = ana,
    prob_init_pres = prob_init_pres
  )

  # Fix build warnings
  group <- NULL; rm(group)
  clado <- NULL; rm(clado)
  ext <- NULL; rm(ext)
  immig <- NULL; rm(immig)
  ana <- NULL; rm(ana)
  prob_init_pres <- NULL; rm(prob_init_pres)

  if (is.null(transform)) {
    breaks <- scales::extended_breaks()
    trans <- "identity"
  } else if (transform == "ihs") {
    breaks <- create_ihs_breaks()
    trans <- scales::trans_new(
      name = "ihs",
      transform = asinh,
      inverse = sinh
    )
  }
  labels <- create_labels(
    signif = signif,
    scientific = scientific
  )
  x_guide <- ggplot2::guide_axis(angle = 25)
  y_guide <- ggplot2::guide_axis(angle = 0)

  clado_density <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_histogram(
      mapping = ggplot2::aes(x = clado, fill = group, colour = group),
      alpha = 0.3,
      position = "identity",
      bins = 10
    ) +
    ggplot2::scale_fill_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab("Density") +
    ggplot2::xlab(expression(lambda^c)) +
    ggplot2::geom_vline(xintercept = sim_clado, colour = "grey10") +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ext_density <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_histogram(
      mapping = ggplot2::aes(x = ext, fill = group, colour = group),
      alpha = 0.3,
      position = "identity",
      bins = 10
    ) +
    ggplot2::scale_fill_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab("Density") +
    ggplot2::xlab(expression(mu)) +
    ggplot2::geom_vline(xintercept = sim_ext, colour = "grey10") +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  immig_density <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_histogram(
      mapping = ggplot2::aes(x = immig, fill = group, colour = group),
      alpha = 0.3,
      position = "identity",
      bins = 10
    ) +
    ggplot2::scale_fill_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab("Density") +
    ggplot2::xlab(expression(gamma)) +
    ggplot2::geom_vline(xintercept = sim_immig, colour = "grey10") +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ana_density <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_histogram(
      mapping = ggplot2::aes(x = ana, fill = group, colour = group),
      alpha = 0.3,
      position = "identity",
      bins = 10
    ) +
    ggplot2::scale_fill_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab("Density") +
    ggplot2::xlab(expression(lambda^a)) +
    ggplot2::geom_vline(xintercept = sim_ana, colour = "grey10") +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  p_density <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_histogram(
      mapping = ggplot2::aes(x = prob_init_pres, fill = group, colour = group),
      alpha = 0.3,
      position = "identity",
      bins = 10
    ) +
    ggplot2::scale_fill_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab("Density") +
    ggplot2::xlab(expression(italic(p))) +
    ggplot2::geom_vline(
      xintercept = sim_prob_init_pres,
      colour = "grey10"
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ext_vs_clado <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = clado,
        y = ext, colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_clado,
        y = sim_ext
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(mu)) +
    ggplot2::xlab(expression(lambda^c)) +
    ggplot2::geom_vline(xintercept = sim_clado, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_ext, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  immig_vs_clado <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = clado,
        y = immig,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_clado,
        y = sim_immig
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(gamma)) +
    ggplot2::xlab(expression(lambda^c)) +
    ggplot2::geom_vline(xintercept = sim_clado, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_immig, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ana_vs_clado <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = clado,
        y = ana,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_clado,
        y = sim_ana
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(lambda^a)) +
    ggplot2::xlab(expression(lambda^c)) +
    ggplot2::geom_vline(xintercept = sim_clado, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_ana, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  p_vs_clado <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = clado,
        y = prob_init_pres,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_clado,
        y = sim_prob_init_pres
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(italic(p))) +
    ggplot2::xlab(expression(lambda^c)) +
    ggplot2::geom_vline(xintercept = sim_clado, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_prob_init_pres, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  immig_vs_ext <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = ext,
        y = immig,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_ext,
        y = sim_immig
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(gamma)) +
    ggplot2::xlab(expression(mu)) +
    ggplot2::geom_vline(xintercept = sim_ext, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_immig, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ana_vs_ext <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = ext,
        y = ana,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_ext,
        y = sim_ana
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(lambda^a)) +
    ggplot2::xlab(expression(mu)) +
    ggplot2::geom_vline(xintercept = sim_ext, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_ana, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  p_vs_ext <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = ext,
        y = prob_init_pres,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_ext,
        y = sim_prob_init_pres
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(italic(p))) +
    ggplot2::xlab(expression(mu)) +
    ggplot2::geom_vline(xintercept = sim_ext, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_prob_init_pres, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  ana_vs_immig <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = immig,
        y = ana,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_immig,
        y = sim_ana
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(lambda^a)) +
    ggplot2::xlab(expression(gamma)) +
    ggplot2::geom_vline(xintercept = sim_immig, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_ana, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  p_vs_immig <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = immig,
        y = prob_init_pres,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_immig,
        y = sim_prob_init_pres
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(italic(p))) +
    ggplot2::xlab(expression(gamma)) +
    ggplot2::geom_vline(xintercept = sim_immig, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_prob_init_pres, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  p_vs_ana <- ggplot2::ggplot(data = plotting_data) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = ana,
        y = prob_init_pres,
        colour = group
      ),
      shape = 16,
      alpha = 0.5
    ) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = sim_ana,
        y = sim_prob_init_pres
      ),
      shape = 15
    ) +
    ggplot2::scale_colour_manual(values = c("#1B842C", "#371F76", "#FFBF00")) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 10),
      text = ggplot2::element_text(size = 7),
      legend.position = "none"
    ) +
    ggplot2::ylab(expression(italic(p))) +
    ggplot2::xlab(expression(lambda^a)) +
    ggplot2::geom_vline(xintercept = sim_ana, colour = "grey50") +
    ggplot2::geom_hline(yintercept = sim_prob_init_pres, colour = "grey50") +
    ggplot2::scale_y_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = y_guide
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels,
      trans = trans,
      guide = x_guide
    )

  legend <- cowplot::get_legend(
    ext_vs_clado +
      ggplot2::guides(color = ggplot2::guide_legend(nrow = 1)) +
      ggplot2::theme(legend.position = "bottom")
  )

  param_estimates <- cowplot::plot_grid(
    clado_density, NULL, NULL, NULL, NULL,
    ext_vs_clado, ext_density, NULL, NULL, NULL,
    immig_vs_clado, immig_vs_ext, immig_density, NULL, NULL,
    ana_vs_clado, ana_vs_ext, ana_vs_immig, ana_density, NULL,
    p_vs_clado, p_vs_ext, p_vs_immig, p_vs_ana, p_density,
    align = "hv", nrow = 5, ncol = 5
  )

  param_estimates <- cowplot::plot_grid(
    param_estimates, legend, ncol = 1, rel_heights = c(1, 0.05)
  )

  title <- cowplot::ggdraw() +
    cowplot::draw_label(
      paste0("Probability of initial presence = ", sim_params$prob_init_pres),
      size = 12
    )

  param_estimates <- cowplot::plot_grid(
    title,
    param_estimates,
    nrow = 2, rel_heights = c(0.05, 1)
  )


  if (!is.null(output_file_path)) {
    ggplot2::ggsave(
      plot = param_estimates,
      filename = output_file_path,
      device = "png",
      width = 180,
      height = 180,
      units = "mm",
      dpi = 400
    )
  } else {
    return(param_estimates)
  }
}
