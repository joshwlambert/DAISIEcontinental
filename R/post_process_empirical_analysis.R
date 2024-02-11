#' Compiles and saves DAISIE inference model output across the parameter space
#'
#' @inheritParams default_params_doc
#'
#' @return Invisibly returns `"Finsished"` (used for saving file)
#' @export
post_process_empirical_analysis <- function(data_folder_path, # nolint function name lintr
                                            output_file_path) {

  files <- list.files(data_folder_path)

  rm_prefix <- gsub(
    pattern = "empirical_param_set_", replacement = "", x = files
  )
  rm_suffix <- gsub("_.*", "", rm_prefix)
  param_set <- as.numeric(rm_suffix)

  for (i in unique(param_set)) {
    idx <- param_set == i
    param_set_files <- files[idx]

    if (length(param_set_files) == 0) {
      stop("No results are in the results directory")
    } else {
      file_paths <- as.list(paste0(data_folder_path, "/", param_set_files))
      results_list <- lapply(file_paths, readRDS)
    }

    # organise mls
    ml <- lapply(results_list, "[[", "ml")

    # extract and check taxonomic group
    taxonomic_group <- lapply(results_list, "[[", "taxonomic_group")
    taxonomic_group_1 <- taxonomic_group[[1]]
    if (!all(sapply(taxonomic_group, identical, taxonomic_group_1))) {
      stop("Taxonomic group is not the same across replicates")
    }

    output <- list(
      ml = ml,
      taxonomic_group = taxonomic_group_1
    )

    output_name <- paste0("empirical_param_set_", i, ".rds")
    output_file <- file.path(output_file_path, output_name)
    saveRDS(output, file = output_file)
  }
  invisible("Finished")
}
