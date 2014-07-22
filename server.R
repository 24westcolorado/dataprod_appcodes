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
go.count  <- 0
go.count2 <- 0

shinyServer(function(input, output) {
        
    #----------------------------------------------------------------------
    # Construct a best fit line between the x and y variables
    fit <- reactive(function() {
        
        id1       <- which(fullnames==input$x)
        id2       <- which(fullnames==input$y)        
        fit       <- lm( mtcars[,id2] ~ mtcars[,id1] )
        
        return(fit)
    })
    
    #--------------------------------------------------------------------------
    # Plotting function
    
    output$plot <- reactivePlot(function() {
        
        tmp       <- mtcars
        id1       <- which(fullnames==input$x)
        id2       <- which(fullnames==input$y)
                
        #----------------------------------------------------------------------
        # Construct the plot with or without the factors
            
        p         <- ggplot(tmp, aes_string(x=names(tmp)[id1], y=names(tmp)[id2])) +
                                                geom_point()                
        p         <- p + xlab(input$x) + ylab(input$y)                     
        
        #----------------------------------------------------------------------
        # Add a best fitting line
        fit.var <- fit()
        b.val   <- fit.var[[1]][1]
        m.val   <- fit.var[[1]][2]
        p <- p + geom_abline(intercept = b.val,
                             slope = m.val )
                
        if (abs( go.count - input$goButton) > 0)
        {
            pred.xval <- as.numeric(input$pred.xval)
            if (is.na(pred.xval) == FALSE)
            {
                dataset <- data.frame(
                    xval = pred.xval,
                    yval = (m.val*pred.xval + b.val) )
                colnames(dataset) <- c(names(tmp)[id1], y=names(tmp)[id2])
                p <- p + geom_point(data=dataset, 
                                    aes_string(x=names(tmp)[id1], y=names(tmp)[id2]),
                                    colour = "red", size = 5)
            }
            go.count <<- input$goButton
        } 
        #----------------------------------------------------------------------
        # Make the plot
        
        print(p)
        
    }, height=350)
    
    #--------------------------------------------------------------------------  
    # Text output of best fitting line
    
    output$bestfitOutput <- renderText(function() {
        
        # String of the best fitting line
        fit.var <- fit()
        str.vec <- paste("slope = ",
                         round(fit.var[[1]][2],2),
                         ", y-intercept = ",
                         round(fit.var[[1]][1],1),sep="")
        
        return(str.vec)
    })
    
    #--------------------------------------------------------------------------  
    # Text output of prediction
    
    output$predictionOutput <- renderText(function() {
        
        # String of the best fitting line
        fit.var <- fit()
        b.val   <- fit.var[[1]][1]
        m.val   <- fit.var[[1]][2]
        pred.xval <- as.numeric(input$pred.xval)
        if (abs( go.count2 - input$goButton) > 0)
        {
            if (is.na(pred.xval) == FALSE)
            {
                yval = (m.val*pred.xval + b.val) 
                str.vec <- paste(
                    input$y," = ",
                    round(yval,1),
                    " given the data and ",
                    input$x," = ",
                    pred.xval,sep="")            
            } else
            {
                str.vec <- "Invalid Entry"
            }
            go.count2 <<- input$goButton
        } else
        {
            str.vec <- ""
        }
        
        return(str.vec)
    })
    
})