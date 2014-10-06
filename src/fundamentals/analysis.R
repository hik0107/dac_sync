########################################
######## Fundamental analysis ##########


str(receipt)

########################################################
## sales distribution by customer ######################

store_list <- c("s9111081","s6004012","s8904083")

## gain chart
receipt %>%
  filter(customer_code != "NA") %>%
  group_by(customer_code) %>%
  select(customer_code,qty_sales) %>%
  summarise(sales = sum(qty_sales)) %>%
  arrange(desc(sales)) -> tmp
   
tmp$dist <- tmp$sales/sum(tmp$sales)

  for (i in 2:nrow(tmp)){
    tmp$cum_percent[1] = tmp$dis[1]
    tmp$cum_percent[i] = tmp$cum_percent[i-1] + tmp$dis[i]
    print(tmp$cum_percent[i])
  }

tmp$cum_percent

revenue <- tmp
plot(seq(1,nrow(revenue),1),revenue$cum_percent*100,
     type="o",xlab="# of customer",ylab="cumulative sales(%)",
     main="Gain Chart of sales by customer : store1 at 2014/01-2014/07")
abline(h=80) ; abline(v = 900)


###########################################################################
## freq and sales plotting

receipt %>%
  filter(customer_code != "NA") %>%
  mutate(unique_prch = paste(yyyymmdd,regi_number,receipt_number,sep="_") ) %>%
  group_by(customer_code) %>%
  select(customer_code,qty_unit,qty_sales,unique_prch,qty_unit) %>%
  summarise(sales=sum(qty_sales),freq=n_distinct(unique_prch),unit=sum(qty_unit)) %>%
  arrange(desc(sales)) -> fm

fm %>%
  mutate(unit_purchase=sales/freq) %>%
  arrange(unit_purchase) -> tmp

print(tmp,n=500)

## paricular customer
cust <- c("c9011181052180000","c9011181032000000")
receipt %>%
  filter(customer_code==cust) %>%
  select(yyyymmdd,customer_code,receipt_number,qty_unit,qty_sales,product) %>%
  arrange(customer_code,yyyymmdd)
  


## KPI
mean(fm$sales) ; mean(fm$freq)
mean(fm$sales/fm$freq)


## Frequency vs Sales (201401-07) plotting
qplot(data=fm,freq,sales,colour=sales/freq,xlim=c(0,100),ylim=c(0,10^5))

#Frew vs Sales (201401-07) plotting : monthly average
qplot(data=fm, freq/7,sales/7,colour=sales/freq,xlim=c(0,15),ylim=c(0,10000))
qplot(data=fm, sales/freq, geom="histogram", binwidth = 100,xlim=c(0,2500))

fm %>%
  arrange(sales)

###########################################################################
## Loyality growth/collapse

ts_sales <- xtabs(data= receipt, qty_sales ~ (customer_code + yyyymm))
ts_sales <- as.data.frame(unclass(ts_sales))


for(i in 1: nrow(ts_sales)){
  ts_sales$total[i] <- sum(ts_sales[i,1:5])
}


ts_sales %>% arrange(desc(total)) ->tmp
head(tmp,200)

lim=c(0,20000)

q <- qplot(ts_sales$"201402", ts_sales$"201406",colour=ts_sales$total,alpha=0.1,
           xlab="purchase amount in 2014.2 (yen)",ylab="in 2014.6 (yen)",
           xlim=lim,ylim=lim)
q +  scale_colour_gradient(limits=c(0,50000),low="blue", high="red")

