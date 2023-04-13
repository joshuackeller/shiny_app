
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
          selectInput(inputId = "cpc_select", label = "CPC Class", choices = distinct_cpc_codes),
          selectInput(inputId = 'cpc_subclass_select', label = 'CPC Subclass', choices = NULL),
          actionButton(inputId = "my_button", label = "Button"),
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
       h1('Second'),
       tabsetPanel(
         tabPanel(title = 'Inputs',
                  wellPanel(
                    textInput(inputId = 'fourth_input', label = 'First Input', width = '200px', placeholder = 'Enter text here'),
                    textInput(inputId = 'fifth_input', label = 'Second Input', width = '200px', placeholder = 'Enter text here'),
                    textInput(inputId = 'sixth_input', label = 'Third Input', width = '200px', placeholder = 'Enter text here'),
                    actionButton(inputId = "my_button", label = "Button")
                  )),
         tabPanel(title = 'Outputs',
                  wellPanel(
                    plotlyOutput(outputId = 'second_output')
                  )),
       )
     )
  ),
                 
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
