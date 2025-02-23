########################################
######    VARIAVEIS E DEFINICOES  ######
########################################

# Local onde o projeto foi salvo no seu computador
project_root_path <- getwd()

# Encoding genérico para renderizações
encoding <- "UTF-8"

########################################
#####          PACOTES            ######
########################################

# Carregar pacotes
source(glue("{project_root_path}/config/libs/install_and_load_packages.R"), encoding = encoding)

########################################
######      AUTHENTICATIONS       ######
########################################

# Fazer conexão com o banco de dados
source(glue("{project_root_path}/config/authentication/authentication.R"), encoding = encoding)

########################################
######     LEITURA DE DADOS       ######
########################################

# update da análise ou usar dados do GCS
update_data <- TRUE

# Leitura dos dados

if(update_data){

  source(glue("{project_root_path}/src/data/loaddata.R"), encoding = encoding)

  message("Você está conectado ao BQ e pronto para usar as tabelas ...")

} else {
  message("Você optou por usar os dados da última vez que você coletou do BQ :) ...")
}

########################################
#####   ANÁLISE EXPLORATÓRIA      ######
########################################

#####
##  JOIN DAS TABELAS E GERAÇÃO DOS DADOS E GRÁFICOS PARA AS ANÁLISES
#####

source(glue("{project_root_path}/src/analysis/analysis.R"), encoding = encoding)

########################################
#####      RELATÓRIOS HTML        ######
########################################

####
## Relatório
####

rmarkdown::render(
  input = glue("{project_root_path}/src/reports/report.Rmd"),
  encoding = encoding, clean = T,
  output_file = glue("{project_root_path}/exports/reports/report.html")
)

####
## Slides
####

rmarkdown::render(
  input = glue("{project_root_path}/src/reports/slides.Rmd"),
  encoding = encoding, clean = T,
  output_file = glue("{project_root_path}/exports/slides/slides.html")
)
