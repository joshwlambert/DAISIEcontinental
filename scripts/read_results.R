files <- list.files(file.path("results"))
file_paths <- as.list(paste0(
  getwd(),
  "/results/",
  files
))
results <- lapply(file_paths, readRDS)
res <- lapply(results, "[[", "res")
mls <- lapply(res, "[[", "mls")
mls <- lapply(mls, "[[", 1)
mls_precise <- lapply(mls, "[[", 1)
mls_max_age <- lapply(mls, "[[", 2)
params <- lapply(results, "[[", "params")
true_pip <- unlist(lapply(params, "[[", "prob_init_species"))
precise_pip <- unlist(lapply(mls_precise, function(x) {
  x$prob_init_pres
}))
ml_precise_gamma <- unlist(lapply(mls_precise, "[[", "gamma"))


max_age_pip <- unlist(lapply(mls_max_age, function(x) {
  x$prob_init_pres
}))

which(precise_pip > 1)
which(max_age_pip > 1)

which(precise_pip > 0.1 & precise_pip < 0.9)
which(max_age_pip > 0.1 & max_age_pip < 0.9)

which(precise_pip > max_age_pip)
which(max_age_pip > precise_pip)
hist(max_age_pip - precise_pip, breaks = 100)

hist(precise_pip, breaks = 100)
hist(max_age_pip, breaks = 100)

plot(true_pip, max_age_pip)

plot(precise_pip, ml_precise_gamma)
