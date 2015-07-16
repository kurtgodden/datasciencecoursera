# server.R

library(shiny)
library(caret)
library(lubridate)

totalActiveData      <- read.csv("total.active.members.csv")
predictionData       <- read.csv("Future.PM.Hikers.Membership.csv") # everything except Date is NA
# Convert Date var to Date and add Day (count from first day of group)
totalActiveData$Date <- as.Date(totalActiveData$Date, format="%m/%d/%y")
totalActiveData$Day  <- 1:nrow(totalActiveData)
numModelDays         <- nrow(totalActiveData)
xLabels              <- seq(from       = totalActiveData$Date[1], 
                            to         = totalActiveData$Date[numModelDays], 
                            length.out = numModelDays)

predictionData$Date  <- as.Date(predictionData$Date, "%m/%d/%y")
beginDayPrediction   <- totalActiveData$Day[nrow(totalActiveData)]+1

lastDayPrediction    <- nrow(totalActiveData)+nrow(predictionData)
predictionData$Day   <- beginDayPrediction:lastDayPrediction

fit                  <- lm(Total.Members ~ Day, data=totalActiveData)
predictedMembership  <- as.numeric(round(predict(fit, newdata=predictionData), digits=0))
predictionData$Total.Members <- predictedMembership
names(predictionData)<- c("Date", "Predicted.Members", "Active.Members", "Day")

function(input, output) {
    output$first3Years <- renderPlot({
        plot(totalActiveData$Total.Members, 
             main = "'PM Hikers' Membership in First 3 Years",
             xlab = "Total Daily Membership from July 2, 2012 through July 2, 2015",
             ylab = "Total Members",
             xaxt = "n", # supress x-axis numeric labels (cf. 'axix()' function just below)
             fg = "darkblue",
             type = "l", col = "blue")
        axis(1, labels = xLabels, at = 1:numModelDays) #add x-axis date labels
        if (input$showFit) 
            abline(fit, col = "red")
    })
    output$summary <- renderPrint(
        if (input$showFit) 
            summary(fit))
    output$prediction <- renderTable({ 
        lastDay  <- input$endPrediction
        firstDay <- predictionData$Date[1]
        numDays  <- (lastDay - firstDay) + 1
        showPrediction <- predictionData[1:numDays, c("Date", "Predicted.Members")]
        showPrediction$Date <- as.character(showPrediction$Date)
        showPrediction
    }, digits=0)
}