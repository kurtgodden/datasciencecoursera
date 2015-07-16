# ui.R

# helpText("Note: while the data view will show only",
#          "the specified number of observations, the",
#          "summary will be based on the full dataset.")

library(shiny)
fluidPage(
    titlePanel("Predicting 'PM Hikers' Membership from the First 3 Years of Member Data"),
    sidebarLayout(
        sidebarPanel(
            h4("What do you want to see?"),
            checkboxInput(inputId = "showFit",
                          label   = "Show regression line in the plot and geeky details below the plot",
                          value   = FALSE),
            h6(div("When box is checked, you may have to scroll down to see predictions.", style="color:red")),
            dateInput(inputId     = "endPrediction",
                           label  = "Show predicted 'PM Hikers' membership from July 3, 2015 to what ending date?",
                           value  = "2015-07-03",
                           min    = "2015-07-03",
                           max    = "2015-12-31",
                           format = "M dd, yyyy"),
            helpText("Click in the date field above and select any ending date between July 3, 2015 and December 31, 2015"),
            h5("PM Hikers Website:"),
            a(href = "http://www.meetup.com/The-PM-Hikers/", target="_blank", 
              "http://www.meetup.com/The-PM-Hikers/")
        ),
        mainPanel(
            h3("Membership Data used for Linear Regression Model"),
            # show actual membership in first 3 years
            plotOutput("first3Years"),  
            helpText("The plot above shows the training data used to create",
                     "a linear regression model, which is then used",
                     "to predict total members for dates after July 2, 2015",
                     "and ending no later than December 31, 2015"),
            verbatimTextOutput("summary"),
            helpText("When the 'Show regression...' box to the left is checked",
                     "then the text box above will show the regression",
                     "coefficients, R-squared, p-values, etc.",
                     "The table below displays the predicted total members",
                     "from July 3, 2015 (the first day after the plot above)",
                     "until the date you select in the date input field to the left."),
            tableOutput("prediction")
        )
    )
)