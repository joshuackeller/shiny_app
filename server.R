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

  
## Create a bar chart based on cpc code 
  data <- reactive({
    req(input$cpc_select)
    filtered_data <- complete_data %>%
      filter(cpc_class == input$cpc_select) %>%
      filter(disambig_assignee_organization!='') %>%
      group_by(disambig_assignee_organization) %>%
      summarize(total=uniqueN(patent_id)) %>%
      arrange(desc(total)) %>%
      slice(1:10)

  return(filtered_data)
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