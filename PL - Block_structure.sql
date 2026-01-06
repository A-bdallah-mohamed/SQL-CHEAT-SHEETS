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


--basic record
    declare 
    type  var is record (
        emp_id newtable.EMPID%TYPE ,emp_name newtable.EMPN%TYPE
    );
     v_rcrd var;
     begin 
        select empid , empn into v_rcrd from newtable;
        DBMS_OUTPUT.put_line('id : '||v_rcrd.emp_id || ' , name : ' ||v_rcrd.emp_name );
        end;

--copying whole table in record (table_name%rowtype)
DECLARE
    var_newtable newtable%rowtype;
    begin 
        var_newtable.empid := 25;
        var_newtable.empn := 'abdallah mohamed';

        update newtable 
        set row = var_newtable;
        end;

--array index 
declare 
type no_index is table of varchar2(100)
index by pls_integer;
 var no_index;
 begin 
    var(0) := 'abdallah';
    var(4) := 'mohamed';
    var(9) := 'ahmed';

    dbms_output.put_line(var(0));
    dbms_output.put_line(var(0));
    dbms_output.put_line(var(0));
    end;

    --manipulation of rows in the array
declare 
type no_index is table of varchar2(100) index by pls_integer;
var_total number;
 var no_index;
 begin 
    var(0) := 'abdallah';
    var(4) := 'mohamed';
    var(9) := 'ahmed';
    var(7) := 'mahmoud';
for i in 0..10
loop 
    if var.exists(i) then 
    DBMS_OUTPUT.put_line('item with index '|| i || ' exist with name '|| var(i));
    else 
    DBMS_OUTPUT.put_line('item with index '|| i || ' doesnt exist');
end if;
end loop;
var_total := var.count;
    dbms_output.put_line(var_total|| ' items in the array');
        dbms_output.put_line(var.first|| ' is the first item in the array');
        dbms_output.put_line(var.next(0)|| ' is the second item in the array');
        dbms_output.put_line(var.last|| ' is the last item in the array');
    end;

-- array without inserting index (automatically 1,2,3,4,....)
declare 
type vir_table is table of varchar2(100);
var vir_table ;
begin 
    var:=vir_table('abdallah','mohamed','ahmed','mahmoud');
dbms_output.put_line(var(3));
dbms_output.put_line(var(1));
dbms_output.put_line(var(2));
end;

-- nested tables 
-- create the nested table 
create or replace type t_owners as table of owners varchar2(100);


--create main table and store the nested table data type as the nested table then store as "name you want to reference with"
create table newtable (
    table_id number,
    table_name varchar2(100),
    owners t_owners
)
nested table owners store as t_t_owners;

--insert into table with nested values inside nested table
insert into newtable values (100,'first table',t_owners('abdallah','mohamed','samy'));
insert into newtable values (101,'second table',t_owners('ahmed','maged','khaled'));
insert into newtable values (102,'third table',t_owners('yousef','saif','abdo'));

--will display
--100	, first table	, ["abdallah","mohamed","samy"]
select * from newtable;

--using the nested table inn query 
SELECT table_name,column_value AS owner
FROM newtable t,
     TABLE(t.owners)
     where column_value = 'ahmed'; 


-- BASIC CURSOR
DECLARE
CURSOR V_VAR_CURSOR IS 
SELECT TABLE_ID,TABLE_NAME FROM NEWTABLE WHERE TABLE_ID IN (100,101);
V_ID NEWTABLE.TABLE_ID%TYPE;
V_NAME NEWTABLE.TABLE_NAME%TYPE;
BEGIN 
    OPEN V_VAR_CURSOR;
    LOOP 
        FETCH V_VAR_CURSOR INTO V_ID,V_NAME;
        EXIT WHEN V_VAR_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_ID|| ' , '||V_NAME);
        END LOOP;
    CLOSE V_VAR_CURSOR;
END;

--CURSOR IN ROWTYPE (SHOULD CHOOSE ALL COLUMNS IN THE SELECT STATEMENT INSIDE THE CURSOR)
DECLARE
CURSOR V_VAR_CURSOR IS 
SELECT * FROM NEWTABLE;
V_TABLENAMES NEWTABLE%ROWTYPE;
BEGIN 
    OPEN V_VAR_CURSOR;
    LOOP 
        FETCH V_VAR_CURSOR INTO V_TABLENAMES;
        EXIT WHEN V_VAR_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_TABLENAMES.TABLE_ID|| ' , '||V_TABLENAMES.TABLE_NAME);
        END LOOP;
    CLOSE V_VAR_CURSOR;
