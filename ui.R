
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(data.table)
source("forageFunctions.R")

shinyUI(fluidPage( 

  # Application title
  titlePanel("Forage Explorer"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      lapply(1:x, function(i) {
        numericInput(dynamicInputs[i,'id'], dynamicInputs[i,'name'],dynamicInputs[i,'value'], step = .2)
      }),
      # numericInput("adaptRatio", "Adaptation Ratio", 1, 0, 1, .1),
      numericInput("carryingCap", "Carrying Capacity Ratio", 1, min = 0, step = .1),
      numericInput("x", "X", 10),
      numericInput("adaptLvl", "Adaptation Trip", .9, 0, 1, .1)
    ),

    mainPanel(
      h4("droughtForage"),
      p("This corresponds to alpha and reflects the impacts of drought from previous years
         drought in the current year will have no affect on this metric"),
      p(span("droughtForage", style = "font-weight:bold"), "= droughtForage[t - 1] * (1 - Gt[t - 1] / x)"),
      h4("forageCarry"),
      p("This is the isolated effect of carrying capacity on the avialable forage using the rain
        index and assumping adaptation up to adaptation level"),
      p(span("forageCarry", style = "font-weight:bold"), "= max(rainIndex[t], adaptLvl) / carryingCap"),
      h4("actualForage"),
      p(span("actualForage", style = "font-weight:bold"), "= actualForage[t] <- droughtForage[t] * rainIndex[t]"),
      h4("finalforage"),
      p("The forage which actually gets used for weight calculations includes effects of 
        drought and carrying capacity"),
      p(span("finalForage", style = "font-weight:bold"), "= ifelse(rainIndex[t] < adaptLvl,
                                                             droughtForage[t] * adaptLvl,
                                                             actualForage[t]) / carryingCap)"),
      h4("Gt"),
      p("The carry over effect of drought from the previous year"),
      p(span("gt", style = "font-weight:bold"), "= 1 - finalForage[t] +
          finalForage[t] * (1 - (rainIndex[t] - (1-adaptLvl)) / rainIndex[t])"),
      DT::dataTableOutput("table")
      
    )
  )
))

