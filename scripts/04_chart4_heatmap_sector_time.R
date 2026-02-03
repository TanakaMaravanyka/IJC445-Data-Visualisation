
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

# CREATE CHART 4 ---------------------------------------------------------------


# Prepare data for heatmap (5-year intervals)
heatmap_data <- rail_data %>%
  filter(Sector != "All operators") %>%
  filter(`Ticket type` %in% c("Advance", "Anytime", "Off Peak", "Season")) %>%
  filter(Year %in% seq(2005, 2025, by = 5)) %>%
  mutate(
    Sector = factor(Sector, levels = c("London and South East", 
                                        "Long distance", 
                                        "Regional")),
    # Reorder ticket types for better visualisation
    `Ticket type` = factor(`Ticket type`, 
                           levels = c("Anytime", "Off Peak", "Advance", "Season"))
  )

# Create visualisation - Improved heatmap
chart4 <- ggplot(heatmap_data, aes(x = factor(Year), y = `Ticket type`, fill = Fare_Index)) +
  geom_tile(colour = "white", linewidth = 1.5) +
  geom_text(aes(label = round(Fare_Index, 0)), 
            colour = "white", fontface = "bold", size = 4) +
  scale_fill_viridis_c(option = "magma", name = "Fare Index", 
                       limits = c(100, 235),
                       breaks = seq(100, 240, by = 20)) +
  facet_wrap(~Sector, ncol = 1, scales = "free_y") +
  labs(
    title = "Chart 4: Fare Index Heatmap Across Sectors and Time",
    subtitle = "Tile plot showing fare patterns at 5-year intervals by sector and ticket type",
    x = "Year",
    y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, colour = "grey30", hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid = element_blank(),
    panel.spacing.y = unit(1, "lines"),
    strip.text = element_text(face = "bold", size = 13, margin = margin(5, 0, 5, 0)),
    strip.background = element_rect(fill = "grey85", colour = "grey60", linewidth = 0.5),
    axis.text.x = element_text(angle = 0, size = 11),
    axis.text.y = element_text(size = 11),
    axis.title.x = element_text(size = 12, face = "bold", margin = margin(t = 10)),
    legend.key.width = unit(1.5, "cm"),
    legend.key.height = unit(0.5, "cm"),
    aspect.ratio = 0.3
  )

# Save chart
dir.create("visualisations/diverse", showWarnings = FALSE, recursive = TRUE)
ggsave("visualisations/diverse/chart4_heatmap_sector_time.png", 
       chart4, width = 12, height = 9, dpi = 300, bg = "white")

# Auto-display chart
print(chart4)


