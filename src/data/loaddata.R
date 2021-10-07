########################################
######         LOAD DATA          ######
########################################

# Descreve os projetos, datasets e respectivas tabelas do BQ que serão usadas. 
# Ponto importante: os dados não são coletados (download) para o R, mas é criada
# uma conexão com o BQ. 

# Define os projetos do BQ que serão usados, bem como os respectivos conjuntos de dados e tabelas de cada projeto. 
bq_infos <- list(
  google_projects = c("data-analytics-learn-317523"),
  dl_datasets = c("ny_flights"),
  dl_tables_flights = c("airlines", "airports", "flights", "planes")
)

# Cria o path completo de cada tabela de interesse (por exemplo, "tembici-datalake-prod.pbsc.bike_states")
table_list <- c(
  apply(tidyr::expand_grid(bq_infos$google_projects[1], bq_infos$dl_datasets[1], bq_infos$dl_tables_flights), 1, function(x) paste0(x, collapse = "."))
)

##### 
##  LOAD DATA (LAZY QUERY)
#####

# Lazy queries: todas as tabelas que serão usadas posteriormente no estudo. 
all_tables_bq <- lapply(1:length(table_list), function (i) {
  dplyr::tbl(con_bq_sb, table_list[i])
}) %>% setNames(c(bq_infos$dl_tables_flights))


