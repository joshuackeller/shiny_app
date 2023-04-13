# Define server logic
server <- function(input, output) {
  # Server code goes here
  # output$first_output <- renderText({
  #   input$first_input
  # })
  
 first_input <- reactive({
    req(input$first_input)
    paste('You entered: ',input$first_input,sep = '',collapse = '')
    })
  output$first_output <- renderText({first_input()})

  
  # Create a reactive variable to store the filtered data
  filtered_data <- reactiveVal()
  
  # Create an observeEvent to listen for the button click
  observeEvent(input$create_graph, {
    # Filter the data based on the input values
    subclass_array <- NULL
    if (!is.null(input$cpc_subclass)) {
      subclass_input <- str_split(input$cpc_subclass, ",\\s*")[[1]]
      subclass_array <- paste0(input$cpc_select, subclass_input)
    }
    filtered_data(
      complete_data %>%
        filter(cpc_class == input$cpc_select) %>%
        {if (!is.null(subclass_array)) filter(., cpc_subclass %in% subclass_array) else .} %>%
        filter(disambig_assignee_organization != '') %>%
        group_by(disambig_assignee_organization) %>%
        summarize(total = uniqueN(patent_id)) %>%
        arrange(desc(total)) %>%
        slice(1:10)
    )
  })
  
  # Create a renderPlotly for the bar chart
  output$plot <- renderPlotly({
    df <- data.frame(disambig_assignee_organization = character(),
                     total = integer())
    
    if (!is.null(filtered_data()) && nrow(filtered_data()) > 0) {
      df <- filtered_data()
    }
    
    plot_ly(
      data = df,
      x = ~disambig_assignee_organization,
      y = ~total,
      name = "Number of Patents",
      type = "bar"
    ) %>% 
      layout(
        title = "Number of Patents",
        xaxis = list(categoryorder = "total descending", title = "Organization"),
        yaxis = list(title = "Total")
      )
  })
  
  
  
  
  
  
  
  
  
  
  
  
}