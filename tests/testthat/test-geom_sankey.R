library(testthat)
library(dplyr)
library(tidyr)
library(ggplot2)

df <- mtcars %>%
  as_tibble() %>%
  drop_na() %>%
  make_long(cyl, vs, am, gear, carb)

df <- df %>%
  dplyr::mutate(
    shift = case_when(
      x == "cyl" & node == 4 ~ -20,
      x == "cyl" & node == 6 ~ -10,
      T ~ 0
    )
  )

p_titanic_sankey <- ggplot(df, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = factor(node), label = node, shift = shift)) +
  geom_sankey(flow.alpha = .6) +
  geom_sankey_text(size = 3) +
  scale_fill_viridis_d() +
  theme_sankey(base_size = 26) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5)) +
  ggtitle("The Titanic data set")
# p_titanic_sankey

test_that("multiplication works", {
  expect_equal(p_titanic_sankey %>% class(), c("gg", "ggplot"))
})
