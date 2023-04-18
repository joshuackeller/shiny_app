
ui <- dashboardPage(
  dashboardHeader(title = "Patent Analytics"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Number of Patents", tabName = "page1", icon = icon("hashtag")),
      menuItem("CAGR", tabName = "page2", icon = icon("chart-simple")),
      menuItem("Map", tabName = "page3", icon = icon("map-location-dot")),
      menuItem("Table", tabName= "page4", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "page1",
                  fluidPage(
                    h2('Number of Patents'),
                    sidebarLayout(
                      sidebarPanel(
                        selectInput(inputId = "cpc_select", label = "CPC Class", choices = distinct_cpc_codes),
                        selectInput(inputId = 'cpc_subclass_select', label = 'CPC Subclass', choices = NULL),
                        width = 2
                      ),
                      mainPanel(
                        plotlyOutput("barchart_plot")
                      )
                    )
                  )
      ),
      tabItem(tabName = "page2",
                    fluidPage(
                      h2('CAGR'),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "cagr_cpc_select", label = "CPC Class", choices = distinct_cpc_codes),
                          selectInput(inputId = 'cagr_cpc_subclass_select', label = 'CPC Subclass', choices = NULL),
                          width = 2
                        ),
                        mainPanel(
                          plotlyOutput("cagr_plot")
                        )
                      )
                    )
      ),
      tabItem(tabName = "page3",
                    fluidPage(
                      h2('Map of Patents by State'),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "map_cpc_select", label = "CPC Class", choices = distinct_cpc_codes),
                          selectInput(inputId = 'map_cpc_subclass_select', label = 'CPC Subclass', choices = NULL),
                          width = 2
                        ),
                        mainPanel(
                          plotlyOutput("map_plot")
                        )
                      )
                    )
    ),
    tabItem(tabName = "page4",
            fluidPage(
              h2('Table'),
              sidebarLayout(
                sidebarPanel(
                  selectInput(inputId = "table_cpc_select", label = "CPC Class", choices = distinct_cpc_codes),
                  selectInput(inputId = 'table_cpc_subclass_select', label = 'CPC Subclass', choices = NULL),
                  width = 2
                ),
                mainPanel(
                  DTOutput("table_data")
              )
            )
          )
    )
  )
)
)
