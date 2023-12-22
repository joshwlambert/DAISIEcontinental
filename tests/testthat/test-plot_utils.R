test_that("create_ihs_breaks runs silent without error", {
  ihs_breaks <- create_ihs_breaks()
  expect_true(is.function(ihs_breaks))
})

test_that("create_labels runs silent without error", {
  labels <- create_labels(signif = 2)
  expect_true(is.function(labels))
})

test_that("scientific (TRUE) runs silent without error", {
  labels <- scientific(c(1, 2, 3, 4, 5), signif = 2, scientific = TRUE)
  expect_true(is.expression(labels))
  expect_length(labels, 5)
})

test_that("scientific (FALSE) runs silent without error", {
  labels <- scientific(c(1, 2, 3, 4, 5), signif = 2, scientific = FALSE)
  expect_true(is.expression(labels))
  expect_length(labels, 5)
})

test_that("choose_scientific runs silent without error", {
  labels <- choose_scientific(c(1e-5, 1, 1e5), signif = 2)
  expect_length(labels, 3)
  expect_true(is.character(labels))
  expect_equal(labels, c("1e-05", "1.0", "1e+05"))
})
