# Define server logic
server <- function(input, output, session) {

  #####
  ##### BAR CHART
  #####
  observeEvent(input$cpc_select, {
    
    # Get the selected class
    selected_class <- input$cpc_select
    
    # Get the options for the selected class
    subclass_options <- unlist(
      (complete_data %>% 
         filter(cpc_class == selected_class) %>% 
        distinct(cpc_subclass))$cpc_subclass
    )
    
    subclass_options <- c("None", subclass_options)
    
    
    # Update the choices for cpc_subclasses
    updateSelectInput(session, "cpc_subclass_select", choices = subclass_options)
  })
  
  barchart_data <- reactive({
    req(input$cpc_select)
    
    if(input$cpc_subclass_select == "None") {
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
  
  output$barchart_plot <- renderPlotly({
    # plot_ly(data = data, x = data$disambig_assignee_organization, y = data$total, type = "bar")
    plot_ly(
      data = barchart_data(),
      x = ~disambig_assignee_organization,
      y = ~total,
      name = "Number of Patents",
      type = "bar"
    ) %>% 
      layout(
        xaxis = list(categoryorder = "total descending", title = "Organization"),
        yaxis = list(title = "Total")
      )
  })
  
  
  
  #####
  ##### CAGR
  #####
  observeEvent(input$cagr_cpc_select, {
    
    # Get the selected class
    selected_class <- input$cagr_cpc_select
    
    # Get the options for the selected class
    subclass_options <- unlist(
      (complete_data %>% 
         filter(cpc_class == selected_class) %>% 
         distinct(cpc_subclass))$cpc_subclass
    )
    
    subclass_options <- c("None", subclass_options)
    
    
    # Update the choices for cpc_subclasses
    updateSelectInput(session, "cagr_cpc_subclass_select", choices = subclass_options)
  })
  
  cagr_data <- reactive({
    req(input$cagr_cpc_select)
    
  
    
    if (input$cagr_cpc_subclass_select == "None") {
      totals <- complete_data %>% 
        filter(cpc_class == input$cagr_cpc_select, disambig_assignee_organization!="") %>% 
        group_by(disambig_assignee_organization) %>% 
        summarize(total=uniqueN(patent_id)) 
    } else {
      totals <- complete_data %>% 
        filter(cpc_class == input$cagr_cpc_select, disambig_assignee_organization!="", cpc_subclass == input$cagr_cpc_subclass_select) %>% 
        group_by(disambig_assignee_organization) %>% 
        summarize(total=uniqueN(patent_id)) 
      
    }
    
    
    totals <- totals %>% 
      arrange(desc(total)) %>%
      slice(1:10) 
    
    
    # Calculate 5 year CAGR for top 10 companies
    cagr <- data.frame(expand.grid(year=2017:2021,disambig_assignee_organization=totals$disambig_assignee_organization))
    temp <- complete_data %>% 
      filter(disambig_assignee_organization %in% totals$disambig_assignee_organization) %>% 
      group_by(year=year(patent_date),disambig_assignee_organization) %>% 
      summarise(n=uniqueN(patent_id))
    cagr <- merge(cagr,temp,by = c('year','disambig_assignee_organization'),all.x = T)
    rm(temp)
    cagr[is.na(cagr)] <- 0
    cagr <- cagr %>%
      group_by(disambig_assignee_organization) %>%
      mutate(cum_cnt = cumsum(n)) %>%  # make sure your date are sorted correctly before calculating the cumulative :)
      filter(year %in% c(2017,2021)) %>%
      pivot_wider(id_cols = disambig_assignee_organization,names_from = year,values_from = cum_cnt)
    cagr$cagr_2017_2021 <- round(((cagr$`2021`/cagr$`2017`)^(1/5))-1,3)
    cagr <- cagr %>% 
      filter(is.finite(cagr_2017_2021))
    
    return(cagr)
  })
  
  output$cagr_plot <- renderPlotly({
    plot_ly(
      data = cagr_data(),
      x = ~disambig_assignee_organization,
      y = ~cagr_2017_2021,
      name = "CAGR",
      type = "bar"
    ) %>% 
      layout(
        xaxis = list(categoryorder = "total descending", title = "Organization"),
        yaxis = list(title = "Total")
      )
  })
  
  #####
  ##### MAP
  #####
  observeEvent(input$map_cpc_select, {
    
    # Get the selected class
    selected_class <- input$map_cpc_select
    
    # Get the options for the selected class
    subclass_options <- unlist(
      (complete_data %>% 
         filter(cpc_class == selected_class) %>% 
         distinct(cpc_subclass))$cpc_subclass
    )
    
    subclass_options <- c("None", subclass_options)
    
    
    # Update the choices for cpc_subclasses
    updateSelectInput(session, "map_cpc_subclass_select", choices = subclass_options)
  })
  
  
  map_data <- reactive({
    req(input$map_cpc_select)
    
    filtered_data <- complete_data %>% 
      filter(cpc_class == input$map_cpc_select)
    
    if(input$map_cpc_subclass_select != "None") {
      filtered_data <- filtered_data %>% 
        filter(cpc_subclass == input$map_cpc_subclass_select)
    }
    
    filtered_data$state_fips <- str_pad(string = filtered_data$state_fips,width = 2,side = 'left',pad = '0')
    filtered_data$county_fips <- str_pad(string = filtered_data$county_fips,width = 3,side = 'left',pad = '0')
    filtered_data$fips <- paste(filtered_data$state_fips,filtered_data$county_fips,sep = '')
    
    dt_county <- filtered_data %>% filter(!is.na(county_fips)) %>% group_by(disambig_state,county,fips) %>% summarise(n=uniqueN(patent_id))
    
    
    # get geojson files for mapping
    url <- 'https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json'
    counties <- rjson::fromJSON(file = url)
    
    
    dt_state <- filtered_data %>% group_by(disambig_state,state_fips) %>% summarise(n=uniqueN(patent_id))
    
    
    l <- list(color = toRGB("white"), width = 2)
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    fig <- plot_geo(dt_state, locationmode = 'USA-states') %>% add_trace(
      z = ~n, 
      text = ~disambig_state, 
      locations = ~disambig_state,
      color = ~n, 
      colors = 'Blues'
    )  %>% colorbar(title = "Count of patents" )%>% layout(
      geo = g
    )
    
    return(fig)
  })
  
  output$map_plot <- renderPlotly({
    map_data()
  })
  
  ####
  #### TABLE
  ####
  observeEvent(input$table_cpc_select, {

    # Get the selected class
    selected_class <- input$table_cpc_select

    # Get the options for the selected class
    subclass_options <- unlist(
      (complete_data %>%
         filter(cpc_class == selected_class) %>%
         distinct(cpc_subclass))$cpc_subclass
    )

    subclass_options <- c("None", subclass_options)


    # Update the choices for cpc_subclasses
    updateSelectInput(session, "table_cpc_subclass_select", choices = subclass_options)
  })

  table_data <- reactive({
    req(input$table_cpc_select)

    filtered_data <- complete_data %>%
      filter(cpc_class == input$table_cpc_select)

    if(input$table_cpc_subclass_select != "None") {
      filtered_data <- filtered_data %>% 
        filter(cpc_subclass == input$table_cpc_subclass_select)
    }
    
    ### Remove unwanted columns
    filtered_data <- filtered_data %>% 
      select(-c(location_id, assignee_id, county ))


    return(filtered_data)
  })

  output$table_data <- renderDT({
    datatable(table_data(), options = list(pageLength = 25, scrollX = T))
  })
  
  
  
}