
ui <- navbarPage(title = 'Patent Analytics',
  # tabPanel(title = "Landing",
  #          fluidPage(
  #            h1('Landing Page')
  #          )),
  tabPanel(title = 'First',
    fluidPage(
      h1('First'),
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "cpc_select_1", label = "Select a CPC code:", choices = distinct_cpc_codes),
          textInput(inputId = 'cpc_subclass_1', label = 'Subclass (delineated by comma)', width = '200px', placeholder = 'Enter subclass codes'),
          actionButton(inputId = "create_graph", label = "Create Graph"),
          width = 2
        ),
        mainPanel(
          plotlyOutput("plot")
        )
      )
    )
  ),
  tabPanel(title = 'Second',
       fluidPage(
         h1('First'),
         sidebarLayout(
           sidebarPanel(
             selectInput(inputId = "cpc_select_2", label = "Select a CPC code:", choices = distinct_cpc_codes),
             textInput(inputId = 'cpc_subclass_2', label = 'Subclass (delineated by comma)', width = '200px', placeholder = 'Enter subclass codes'),
             actionButton(inputId = "create_map", label = "Create map"),
             width = 2
           ),
           mainPanel(
             plotlyOutput("map")
           )
         )
       )        
)

# ui <- fluidPage(
#   fluidRow(
#     column(width = 6, offset = 6,
#            p('hello there')
#     )
#   ),
#   tabsetPanel(
#     tabPanel(title = 'Inputs',
#              wellPanel(
#                textInput(inputId = 'my_input', label = 'Input', width = '200px', placeholder = 'Enter text here')
#              )),
#     tabPanel(title = 'Outputs',
#              wellPanel(
#                plotlyOutput(outputId = 'my_output')
#              )),
#   )
# )
#   
  
  
################
################ Layout
