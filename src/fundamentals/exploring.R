
## seeing the number of customer/purchase
receipt %>%
  summarise(n_distinct(customer_code),
            n_distinct(receipt_number))
# num of unique customer is 3930, 9998


receipt %>%
  filter(customer_code != "NA") %>%
  select(regi_number,yyyymmdd,customer_code,receipt_number) %>%
  group_by(regi_number,yyyymmdd) %>%
  summarise(n_distinct(customer_code),
            n_distinct(receipt_number)) %>%
  arrange(yyyymmdd) -> tmp


## duplicate customers purchases in same day??
receipt %>%
  filter(yyyymmdd==20140201) %>%
  select(regi_number,yyyymmdd,customer_code,receipt_number) %>%
  group_by(regi_number,customer_code) %>%
  summarise(cust_num = n_distinct(customer_code),
            purc_num = n_distinct(receipt_number)) %>%
  filter(purc_num >=2)

receipt %>%  
  filter(customer_code=="c9011181001020000",
         yyyymmdd==20140201) %>%
  select(time,receipt_number,regi_number,product,qty_unit)