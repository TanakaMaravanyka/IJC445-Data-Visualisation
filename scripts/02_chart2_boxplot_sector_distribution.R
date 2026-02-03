# ==============================================================================
# IJC445 DATA VISUALISATION - CHART 2: BOX PLOT (Distribution by Sector)
# ==============================================================================
# Script: 02_chart2_boxplot_sector_distribution.R
# Purpose: Create box plot showing fare index distribution across sectors
# Chart Type: Box Plot (Statistical Distribution)
# Module: IJC445 Data Visualisation
# Date: January 2026
# ==============================================================================

# SETUP ------------------------------------------------------------------------

library(tidyverse)
library(RColorBrewer)

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

# CREATE CHART 2 ---------------------------------------------------------------


# Filter data for box plot
box_data <- rail_data %>%
  filter(Sector != "All operators") %>%
  filter(`Ticket type` != "All tickets")

# Create visualisation
chart2 <- ggplot(box_data, aes(x = Sector, y = Fare_Index, fill = Sector)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21, outlier.size = 2.5, 
               outlier.fill = "red", outlier.alpha = 0.6) +
  # Add mean as a diamond point
  stat_summary(fun = mean, geom = "point", shape = 23, size = 4, 
               fill = "darkred", colour = "white", stroke = 1) +
  # Colourblind-safe palette
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(breaks = seq(100, 250, by = 25)) +
  labs(
    title = "Chart 2: Fare Index Distribution Across Sectors",
    subtitle = "Box plot showing median, quartiles, and outliers | Red diamond = mean",
    x = "Rail Sector",
    y = "Fare Index (2004-2025 combined)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, colour = "grey30", hjust = 0.5),
    legend.position = "none",
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 12),
    axis.text.x = element_text(angle = 15, hjust = 1)
  )

# Save chart
dir.create("visualisations/diverse", showWarnings = FALSE, recursive = TRUE)
ggsave("visualisations/diverse/chart2_boxplot_sector_distribution.png", 
       chart2, width = 10, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart2)


