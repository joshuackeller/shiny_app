# Define server logic
server <- function(input, output, session) {
  # Server code goes here
  # output$first_output <- renderText({
  #   input$first_input
  # })
  

  observeEvent(input$cpc_select, {
    
    # Get the selected class
    selected_class <- input$cpc_select
    
    # Get the options for the selected class
    subclass_options <- unlist(
      (complete_data %>% 
         filter(cpc_class == selected_class) %>% 
        distinct(cpc_subclass))$cpc_subclass
    )
    
    
    # Update the choices for cpc_subclasses
    updateSelectInput(session, "cpc_subclass_select", choices = subclass_options)
  })
  

  
## Create a bar chart based on cpc code 
  data <- reactive({
    req(input$cpc_select)
    
    if(is.null(input$cpc_subclass_select)) {
      filtered_data <- complete_data %>%
        filter(cpc_class == input$cpc_select) %>%
        filter(disambig_assignee_organization!='') %>%
        group_by(disambig_assignee_organization) %>%
        summarize(total=uniqueN(patent_id)) %>%
        arrange(desc(total)) %>%
        slice(1:10)
      
      return(filtered_data)
    } else {
      filtered_data <- complete_data %>%
        filter(cpc_class == input$cpc_select, cpc_subclass == input$cpc_subclass_select) %>%
        filter(disambig_assignee_organization!='') %>%
        group_by(disambig_assignee_organization) %>%
        summarize(total=uniqueN(patent_id)) %>%
        arrange(desc(total)) %>%
        slice(1:10)
    }



  })
  
  output$plot <- renderPlotly({
    # plot_ly(data = data, x = data$disambig_assignee_organization, y = data$total, type = "bar")
    plot_ly(
      data = data(),
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