   -- logging lines
   begin 
   dbms_output.put_line('this is an anonymus block');
   end;
   
   -- declaring then logging
   declare 
   x number default 5 ;
   y number := 15;
   z varchar2(100) := 'Abdallah';  
   begin 
    dbms_output.put_line(x);
    dbms_output.put_line(y);
    dbms_output.put_line(x+y);
    dbms_output.put_line(z);
    dbms_output.put_line(x || y || z);
    end;
    
    
   -- nested blocks
    declare 
    const_1 number := 2;
    const_2 number := 18;
    const_3 varchar2(100) := 'Abdallah';
    begin
            declare 
            const_4 number := 2;
            const_5 varchar2(100) :='Mohamed' ;
            begin 
            dbms_output.put_line(const_1);
            dbms_output.put_line(const_2);
            dbms_output.put_line(const_3);
            dbms_output.put_line(const_1 + const_2);
            dbms_output.put_line(const_1 + const_2 + const_4);
            dbms_output.put_line(const_3 || ' ' || const_5);
            end;
    dbms_output.put_line(const_1 + const_2 + 2);
    end;
    
    
    
   -- if inner block has variable nammed same as a variable in outer block
   -- in the inner block it prio the variable in its block
   <<Outer>>
   declare 
   a number := 1;
   b number := 2;
   begin 
           declare 
           a number :=  3;
           b number :=  4;
           begin 
           dbms_output.put_line(a || ' ' || b);
           dbms_output.put_line(a || ' ' || outer.b);
           dbms_output.put_line(outer.a|| ' ' ||b);
           dbms_output.put_line(outer.a || ' ' || outer.b);
           dbms_output.put_line(outer.a + a);
           end;
   end;
 <<Outer>>



-- REFERENCE THE DATA TYPE OF A COLUMN THROUGH "TABLE.COLUMN%TYPE"
DECLARE
PL_ITEM_NAME ITEMS.ITEM_NAME%TYPE;
PL_ITEM_NEW_NAME ITEMS.ITEM_NAME%TYPE;
BEGIN 
SELECT ITEM_NAME
INTO PL_ITEM_NAME
FROM ITEMS
WHERE ITEM_ID = 391;
PL_ITEM_NEW_NAME := PL_ITEM_NAME || 'New'; 
DBMS_OUTPUT.PUT_LINE(PL_ITEM_NAME || ' ' ||PL_ITEM_NEW_NAME);
END;


-- INSERTING IN AN ANONYMOUS BLOCK
DECLARE
PL_ITEM_ID ITEMS.ITEM_ID%TYPE := 393;
PL_ITEM_NAME ITEMS.ITEM_NAME%TYPE := 'Ice Coffee';
PL_ITEM_PRICE ITEMS.ITEM_PRICE%TYPE := '65' ;
begin 
insert into items values (PL_ITEM_ID,PL_ITEM_NAME,PL_ITEM_PRICE);
DBMS_OUTPUT.PUT_LINE('New item been inserted : ITEM_ID : ' || PL_ITEM_ID || ' ITEM_NAME : ' || PL_ITEM_NAME || ' ITEM_PRICE : ' || PL_ITEM_PRICE );

end;

select * from items;

commit;