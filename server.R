library(shiny)
library(plotly)
 
    
shinyServer(function(input, output, session) {
        
    map_re = reactive({
        if(is.null(input$checkGroup)){
            map_re = fuels
        }
        else{
            fuels %>% filter(fuel_type_code %in% input$checkGroup)
        }
    })


    fleet_re = reactive({
        vehicles %>% filter(fuel_type_code == input$cartype, model_year >= 1995) %>% 
        group_by(model_year, fuel_type_code) %>%
        count(fuel_type_code)
    })
        
        g <- list(
            scope = 'usa',
            projection = list(type = 'albers usa'),
            showland = TRUE,
            landcolor = toRGB("gray95"),
            subunitcolor = toRGB("gray85"),
            countrycolor = toRGB("gray85"),
            countrywidth = 0.5,
            subunitwidth = 0.5
        )
        output$map = renderPlotly({
            plot_geo(map_re(), lat = ~latitude, lon = ~longitude) %>%
                add_markers(
                    text = ~paste(city, state, fuel_type_code, sep = "<br />"),
                    color = ~fuel_type_code, symbol = I("circle"), size = I(4), hoverinfo = "text"
                ) %>%
                colorbar(title = "Fuel Stations in US") %>%
                layout(
                    title = 'Alternative Fuel Station Locator', geo = g
                )
        })
        # output$FuelType <- renderPrint({input$checkGroup})

        output$hist <- renderPlot({
            fuels %>% group_by(open_year) %>%
                filter(open_year>2009, fuel_type_code == 'ELEC') %>%
                count(na.rm=T, ev_level1_count, ev_level2_count, ev_dc_fast_count) %>%
                gather(key, value, ev_level1_count, ev_level2_count, ev_dc_fast_count, na.rm = T) %>%
                ggplot(aes(x = (open_year), y=value, color = key, label = (open_year)))+
                geom_bar(
                    position = 'dodge', stat = 'identity')+
                ggtitle('Electric Charger Count by Type')+
                scale_color_discrete(name="Charger Type",
                                     labels=c("DC Fast","Lvl 1", "Lvl 2"))+
                xlab('Year')+ylab('Count')
        })
        output$hist1 <- renderPlot({
            fuels %>% group_by(ev_pricing) %>%
                filter(., ev_pricing != '', ) %>%
                count(na.rm=T, ev_level1_count, ev_level2_count, ev_dc_fast_count) %>%
                gather(key, value, ev_level1_count, ev_level2_count, ev_dc_fast_count, na.rm = T) %>%
                ggplot(aes(x = (ev_pricing), y=value, color = key, label = (ev_pricing)))+
                geom_bar(
                    position = 'dodge', stat = 'identity')+
                ggtitle('Electric Charger Type by Cost')+
                scale_color_discrete(name="Charger Type",
                                     labels=c("DC Fast","Lvl 1", "Lvl 2"))+
                xlab('Cost')+ylab('Count')
        })
        output$hist2 <- renderPlot({
            fuels %>% group_by(access_code) %>%
                filter(fuel_type_code == 'ELEC') %>%
                count(na.rm=T, ev_level1_count, ev_level2_count, ev_dc_fast_count) %>%
                gather(key, value, ev_level1_count, ev_level2_count, ev_dc_fast_count, na.rm = T) %>%
                ggplot(aes(x = (access_code), y=value, color = key, label = (access_code)))+
                geom_bar(
                    position = 'dodge', stat = 'identity')+
                ggtitle('Electric Charger Type by Access')+
                scale_color_discrete(name="Charger Type",
                                     labels=c("DC Fast","Lvl 1", "Lvl 2"))+
                xlab('Access')+ylab('Count')
        })
        output$hist3 <- renderPlot({
            fuels %>% group_by(open_year, access_code) %>%
                filter(open_year>2009, fuel_type_code == 'ELEC') %>% 
                count(access_code) %>%
                ggplot(aes(x = open_year, y=n))+
                geom_bar(aes(color=access_code),position = 'dodge', stat = 'identity')+
                ggtitle('Electric Charger Count by Access')+
                xlab('Year')+ylab('Station Count')
        })
        
        output$fleet <- renderPlot({
            ggplot(data = fleet_re(), mapping = aes(x = model_year, y = n)) +
                geom_bar(aes(fill = n), stat = 'identity')+
                ggtitle('Car Count by Fuel Type')+
                xlab('Year')+ylab('Count')
        })
        
        output$table <- DT::renderDataTable({
            datatable(fuels, rownames=FALSE) %>%
                formatStyle(input$selected, background="skyblue", fontWeight='bold')
        })
        output$table1 <- DT::renderDataTable({
            datatable(vehicles, rownames=FALSE) %>%
                formatStyle(input$selected, background="skyblue", fontWeight='bold')
        })
})
