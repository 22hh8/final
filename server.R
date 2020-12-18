library(shiny)
library(shinydashboard)
library(tidyverse)
library(data.table)
library(DT)

# 2 tabs: artist and artwork use navbar, 3-4 minute video. Due 12/18. 
shinyServer(function(input,output,session) {
    
    # Input Data
    tate <- read_csv("tate.csv") #re-do 
    
    output$tate <- DT::renderDataTable({
        tate %>% filter(acquisitionYear >= input$date1[1],acquisitionYear <= input$date1[2])
    })
    
    output$gender <- renderPlot({
        tate1 <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2], !is.na(gender)) %>% 
                    distinct(name,gender) %>% group_by(gender)
        tate1$gender <- factor(tate1$gender,levels= c("Female","Male"))
        
        g <- ggplot(tate1, aes(x=gender,fill=gender)) + geom_bar(width=0.3) + xlab("Gender") + ylab("Count") +
                scale_fill_manual(name = "Gender", values = c("Female" = "gold", "Male" = "darkred"), drop =FALSE) + 
                theme_minimal() + scale_y_continuous(limits=c(0,3000)) + scale_x_discrete(drop = FALSE) +
                geom_text(stat='count', aes(label=..count..), vjust=-1)
        return(g)
    })
    
    output$medium <- renderPlot({
        medium <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2], !is.na(medium)) %>% group_by(medium) %>% count() %>% arrange(desc(n)) %>% head(5)
        g <- ggplot(medium, aes(x=reorder(medium,n),y=n)) + 
            geom_bar(stat="identity",width=0.3) + coord_flip() + 
            ylab("Count") + xlab("Medium") + theme_minimal()
        return(g)
    })
    
    #Maybe better represent the plots/Show proprotion rather than count
    output$inscription <- renderPlot({
        tate1 <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2]) %>% group_by(inscription) %>% count()
        tate1$inscription[is.na(tate1$inscription)] <- "Missing"
        tate1$inscription <- factor(tate1$inscription, levels = c("date inscribed","Missing")) 
        tate1 <- tate1 %>% ungroup() %>% mutate(per=round(n/sum(n),digits = 2))
        
        g <- ggplot(tate1, aes(x="",y=n,fill=inscription)) + geom_bar(stat="identity") +
                coord_polar("y", start=0) +
                geom_text(aes(label = per), position = position_stack(vjust = 0.5), size = 3, color= "white") + 
                scale_fill_manual(name = "Inscription", values = c("date inscribed" = "darkblue", "Missing" = "darkgray"), drop = FALSE,
                                  labels= c("Date Inscribed","Missing")) +
                scale_x_discrete(drop = FALSE) + 
                theme_minimal() 
        return(g)
    })
    
    output$year <- renderPlot({
        tate1 <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2]) %>% select(year) %>% 
            mutate(period = case_when(year>=1720 & year <1780 ~ "Rococo/Neoclassicism",
                                      year >= 1780 & year < 1860 ~ "Romanticism",
                                      year >= 1860 & year < 1946 ~ "Modern",
                                      year >= 1946~ "Contemporary")
                   )
        palette1 = c("Rococo/Neoclassicism"= "#F8766D", "Romanticism"="#A3A500", "Modern"="#00BF7D", "Contemporary"="#00B0F6")
        
        g <- ggplot(tate1,aes(x=year,fill=period)) + geom_histogram() + xlab("Year of Artwork Completed") + ylab("Count") + 
                xlim(1700,2013) + 
                scale_fill_manual(values = palette1,name="Periods in Western Art History")
        
        return(g)
    })
    output$artist <- renderValueBox({
        topartist <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2], !is.na(name)) %>% group_by(name) %>% count() %>% arrange(desc(n)) %>% head(1)
        valueBox(
            value = tags$p(topartist[1], style = "font-size: 60%;"),
            "Top Artist", icon = icon("list-ol"),
            color = "purple"
        )
    })
    
    output$count <- renderValueBox({
        topartist <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2], !is.na(name)) %>% group_by(name) %>% count() %>% arrange(desc(n)) %>% head(1)
        valueBox(
            topartist[2], "Number of Artworks by Top Artist", icon = icon("palette"),
            color = "yellow"
        )
    }) 
    
    output$total <- renderValueBox({
        total <- tate %>% filter(acquisitionYear >= input$date[1],acquisitionYear <= input$date[2]) %>% count()
        valueBox(
            total[1], "Total Number of Artworks", icon = icon("paint-brush")
        )
    }) 
    
})