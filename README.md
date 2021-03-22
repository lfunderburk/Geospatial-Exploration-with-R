## Exploring Vancouver Open Data with R

By: Laura Gutierrez Funderburk

This code is inspired by Aetaka Shashank's instructional material https://aticup.github.io/webmapr/

This repository contains information licensed under the Open Government Licence – Vancouver. See https://opendata.vancouver.ca/pages/licence/ for details. 

Datasets used: 

Public Art https://opendata.vancouver.ca/explore/dataset/public-art/information/?rows=50&refine.status=In+place&location=13,49.28936,-123.05022

Local area boundary https://opendata.vancouver.ca/explore/dataset/local-area-boundary/information/?location=13,49.2474,-123.12402 


### R packages required

    install.packages("leaflet") # version 2.0.4.1
    install.packages("magittr # version 2.0.1
    install.packages("tidyverse") # 1.3.0
    install.packages("sf") # 0.9-8
    install.packages("maps")
    install.packages("jsonlite") # 1.7.2
    install.packages("tidyjson") # 0.3.1