END;

-- CURSOR WITH VARIABLE AS CURSOR DATATYPE 
DECLARE
CURSOR V_CURSOR IS 
SELECT TABLE_ID,TABLE_NAME FROM NEWTABLE;

V_TABLE V_CURSOR%ROWTYPE;

BEGIN 
    OPEN V_CURSOR ;
    LOOP 
        FETCH V_CURSOR INTO V_TABLE;
        EXIT WHEN V_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_TABLE.TABLE_ID || ' ' ||V_TABLE.TABLE_NAME );
        END LOOP;
        CLOSE V_CURSOR;
        END;



-- FOR LOOP IN A CURSOR 
--(NO OPEN, NO FETCH, NO CLOSE)
-- i CONTAINS ALL CURSOR SELECT QUERY RESULT COLUMNS
DECLARE 
CURSOR V_CURSOR IS 
SELECT TABLE_NAME FROM NEWTABLE;

BEGIN 
    FOR I IN V_CURSOR 
    LOOP 
        DBMS_OUTPUT.PUT_LINE( I.TABLE_NAME);
        END LOOP;
        END;


-- using the select ttatement inside the for loop 
declare 
begin 
    for i in (SELECT TABLE_NAME FROM NEWTABLE)
    loop 
        dbms_output.put_line(i.table_name);
    end loop;
end;


-- cursor with parametars 
declare 
cursor v_curs(id number) is 
select table_name from newtable where table_id = id;
begin 
    for i in v_curs(102)
    LOOP
        dbms_output.put_line(i.table_name);
    end loop;
end;

--handling exeptions 

declare 
var_name varchar2(100);
begin 
    for i in 95..105
    loop 
        begin
        select table_name into var_name  from newtable where table_id = i;
        dbms_output.put_line(i|| ' ' ||var_name);
        exception 
        when too_many_rows then 
                dbms_output.put_line(i|| ' more than one row for this id');
   
        when no_data_found then 
                dbms_output.put_line(i || ' no data found for this id');
end;
          end loop;
    end;


--loggin sql output in the dbms
declare 
v_table_id number := 104;
v_table_name newtable.table_name%type := 'table six';
begin 
    insert into newtable values (v_table_id,v_table_name,null);
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);
end;

 --CREATING PROCEDURE STRUCTURE
CREATE OR REPLACE PROCEDURE CHANGE_SALARY
(
    E_ID IN NUMBER, 
    SALARY_INC IN NUMBER
) IS
BEGIN 
    UPDATE EMPLOYEES 
    SET EMP_SALARY = EMP_SALARY + SALARY_INC
    WHERE EMP_ID = E_ID;
    COMMIT;
    END;

--EXECUTE THE PROCEDURE
EXECUTE CHANGE_SALARY(1008,2500);

--EXECUTING PROCEDURE WITH INPUT VARIABLE
EXECUTE CHANGE_SALARY(1009,&AMOUNT);

--DROPPING PROCEDURE 
DROP PROCEDURE CHANGE_SALARY;
   

--PROCEDURE OUT PARAMETERS
CREATE OR REPLACE PROCEDURE GET_FIRST_NAME (
e_id in employees.emp_id%type,
firstname out employees.first_name%type
)
is
begin 
    select first_name into firstname from employees where emp_id = e_id;
    end;

--then use this procedure in an anonymous block
    declare
    f_n employees.first_name%type;
    begin 
         GET_FIRST_NAME(1010,f_n);
         dbms_output.put_line(f_n);
         end;


--PROCEDURE IN OUT PARAMETERS
CREATE OR REPLACE PROCEDURE SET_PHONE
(
    P_NUM IN OUT varchar2
)
IS 
BEGIN 
    P_NUM := '+20' || P_NUM;
    END SET_PHONE;

DECLARE
phone varchar2(100)  := 01023711156;
phoneoutput employees.phone_number%type;
begin 
    SET_PHONE(phone);
    update employees 
    set phone_number = phone
    where emp_id = 1008;

    select phone_number into phoneoutput from employees where emp_id = 1008;
    dbms_output.put_line(phoneoutput);
end;

