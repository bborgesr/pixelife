library(shiny)
library(DT)
library(dplyr)
library(colourpicker)
library(webshot)
source("colors.R", local = TRUE)

# options(shiny.launch.browser=F, shiny.minified=F, shiny.port = 9000)

ui = fluidPage(titlePanel("PIXELIFE"),
  tags$head(tags$style(HTML(css))),
  fluidRow(
    column(2,
      numericInput("size", "Number of pixels", 10), 
      actionButton("reset", "Clear drawing", class="btn btn-danger"), br(), br(),
      # actionButton("save", "Download", class="btn btn-info"), br(), br(),
      colourInput("color", "Select colour", palette = "limited", allowedCols = colors, value = "#A82800")
      # radioButtons("color", "Choose color", 
      #   choiceNames = choiceNames,
      #   choiceValues = choiceValues
      # )
    ),
    column(10, DT::dataTableOutput("drawing"), div(id = "placeholder"))
  )
)

server = function(input, output, session) {
  rv <- reactiveValues(data = NULL)
  
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
  
  # output$save <- downloadHandler(
  #   filename = function() {
  #     paste("drawing.html")
  #   },
  #   content = function(file) {
  #     saveWidget("drawing", file)
  #   }
  # )
  

  # observeEvent(input$save, {
  #   d <- session$clientData
  #   url <- paste0(d$url_protocol, "//", d$url_hostname, ":", d$url_port)
  #   webshot(url) #, file = paste0("drawing-", Sys.Date(), ".png", selector = "table"))
  # })

  output$drawing = DT::renderDataTable({
    rv$data
  }, server = FALSE)
}

shinyApp(ui, server)