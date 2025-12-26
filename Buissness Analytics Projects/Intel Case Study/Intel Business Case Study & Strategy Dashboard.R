# Intel Strategic Analysis Dashboard
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(lubridate)
library(reshape2)
library(ggplot2)
library(tidyr)
library(viridis)  # For better color palettes
library(scales)   # For better formatting

intel_data <- read.csv("intel_data.csv", stringsAsFactors = FALSE)
market_share <- read.csv("x86_market_share.csv", stringsAsFactors = FALSE)
market_share <- market_share[nrow(market_share):1, ]
revenue_history <- read.csv("intel_revenue_history.csv", stringsAsFactors = FALSE)

# Data preprocessing
intel_data$Date <- as.Date(paste0(intel_data$Date, "-01"))
intel_data$Year <- year(intel_data$Date)

# Convert quarterly data for market share
market_share$Period <- market_share$Quarter
market_share$Year <- as.numeric(substr(market_share$Quarter, 4, 7))
market_share$Q <- as.numeric(substr(market_share$Quarter, 2, 2))

# Convert revenue history for stacked bar chart
revenue_history$Date <- factor(revenue_history$Date, levels = rev(revenue_history$Date))
intel_revenue_long <- pivot_longer(revenue_history, -Date, names_to = "Category", values_to = "Value")
intel_revenue_long <- intel_revenue_long[!is.na(intel_revenue_long$Value) & intel_revenue_long$Value > 0,]