--substitution variable IN PL BLOCK
DECLARE
phone employees.phone_number%type := &num;
phoneoutput employees.phone_number%type;
begin 
    SET_PHONE(phone);
    update employees 
    set phone_number = phone
    where emp_id = 1007;

    select phone_number into phoneoutput from employees where emp_id = 1007;
    dbms_output.put_line(phoneoutput);
end;

  

  --PASSING PARAMETERS USING A PROSEDURE 
  CREATE PROCEDURE ADD_STAFF(
    ID IN EMPLOYEES.EMP_ID%TYPE,
    SALARY IN EMPLOYEES.EMP_SALARY%TYPE,
    NAME EMPLOYEES.FIRST_NAME%TYPE,
    P_N EMPLOYEES.PHONE_NUMBER%TYPE
  )
  IS 
  BEGIN 
    INSERT INTO EMPLOYEES VALUES (ID,SALARY,NAME,P_N);
    END;


--PASSING PARAMETERS IIN PROCEDURE POSITIONALLY
DECLARE
PHONE VARCHAR2(100):= 01025644897;
BEGIN
    SET_PHONE(PHONE);
    ADD_STAFF(1013,9000,'KHALED',PHONE);
END;

--it will give error if parameters are not enough (missing parameters will work if they have default values in the procedure)
DECLARE
PHONE VARCHAR2(100):= 01123564897;
BEGIN
    SET_PHONE(PHONE);
    ADD_STAFF(1014,10000,'FADY',PHONE);
END;

-- nammed parameter calling (doesnt have to be in order)
DECLARE
PHONE VARCHAR2(100):= 01123564897;
BEGIN
    SET_PHONE(PHONE);
    ADD_STAFF( salary => 14500,name =>'FADY',P_N => PHONE,id => 1015);
END;


--EXCEPTIONS HANDELING
--DIVIDE BY ZERO 
DECLARE 
RESULT NUMBER;
BEGIN 
    RESULT := 1 / 0;
    EXCEPTION 
    WHEN ZERO_DIVIDE THEN 
    DBMS_OUTPUT.PUT_LINE('CANNOT DIVIDE BY ZERO');
    END;

--NO DATA FOUND 
DECLARE 
DEPT_ID NUMBER := 120;
NAME HR.EMPLOYEES.LAST_NAME%TYPE;
BEGIN 
SELECT LAST_NAME INTO NAME FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = DEPT_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN 
DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END;



--TOO MANY DATA FOUND 
DECLARE 
DEPT_ID NUMBER := 50;
NAME HR.EMPLOYEES.LAST_NAME%TYPE;
BEGIN 
SELECT LAST_NAME INTO NAME FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = DEPT_ID;
EXCEPTION
WHEN TOO_MANY_ROWS  THEN 
DBMS_OUTPUT.PUT_LINE('TOO MANY DATA');
END;

--DATA TYPE ERRORS 
DECLARE 
VAR NUMBER;
BEGIN 
    VAR := 17;
    dbms_output.put_line(VAR);

    exception 
    when value_error 
    then 
        dbms_output.put_line('invalid data type');
end;


--similar value in a unique column (id 1016 already exists)
declare 
id number := 1016;
begin 
    insert into employees values (id,7000,'nour',null);
    exception 
    when 
    dup_val_on_index then 
    dbms_output.put_line('invalid data insert');
    end;


-- any other error 
declare 
id number := 1016;
begin 
    insert into employees values (id,7000,'nour',null);
    exception 
    when 
    others then 
    dbms_output.put_line('unknown error');
      dbms_output.put_line(sqlerrm);
    end;
 
 
--FUNCTIONS 
--CREATING A FUNCTION
CREATE OR REPLACE  FUNCTION display_sal 
(f_id number)
return number
is 
fn_sal number;
begin 
    select emp_salary into fn_sal from employees where emp_Id = f_id;
    return fn_sal ;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    RETURN -1;
    end;


--USE FUNCTION IN AN EXPRESSION
    declare 
    v_sal number;
    begin 
        v_sal := display_sal(1015);
        dbms_output.put_line(v_sal);
        end;

--USE FUNCTION AS PARAMETER
   begin 
        dbms_output.put_line(display_sal(1015));
        end;

--EXECUTE FUNCTION ONE LINE
EXECUTE DBMS_OUTPUT.PUT_LINE(display_sal(1015));

