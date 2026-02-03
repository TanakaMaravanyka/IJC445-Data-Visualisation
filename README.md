[README.md](https://github.com/user-attachments/files/25039951/README.md)
# IJC445 - Data Visualisation
Module: IJC445 Data Visualisation  
Topic:  How have different passenger segments experienced rail fare inflation across sectors in Great Britain between 2004 and 2025, and what does this reveal about pricing strategies and regional inequality? 


## 📊 Project Overview

This project analyses Great Britain rail fare inflation data (ORR Table 7182) to explore how different passenger segments have been impacted by pricing strategies over the last 21 years.

The coursework demonstrates proficiency in:
- Data Visualisation Theory: Applying Grammar of Graphics and ASSERT frameworks
- R Programming: Advanced `ggplot2` usage, data transformation, and scripting
- Ethical Design: Creating accessible, truthful, and context-aware charts
- Visual Storytelling: Combining multiple chart types into a cohesive narrative

---

> Research Question:
> "How have different passenger segments experienced rail fare inflation differently across Great Britain rail sectors from 2004-2025, and what does this reveal about pricing strategies and regional disparities?"


---

## 📁 Folder Structure

```
IJC445-Data-Visualisation/
├── data/                             # Cleaned dataset (from IJC437)
│   └── 7182_Change_by_ticket_type.csv
├── scripts/                          # R visualisation scripts
│   ├── 01_chart1_line_anytime_advance.R      # Chart 1: Line chart
│   ├── 02_chart2_boxplot_sector_distribution.R  # Chart 2: Box plot
│   ├── 03_chart3_bar_cumulative_inflation.R  # Chart 3: Bar chart
│   ├── 04_chart4_heatmap_sector_time.R       # Chart 4: Heatmap
│   ├── DATA_VISUALISATION.R          # All-in-one comprehensive script

├── visualisations/                   # Generated visualisations
│   └── diverse/                      # 4 diverse chart types (PNG, 300 DPI)
│       ├── 00_COMPOSITE_4_diverse_charts.png  # Main submission chart
│       ├── chart1_line_anytime_vs_advance.png
│       ├── chart2_boxplot_sector_distribution.png
│       ├── chart3_bar_cumulative_inflation.png
│       └── chart4_heatmap_sector_time.png
```


##  Data Source and  Preprocessing

>## [!NOTE]
> Data cleaning and preprocessing for this project were conducted as part of the IJC437 Introduction to Data Science module.
> 
> The cleaned dataset (`7182_Change_by_ticket_type.csv`) has been copied to this project's `data/` folder for standalone use. This allows the IJC445 project to be submitted independently to GitHub without external dependencies.
> 
> For the original data cleaning methodology, see:  
>
>https://github.com/TanakaMaravanyka/IJC437-Introduction-to-Data-Science/blob/main/data/7182_Change_by_ticket_type.csv
> This demonstrates a professional data science workflow where exploratory analysis (IJC437) informs advanced visualisation (IJC445), while maintaining project independence for separate repository submission.

Dataset Location (This Project):  
`data/7182_Change_by_ticket_type.csv`

Original Source:  
Office of Rail and Road (2025) *Table 7182: Average Change in Fares by Ticket Type*  


Data Cleaning:  
Performed in IJC437 module (see GitHub link above for methodology).

##  Running the Analysis

### Two Approaches Available

This project provides two ways to run the visualisation code:

####  Approach 1: Individual Scripts (Recommended for Development)

Best for: Debugging, customisation, learning, selective chart generation.

Run individual charts independently:

```r
# Set working directory to project root
setwd("c:/Tanaka Maravanyika/IJC445-Data-Visualisation")

# Run individual chart scripts (each is self-contained)
source("scripts/01_chart1_line_anytime_advance.R")       # Chart 1: Line chart
source("scripts/02_chart2_boxplot_sector_distribution.R") # Chart 2: Box plot  
source("scripts/03_chart3_bar_cumulative_inflation.R")    # Chart 3: Bar chart
source("scripts/04_chart4_heatmap_sector_time.R")         # Chart 4: Heatmap
```

Benefits:
- ✅ Run specific charts independently.
- ✅ Each script is self-contained (loads own data).
- ✅ Easier debugging (isolate issues to specific scripts).
- ✅ Modify individual components without affecting others.
- ✅ Professional code organisation.

## Approach 2: All-in-One Script (Quick Execution)

Best for: Quick runs, demonstrations, one-click execution in RStudio.

Run everything in one file:

```r

# Run comprehensive script (creates all 4 charts + composite)
source("scripts/DATA_VISUALISATION.R")

```

Benefits:
- ✅ Single file execution creates all 4 charts.
- ✅ Generates composite visualisation automatically.
- ✅ Perfect for RStudio "Run All" button.
- ✅ Easy to share with lecturers/reviewers.

> [!TIP]
> **Automatic Display**: Running these scripts will automatically render the charts in your RStudio 'Plots' pane. No manual commands required!

---

## Why Both Approaches?

Individual Scripts - Professional development:
- Each chart in a separate file.
- Easy to test and modify.
- Clear separation of concerns.

All-in-One Script - Convenience:
- Quick demonstrations.
- Single file to run.
- Automatic composite generation.

Both produce identical outputs - choose based on your workflow preference!

---

## Troubleshooting

### Some Charts  Appearance in RStudio
You may notice that in some cases they may appears "squashed" or distorted with overlapping text in the RStudio 'Plots' pane.

This is normal. The code enforces a specific aspect ratio (0.3) to ensure the final image uses the correct wide dimensions suitable for the report. RStudio's small preview pane cannot display this ratio correctly.

Solution: Recommended  Check the saved file (visualisations/diverse/) or in some cases to use the ' Zoom ' button in RStudio to view it in a larger window. The saved file will always render correctly .


---
## Quick Start Examples

### Option 1: Run All Visualisations at Once (Recommended)

```r
# Set working directory to project root
# setwd("path/to/IJC445-Data-Visualisation")

# Run master script
source("scripts/DATA_VISUALISATION.R")
```

This will:
1. Load all required packages.
2. Transform data from wide to long format.
3. Generate all 4 individual charts.
4. Create the composite visualisation.
5. Save all outputs to the `visualisations/` folder.

### Option 2: Run Individual Scripts

Each chart script is self-contained (loads its own data and packages). Comprehensive setup is not required.

```r
# Example: Generate Chart 1 (Line Chart)
source("scripts/01_chart1_line_anytime_advance.R")

# Example: Generate Chart 2 (Box Plot)
source("scripts/02_chart2_boxplot_sector_distribution.R")

```
*(Note: Individual scripts save outputs to `visualisations/`)*

### Option 3: Use Original Monolithic Script

```r
source("scripts/DATA_VISUALISATION.R")
```


## 📈 Visualisation Components

### Chart 1: The Flexibility Premium (Line Chart)
- Type: Time series line chart.
- Purpose: Show divergence between Anytime and Advance fares over time.
- Visual Encoding: Dual lines with colour + linetype redundancy.
- Key Insight: Anytime fares increased 26% more than Advance fares (2004-2025).
- Best For: Showing trends and comparisons over time.

### Chart 2: Fare Distribution by Sector (Box Plot)
- Type: Statistical box plot.
- Purpose: Compare fare index distributions across three rail sectors.
- Visual Encoding: Box-and-whisker with mean indicator.
- Key Insight: The Regional sector shows the highest variability in fare changes.
- Best For: Comparing distributions, identifying outliers and central tendency.

### Chart 3: Cumulative Inflation by Ticket Type (Horizontal Bar Chart)
- Type: Ranked horizontal bar chart.
- Purpose: Compare total fare increases across ticket types.
- Visual Encoding: Length-based comparison with colour gradient.
- Key Insight: Anytime travellers faced the highest cumulative increase (+137.9%).
- Best For: Ranking and magnitude comparison (Cleveland & McGill hierarchy).

### Chart 4: Sector × Time Patterns (Heatmap)
- Type: Faceted tile plot (heatmap).
- Purpose: Show multi-dimensional patterns across sectors, time, and ticket types.
- Visual Encoding: Colour intensity represents fare index values.
- Key Insight: Consistent upward trend across all sectors, with Regional showing steepest recent growth.
- Best For: Spotting patterns in multi-dimensional categorical data.

### Composite Visualisation
- Layout: 2×2 grid using `patchwork`.
- Size: 20×16 inches, 300 DPI.
- Purpose: Main coursework submission showing all 4 diverse chart types.



##  Design Principles

### Colourblind-Safe Palettes
- Okabe & Ito palette: Charts 1 & 4 (orange #D55E00, blue #0072B2).
- ColorBrewer Set2: Chart 2 (faceted comparison).
- Viridis Plasma: Chart 3 (continuous gradient).

### Accessibility Features
- ✅ 300 DPI resolution for print quality.
- ✅ Minimum 12pt font size (WCAG-compliant).
- ✅ Redundant encoding (colour + linetype/shape).
- ✅ Reduced chart junk (minimal gridlines).
- ✅ Direct labelling (no legend lookups required).


## ✅ Coursework Requirements Checklist

- [x] 4+ charts created (have 5: 4 individual + 1 composite).
- [x] All charts original R code.
- [x] 5 sections with correct names.
- [x] Section 1 discusses all charts.
- [x] Sections 2-5 each focus on one chart.
- [x] ASSERT framework applied.
- [x] Grammar of Graphics discussed.
- [x] Accessibility addressed.
- [x] Visualisation choice justified.
- [x] Ethical implications explored.
- [x] Colourblind-safe palettes used.
- [x] 300 DPI output.

---


Cross-Reference:  
Data cleaning methodology → `../IJC437-Introduction-to-Data-Science/README.md`


