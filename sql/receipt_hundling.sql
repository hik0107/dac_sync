/*/
 recipt data /*/


 select count(*) from raw_receipt
/*/# of records ; 18,626,993 /*/

 select substr("システム年月日",1,6),count(*) 
 from raw_receipt
 group by substr("システム年月日",1,6)
 order by substr("システム年月日",1,6)

 /*/+++++++++++++++++++/*/
/*/ try to focus on store 's9111081' /*/
select  "店舗",count(*) 
from raw_receipt
group by  "店舗" ;
/*/ 558,940 records in caes of one focused store /*/

select  "店舗",count(*) 
from raw_receipt
where "店舗" =  's9111081' and substr("システム年月日",1,6) >=201401
group by  "店舗";
/*/ 277,176 records in this compaction /*/





 /*/+++++++++++++++++++/*/
/*/ create table ---------------------- /*/
drop table receipt_englishsub ;

create table receipt_englishsub 
as 
(
select
  "システム年月日" as "yyyymmdd",
  substr("システム年月日",1,6) as "yyyymm",
  "販売時刻" as "time",
  "店舗" as "store",
  "顧客CD" as "customer_code",
  "POS大分類CD" as "category1_code",
  "POS大分類名" as "category1",
  "POS中分類CD" as "category2_code",
  "POS中分類名" as "category2",
  "JANCD"  as "JAN_code",
  "商品名" as "product",
  "規格" as "kikaku",
  "販売売上" as "qty_sales",
  "数量" as "qty_unit",
  "レジ番号" as "regi_number",
  "レシート番号" as "receipt_number",
  "シーケンス番号" as "seq_nmumber",
  "FSP利用フラグ" as "fsp_execute_flag",
  "セグメントID" as "segment"
from raw_receipt
)

/*/ where "店舗" =  's9111081' and substr("システム年月日",1,6) >=201401 /*/
