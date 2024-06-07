#' Compiles and saves DAISIE inference model output for the vicariance analysis
#'
#' @inheritParams default_params_doc
#'
#' @return Invisibly returns `"Finsished"` (used for saving file)
#' @export
post_process_vicariance_results <- function(data_folder_path,
                                            output_file_path) {
  files <- list.files(data_folder_path)

  if (length(files) == 0) {
    stop("No results are in the results directory")
  } else {
    file_paths <- as.list(paste0(data_folder_path, "/", files))
    results_list <- lapply(file_paths, readRDS)
  }

  ml <- lapply(results_list, "[[", "ml")
  ml <- do.call(rbind, ml)
  ml_cols <- c(
    "lambda_c", "mu", "K", "gamma", "lambda_a", "prob_init_pres", "loglik"
  )
  ml <- ml[, ml_cols]

  sim_params <- lapply(results_list, "[[", "sim_params")
  sim_params <- lapply(sim_params, as.data.frame)
  sim_params <- do.call(rbind, sim_params)
  colnames(sim_params) <- c(
    "total_time", "island_clado", "island_ex", "island_k", "island_immig",
    "island_ana", "true_p", "optimmethod", "epss"
  )

  output <- cbind(param_set = 1:nrow(ml), ml, sim_params)

  output_name <- paste0("param_sets.rds")
  output_file <- file.path(output_file_path, output_name)
  saveRDS(output, file = output_file)
  invisible("Finished")
}
