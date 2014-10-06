#### loading neccesary packages #### 
library(dplyr)
library(ggplot2)
library(RPostgreSQL)
library(reshape2)

install.packages("reshape")
library(reshape)

#### loading neccesary data sets ####
## DB_connection
## postgres 8.2.15 [hikaru.kashida@192.168.99.68:5432/pj020102]  

config <- read.csv("C:/R_dir/DAC/config/config.csv" ,stringsAsFactors=F)
conn   <- src_postgres(dbname = config$db_name,
                       host   = config$host,
                       port   = config$port,
                       user   = config$user,
                       password =config$password)

## Table import
Sys.setlocale("LC_CTYPE", "C")

############################################
### fsp table ##############################
import_tbl1  <- tbl(conn,"fsp_englishsub",fileEncoding="CP932")

import_tbl1 %>%
  filter(yyyymm >= 201400) %>% 
  arrange(yyyymm) %>%
  filter(store %in% c("s9111081","s6004012","s8904083")) ->q # tokyox2 and hokkaido   
         
collect(q) -> dat
str(dat)

dat$category <- iconv(dat$category,from="utf-8",to="cp932")
dat$segment  <- iconv(dat$segment,from="utf-8",to="cp932")
dat$flg      <- iconv(dat$flg,from="utf-8",to="cp932")

##
write.csv(dat,"C:/R_dir/DAC/src/fundamentals/fsp_sample.csv")
fsp <- read.csv("C:/R_dir/DAC/src/fundamentals/fsp_sample.csv")
fsp <- tbl_df(fsp)


############################################
### receipt table ##########################

import_tbl2  <- tbl(conn,"receipt_englishsub")

import_tbl2 %>%
  filter(yyyymm >= 201400) %>%
  filter(store %in% c("s9111081","s6004012","s8904083")) ->q # tokyox2 and hokkaido   

collect(q) -> dat
str(dat)

dat$category1  <- iconv(dat$category1,from="utf-8",to="cp932")
dat$category2  <- iconv(dat$category2,from="utf-8",to="cp932")
dat$product    <- iconv(dat$product,from="utf-8",to="cp932")

##

write.csv(dat,"C:/R_dir/DAC/src/fundamentals/receipt_sample.csv")
receipt <- read.csv("C:/R_dir/DAC/src/fundamentals/receipt_sample.csv")
receipt <- tbl_df(receipt)
str(receipt)