--AS PART OF A SELECT 
SELECT display_sal(1015) FROM DUAL;


SELECT EMP_ID,FIRST_NAME ,display_sal(EMP_ID) FROM EMPLOYEES WHERE EMP_ID = 1015;



--CANT USE A FUNCTION WITH A DML STATEMENT ON A TABLE INSIDE A DML STATEMENT ON THE SAME TABLE (mutating)
UPDATE employees
SET EMP_SALARY = display_sal(EMP_iD) - 2000
WHERE EMP_ID = 1016;



--OBJECT SETTINGS
SELECT * FROM USER_OBJECTS WHERE OBJECT_NAME ='DISPLAY_SAL';


--RETURN EVERY LINE OF CODE IN THE FUNCTION
SELECT LINE, TEXT FROM U SER_SOURCE WHERE NAME = 'DISPLAY_SAL'; 

--DISPLAYING THE EXCEPTION 
SELECT display_sal(9999) FROM DUAL;


--USING FUNCTION 
CREATE OR REPLACE FUNCTION INCREASE_SALARY 
(
    F_SAL NUMBER
)
RETURN varchar2 
IS 
BEGIN 
    IF F_SAL <=5000 THEN 
    RETURN F_SAL + 1000 || '  (1000)';
    ELSIF F_SAL > 5000 AND F_SAL <= 10000 THEN 
    RETURN F_SAL + 1500 || '  (1500)';
    ELSE 
    RETURN F_SAL + 2000 || '  (2000)';
    END IF;
    END;

    SELECT EMP_ID, FIRST_NAME, EMP_SALARY, INCREASE_SALARY(EMP_SALARY) AS "SALARY (TAX)" FROM EMPLOYEES;


--"PACKAGE" IS A GROUP OF REALTED FUNCTIONS, PROCEDURES AND OTHER OBJECTS
--FIRST WE CREATE THE PACKAGE STRUCTURE 
CREATE OR REPLACE PACKAGE maths
is 
function sum(num1 number, num2 number) return number;
function miinus(num1 number, num2 number) return number;
function multiply(num1 number, num2 number) return number;
function divide(num1 number, num2 number) return number;
end;

--then we create the package body
create or replace package body maths 
is 

--function 1
function sum(num1 number, num2 number)
return number 
is 
begin 
    return num1 + num2 ;
    end;

--function 2
    function miinus(num1 number, num2 number)
return number 
is 
begin 
    return num1 - num2 ;
    end;

--function 3
    function multiply(num1 number, num2 number)
return number 
is 
begin 
    return num1 * num2 ;
    end;

--function 4
    function divide(num1 number, num2 number)
return number 
is 
begin 
    return num1 / num2 ;
    end;
end;

--then call functions from inside the package
select maths.sum(3,7) from dual;
select maths.miinus(7,2) from dual;
select maths.multiply(5,4) from dual;
select maths.divide(100,5) from dual;

  
  

--package initialization section runs first before calling any object inside the package 
create or replace package test 
is
procedure hello;
end;

create or replace package body test 
is 

--defining the procedure 
procedure hello 
is 
begin dbms_output.put_line('procedure body');
end;

--package initialization section
begin 
    dbms_output.put_line('package body');
    end;

execute test.hello;


--if you have a package with two procedures same name same number of parameters same data types for parameters it will run an error (conflicts with this use) 
create or replace package double 
is 
procedure proc_1(v_1 number,v_2 varchar2);
procedure proc_1(v_1 number,v_2 varchar2);
end;



--when you call other object from inside an object in a package it should be above it 
--this is called forward declaration
--for example 
create or replace package package_2
is
procedure display_salary_in_dollars(id number);
end;



create or replace package body package_2 
is 

dollar_price number := 47;

function  get_salary_in_dollars(
    Original_sal number
)
return number
is
begin 
    return
Original_sal / dollar_price;
end;


procedure DISPLAY_SALARY_IN_DOLLARS 
(
   id number
)
is

--its better to have these variables as out parameters instead if you gonna use them else where
sal  number;
sal_dollar  number;

begin 
    select emp_salary into sal from employees where emp_id = id;
sal_dollar:= get_salary_in_dollars(sal);
dbms_output.put_line(sal_dollar);
end; 
end;


execute package_2.display_salary_in_dollars(1007);


--using a cursor inside a package
