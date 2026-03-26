
# Libraries ---
library(shiny)
library(tidyverse)
library(bslib)

# Load the data ---
student_data <- read.csv("data/student_lifestyle_dataset.csv")
student_data$Stress_Level <- factor(student_data$Stress_Level, 
                                    levels = c("Low", "Moderate", "High"))


# ui logic ---
ui <- page_sidebar(
  
  # title ---
  title = "Student Stress Levels",
  
  # sidebar ---
  sidebar = sidebar(
    helpText("Explore relationships between stress level 
             and various student factors."),
    position = "left",
    width = "3in", 
    
    # widget to select the variable ---
    selectInput(
      "var",
      label = "Choose a variable to display against Stress Level",
      choices = c(
        "Study Hours Per Day",
        "Sleep Hours Per Day",
        "Social Hours Per Day",
        "Physical Activity Hours Per Day",
        "GPA"),
      selected = "Study Hours Per Day"
    ),
    
    # widget to choose plot type ---
    selectInput(
      "plot_type",
      label = "Choose plot type",
      choices = c("Box Plot", "Violin Plot"),
      selected = "Box Plot"
    ),
    
  ),
  
  # adding tabs for different sections
  mainPanel(
    tabsetPanel(
      
      # first tab: display plot ---
      tabPanel("Stress vs Variable",
               card(plotOutput("graph", height = "500px"),
                    card_footer(markdown("Dataset by Steve1215Rogg on [Kaggle](https://www.kaggle.com/datasets/steve1215rogg/student-lifestyle-dataset).")))
      ),
      
      # second tab: stat summary ---
      tabPanel("Data Summary",
               DT::dataTableOutput("summary_table")
      )
    ),
  )
)


# server logic ---
server <- function(input, output) {
  
  # function and data wrangling for tab 2 ---
  summary_stats <- reactive({
    x_variable <- switch(input$var,
                         "Study Hours Per Day" = "Study_Hours_Per_Day",
                         "Sleep Hours Per Day" = "Sleep_Hours_Per_Day",
                         "Social Hours Per Day" = "Social_Hours_Per_Day",
                         "Physical Activity Hours Per Day" = 
                           "Physical_Activity_Hours_Per_Day",
                         "GPA" = "GPA"
    )
    
    summary_data <- student_data %>%
      group_by(Stress_Level) %>%
      summarise(
        max_value = max(.data[[x_variable]], na.rm = TRUE),
        min_value = min(.data[[x_variable]], na.rm = TRUE),
        mean_value = mean(.data[[x_variable]], na.rm = TRUE),
        sd_value = sd(.data[[x_variable]], na.rm = TRUE)
      )
    return(summary_data)
  })
  
  output$summary_stats <- renderPrint({
    summary_stats()
  })
  
  # wrangling and set up for tab 1 ---
  output$graph <- renderPlot({
    
    # switch to store different x-variable options
    x_variable <- switch(input$var,
                         "Study Hours Per Day" = "Study_Hours_Per_Day",
                         "Sleep Hours Per Day" = "Sleep_Hours_Per_Day",
                         "Social Hours Per Day" = "Social_Hours_Per_Day",
                         "Physical Activity Hours Per Day" = 
                           "Physical_Activity_Hours_Per_Day",
                         "GPA" = "GPA"
    )
    
    # create plot based on selected plot type ---
    # violin plot
    if (input$plot_type == "Violin Plot") {
      ggplot(data = student_data, aes_string(x = "Stress_Level", 
                                             y = x_variable, 
                                             fill = "Stress_Level")) +
        geom_violin(trim = FALSE) + 
        labs(
          x = "Stress Level",
          y = input$var,
          title = paste(input$var, "by Stress Level")
        ) +
        theme_minimal(base_size = 15) +
        theme(
          axis.title = element_text(face = "bold", size = 14),
          axis.text = element_text(size = 12),
          plot.title = element_text(face = "bold", size = 16, 
                                    hjust = 0.5, color = "#1f78b4"),
          legend.position = "none",
          panel.grid.major = element_line(color = "lightgray", size = 0.5),
          panel.grid.minor = element_blank()
        ) +
        scale_fill_manual(values = c("Low" = "#A1D1D1", 
                                     "Moderate" = "#F3A1A1", 
                                     "High" = "#FF6A6A"))
      
    }
    
    # box plot
    else {
      ggplot(data = student_data, aes_string(x = "Stress_Level",
                                             y = x_variable, 
                                             fill = "Stress_Level")) +
        geom_boxplot() +
        labs(
          x = "Stress Level",
          y = input$var,
          title = paste(input$var, "by Stress Level")
        ) +
        theme_minimal(base_size = 15) +
        theme(
          axis.title = element_text(face = "bold", size = 14),
          axis.text = element_text(size = 12),
          plot.title = element_text(face = "bold", size = 16, 
                                    hjust = 0.5, color = "#1f78b4"),
          legend.position = "none",
          panel.grid.major = element_line(color = "lightgray", size = 0.5),
          panel.grid.minor = element_blank()
        ) +
        scale_fill_manual(values = c("Low" = "lightblue", 
                                     "Moderate" = "pink", 
                                     "High" = "#FF6A6A"))
      
    }
  })
  
  # output the summary table for the second tab ---
  output$summary_table <- DT::renderDataTable({
    summary_stats() %>%
      rename(
        "Stress Level" = Stress_Level,
        "Mean Value" = mean_value,
        "Maximum Value" = max_value,
        "Minimum Value" = min_value,
        "Standard Deviation" = sd_value
      ) %>%
      DT::datatable(
        options = list(
          pageLength = 3,  
          dom = 't'
        ),
        rownames = FALSE, 
        caption = "Summary Statistics by Stress Level and 
            Selected Student Variable"
      ) %>%
      DT::formatRound(columns = c("Maximum Value", "Minimum Value", 
                                  "Mean Value", "Standard Deviation"), 
                      digits = 2)
  })
}

# run the app ---
shinyApp(ui = ui, server = server)
