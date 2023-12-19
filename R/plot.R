plot.continental_test <- function(x, ...) {
  prob_init_pres <- unlist(lapply(res$mls, \(x) vapply(x, "[[", FUN.VALUE = numeric(1), "prob_init_pres")))
  logliks <- unlist(lapply(res$mls, \(x) vapply(x, "[[", FUN.VALUE = numeric(1), "loglik")))
  df <- data.frame(prob_init_pres = prob_init_pres, loglik = logliks)
  mean <- aggregate(df, list(prob_init_pres), mean)[, c(1, 3)]
  colnames(mean) <- c("prob_init_pres", "mean_loglik")
  sd <- aggregate(df, list(prob_init_pres), sd)[, c(1, 3)]
  colnames(sd) <- c("prob_init_pres", "sd_loglik")
  df <- merge(mean, sd, by = "prob_init_pres")

  ggplot2::ggplot(data = df) +
    ggplot2::geom_point(
      mapping = ggplot2::aes(
        x = prob_init_pres,
        y = mean_loglik
      )
    ) +
    ggplot2::geom_errorbar(
      mapping = ggplot2::aes(
        x = prob_init_pres,
        y = mean_loglik,
        ymin = mean_loglik - sd_loglik,
        ymax = mean_loglik + sd_loglik
      )
    )
}
