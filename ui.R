library(shiny)
library(ggplot2)
library(Hmisc)
fullnames <- c("Miles/(US) gallon",
               "Number of cylinders",
               "Displacement (cu.in.)",
               "Gross horsepower",
               "Rear axle ratio",
               "Weight (lb/1000)",
               "1/4 mile time",
               "V/S",
               "Transmission (0 = automatic, 1 = manual)",
               "Number of forward gears",
               "Number of carburetors")

shinyUI(pageWithSidebar(
    
    headerPanel("Predicting Outcomes with MTCars data and a Linear Best-Fit"),
    
    sidebarPanel(
        h3('Plotting Variables'),
        selectInput('x', 'X', choices = fullnames,
                    selected = fullnames[1]),
        selectInput('y', 'Y', choices = fullnames,
                    selected = fullnames[3]),
        h3('Prediction Value'),
        textInput("pred.xval", "X-value: "),
        actionButton("goButton", "Predict!")
    ),
    
    mainPanel(
        tabsetPanel(
            tabPanel("APPLICATION", value=1,
                     h3('Prediction:'),
                     verbatimTextOutput('predictionOutput'),
                     h3('Least-Squares (best fit) line to the data'),
                     verbatimTextOutput('bestfitOutput'),
                     h3('Plot of the data'),                     
                    plotOutput('plot')),
            tabPanel("DOCUMENTATION", value=2,
                     h4('This document describes the usage and details of the \'Predicting Outcomes with MTCars data and a Linear Best-Fit\' Shiny
                        application.  The application uses the mtcars dataset, which is provided in Rs base 
                        package.  This dataset data was extracted from the 1974 Motor Trend US magazine, and
                        comprises fuel consumption and 10 aspects of automobile design and performance for
                        32 automobiles (1973–74 models), see ?mtcars for more details.'),
                     h4('The shiny app allows the user to choose any two variables on the left hand side to 
                        be plotted as either the X- or Y-variable.  For any selection made a plot is made of
                        all the data and a linear fit is made to the data with regard to the two selected 
                        variables.  Additionally, we show the slope and intercept of the linear fit above 
                        the plot on the right hand side.'),
                     h4('The user can then predict the Y-value from a chosen X-value.  The X-value is to be
                        input on the left hand side of the application.  Once the user presses the Predict! 
                        a prediction is made by evaluating the linear fit at the requested X-value.  The 
                        prediction is shown in the plot as a red dot and in the textbox at the top right.')
                     )
            , id = "conditionedPanels"
        )
    )
))