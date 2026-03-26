# Student Stress Levels Visualization
*Final Project for STAT 302 at Northwestern University - December 2024*

## Overview
This project explores how various factors (study hours, sleep, social time, physical activity, GPA) relate to student stress levels. Using an interactive Shiny app, users can examine distributions and summary statistics for different factors across low, moderate, and high stress groups. Key insights include:
- Sleep hours vary less than expected across stress levels.
- Social hours per day show surprisingly little variability.
- Users can view both box plots (medians and general distribution) and violin plots (detailed distribution patterns).

## Methods
- Data cleaning and preprocessing in R using `tidyverse`  
- Interactive Shiny web app using `shiny` and `bslib`  
- Visualizations with `ggplot2` for box and violin plots  
- Interactive summary statistics tables with `DT`  
- UI includes dynamic variable selection and plot type switching  

## Key Features
- Selectable y-axis variable: Study Hours, Sleep Hours, Social Hours, Physical Activity, GPA  
- Switchable plot type: Box Plot / Violin Plot  
- Summary statistics tab for each variable by stress level  

## Data Sources
- [Student Lifestyle Dataset on Kaggle](https://www.kaggle.com/datasets/steve1215rogg/student-lifestyle-dataset)  

## Files
- `student_stress_code.R` – R script containing the Shiny app code  
- `student_stress_additional_info` – Analysis of results and app justification 

## Web App
Explore the interactive Shiny app online:  

[![Shiny App](https://img.shields.io/badge/Shiny-App-blue)](https://mayaschwa.shinyapps.io/Student_Stress_Levels/)
