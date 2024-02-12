data_folder_path <- ifelse(
  test = is_testing(),
  yes = file.path("..", "..", "inst", "post_processed_empirical_results"),
  no = file.path("inst", "post_processed_empirical_results")
)

test_that("plot_loglik_dist (no save) runs silent without error", {
  expect_silent(
    plot_loglik_dist(
      data_folder_path = data_folder_path,
      output_file_path = NULL,
      parameter = "loglik"
    )
  )
})

test_that("plot_loglik_dist (save) runs silent without error", {
  output_filename <- tempfile(
    pattern = "",
    tmpdir = tempdir(),
    fileext = ".png"
  )
  expect_false(file.exists(output_filename))

  expect_silent(
    plot_loglik_dist(
      data_folder_path = data_folder_path,
      output_file_path = output_filename,
      parameter = "loglik"
    )
  )
  file.remove(output_filename)
  expect_false(file.exists(output_filename))
})
