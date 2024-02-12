data_folder_path <- ifelse(
  test = is_testing(),
  yes = file.path("..", "..", "inst", "post_processed_daisie_results"),
  no = file.path("inst", "post_processed_daisie_results")
)

test_that("plot_param_diffs (no save) runs silent without error", {
  expect_silent(
    DAISIEcontinental::plot_param_diffs(
      param_set = 1,
      data_folder_path = data_folder_path,
      output_file_path = NULL,
      signif = 3,
      scientific = FALSE,
      transform = "ihs"
    )
  )
})

test_that("plot_param_diffs (save) runs silent without error", {
  output_filename <- tempfile(
    pattern = "",
    tmpdir = tempdir(),
    fileext = ".png"
  )
  expect_false(file.exists(output_filename))

  expect_silent(
    DAISIEcontinental::plot_param_diffs(
      param_set = 1,
      data_folder_path = data_folder_path,
      output_file_path = output_filename,
      signif = 3,
      scientific = FALSE,
      transform = "ihs"
    )
  )
  file.remove(output_filename)
  expect_false(file.exists(output_filename))
})
