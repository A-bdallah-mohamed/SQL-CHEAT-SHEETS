--A view is a virtual copy and a shortcut of a query select 
create view items_view as (select * from items);

select * from items_view;

insert into items_view values (items_seq.nextval,'Ice Coffee',55);

select * from items where item_price = 35;


--"with check option" lets the view only to insert into items with price 35
create view item_35_price as (select * from items where item_price = 35) with check option; 

drop view item_35_price;

select * from item_35_price;

insert into item_35_price values (18,'Lemon Mint', 35);



select invoice_id,to_char(invoice_date,'yyyy-mm-dd HH12:MI AM'),item_id from invoices;

--functions must have alias
create view invoices_dates_view as (select invoice_id,to_char(invoice_date,'yyyy-mm-dd HH12:MI AM') Date_time,item_id from invoices);

rename invoices_dates_seq to invoices_dates_view;


select * from invoices_dates_view;

