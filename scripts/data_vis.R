ContinentalTesting::plot_param_diffs(
  param_set = 1,
  data_folder_path = file.path("results"),
  output_file_path = file.path("plots", "param_estimates_1.png"),
  signif = 3,
  scientific = FALSE,
  transform = "ihs"
)

ContinentalTesting::plot_param_diffs(
  param_set = 9,
  data_folder_path = file.path("results"),
  output_file_path = file.path("plots", "param_estimates_9.png"),
  signif = 3,
  scientific = FALSE,
  transform = "ihs"
)

ContinentalTesting::plot_param_diffs(
  param_set = 17,
  data_folder_path = file.path("results"),
  output_file_path = file.path("plots", "param_estimates_17.png"),
  signif = 3,
  scientific = FALSE,
  transform = "ihs"
)
