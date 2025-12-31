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

