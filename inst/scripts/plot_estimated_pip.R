# run read_results script first to get max_age_pip vector

ggplot2::ggplot(data = as.data.frame(max_age_pip)) +
  ggplot2::geom_density(
    mapping = ggplot2::aes(
      x = max_age_pip
    ),
    fill = "#008080",
    alpha = 0.5
  ) +
  ggplot2::scale_y_continuous("Density") +
  ggplot2::scale_x_continuous("Estimated Probability of Initial Presence (p)") +
  ggplot2::theme_classic()


data <- data.frame(true_pip = true_pip, max_age_pip = max_age_pip)
data$diff <- data$true_pip - data$max_age_pip
ggplot2::ggplot(data = data) +
  ggplot2::geom_density(
    mapping = ggplot2::aes(
      x = diff
    ),
    fill = "#8F00FF",
    alpha = 0.3
  ) +
  ggplot2::scale_y_continuous("Density") +
  ggplot2::scale_x_continuous("Delta p (true value - estimated value)") +
  ggplot2::theme_classic()
