library(tidyverse)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(plotly)
library(bslib)
library(data.table)
library(quanteda)
library(quanteda.textstats)
library(text2vec)
library(rjson)
library(stm)
library(udpipe)
library(DT)

# load("distinct_cpc_codes.Rdata")
# complete_data <- read_csv("complete_data.csv")

complete_data <- read_csv("https://byu.box.com/shared/static/yh52u7d51txmkcmyw13ef6eyixk2igdz.csv")

download.file("https://byu.box.com/shared/static/4tbg1jz4gjin7fatr4e3mcn0a2jo2cai.rdata", "distinct_cpc_codes.Rdata")

load("distinct_cpc_codes.Rdata")