# UI
ui <- dashboardPage(
  dashboardHeader(title = span(img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/Intel_logo_%282006-2020%29.svg/220px-Intel_logo_%282006-2020%29.svg.png", height = 25), "Strategic Analysis"), titleWidth = 300),
  
  dashboardSidebar(width = 250,
    sidebarMenu(id = "sidebar",
      menuItem("Executive Summary", tabName = "summary", icon = icon("chart-line")),
      menuItem("Financial Performance", tabName = "financial", icon = icon("dollar-sign")),
      menuItem("Market Share Analysis", tabName = "market", icon = icon("pie-chart")),
      menuItem("Revenue Breakdown", tabName = "revenue", icon = icon("bar-chart")),
      menuItem("Strategic Recommendations", tabName = "recommendations", icon = icon("lightbulb"))
    ),
    br(),
    div(style = "padding: 0 15px",
        selectInput("theme_choice", "Dashboard Theme:", 
                  choices = c("Intel Blue" = "blue", "Dark Mode" = "dark", "Professional" = "professional"),
                  selected = "blue")
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f9f9f9;
        }
        .box {
          box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
          transition: all 0.3s cubic-bezier(.25,.8,.25,1);
        }
        .box:hover {
          box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
        }
        .value-box {
          box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
          transition: all 0.3s cubic-bezier(.25,.8,.25,1);
        }
        .value-box:hover {
          box-shadow: 0 7px 14px rgba(0,0,0,0.25), 0 5px 5px rgba(0,0,0,0.22);
        }
      "))
    ),
    
    uiOutput("dynamic_theme"),
    
    tabItems(
      # Executive Summary Tab
      tabItem(tabName = "summary",
              fluidRow(
                box(title = "Intel's Current Crisis", status = "primary", solidHeader = TRUE, width = 12,
                    h4("Key Challenges Identified:"),
                    tags$ul(
                      tags$li("Net profit margin collapsed from +31.68% (Q1 2022) to -36.19% (Q1 2025)"),
                      tags$li("Market share erosion to AMD across desktop, mobile, and server segments"),
                      tags$li("Foundry Services struggling with limited revenue despite massive investments"),
                      tags$li("Client Computing revenue declining while competitors gain ground")
                    )
                )
              ),
              
              fluidRow(
                valueBoxOutput("current_margin"),
                valueBoxOutput("market_position"),
                valueBoxOutput("roi")
              ),
              
              fluidRow(
                box(title = "Critical Metrics Trend", status = "warning", solidHeader = TRUE, width = 12,
                    plotlyOutput("summary_trend")
                )
              )
      ),
      
      # Financial Performance Tab
      tabItem(tabName = "financial",
              fluidRow(
                box(title = "Profitability Crisis", status = "primary", solidHeader = TRUE, width = 6,
                    plotlyOutput("profit_margin_plot")
                ),
                box(title = "Revenue vs Operating Income", status = "primary", solidHeader = TRUE, width = 6,
                    plotlyOutput("revenue_income_plot")
                )
              ),
              
              fluidRow(
                box(title = "R&D Investment vs Returns", status = "warning", solidHeader = TRUE, width = 6,
                    plotlyOutput("rd_analysis")
                ),
                box(title = "Financial Health Indicators", status = "info", solidHeader = TRUE, width = 6,
                    plotlyOutput("financial_health")
                )
              ),
              
              fluidRow(
                box(title = "Key Financial Insights", status = "danger", solidHeader = TRUE, width = 12,
                    h4("Critical Findings:"),
                    tags$ul(
                      tags$li("Intel's net profit margin turned negative in Q1 2023 and has worsened"),
                      tags$li("R&D spending remains high (~$16B annually) but returns are diminishing"),
                      tags$li("Operating income turned negative, indicating core business struggles"),
                      tags$li("Current ratio below 2.0 suggests potential liquidity concerns")
                    )
                )
              )
      ),
      
      # Market Share Tab
      tabItem(tabName = "market",
              fluidRow(
                box(title = tags$div(
                      tags$span("Market Share Evolution", style = "font-size: 18px;"),
                      tags$span(uiOutput("quarter_display"), style = "float:right; padding-right:15px; color:#0071c5;")
                    ), 
                    status = "primary", solidHeader = TRUE, width = 12,
                    fluidRow(
                      column(width = 9,
                        sliderInput("quarter_select", "Select Quarter:",
                                  min = 1, max = nrow(market_share), value = 1,
                                  step = 1, animate = animationOptions(interval = 1500, loop = TRUE))
                      ),
                      column(width = 3, style = "margin-top: 19px;",
                        actionButton("show_trend", "Show Trends Over Time", icon = icon("line-chart"),
                                   style = "color: #fff; background-color: #0071c5; border-color: #2e6da4; padding: 8px;")
                      )
                    )
                )
              ),
              
              fluidRow(
                box(title = "x86 Desktop Market Share", status = "primary", solidHeader = TRUE, width = 4,
                    plotlyOutput("desktop_share", height = "300px")
                ),
                box(title = "x86 Mobile Market Share", status = "primary", solidHeader = TRUE, width = 4,
                    plotlyOutput("mobile_share", height = "300px")
                ),
                box(title = "x86 Server Market Share", status = "primary", solidHeader = TRUE, width = 4,
                    plotlyOutput("server_share", height = "300px")
                )
              ),
              
              fluidRow(
                uiOutput("market_trend_panel")
              ),
              
              fluidRow(
                box(title = "Competitive Analysis", status = "info", solidHeader = TRUE, width = 12,
                    h4("Market Share Insights:"),
                    tags$ul(
                      tags$li("AMD gained significant ground in desktop (19% to 28%) and server markets (5% to 27%)"),
                      tags$li("Intel maintains dominance in mobile but AMD is growing (17% to 22.5%)"),
                      tags$li("Server market erosion is most concerning - high-margin segment"),
                      tags$li("Desktop market share loss accelerated post-2022")
                    )
                )
              )
      ),
      
      # Revenue Breakdown Tab
      tabItem(tabName = "revenue",
              fluidRow(
                box(title = "Intel Revenue Breakdown", status = "primary", solidHeader = TRUE, width = 12,
                    tabsetPanel(
                      tabPanel("Stacked View", plotlyOutput("revenue_stacked_bar", height = "600px")),
                      tabPanel("Segment Comparison", plotlyOutput("revenue_segment_comparison", height = "600px")),
                      tabPanel("Growth Rates", plotlyOutput("revenue_growth_chart", height = "600px"))
                    )
                )
              ),
              
              fluidRow(
                box(title = "Revenue Analysis", status = "info", solidHeader = TRUE, width = 12,
                    h4("Revenue Insights:"),
                    tags$ul(
                      tags$li("Client Computing consistently dominates revenue (~60-70% of total)"),
                      tags$li("Data Center revenue remained relatively stable around $25-27B"),
                      tags$li("Foundry Services shows dramatic growth from ~$0.3B to $17.57B"),
                      tags$li("Network and Edge segment peaked in Q1 2023 at $8.15B but declined significantly"),
                      tags$li("Foundry growth represents Intel's strategic pivot toward manufacturing services")
                    )
                )
              )
      ),
      
      # Recommendations Tab
      tabItem(tabName = "recommendations",
              fluidRow(
                box(title = "Strategic Recommendations", status = "success", solidHeader = TRUE, width = 12,
                    h3("1. Accelerate 18A Process Node Delivery"),
                    p("Priority: High"),
                    tags$ul(
                      tags$li("Focus all fabrication resources on delivering competitive 18A node"),
                      tags$li("Critical for regaining technology leadership and customer confidence")
                    ),
                    
                    h3("2. Strategic Foundry Partnerships"),
                    p("Priority: High"),
                    tags$ul(
                      tags$li("Secure long-term contracts with major customers (Apple, Nvidia, AMD)"),
                      tags$li("Target 25% market share in foundry services")
                    ),
                    
                    h3("3. Server Market Defense"),
                    p("Priority: Medium"),
                    tags$ul(
                      tags$li("Develop competitive server processors to halt AMD gains"),
                      tags$li("Focus on AI/ML accelerated computing integration"),
                      tags$li("Consider merger deals with AI-oriented firms")
                    )
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Dynamic theme based on user selection
  output$dynamic_theme <- renderUI({
    theme <- input$theme_choice
    
    if(theme == "dark") {
      tags$style(HTML("
        .content-wrapper, .right-side { background-color: #2c3e50; color: #ecf0f1; }
        .box { background-color: #34495e; color: #ecf0f1; border-top-color: #f39c12; }
        .box-header { color: #ecf0f1; }
        .box-body { color: #ecf0f1; }
        .sidebar-menu>li>a { color: #ecf0f1; }
      "))
    } else if(theme == "professional") {
      tags$style(HTML("
        .content-wrapper, .right-side { background-color: #f5f5f5; }
        .box { background-color: white; border-top-color: #3c8dbc; }
        .info-box { background-color: #fafafa; }
      "))
    } else { # Intel Blue theme
      tags$style(HTML("
        .content-wrapper, .right-side { background-color: #f4f4f4; }
        .box { border-top-color: #0071c5; }
      "))
    }
  })
  
  # Display current quarter for market share slider
  output$quarter_display <- renderUI({
    selected_row <- as.numeric(input$quarter_select)
    selected_quarter <- market_share$Quarter[selected_row]
    h4(selected_quarter)
  })
  
  # Value boxes for summary
  output$current_margin <- renderValueBox({
    latest_margin <- tail(intel_data$Net.Profit.Margin[!is.na(intel_data$Net.Profit.Margin)], 1)
    valueBox(
      value = paste0(round(latest_margin, 1), "%"),
      subtitle = "Current Net Profit Margin",
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  output$market_position <- renderValueBox({
    desktop_latest <- market_share$x86_Desktop_Intel[nrow(market_share)]
    mobile_latest <- market_share$x86_Mobile_Intel[nrow(market_share)]
    server_latest <- market_share$x86_Server_Intel[nrow(market_share)]
    
    desktop_2020 <- market_share$x86_Desktop_Intel[1]
    mobile_2020 <- market_share$x86_Mobile_Intel[1]
    server_2020 <- market_share$x86_Server_Intel[1]
    
    # Calculate losses
    desktop_loss <- desktop_latest - desktop_2020
    mobile_loss <- mobile_latest - mobile_2020
    server_loss <- server_latest - server_2020
    
    # Average loss
    avg_loss <- (desktop_loss + mobile_loss + server_loss) / 3
    
    valueBox(
      value = paste0(round(avg_loss, 1), "pp"),
      subtitle = "Avg Market Loss Since 2020",
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  
  output$roi <- renderValueBox({
    latest_rd <- tail(intel_data$Research.and.Development.Expenses[!is.na(intel_data$Research.and.Development.Expenses)], 1)
    latest_operating_income <- tail(intel_data$Operating.Income[!is.na(intel_data$Operating.Income)], 1)
    
    rd_roi <- (latest_operating_income / latest_rd) * 100
    
    valueBox(
      value = paste0(round(rd_roi, 0), "%"),
      subtitle = paste0("R&D Return on Investment\n($", round(latest_operating_income, 1), "B income / $", round(latest_rd, 1), "B R&D)"),
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  
  # Summary trend plot
  output$summary_trend <- renderPlotly({
    recent_data <- intel_data[intel_data$Year >= 2020 & !is.na(intel_data$Net.Profit.Margin),]
    
    p <- plot_ly(recent_data, x = ~Date, y = ~Net.Profit.Margin, 
                 type = 'scatter', mode = 'lines+markers',
                 name = 'Net Profit Margin',
                 line = list(color = '#d32f2f', width = 3)) %>%
      add_trace(y = 0, mode = 'lines', name = 'Break-even',
                line = list(color = 'black', dash = 'dash')) %>%
      layout(title = "Intel's Profitability Collapse (2020-2025)",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Net Profit Margin (%)"),
             hovermode = 'x')
    
    p
  })
  
  # Financial plots
  output$profit_margin_plot <- renderPlotly({
    data_clean <- intel_data[!is.na(intel_data$Net.Profit.Margin) & intel_data$Year >= 2015,]
    
    p <- plot_ly(data_clean, x = ~Date, y = ~Net.Profit.Margin,
                 type = 'scatter', mode = 'lines+markers',
                 line = list(color = '#1976d2', width = 2),
                 marker = list(size = 6)) %>%
      add_trace(y = 0, mode = 'lines', name = 'Break-even',
                line = list(color = 'red', dash = 'dash')) %>%
      layout(title = "Net Profit Margin Trend",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Net Profit Margin (%)"))
    
    p
  })
  
  output$revenue_income_plot <- renderPlotly({
    data_clean <- intel_data[!is.na(intel_data$Revenue) & !is.na(intel_data$Operating.Income) & intel_data$Year >= 2018,]
    
    p <- plot_ly(data_clean, x = ~Date) %>%
      add_trace(y = ~Revenue, name = 'Revenue', type = 'scatter', mode = 'lines',
                line = list(color = '#4caf50', width = 2)) %>%
      add_trace(y = ~Operating.Income, name = 'Operating Income', type = 'scatter', mode = 'lines',
                line = list(color = '#ff9800', width = 2)) %>%
      layout(title = "Revenue vs Operating Income",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Billions USD"))
    
    p
  })
  
  output$rd_analysis <- renderPlotly({
    data_clean <- intel_data[!is.na(intel_data$Research.and.Development.Expenses) & intel_data$Year >= 2015,]
    
    p <- plot_ly(data_clean, x = ~Date, y = ~Research.and.Development.Expenses,
                 type = 'bar', name = 'R&D Expenses',
                 marker = list(color = '#9c27b0')) %>%
      layout(title = "R&D Investment Trend",
             xaxis = list(title = "Date"),
             yaxis = list(title = "R&D Expenses (Billions USD)"))
    
    p
  })
  
  output$financial_health <- renderPlotly({
    data_clean <- intel_data[!is.na(intel_data$Current.Ratio) & intel_data$Year >= 2018,]
    
    p <- plot_ly(data_clean, x = ~Date, y = ~Current.Ratio,
                 type = 'scatter', mode = 'lines+markers',
                 line = list(color = '#795548', width = 2),
                 marker = list(size = 6)) %>%
      add_trace(y = 2, mode = 'lines', name = 'Healthy Ratio (2.0)',
                line = list(color = 'green', dash = 'dash')) %>%
      layout(title = "Current Ratio (Liquidity Health)",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Current Ratio"))
    
    p
  })
  
  # Show/hide market trend panels based on button click
  observeEvent(input$show_trend, {
    if(input$show_trend %% 2 == 1) { # Odd clicks show trend
      output$market_trend_panel <- renderUI({
        fluidRow(
          box(title = "Market Share Trend Over Time", status = "warning", solidHeader = TRUE, width = 12,
              plotlyOutput("market_trend_plot", height = "400px")
          )
        )
      })
    } else { # Even clicks hide trend
      output$market_trend_panel <- renderUI({ NULL })
    }
  })
  
  # Market share plots with slider
  output$desktop_share <- renderPlotly({
    selected_row <- as.numeric(input$quarter_select)
    selected_data <- market_share[selected_row,]
    selected_quarter <- market_share$Quarter[selected_row]
    
    # Calculate previous quarter values if available
    prev_intel <- ifelse(selected_row > 1, 
                         market_share$x86_Desktop_Intel[selected_row-1],
                         NA)
    change_text <- ifelse(!is.na(prev_intel), 
                          paste0("<br>Change: ", round(selected_data$x86_Desktop_Intel - prev_intel, 1), "pp"),
                          "")
    
    # Create hover text
    hover_intel <- paste0("Intel: ", selected_data$x86_Desktop_Intel, "%", change_text)
    hover_amd <- paste0("AMD: ", selected_data$x86_Desktop_AMD, "%")
    
    # Create donut chart instead of pie chart
    p <- plot_ly(
      labels = c("Intel", "AMD"), 
      values = c(selected_data$x86_Desktop_Intel, selected_data$x86_Desktop_AMD),
      type = 'pie',
      hole = 0.4,
      marker = list(colors = c('#0071c5', '#ed1c24'),
                    line = list(color = '#FFFFFF', width = 2)),
      textposition = 'inside',
      textinfo = 'label+percent',
      hoverinfo = 'text',
      text = c(hover_intel, hover_amd),
      insidetextfont = list(color = '#FFFFFF'),
      hoverlabel = list(bgcolor = "white", font = list(size = 14))
    ) %>%
    layout(
      title = list(
        text = paste("Desktop", selected_quarter),
        font = list(size = 16)
      ),
      showlegend = TRUE,
      legend = list(orientation = "h", y = -0.2),
      annotations = list(
        list(
          text = paste0(round(selected_data$x86_Desktop_Intel), "%"),
          x = 0.5, y = 0.5, showarrow = FALSE, 
          font = list(size = 20, color = "#0071c5", family = "Arial, sans-serif")
        )
      )
    )
    
    p
  })
  
  output$mobile_share <- renderPlotly({
    selected_data <- market_share[input$quarter_select,]
    
    # Calculate previous quarter values if available
    prev_intel <- ifelse(input$quarter_select > 1, 
                         market_share$x86_Mobile_Intel[input$quarter_select-1],
                         NA)
    change_text <- ifelse(!is.na(prev_intel), 
                          paste0("<br>Change: ", round(selected_data$x86_Mobile_Intel - prev_intel, 1), "pp"),
                          "")
    
    # Create hover text
    hover_intel <- paste0("Intel: ", selected_data$x86_Mobile_Intel, "%", change_text)
    hover_amd <- paste0("AMD: ", selected_data$x86_Mobile_AMD, "%")
    
    p <- plot_ly(
      labels = c("Intel", "AMD"), 
      values = c(selected_data$x86_Mobile_Intel, selected_data$x86_Mobile_AMD),
      type = 'pie',
      hole = 0.4,
      marker = list(colors = c('#0071c5', '#ed1c24'),
                    line = list(color = '#FFFFFF', width = 2)),
      textposition = 'inside',
      textinfo = 'label+percent',
      hoverinfo = 'text',
      text = c(hover_intel, hover_amd),
      insidetextfont = list(color = '#FFFFFF')
    ) %>%
    layout(
      title = list(
        text = paste("Mobile", selected_data$Quarter),
        font = list(size = 16)
      ),
      showlegend = TRUE,
      legend = list(orientation = "h", y = -0.2),
      annotations = list(
        list(
          text = paste0(round(selected_data$x86_Mobile_Intel), "%"),
          x = 0.5, y = 0.5, showarrow = FALSE, 
          font = list(size = 20, color = "#0071c5", family = "Arial, sans-serif")
        )
      )
    )
    
    p
  })
  
  output$server_share <- renderPlotly({
    selected_data <- market_share[input$quarter_select,]
    
    # Calculate previous quarter values if available
    prev_intel <- ifelse(input$quarter_select > 1, 
                         market_share$x86_Server_Intel[input$quarter_select-1],
                         NA)
    change_text <- ifelse(!is.na(prev_intel), 
                          paste0("<br>Change: ", round(selected_data$x86_Server_Intel - prev_intel, 1), "pp"),
                          "")
    
    # Create hover text
    hover_intel <- paste0("Intel: ", selected_data$x86_Server_Intel, "%", change_text)
    hover_amd <- paste0("AMD: ", selected_data$x86_Server_AMD, "%")
    
    p <- plot_ly(
      labels = c("Intel", "AMD"), 
      values = c(selected_data$x86_Server_Intel, selected_data$x86_Server_AMD),
      type = 'pie',
      hole = 0.4,
      marker = list(colors = c('#0071c5', '#ed1c24'),
                    line = list(color = '#FFFFFF', width = 2)),
      textposition = 'inside',
      textinfo = 'label+percent',
      hoverinfo = 'text',
      text = c(hover_intel, hover_amd),
      insidetextfont = list(color = '#FFFFFF')
    ) %>%
    layout(
      title = list(
        text = paste("Server", selected_data$Quarter),
        font = list(size = 16)
      ),
      showlegend = TRUE,
      legend = list(orientation = "h", y = -0.2),
      annotations = list(
        list(
          text = paste0(round(selected_data$x86_Server_Intel), "%"),
          x = 0.5, y = 0.5, showarrow = FALSE, 
          font = list(size = 20, color = "#0071c5", family = "Arial, sans-serif")
        )
      )
    )
    
    p
  })
  
  # Market share trend plot
  output$market_trend_plot <- renderPlotly({
    # Create a plot showing all market share trends over time
    desktop_df <- data.frame(Quarter = market_share$Quarter, 
                            Share = market_share$x86_Desktop_Intel, 
                            Segment = "Desktop")
    mobile_df <- data.frame(Quarter = market_share$Quarter, 
                           Share = market_share$x86_Mobile_Intel, 
                           Segment = "Mobile")
    server_df <- data.frame(Quarter = market_share$Quarter, 
                           Share = market_share$x86_Server_Intel, 
                           Segment = "Server")
    
    all_data <- rbind(desktop_df, mobile_df, server_df)
    
    p <- plot_ly() %>%
      add_trace(data = desktop_df, x = ~Quarter, y = ~Share, type = 'scatter', mode = 'lines+markers',
                name = 'Desktop', line = list(color = '#1976d2', width = 3), 
                marker = list(size = 8, symbol = 'circle')) %>%
      add_trace(data = mobile_df, x = ~Quarter, y = ~Share, type = 'scatter', mode = 'lines+markers',
                name = 'Mobile', line = list(color = '#43a047', width = 3),
                marker = list(size = 8, symbol = 'square')) %>%
      add_trace(data = server_df, x = ~Quarter, y = ~Share, type = 'scatter', mode = 'lines+markers',
                name = 'Server', line = list(color = '#e53935', width = 3),
                marker = list(size = 8, symbol = 'diamond')) %>%
      layout(title = "Intel's Market Share Trends Across Segments",
             xaxis = list(title = "Quarter", tickangle = -45),
             yaxis = list(title = "Market Share (%)", range = c(50, 100)),
             hovermode = "x unified",
             legend = list(orientation = 'h', y = -0.2))
    
    p
  })
  
  # Revenue stacked bar chart with enhanced features
  output$revenue_stacked_bar <- renderPlotly({
    # Group categories by importance
    primary_categories <- c("Client Computing", "Data Center", "Foundry Services")
    
    # Create custom color palette with emphasis on primary categories
    category_colors <- viridis(n = length(unique(intel_revenue_long$Category)), option = "turbo")
    names(category_colors) <- sort(unique(intel_revenue_long$Category))
    
    # For primary categories, use distinct colors
    category_colors["Client Computing"] <- "#0071c5"  # Intel blue
    category_colors["Data Center"] <- "#ed1c24"  # Red
    category_colors["Foundry Services"] <- "#4caf50"  # Green
    
    p <- plot_ly(intel_revenue_long, x = ~Date, y = ~Value, 
                color = ~Category, colors = category_colors,
                type = 'bar', hoverinfo = 'text',
                text = ~paste0(Category, ": $", round(Value, 2), "B")) %>%
      layout(barmode = 'stack',
             title = list(
               text = "Intel Revenue Breakdown by Business Segment",
               font = list(size = 18)
             ),
             xaxis = list(title = "Quarter", tickangle = -45),
             yaxis = list(title = "Revenue in Billions ($)"),
             legend = list(orientation = "h", x = 0, y = -0.2),
             annotations = list(
               list(
                 x = "Q1 2023", y = 120, 
                 text = "Start of Foundry Growth",
                 showarrow = TRUE,
                 arrowhead = 1,
                 arrowcolor = "#4caf50",
                 arrowsize = 1,
                 font = list(size = 12)
               )
             ))
    
    p
  })
  
  # New segment comparison chart
  output$revenue_segment_comparison <- renderPlotly({
    # Prepare data for segment comparison
    segment_data <- intel_revenue_long %>%
      group_by(Category) %>%
      summarise(
        Average = mean(Value, na.rm = TRUE),
        Max = max(Value, na.rm = TRUE),
        Min = min(Value, na.rm = TRUE),
        Latest = tail(Value[!is.na(Value)], 1),
        LatestGrowth = (tail(Value[!is.na(Value)], 1) / tail(Value[!is.na(Value)], 2) - 1) * 100
      )
    
    # Sort by importance
    segment_data <- segment_data[order(-segment_data$Average),]
    
    # Create a horizontal bar chart for comparison
    p <- plot_ly() %>%
      add_trace(
        x = segment_data$Latest,
        y = segment_data$Category,
        type = 'bar',
        orientation = 'h',
        name = 'Latest Quarter',
        marker = list(color = '#0071c5')
      ) %>%
      add_trace(
        x = segment_data$Average,
        y = segment_data$Category,
        type = 'scatter',
        mode = 'markers',
        name = 'Average',
        marker = list(color = '#ff9800', size = 12, symbol = 'diamond')
      ) %>%
      add_trace(
        x = segment_data$Max,
        y = segment_data$Category,
        type = 'scatter',
        mode = 'markers',
        name = 'Maximum',
        marker = list(color = '#4caf50', size = 10, symbol = 'triangle-up')
      ) %>%
      layout(
        title = "Revenue Segment Performance Comparison",
        xaxis = list(title = "Revenue in Billions ($)"),
        yaxis = list(title = "", categoryorder = "trace"),
        barmode = 'group',
        legend = list(orientation = 'h', y = -0.2),
        hovermode = "closest"
      )
    
    p
  })
  
  # New growth rate chart
  output$revenue_growth_chart <- renderPlotly({
    # Prepare data for growth analysis
    growth_data <- intel_revenue_long %>%
      group_by(Category) %>%
      arrange(Date) %>%
      mutate(
        PrevValue = lag(Value),
        GrowthRate = (Value / PrevValue - 1) * 100
      ) %>%
      filter(!is.na(GrowthRate))
    
    # Create growth rate chart
    p <- plot_ly() %>%
      add_trace(
        data = growth_data,
        x = ~Date,
        y = ~GrowthRate,
        color = ~Category,
        type = 'scatter',
        mode = 'lines+markers',
        line = list(width = 2),
        marker = list(size = 6)
      ) %>%
      add_trace(
        x = unique(growth_data$Date),
        y = rep(0, length(unique(growth_data$Date))),
        type = 'scatter',
        mode = 'lines',
        line = list(color = 'black', dash = 'dash', width = 1),
        showlegend = FALSE,
        hoverinfo = 'none'
      ) %>%
      layout(
        title = "Quarter-over-Quarter Growth Rates by Business Segment",
        xaxis = list(title = "Quarter"),
        yaxis = list(title = "Growth Rate (%)", zeroline = TRUE),
        legend = list(orientation = 'h', y = -0.2),
        hovermode = "x unified"
      )
    
    p
  })

  # ...existing code...
}

# Run the application
shinyApp(ui = ui, server = server)