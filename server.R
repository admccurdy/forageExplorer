
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#



shinyServer(function(input, output) {

  output$table <- DT::renderDataTable(DT::datatable({
    forageFrame <- getForageFrame(input, dynamicInputs)
    forageFrame[1,] <- 1
    for(i in 1:nrow(forageFrame)){
      inputID <- dynamicInputs$id[i]
      forageFrame$year[i] <- i
      forageFrame$rainIndex[i] <- input[[inputID]]
      
      ## This is forage just impacted by CC
      forageFrame$forageCarry[i] <- max(forageFrame$rainIndex[i], input$adaptLvl) / input$carryingCap
      
      ## This is the forage 
      forageFrame$droughtForage[i] <- ifelse(i == 1, 1 * (1 - 0 / input$x),
                                             forageFrame$droughtForage[i - 1] * (1 - forageFrame$Gt[i - 1] / input$x))
      
      ## This is assumes that the rain index is a 1:1 conversion to forage
      forageFrame$actualForage[i] <- forageFrame$droughtForage[i] * forageFrame$rainIndex[i]
      

      ## This is the forage with drought and cc accounted for and adaptation
      forageFrame$finalForage[i] <- with(forageFrame, ifelse(rainIndex[i] < input$adaptLvl,
                                                             droughtForage[i] * input$adaptLvl,
                                                             actualForage[i]) / input$carryingCap)
      
      if(forageFrame$rainIndex[i] > input$adaptLvl & 
         forageFrame$rainIndex[i] < 1){
        forageFrame$Gt[i] <- 1 - forageFrame$finalForage[i] +
          forageFrame$finalForage[i] * (1 - (forageFrame$rainIndex[i] - (1-input$adaptLvl))/
                                          forageFrame$rainIndex[i])
      }else{
        forageFrame$Gt[i] <- 1 - forageFrame$finalForage[i]
      }
    }
    # print(forageFrame)
  forageFrame[,(names(forageFrame)) := lapply(.SD, round, 2), .SDcols = names(forageFrame) ]}))
}) 
