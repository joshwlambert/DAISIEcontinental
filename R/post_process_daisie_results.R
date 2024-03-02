#' Compiles and saves DAISIE inference model output across the parameter space
#'
#' @inheritParams default_params_doc
#'
#' @return Invisibly returns `"Finsished"` (used for saving file)
#' @export
post_process_daisie_results <- function(data_folder_path,
                                        output_file_path) {
  files <- list.files(data_folder_path)

  rm_prefix <- gsub(pattern = "param_set_", replacement = "", x = files)
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

    # extract and check sim_params
    sim_params <- lapply(results_list, "[[", "sim_params")
    sim_params_1 <- sim_params[[1]]
    if (!all(sapply(sim_params, identical, sim_params_1))) {
      stop("Simulation parameters are not the same across replicates")
    }

    # organise param_diffs
    param_diffs <- lapply(results_list, "[[", "param_diffs")
    # check that the young, old, ancient is in this order
    young_param_diffs <- lapply(param_diffs, function(x) {
      lapply(x, "[[", 1)
    })
    old_param_diffs <- lapply(param_diffs, function(x) {
      lapply(x, "[[", 2)
    })
    ancient_param_diffs <- lapply(param_diffs, function(x) {
      lapply(x, "[[", 3)
    })

    param_diffs <- list(
      clado_diffs = list(
        young = sapply(young_param_diffs, "[[", "clado_diffs"),
        old = sapply(old_param_diffs, "[[", "clado_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "clado_diffs")
      ),
      ext_diffs = list(
        young = sapply(young_param_diffs, "[[", "ext_diffs"),
        old = sapply(old_param_diffs, "[[", "ext_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "ext_diffs")
      ),
      k_diffs = list(
        young = sapply(young_param_diffs, "[[", "k_diffs"),
        old = sapply(old_param_diffs, "[[", "k_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "k_diffs")
      ),
      immig_diffs = list(
        young = sapply(young_param_diffs, "[[", "immig_diffs"),
        old = sapply(old_param_diffs, "[[", "immig_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "immig_diffs")
      ),
      ana_diffs = list(
        young = sapply(young_param_diffs, "[[", "ana_diffs"),
        old = sapply(old_param_diffs, "[[", "ana_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "ana_diffs")
      ),
      prob_init_pres_diffs = list(
        young = sapply(young_param_diffs, "[[", "prob_init_pres_diffs"),
        old = sapply(old_param_diffs, "[[", "prob_init_pres_diffs"),
        ancient = sapply(ancient_param_diffs, "[[", "prob_init_pres_diffs")
      )
    )

    # organise mls
    ml <- lapply(results_list, "[[", "ml")
    young_ml <- lapply(ml, "[[", 1)
    old_ml <- lapply(ml, "[[", 2)
    ancient_ml <- lapply(ml, "[[", 3)
    ml <- list(young = young_ml, old = old_ml, ancient = ancient_ml)

    output <- list(
      ml = ml,
      param_diffs = param_diffs,
      sim_params = sim_params_1
    )

    output_name <- paste0("param_set_", i, ".rds")
    output_file <- file.path(output_file_path, output_name)
    saveRDS(output, file = output_file)
  }
  invisible("Finished")
}
