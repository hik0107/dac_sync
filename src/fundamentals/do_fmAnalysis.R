###########################################################################
## dataset preparation

receipt %>%
  filter(customer_code != "NA") %>%
  mutate(unique_prch = paste(yyyymmdd,store,regi_number,receipt_number,sep="_") ) %>%
  group_by(customer_code,store) %>%
  select(customer_code,store,qty_unit,qty_sales,unique_prch,qty_unit) %>%
  summarise(sales=sum(qty_sales),freq=n_distinct(unique_prch),unit=sum(qty_unit)) %>%
  arrange(desc(sales)) -> fm

fm %>%
  mutate(unit_purchase=sales/freq) %>%
  arrange(unit_purchase) 


#######################################################################
## KPIs
fm %>% group_by(store) %>% 
  summarise(total_sales=sum(sales),num_cust=n_distinct(customer_code),
            avg_sales=mean(sales),avg_freq=mean(freq),avg_unitPurchase=mean(sales/freq))-> kpi

kpi
kpi$store <- c("ktsk","sngw","ebts")
kpi$store <- factor(kpi$store,levels=c("sngw","ktsk","ebts"))

windows()
q <- qplot(data=kpi,x=store,stat="identity",fill=store)
q1 <- q + aes(y=num_cust)
q2 <- q + aes(y=total_sales) 
q3 <- q + aes(y=avg_unitPurchase)
q4 <- q + aes(y=avg_freq)

multiplot(q2,q1,q3,q4,cols=2) # caution :: needs function definition


########################################################################
## Frequency vs Sales (201401-06) plotting
windows()
q <- qplot(data=fm,freq/6,sales/6,colour=sales/freq,xlim=c(0,25),ylim=c(0,25000),facets=store~.
           ,main="[freqency vs total_sales] per month (avg of Jan-June.2014)"
           ,xlab="# of purchase per month",ylab="total_purchase(yen) per month",
           size=10,alpha=0.001)

q + scale_colour_gradient(limits=c(0,1500),low="blue", high="red")


#Frew vs Sales (201401-07) plotting : monthly average
qplot(data=fm, sales/freq, geom="histogram", binwidth = 100,xlim=c(0,2500))



########################################################################
## stairing at paricular customers
cust <- c("c9011181052180000","c9011181032000000")
receipt %>%
  filter(customer_code==cust) %>%
  select(yyyymmdd,customer_code,receipt_number,qty_unit,qty_sales,product) %>%
  arrange(customer_code,yyyymmdd)

