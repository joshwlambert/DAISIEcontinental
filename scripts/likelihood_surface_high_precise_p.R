# test how flat the likelihood surface is for a high value of p for precise col times

# run read_results script first to get data

results[[26]]$res$mls[[1]][[1]]

lambda_c <- 0.3673695
mu <- 1.737519e-15
K <- 14.25096
gamma <- 0.690011
lambda_a <- 0.7689067
prob_init_pres <- 0.3185377


results[[26]]$res$sims

logliks <- c()
for (j in seq(0.01, 1.00, 0.01)) {
  message("p = ", j)
  loglik <- DAISIE::DAISIE_loglik_CS(
    pars1 = c(lambda_c, mu, K, gamma, lambda_a, j),
    pars2 = c(1.0e+02, 1.1e+01, 0.0e+00, 0.0e+00, NA, 0.0e+00, 1.0e-04, 1.0e-05,
              1.0e-07, 4.0e+03, 9.5e-01, 9.8e-01),
    datalist = results[[26]]$res$sims[[1]],
    methode = "lsodes",
    CS_version = 1,
    abstolint = 1e-16,
    reltolint = 1e-10
  )

  logliks <- c(logliks, loglik)
}

plot(
  seq(0.01, 1.0, 0.01),
  logliks,
  xlab = "Probability of initial presence",
  ylab = "Log likelihood"
)
