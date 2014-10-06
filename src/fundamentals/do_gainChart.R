########################################################
## sales distribution by customer ######################

str(receipt)


########################################################
## 1.table preparation  ################################

store_list <- c("s9111081","s6004012","s8904083")

## create subset table(by store)

for (i in 1:length(store_list)){   

  receipt %>%
  filter(store == store_list[i]) %>%
  filter(customer_code != "NA") %>%
  group_by(customer_code,store) %>%
  select(customer_code,store,qty_sales) %>%
  summarise(sales = sum(qty_sales)) %>%
  arrange(desc(sales))  -> tmp

  assign(paste("cstm_data",store_list[i],sep="_"),tmp)
  
}

cstm_data <- list(cstm_data_s6004012,cstm_data_s8904083,cstm_data_s9111081)


## calculate cumulative sales%

for (k in 1:length(store_list)){
  
  cstm_data[[k]]$dist <- cstm_data[[k]]$sales / sum(cstm_data[[k]]$sales)

    for (i in 2:nrow(cstm_data[[k]])){
      cstm_data[[k]]$cum_percent[1] = cstm_data[[k]]$dist[1]
      cstm_data[[k]]$cum_percent[i] =  cstm_data[[k]]$cum_percent[i-1] +  cstm_data[[k]]$dis[i]
      print(cstm_data[[k]]$cum_percent[i])
    }
}

cstm_data

revenue <- rbind(cstm_data[[1]],cstm_data[[2]],cstm_data[[3]])

## dataset preparation end ######################
########################################################################

q0 <- qplot(x=store,data=revenue,geom="bar",fill=I("blue"),ylab="# of customer",
      main="#customer by store in Jan-June,2014",alpha=0.01)

q1  <- qplot(data=cstm_data[[1]],y=cum_percent,xlab="#cust" ,ylab="% in ttl_sales",colour=sales,main="ebts")
q2  <- qplot(data=cstm_data[[2]],y=cum_percent,xlab="#cust" ,ylab="% in ttl_sales",colour=sales,main="ktsk")
q3  <- qplot(data=cstm_data[[3]],y=cum_percent,xlab="#cust" ,ylab="% in ttl_sales",colour=sales,main="sngw")

aes <- scale_colour_gradient(limits=c(0,50000),low="blue", high="red")

multiplot(q0,q1+aes,q2+aes,q3+aes,cols=2)
