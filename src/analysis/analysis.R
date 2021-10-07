########################################
######      LAZY QUERIES          ######
########################################

# Descreve as queries que o BQ de cada projeto deve executar. O objetivo é fazer
# com que a maior quantidade de dados seja processada no BQ. Para tanto,
#  1. define as lazy queries que serão executadas no BQ
#  2. coleta apenas os resultados das agregações
#  3. cria as visualizações de interesse usando apenas os dados coletados
#  4. salva em um arquivo os dados necessários para o relatório ou apresentação

#####
##  QUERIES VARIÁVEIS
#####

# Variáveis que serão aplicadas nas queries
destinos <- c("IAH", "HOU")

#####
##  LAZY QUERIES
#####

# Lista que "armazenará" as lazy queries e outra que armazena os resultados
lazy_queries <- list()
results <- list()

lazy_queries$mean_delay_month <- all_tables_bq$flights %>%
    dplyr::left_join(all_tables_bq$airports, by = c("dest" = "faa")) %>%
    dplyr::group_by(year, month) %>%
    dplyr::summarise(mean_delay = mean(dep_delay, na.rm = TRUE), .groups = "drop") %>%
    dplyr::collect()

#####
##  ANÁLISE 1: Atraso dos voos
#####


# Gráfico
results$charts$mean_delay_month <- highcharter::hchart(lazy_queries$mean_delay_month, "column", hcaes(y = mean_delay, x = month)) %>%
  highcharter::hc_xAxis(title = list(text = 'Meses (2013)')) %>%
  highcharter::hc_yAxis(title = list(text = 'Média de Atraso na Saída')) %>%
  highcharter::hc_plotOptions(column = list(stacking = c("normal"))) %>%
  highcharter::hc_chart(zoomType = "xy") %>%
  highcharter::hc_colors("#f90083") %>%
  highcharter::hc_size(height = 450) %>%
  highcharter::hc_title(text = "Média de Atraso na Saída por Mês no ano de 2013") %>%
  highcharter::hc_tooltip(formatter = JS( "function()
               {return 'Média Atraso: ' + this.y.toFixed(2) + '</b><br/>' +
                'Mês: ' + this.point.x + '</b><br/>' ;}"))


# Para ampliar a análise, podemos criar uma tabela que mostre, por mês, a média de atraso por cia aerea.
results$tbl$mean_delay_month <- lazy_queries$mean_delay_month %>%
  reactable::reactable(filterable = TRUE)

#####
##  ANÁLISE 2:
#####


#####
##  SALVAR GRÁFICOS E TABELAS
#####
saveRDS(results, glue("{getwd()}/exports/rds-results/dfs.rds"), compress = FALSE)
