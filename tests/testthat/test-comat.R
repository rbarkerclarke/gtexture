test_that("co-occurrence matrix generation (manhattan distance)", {
  # create test fitness landscape
  set.seed(42)
  a <- stats::runif(9, -1) %>% round
  #print(a)
  a <- array(a, dim = rep(3, 2))
  fl <- fitscape::FitLandDF(a)

  # print co-occurrence matrix
  cm <- get_comatrix(fl, 3)
  #print(cm)

  # manually calculated cm for 3x3: 1 1 0 1 0 0 0 -1 0
  ans_cm <- matrix(c(0 / 32, 4 / 32, 0 / 32,
                     4 / 32, 8 / 32, 5 / 32,
                     0 / 32, 5 / 32, 6 / 32),
                   nrow = 3)

  # test co-occurrence matrix
  expect_true("matrix" %in% class(cm))
  expect_equal(cm, t(cm))
  expect_equal(sum(cm), 1)
  expect_equal(cm, ans_cm)
})