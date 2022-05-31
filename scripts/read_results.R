files <- list.files(file.path("results"))
file_paths <- as.list(paste0(
  getwd(),
  "/results/",
  files
))
results <- lapply(file_paths, readRDS)
mls <- lapply(results, "[[", "mls")
pip <- unlist(lapply(mls, function(x) {
  x[[1]]$prob_init_pres
}))
