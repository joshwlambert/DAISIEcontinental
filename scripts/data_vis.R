for (i in seq_len(18)) {
  DAISIEcontinental::plot_param_diffs(
    param_set = i,
    data_folder_path = file.path("inst", "post_processed_daisie_results"),
    output_file_path = file.path("inst", "plots", paste0("param_estimates_", i, ".png")),
    signif = 3,
    scientific = FALSE,
    transform = "ihs"
  )
}

DAISIEcontinental::plot_loglik_dist(
  data_folder_path = file.path("inst", "post_processed_empirical_results"),
  output_file_path = file.path("inst", "plots", "empirical_clado_dist.png"),
  parameter = "loglik"
)

DAISIEcontinental::plot_loglik_dist(
  data_folder_path = file.path("inst", "post_processed_empirical_results"),
  output_file_path = file.path("inst", "plots", "empirical_clado_dist.png"),
  parameter = "lambda_c"
)

DAISIEcontinental::plot_loglik_dist(
  data_folder_path = file.path("inst", "post_processed_empirical_results"),
  output_file_path = file.path("inst", "plots", "empirical_ext_dist.png"),
  parameter = "mu"
)

DAISIEcontinental::plot_loglik_dist(
  data_folder_path = file.path("inst", "post_processed_empirical_results"),
  output_file_path = file.path("inst", "plots", "empirical_immig_dist.png"),
  parameter = "gamma"
)

DAISIEcontinental::plot_loglik_dist(
  data_folder_path = file.path("inst", "post_processed_empirical_results"),
  output_file_path = file.path("inst", "plots", "empirical_ana_dist.png"),
  parameter = "lambda_a"
)
