for (i in seq_len(12)) {
  DAISIEcontinental::plot_param_diffs(
    param_set = i,
    data_folder_path = file.path("inst", "post_processed_daisie_results"),
    output_file_path = file.path("inst", "plots", paste0("param_estimates_", i, ".png")),
    signif = 3,
    scientific = FALSE,
    transform = "ihs"
  )
}
