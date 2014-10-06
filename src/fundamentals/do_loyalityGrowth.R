###########################################################################
## Loyality growth/collapse


###########################################################################
## dataset preparation ###################################################
receipt %>%
  filter(customer_code != "NA") %>%
  mutate(unique_prch = paste(yyyymm,store,regi_number,receipt_number,sep="_") ) %>%
  group_by(yyyymm,customer_code,store) %>%
  select(yyyymm,customer_code,store,qty_unit,qty_sales,unique_prch,qty_unit) %>%
  summarise(sales=sum(qty_sales),freq=n_distinct(unique_prch),unit=sum(qty_unit)) %>%
  arrange(desc(sales)) -> fm


### dummy data to avoid NA

receipt %>%
  filter(customer_code != "NA") %>%
  group_by(customer_code,store) %>%
  select(customer_code,store) %>%
  mutate("201401"=0,"201402"=0,"201403"=0,"201404"=0,"201405"=0,"201406"=0) -> tmp

fm_na.fill <- tbl_df( melt(data=tmp,id=c("store","customer_code")) )
fm_na.fill$freq <- 0 ; fm_na.fill$unit <- 0

fm_na.fill %>%
  select(yyyymm=variable,customer_code,store,sales=value,freq,unit) -> fm_na.fill

# combilw with original data
fm <- rbind(fm,fm_na.fill)

fm %>%
  group_by(yyyymm,customer_code,store) %>%
  select(yyyymm,customer_code,store,sales,freq,unit) %>%
  summarise(sales=sum(sales),"freq"=sum(freq),"unit"=sum(unit)) %>%
  arrange(store,customer_code) -> fm


## end ##################################################################



## reshape (cross tabs)
fm_ts <- reshape(data = fm[,1:5], timevar="yyyymm",idvar=c("customer_code","store"),direction="wide")

fm_ts %>%
  select(customer_code,store,
         purchase01=sales.201401,
         purchase02=sales.201402,
         purchase03=sales.201403,
         purchase04=sales.201404,
         purchase05=sales.201405,
         purchase06=sales.201406,
         freq01=freq.201401,
         freq02=freq.201402,
         freq03=freq.201403,
         freq04=freq.201404,
         freq05=freq.201405,
         freq06=freq.201406) %>%
  mutate(purchase_ttl=(purchase01+purchase02+purchase03+purchase04+purchase05+purchase06),
         freq_ttl=freq01+freq02+freq03+freq04+freq05+freq06) %>%
  arrange(store) -> fm_ts

fm_ts



##################visualization ######################

## amount
lim=c(0,20000)
q1 <- qplot(alpha=0.1,xlim=lim,ylim=lim,facets=store~.,size=10,
           data = fm_ts, x=purchase01, y=purchase06, colour=purchase_ttl,
           xlab="purchase amount in 2014.1 (yen)",ylab="purchase amount in 2014.6 (yen)",
           main="monetary comparison : purchase_yen in 2014.01 vs 2014.06")

q1 +  scale_colour_gradient(limits=c(0,50000),low="blue", high="red")


## frequency
lim=c(0,40)
q2 <- qplot(alpha=0.001,xlim=lim,ylim=lim,facets=store~.,
            data = fm_ts, x=freq01, y=freq06, colour=purchase_ttl,size=10,
            xlab="purchase freq in 2014.1 (#)",ylab="purchase freq in 2014.6 (#)")

q2 +  scale_colour_gradient(limits=c(0,100000),low="blue", high="red")


########
fm_ts %>%
  filter(freq01>=30)