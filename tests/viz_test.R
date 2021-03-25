### Todo ggsankey
# make tests
# make readme

### Do later
# stright lines?
# viz with links that jumps x:s
# decisiontrees viz
# flow.labels
# facet title remove box

library(tidyverse)
library(gapminder)
library(titanic)
library(patchwork)
library(gapminder)
library(hablar)


# TESTS -------

# *Titanic -------

# **Sankey ---------------------------
df <- titanic::titanic_train %>%
  as_tibble() %>%
  drop_na() %>%
  mutate(Fare = round(Fare, -1)) %>%
  make_long(Embarked, Sex, Fare, Pclass, Survived)

df <- df %>%
  dplyr::mutate(
    shift = case_when(
      x == "Sex" & node == "male" ~ 300,
      x == "Sex" & node == "female" ~ -300,
      T ~ 0
    )
  )

p_titanic_sankey <- ggplot(df, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = node, label = node, shift = shift)) +
  geom_sankey(flow.alpha = .6) +
  geom_sankey_text(size = 3) +
  scale_fill_viridis_d() +
  theme_sankey(base_size = 26) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5)) +
  ggtitle("The Titanic data set")

# **Alluvial ---------------------------
df <- titanic::titanic_train %>%
  as_tibble() %>%
  drop_na() %>%
  make_long(Embarked, Sex, Pclass, Survived)

df <- df %>%
  dplyr::mutate(
    shift = case_when(
      x == "Sex" & node == "male" ~ 300,
      x == "Sex" & node == "female" ~ -300,
      T ~ 0
    )
  )

p_titanic_alluvial <- ggplot(df, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = node, label = node)) +
  geom_alluvial(flow.alpha = .6) +
  geom_alluvial_label(size = 8) +
  scale_fill_viridis_d() +
  theme_alluvial(base_size = 26) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5)) +
  ggtitle("The Titanic data set")

# **Alluvial facets ---------------------------
df <- bind_rows(
  titanic::titanic_train %>%
    as_tibble() %>%
    drop_na() %>%
    make_long(Embarked, Sex, Pclass, Survived) %>%
    dplyr::mutate(ppppp = 1),
  titanic::titanic_train %>%
    as_tibble() %>%
    drop_na() %>%
    make_long(Embarked, Sex, Pclass, Survived) %>%
    dplyr::mutate(ppppp = 2)
)

df <- df %>%
  dplyr::mutate(
    shift = case_when(
      x == "Sex" & node == "male" ~ 300,
      x == "Sex" & node == "female" ~ -300,
      T ~ 0
    )
  )

p_titanic_alluvial <- ggplot(df, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = node, label = node)) +
  geom_alluvial(flow.alpha = .6, smooth = 6) +
  geom_alluvial_label(size = 4) +
  scale_fill_viridis_d() +
  theme_alluvial(base_size = 12) +
  facet_wrap(~ppppp) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5)) +
  ggtitle("The Titanic data set")


# **SankeyBump ---------------------------
df <- gapminder %>%
  group_by(continent, year) %>%
  summarise(gdp = (sum_(pop * gdpPercap)/1e9) %>% round(0), .groups = "keep") %>%
  ungroup()

p_gapminder_bumpsankey <- ggplot(df, aes(x = year,
                                         node = continent,
                                         fill = continent,
                                         value = gdp)) +
  geom_sankey_bump(space = 0, type = "alluvial", color = "transparent", smooth = 6) +
  scale_fill_viridis_d(option = "A", alpha = .8) +
  theme_sankey_bump(base_size = 16) +
  labs(x = NULL,
       y = "GDP ($ bn)",
       fill = NULL,
       color = NULL) +
  theme(legend.position = "bottom") +
  labs(title = "GDP development per continent")

# **plot all
p_titanic_sankey / p_titanic_alluvial / p_gapminder_bumpsankey
