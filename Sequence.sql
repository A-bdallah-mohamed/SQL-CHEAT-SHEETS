select * from items;

insert into items values (items_seq.nextval,'Espresso', 40);

select * from user_sequences;
alter sequence items_seq 
INCREMENT by 1;

drop sequence items_seq;

create sequence items_seq
start with 1
INCREMENT by 1 
maxvalue 5
nocache 
nocycle;

alter sequence items_seq
INCREMENT by 1;

select items_seq.nextval from dual;
select items_seq.currval from dual;


update items
set item_id = items_seq.nextval;