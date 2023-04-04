
ui <- navbarPage(title = 'Patent Analytics',
  tabPanel(title = "Landing",
           fluidPage(
             h1('Landing Page')
           )),
  tabPanel(title = 'First',
    fluidPage(
      h1('First'),
      tabsetPanel(
        tabPanel(title = 'Inputs',
                 wellPanel(
                   textInput(inputId = 'first_input', label = 'First Input', width = '200px', placeholder = 'Enter text here'),
                   textInput(inputId = 'second_input', label = 'Second Input', width = '200px', placeholder = 'Enter text here'),
                   textInput(inputId = 'third_input', label = 'Third Input', width = '200px', placeholder = 'Enter text here'),
                   actionButton(inputId = "my_button", label = "Button")
                 )),
        tabPanel(title = 'Outputs',
                 wellPanel(
                   plotlyOutput(outputId = 'my_output')
                 )),
      )
    )
  ),
  tabPanel(title = 'Second',
    fluidPage(
       h1('Second'),
       tabsetPanel(
         tabPanel(title = 'Inputs',
                  wellPanel(
                    textInput(inputId = 'first_input', label = 'First Input', width = '200px', placeholder = 'Enter text here'),
                    textInput(inputId = 'second_input', label = 'Second Input', width = '200px', placeholder = 'Enter text here'),
                    textInput(inputId = 'third_input', label = 'Third Input', width = '200px', placeholder = 'Enter text here'),
                    actionButton(inputId = "my_button", label = "Button")
                  )),
         tabPanel(title = 'Outputs',
                  wellPanel(
                    plotlyOutput(outputId = 'my_output')
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
