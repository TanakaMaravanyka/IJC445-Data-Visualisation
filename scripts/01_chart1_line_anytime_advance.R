# ==============================================================================
# IJC445 DATA VISUALISATION - CHART 1: LINE CHART (Anytime vs Advance)
# ===================================================================
# ==============================================================================

# SETUP ------------------------------------------------------------------------

library(tidyverse)
library(scales)

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

# CREATE CHART 1 ---------------------------------------------------------------


# Filter for Anytime and Advance tickets
anytime_advance <- rail_data %>%
  filter(`Ticket type` %in% c("Anytime", "Advance"),
         Sector == "All operators")

# Create visualisation
chart1 <- ggplot(anytime_advance, aes(x = Year, y = Fare_Index, 
                                      colour = `Ticket type`, 
                                      linetype = `Ticket type`)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  geom_hline(yintercept = 100, linetype = "dotted", colour = "grey40", size = 0.8) +
  # Colourblind-safe Okabe & Ito palette
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
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, colour = "grey30", hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "grey90"),
    axis.text = element_text(size = 12)
  )

# Save chart
dir.create("visualisations/diverse", showWarnings = FALSE, recursive = TRUE)
ggsave("visualisations/diverse/chart1_line_anytime_vs_advance.png", 
       chart1, width = 12, height = 7, dpi = 300, bg = "white")

# Auto-display chart
print(chart1)



