# Business Analytics Projects

A collection of business analytics projects designed to understand concepts **from the fundamental to the complex**. These projects demonstrate data-driven decision making, statistical analysis, and business intelligence techniques using R.

## Learning Progression

This collection builds analytical skills progressively:

1. **Foundational** → Basic R programming, control structures, and statistical functions
2. **Intermediate** → Data cleaning, manipulation, and visualization with tidyverse
3. **Advanced** → Interactive dashboards, complex business case analysis, and strategic insights

---

## Projects Overview

### 1. E-Commerce Price Comparison & Supplier Analysis
`Alibaba Price Comparisons/`

**Objective:** Analyze and compare pricing strategies across major e-commerce platforms (Amazon, Alibaba, eBay) to identify the best performing companies and market trends.

**Key Analyses:**
- Identifying best performing company by average sales
- Stock volatility classification (Extreme/High/Moderate/Low/Stable)
- Stock price monitoring with alert systems
- Growth trend analysis with consecutive decline detection

**Skills Demonstrated:**
| Skill | Implementation |
|-------|----------------|
| Control Structures | if-else statements, for loops |
| Statistical Functions | mean(), max(), data aggregation |
| Business Logic | Threshold-based alerts, trend analysis |
| Decision Systems | Multi-level classification algorithms |

**Files:**
- `Business Intelligence & Supplier Analysis for E-Commerce.qmd` - Quarto analysis document
- `Amazon_Alibaba_eBay_Comparison_Daily_2010_2020.csv` - 10-year comparison dataset

---

### 2. Employee Performance & Attrition Analysis
`Employee Performance & Attrition Analysis/`

**Objective:** Perform comprehensive HR analytics to understand employee performance patterns, identify attrition risk factors, and provide data-driven recommendations for workforce management.

**Key Analyses:**
- Advanced data cleaning with multiple imputation strategies
- Employee demographic analysis
- Performance metrics correlation
- Department-wise attrition patterns

**Skills Demonstrated:**
| Skill | Implementation |
|-------|----------------|
| Data Cleaning | NA handling, empty string detection, imputation |
| tidyverse | dplyr (mutate, filter, group_by), tidyr |
| Visualization | ggplot2 charts and plots |
| Domain Logic | Experience-based age estimation, department standardization |

**Imputation Techniques:**
```r
# Age estimation based on years of experience
estimate_age <- function(yoe) {
  return(20 + yoe + sample(-4:4, 1))  # Starting age ± variation
}

# Department name repair using ID associations
# Majority-rule naming based on Department_ID
```

**Files:**
- `Employee Performance & Attrition Analysis.qmd` - Comprehensive analysis document
- `employee.csv` - Employee demographic data
- `performance.csv` - Performance metrics data

---

### 3. Intel Corporation Strategic Analysis (2022-2025)
`Intel Case Study/`

**Objective:** Data-driven strategic analysis of Intel Corporation's challenges and opportunities based on the Reuters special report "Inside Intel, CEO Pat Gelsinger fumbled the revival of an American icon."

**Key Analyses:**
- Problem identification from business journalism
- Revenue and stock performance trend analysis
- Internal challenges assessment (leadership, manufacturing, financial)
- External factors evaluation (competition, geopolitics, customer base)
- Interactive Shiny dashboard for strategic insights

**Business Problems Analyzed:**
| Category | Issues |
|----------|--------|
| **Internal** | Leadership missteps, chip manufacturing delays, financial strain |
| **External** | Market share loss to AMD/Nvidia, eroding customer base, geopolitical pressures |
| **Strategic** | IDM 2.0 execution, CHIPS Act leverage, AI/cloud competitiveness |

**Skills Demonstrated:**
| Skill | Implementation |
|-------|----------------|
| Business Intelligence | Strategic case analysis, problem framing |
| Interactive Dashboards | Shiny, shinydashboard |
| Visualization | ggplot2, plotly (interactive charts) |
| Time Series | lubridate, trend analysis |

**Files:**
- `Data-Driven Strategic Analysis Intel Corporation 2022-2025.qmd` - Full case analysis
- `Intel Business Case Study & Strategy Dashboard.R` - Interactive Shiny dashboard
- `intel_data.csv` - Historical Intel data
- `intel_revenue_history.csv` - Revenue trends
- `x86_market_share.csv` - CPU market share data

---

## Technologies Used

| Category | Tools |
|----------|-------|
| **Language** | R |
| **Data Manipulation** | dplyr, tidyr |
| **Visualization** | ggplot2, plotly |
| **Interactive Apps** | Shiny, shinydashboard |
| **Date Handling** | lubridate |
| **Document Format** | Quarto (.qmd) |

---

## Skills Progression Map

```
Project 1: E-Commerce Analysis
├── Basic R: vectors, loops, conditionals
├── Statistical functions: mean, max
└── Business logic implementation

        ↓

Project 2: Employee Analytics  
├── tidyverse ecosystem
├── Data cleaning strategies
├── Advanced imputation techniques
└── ggplot2 visualization

        ↓

Project 3: Intel Case Study
├── Business case methodology
├── Interactive Shiny dashboards
├── Plotly interactive charts
└── Strategic analysis framework
```

---

## Getting Started

### Prerequisites
```r
install.packages(c("tidyverse", "ggplot2", "plotly", "shiny", "shinydashboard", "lubridate"))
```

### Running the Projects
1. Open the `.qmd` files in RStudio with Quarto support
2. Set the working directory to the project folder
3. Render the Quarto document or run code chunks interactively

---
