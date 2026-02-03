# ==============================================================================
# IJC445 DATA VISUALISATION - CHART 3: HORIZONTAL BAR CHART (Cumulative Inflation)
# ==============================================================================

# ==============================================================================

# SETUP ------------------------------------------------------------------------

library(tidyverse)
library(viridis)

# LOAD AND TRANSFORM DATA ------------------------------------------------------

data_raw <- read_csv("data/7182_Change_by_ticket_type.csv", 
                     col_types = cols(.default = "c"),
                     show_col_types = FALSE)

rail_data <- data_raw %>%
  filter(!Sector %in% c("Retail Prices Index")) %>%
  filter(!str_detect(`Ticket type`, "Revenue per journey")) %>%
  select(Sector, `Ticket type`, `2004`:`2025 [note 1]`) %>%
  pivot_longer(
    cols = `2004`:`2025 [note 1]`,
    names_to = "Year",
    values_to = "Fare_Index"
  ) %>%
  mutate(
    Year = as.numeric(str_extract(Year, "\\d{4}")),
    Fare_Index = as.numeric(Fare_Index)
  ) %>%
  filter(!is.na(Fare_Index))

# CREATE CHART 3 ---------------------------------------------------------------


# Calculate cumulative inflation
cumulative_inflation <- rail_data %>%
  filter(Sector == "All operators",
         `Ticket type` != "All tickets",
         Year %in% c(2004, 2025)) %>%
  group_by(`Ticket type`) %>%
  summarise(
    Fare_2004 = Fare_Index[Year == 2004][1],
    Fare_2025 = Fare_Index[Year == 2025][1]
  ) %>%
  filter(!is.na(Fare_2004), !is.na(Fare_2025)) %>%
  mutate(
    Cumulative_Increase = ((Fare_2025 - Fare_2004) / Fare_2004) * 100
  ) %>%
  arrange(desc(Cumulative_Increase))

# Create visualisation
chart3 <- ggplot(cumulative_inflation, 
                 aes(x = reorder(`Ticket type`, Cumulative_Increase), 
                     y = Cumulative_Increase,
                     fill = Cumulative_Increase)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0("+", round(Cumulative_Increase, 1), "%")),
            hjust = -0.2, size = 4.5, fontface = "bold") +
  scale_fill_viridis_c(option = "plasma", direction = -1, name = "Inflation %") +
  coord_flip(ylim = c(0, max(cumulative_inflation$Cumulative_Increase) * 1.15)) +
  labs(
    title = "Chart 3: Total Fare Inflation by Ticket Type",
    subtitle = "Horizontal bar chart ranking cumulative increases (2004-2025)",
    x = NULL,
    y = "Cumulative Fare Increase (%)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, colour = "grey30", hjust = 0.5),
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text = element_text(size = 12),
    axis.text.y = element_text(size = 13, face = "bold")
  )

# Save chart
dir.create("visualisations/diverse", showWarnings = FALSE, recursive = TRUE)
ggsave("visualisations/diverse/chart3_bar_cumulative_inflation.png", 
       chart3, width = 10, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart3)



