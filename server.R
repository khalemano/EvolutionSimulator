library(shiny)

#creates a new hillgrid layer
newlayer = function(x=5,y=5,value=0,nrow=20,ncol=20){
  mat=matrix(0,nrow,ncol)
  maxd = sqrt(nrow^2+ncol^2)
  for (i in 1:nrow){
    for (j in 1:ncol){
      dist = sqrt((i-x)^2+(j-y)^2)
      mat[i,j]= value/(dist+1)
    }
  }
  mat
}

addCell = function(x,y,df){
  rbind(df,data.frame(x=x,y=y))
}

double = function(df,mutLvl=33){
  mutLvl=mutLvl/33
  dfnew = data.frame(x=(df$x + round(rnorm(length(df$x),mean=0,sd=mutLvl))),
                     y=(df$y + round(rnorm(length(df$y),mean=0,sd=mutLvl))))
  dfnew = subset(dfnew,x>0 & x<=20 & y>0 & y<=20)
  rbind(df,dfnew)
}

selection = function(df, hillgrid, threshold=10){
  score = hillgrid[cbind(df$x,df$y)]
  ord = order(score,decreasing=TRUE)
  if(length(ord) > threshold){
    ord=ord[1:threshold]
  }
  df[ord,c('x','y')]
}


shinyServer(
  function(input,output,session){
    
    #sets session variables
    v = reactiveValues(hillgrid=matrix(0,20,20),bcelldf=data.frame())
    
    #Reset All
    observe({
      if (input$resetAllButton == 0){
        return()
      }
      isolate({
        v$hillgrid = newlayer(5,5,10)
        v$bcelldf = addCell(10,10,data.frame())
      })
    })    
    
    
    #add hill
    observe({
      input$addHillButton
      isolate({
        v$hillgrid = v$hillgrid + newlayer(input$hillx,input$hilly,10)
      })
    })
    
    
    #clear hills
    observe({
      if (input$clearHillsButton == 0){
        return()
      }
      isolate({
        v$hillgrid = matrix(0,20,20)
      })
    })
    
    #add b cell
    observe({
      input$addBcellButton
      isolate({
        v$bcelldf = addCell(input$cellx,input$celly,v$bcelldf)
      })
    })

    #clear b cells
    observe({
      if (input$clearBcellButton == 0){
        return()
      }
      isolate({
        v$bcelldf = data.frame()
      })
    })
    
    
    
    #proliferation
    observe({
      if (input$prolifButton == 0){
        return()
      }
      isolate({
        v$bcelldf = double(v$bcelldf,input$mutlvl)
      })
    })
    
    #selection
    observe({
      if (input$selectButton == 0){
        return()
      }
      isolate({
        v$bcelldf = selection(v$bcelldf, v$hillgrid, input$threshold)
      })
    })
    
    #Proliferate and Select
    observe({
      if (input$prolifAndSelectButton == 0){
        return()
      }
      isolate({
        v$bcelldf = double(v$bcelldf,input$mutlvl)
        v$bcelldf = selection(v$bcelldf, v$hillgrid, input$threshold)
      })
    }) 
    
    #Plots the grid
    output$grid = renderPlot({
      image(x=1:20,y=1:20,z=v$hillgrid,main="Mutational Space",
            xlab="",ylab="")
      if(nrow(v$bcelldf) != 0){
        df = aggregate(v$bcelldf$x,by=list(v$bcelldf$x,v$bcelldf$y),length)
        text(df[,1],df[,2],df[,3])
      }
    })
    
    
    
  }
)