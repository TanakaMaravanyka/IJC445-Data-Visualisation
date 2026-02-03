
# SETUP ------------------------------------------------------------------------


# Load required packages
library(tidyverse)      # Data manipulation and ggplot2
library(scales)         # Scale formatting
library(viridis)        # Colourblind-safe palettes
library(RColorBrewer)   # Additional colour palettes

# Create output directory
dir.create("visualisations/diverse", showWarnings = FALSE, recursive = TRUE)

# LOAD AND TRANSFORM DATA ------------------------------------------------------


# Load the data - read all columns as character to avoid type conflicts
data_raw <- read_csv("data/7182_Change_by_ticket_type.csv", 
                     col_types = cols(.default = "c"),
                     show_col_types = FALSE)

# Transform to long format for ggplot2
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

# Custom theme for all charts
theme_custom <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, colour = "grey30", hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 12)
  )

# ==============================================================================
# CHART 1: LINE CHART - Anytime vs Advance 
# ==============================================================================


# Filter for Anytime and Advance tickets across all sectors
anytime_advance <- rail_data %>%
  filter(`Ticket type` %in% c("Anytime", "Advance"),
         Sector == "All operators") %>%
  select(Year, `Ticket type`, Fare_Index)

# Create visualisation
chart1 <- ggplot(anytime_advance, aes(x = Year, y = Fare_Index, 
                                      colour = `Ticket type`, 
                                      linetype = `Ticket type`)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  geom_hline(yintercept = 100, linetype = "dotted", colour = "grey40", size = 0.8) +
  # Colourblind-safe Okabe and  Ito palette
  scale_colour_manual(
    values = c("Anytime" = "#D55E00", "Advance" = "#0072B2"),
    name = "Ticket Type"
  ) +
  scale_linetype_manual(
    values = c("Anytime" = "solid", "Advance" = "dashed"),
    name = "Ticket Type"
  ) +
  scale_x_continuous(breaks = seq(2004, 2025, by = 3)) +
  scale_y_continuous(limits = c(90, 250)) +
  labs(
    title = "Chart 1: The Flexibility Premium Over Time",
    subtitle = "Line chart showing divergence between Anytime and Advance fares (2004-2025)",
    x = "Year",
    y = "Fare Index (2004 = 100)"
  ) +
  theme_custom +
  theme(panel.grid.major = element_line(colour = "grey90"))

ggsave("visualisations/diverse/chart1_line_anytime_vs_advance.png", 
       chart1, width = 12, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart1)



# ==============================================================================
# CHART 2: BOX PLOT - Distribution by Sector 
# ==============================================================================


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
  theme_custom +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 15, hjust = 1)
  )

ggsave("visualisations/diverse/chart2_boxplot_sector_distribution.png", 
       chart2, width = 10, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart2)



# ==============================================================================
# CHART 3: HORIZONTAL BAR CHART - Cumulative Inflation 
# ==============================================================================


# Calculate cumulative inflation for each ticket type (2004 to 2025)
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
  scale_fill_viridis_c(option = "plasma", direction = -1, 
                       name = "Inflation %") +
  coord_flip(ylim = c(0, max(cumulative_inflation$Cumulative_Increase) * 1.15)) +
  labs(
    title = "Chart 3: Total Fare Inflation by Ticket Type",
    subtitle = "Horizontal bar chart ranking cumulative increases (2004-2025)",
    x = NULL,
    y = "Cumulative Fare Increase (%)"
  ) +
  theme_custom +
  theme(
    legend.position = "none",
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 13, face = "bold")
  )

ggsave("visualisations/diverse/chart3_bar_cumulative_inflation.png", 
       chart3, width = 10, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart3)



# ==============================================================================
# CHART 4: HEATMAP - Sector × Time Patterns 
# ==============================================================================


# Prepare data for heatmap (5-year intervals)
heatmap_data <- rail_data %>%
  filter(Sector != "All operators") %>%
  filter(`Ticket type` %in% c("Advance", "Anytime", "Off Peak", "Season")) %>%
  filter(Year %in% seq(2005, 2025, by = 5)) %>%
  mutate(
    Sector = factor(Sector, levels = c("London and South East", 
                                        "Long distance", 
                                        "Regional")),
    # Reorder ticket types for better visualization
    `Ticket type` = factor(`Ticket type`, 
                           levels = c("Anytime", "Off Peak", "Advance", "Season"))
  )

# Create visualisation
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
  theme_custom +
  theme(
    panel.grid = element_blank(),
    panel.spacing.y = unit(1, "lines"),
    strip.text = element_text(face = "bold", size = 13, margin = margin(5, 0, 5, 0)),
    strip.background = element_rect(fill = "grey85", colour = "grey60", linewidth = 0.5),
    axis.text.x = element_text(angle = 0, size = 11),
    axis.text.y = element_text(size = 11),
    axis.title.x = element_text(size = 12, face = "bold", margin = margin(t = 10)),
    legend.key.width = unit(1.5, "cm"),
    legend.key.height = unit(0.5, "cm"),
    # Note: Fixed aspect ratio (0.3) ensures widely spaced tiles in the final image.
    # This may cause the plot to look "squashed" in the small RStudio Plots pane.
    # Please check the saved PNG file for the correct view.
    aspect.ratio = 0.3
  )

ggsave("visualisations/diverse/chart4_heatmap_sector_time.png", 
       chart4, width = 12, height = 9, dpi = 300, bg = "white")

# Auto-display chart
print(chart4)



# ==============================================================================
# CREATE COMPOSITE - All 4 Charts
# ==============================================================================
# Create composite visualisation


library(patchwork)

composite <- (chart1 + chart2) / (chart3 + chart4) +
  plot_annotation(
    title = "IJC445 Data Visualisation - 4 Diverse Chart Types",
    subtitle = "Great Britain Rail Fare Analysis (2004-2025) using Line, Box, Bar, and Heatmap charts",
    theme = theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5, colour = "grey40")
    )
  ) &
  theme(plot.tag = element_text(size = 14, face = "bold"))

ggsave("visualisations/diverse/00_COMPOSITE_4_diverse_charts.png", composite, 
       width = 20, height = 16, dpi = 300, bg = "white")

# Auto-display composite
print(composite)



# ==============================================================================
# SUMMARY
# ==============================================================================


