library(shiny)
shinyUI(
  pageWithSidebar(
    headerPanel("Evolution Simulator"),
    sidebarPanel(
      h2('Basic Controls'),
      p('Press the "Expand and Select" button repeatedly and watch
        the graph to the right.'),
      actionButton('prolifAndSelectButton','Expand and Select'),
      actionButton('resetAllButton','Reset'),
      br(),br(),
      
      h2('Advanced'),
      p('The controls below allow finer control of the simulation,
        such as the mutation rate of the organisms and how many orgnaisms are selected.
        Organisms and favorable genetic states (FGS) can be added as well.'),
            
      h3('Evolution Controls'),
      numericInput('mutlvl','Mutation Rate (1-100)',20,min=1,max=100,step=1),      
      numericInput('threshold','Number to Select (1-50)',10,min=1,max=50,step=1),       
      actionButton('prolifButton','Expand'),
      actionButton('selectButton','Select'),
      br(),br(),

      h3('Organism Controls'),
      numericInput('cellx','X-coordinate (1-20)',10,min=1,max=20,step=1),
      numericInput('celly','Y-coordinate (1-20)',10,min=1,max=20,step=1),
      actionButton('addBcellButton','Add Organism'),
      actionButton('clearBcellButton','Clear All Organisms'),
      br(),br(),      
      
      h3('FGS Controls'),
      numericInput('hillx','X-coordinate (1-20)',5,min=1,max=20,step=1),
      numericInput('hilly','Y-coordinate (1-20)',5,min=1,max=20,step=1),
      actionButton('addHillButton','Add FGS'),
      actionButton('clearHillsButton','Clear All FGSs')
    ),
    mainPanel(
      p('This application simulates evolution. Numbers on the graph represent organisms.
        The white square on the graph is a target.
        For a basic look at the simulator, use the basic controls to the left.'),
      plotOutput('grid'),
       p('This grid represents mutational space.
        Numbers on the grid represent the number of organisms at that location.
        Organisms at the same location are genetically identical, 
        while organisms at different locations are genetically distinct.
        The "Expand" button causes the organisms to generate offspring.
        The offspring can be mutated compared to the parent organism and therefore may
        occupy a different location on the grid.
        White squares on the grid represent favorable genetic states (FGS).
        The "Select" button selects the organisms closest to a favorable genetic state.')
    )
  ))