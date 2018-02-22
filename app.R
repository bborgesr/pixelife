library(shiny)
library(DT)
library(dplyr)
library(webshot)
library(colourpicker)
source("colors.R", local = TRUE)

ui = fluidPage(titlePanel("PIXELIFE"),
  tags$head(tags$style(HTML(css))),
  fluidRow(
    column(2,
      numericInput("size", "Number of pixels", 10), 
      actionButton("reset", "Clear drawing", class = "btn btn-danger"), br(), br(),
      colourInput("color", "Select colour", palette = "limited",
        allowedCols = colors, value = "#A82800"),
      bookmarkButton("bookmark")
    ),
    column(10, uiOutput("drawing"), div(id = "placeholder"))
  )
)

server = function(input, output, session) {
  rv <- reactiveValues(data = NULL, drawTable = TRUE)
  
  observeEvent(input$size, {
    # create data frame for the first time (or reset it if user changes the size)
    size <- input$size
    vals <- lapply(1:size, function(i) { 
      id <- paste0("c", i, "_", 1:size)
      val <- paste0(i, ",", 1:size)
      sprintf("<div id='%s' style = 'height:%spx'>%s</div>", id, height, "")
    })
    names(vals) <- paste0("X", 1:size)
    data <- data.frame(vals)
    rownames(data) <- paste0("Y", 1:size)
    
    # create datatable object
    rv$data <- datatable(data,  escape = FALSE,
      class = "cell-border stripe", selection = "none", 
      options = list(dom = 't', pageLength = size, autoWidth = TRUE,
        columnDefs = list(list(width = paste0(height, "px"), targets = "_all")))) %>%
      formatStyle(names(vals),
        color = "grey", textAlign = "center", backgroundColor = "white")
  })
  
  observeEvent(input$drawing_cell_clicked, {
    cell <- input$drawing_cell_clicked
    id <- paste0("c", cell$col, "_", cell$row)
    html <- HTML(paste0('#', id, ' { background-color:', input$color ,'; }'))
    insertUI("#placeholder", "beforeEnd", tags$style(html))
  })
  
  observeEvent(input$reset, {
    removeUI("#placeholder")
    insertUI("#drawing", "afterEnd", div(id = "placeholder"))
  })
  
  output$drawing <- if (rv$drawData) {
    DT::renderDataTable(rv$data, server = FALSE)
    rv$drawData <- FALSE
  } else {
    ""
  }
  
  onBookmark(function(state) {
    state$values$customCSS <- customCSS
  })
  
  onRestore(function(state) {
    state$values$rv$drawData <- FALSE
    customCSS <- state$values$customCSS
    insertUI("#placeholder", "beforeEnd", tags$style(customCSS))
  })
}

shinyApp(ui, server)