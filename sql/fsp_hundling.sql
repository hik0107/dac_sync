/*/ 
FSP data hundling
/*/ 



select count(column_no) from info2_raw_fsp_data


select "年月",count("年月") 
 from raw_fsp_data
 group by "年月"
 order by "年月"

/*/ 201307 ~ 201406  /*/ 
/*/ 201307 ~ 201312 : discounting   /*/ 
/*/ 201307 ~ 201312 : points  /*/ 

select "年月",count("年月") 
 from raw_fsp_data
 where "年月" >= 201401
 group by "年月"



 select "店舗",count("店舗") 
 from raw_fsp_data
 group by "店舗"
 order by  count("店舗")  ;

 select "店舗",count("店舗") 
 from raw_fsp_data
where "店舗" = 's9111081'
group by "店舗"
 
/*/ 10 stores exit : # of data varies from 375K to 2.6M /*/


 create table fsp_englishsub as
 (select 
   "年月" as "yyyymm",
  "店舗" as "store",
  "顧客CD" as "customer_code",
  "POS中分類CD" as "category_code",
  "POS中分類名" as "category",
  "セグメントID" as "segment_code",
  "セグメント名" as "segment",
  "本部推奨売価" as "sales_price",
  "特典値" as "tokuten",
  "売価差" as "price_gap",
  "値引額" "discounting",
  "FLG" as "flg",
  "購入FLG" as "purchase_flg",
  "権利適用FLG" as "execute_flg",
  "権利数" as "qty_own",
  "FSP数量" as "qty_fsp",
  "特売数量" as "qty_tokubai",
  "定番数量" as "qty_teiban",
  "月間数量" as "qty_gekkan"
 
 from raw_fsp_data
 )

drop table fsp_englishsub

/*/  where ("年月" >= 201401) AND  ("店舗"='s9111081') ; /*/