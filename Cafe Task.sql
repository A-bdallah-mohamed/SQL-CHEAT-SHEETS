--items (item id - PK, item name, item price)
--
--products (Product id - PK, Product name, Product price)
--
--staff (Employee id - PK, Employee name, Department id - FK, Salary)
--->Departments (Department id - PK, Department name, Department Manager - FK)
--->Attendance ( Employee id - FK, Start time, End time)
--
--customers (Customer id - PK, Customer Name)
--->Recites (Recite id - PK, Customer id - FK, Order id - FK, Employee id - FK)
--->Orders (Order id - Pk, PRODUCT_ID - FK, PRODUCT_PRICE, ITEM_ID - FK, ITEM_PRICE)
--
--items (item id - PK, item name, item price)
CREATE TABLE ITEMS (
ITEM_ID NUMBER,
ITEM_NAME VARCHAR2(200),
ITEM_PRICE NUMBER,
CONSTRAINT ITEMS_PK PRIMARY KEY (ITEM_ID),
CONSTRAINT ITEMS_PRICE_NOT_NULL_FK CHECK (ITEM_PRICE is not NULL)  
);

--products (Product id - PK, Product name, Product price)
CREATE TABLE PRODUCTS (
PRODUCT_ID NUMBER,
PRODUCT_NAME VARCHAR2(200),
PRODUCT_PRICE NUMBER,
CONSTRAINT PRODUCTS_PK PRIMARY KEY (PRODUCT_ID),
CONSTRAINT PRODUCT_PRICE_IS_NOT_NULL CHECK (PRODUCT_PRICE IS NOT NULL)
);

--->Departments (Department id - PK, Department name, Department Manager - FK)
CREATE TABLE DEPARTMENTS ( 
DEPT_ID NUMBER ,
DEPT_NAME VARCHAR2(50),
DEPT_MANAGER NUMBER,
CONSTRAINT DEPARTMEMNT_PK PRIMARY KEY (DEPT_ID));


--staff (Employee id - PK, Employee name, Department id - FK, Salary)
CREATE TABLE STAFF (
EMPLOYEE_ID NUMBER,
EMPLOYEE_NAME VARCHAR2(100),
DEPT_ID NUMBER,
SALARY NUMBER,
CONSTRAINT STAFF_ID PRIMARY KEY (EMPLOYEE_ID),
CONSTRAINT STAFF_DEPT_FK FOREIGN KEY (DEPT_ID) REFERENCES DEPARTMENTS(DEPT_ID)
);

ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT DEPT_MANAGER_FK  FOREIGN KEY (DEPT_MANAGER) REFERENCES STAFF(EMPLOYEE_ID);

--->Attendance ( Employee id - FK, Start time, End time)
CREATE TABLE Attendance(
EMPLOYEE_ID NUMBER,
DAY_DATE DATE,
START_TIME DATE,
END_TIME DATE,
CONSTRAINT EMPLOYEE_ATTANDANCE_FK FOREIGN KEY (EMPLOYEE_ID) REFERENCES STAFF(EMPLOYEE_ID)
);

--customers (Customer id - PK, Customer Name)
CREATE TABLE CUSTOMERS (
CUSTOMER_ID NUMBER ,
CUSTOMER_NAME VARCHAR2(100),
CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTOMER_ID)
);

--->Recites (Recite id - PK, Customer id - FK, Order id - FK, Employee id - FK)
CREATE TABLE RECEITES (
RECEITE_ID NUMBER ,
CUSTOMER_ID NUMBER,
DAY_DATE DATE,
ORDER_ID NUMBER,
SALESMAN NUMBER,
CONSTRAINT RECEITE_PK PRIMARY KEY (RECEITE_ID),
CONSTRAINT CUSTOMER_RECEITE FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID),
CONSTRAINT RECEITE_SALESMAN FOREIGN KEY (SALESMAN) REFERENCES STAFF(EMPLOYEE_ID)
);

--->Orders (Order id - Pk, PRODUCT_ID - FK, PRODUCT_PRICE, ITEM_ID - FK, ITEM_PRICE)
CREATE TABLE ORDERS(
ORDER_ID NUMBER,
PRODUCT_ID NUMBER,
PRODUCT_PRICE NUMBER,
PRODUCT_NAME VARCHAR2(100),
ITEM_ID NUMBER,
ITEM_PRICE NUMBER,
ITEM_NAME VARCHAR2(100),
CONSTRAINT ORDER_PK PRIMARY KEY (ORDER_ID),
CONSTRAINT PRODUCT_IN_ORDER_FK FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
CONSTRAINT ITEM_IN_ORDER_FK FOREIGN KEY (ITEM_ID) REFERENCES ITEMS(ITEM_ID)
);

ALTER TABLE RECEITES 
ADD CONSTRAINT RECEITES_ORDER_FK  FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID);





--as a shop owner 
--
--1-i want to follow up my staff attendance 
--

SELECT  E.EMPLOYEE_NAME,TO_CHAR(A.DAY_DATE,'yyyy-mm-dd') AS "Day",DECODE(A.START_TIME,NULL, 'No','Yes') Attended,
decode(A.START_TIME ,null,'Absent',to_char(A.START_TIME , 'HH12:MI:SS AM')) AS "Start Time",
decode(A.END_TIME,null,'Absent',to_char(A.END_TIME , 'HH12:MI:SS AM')) AS "End Time",
decode     (A.START_TIME,null,'Absent',FLOOR((
(select END_TIME from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE )
- 
(select start_time from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE ))
* 24) || ' Hours ' || floor((((
(select END_TIME from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE )
- 
(select start_time from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE ))
* 24) - FLOOR((
(select END_TIME from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE )
- 
(select start_time from attendance B where B.EMPLOYEE_ID = A.EMPLOYEE_ID and B.DAY_DATE = A.DAY_DATE ))
* 24)) *60)||' Minutes') as "Work Time"
FROM ATTENDANCE A
JOIN STAFF E
ON e.employee_id = a.employee_id
order by A.DAY_DATE;







--WHERE A.EMPLOYEE_ID = 1016 AND A.DAY_DATE = TO_DATE('2025-12-21','YYYY-MM-DD');

--2-i want to know customer visits per day
--

select to_char(DAY_AND_TIME,'YYYY-MM-DD') "Day", COUNT(DISTINCT customer_Id) "Customers" from RECEITES GROUP BY to_char(DAY_AND_TIME,'YYYY-MM-DD');

--3-i want to know revenue (revenue is the net from sales minus salary it`s calculated per month)
--

select to_char(r.DAY_AND_TIME,'yyyy-MM') "Month",
SUM(O.PRODUCT_PRICE) "Products Sales",
SUM(O.ITEM_PRICE) "Items Sales",
(SUM(O.ITEM_PRICE) + SUM(O.PRODUCT_PRICE)) "Sales",
(select sum(salary) from Staff) "Sum Salary",
((SUM(O.ITEM_PRICE) + SUM(O.PRODUCT_PRICE) - (select sum(salary) from Staff))) "Revenue"
from receites r
join orders o
on r.receite_id = o.receite_id
group by to_char(r.DAY_AND_TIME,'yyyy-MM')
order by to_char(r.DAY_AND_TIME,'yyyy-MM');


--4-i want to know how much salaries per department
--

select d.dept_name "Dept Name", sum(s.salary) "Sum Salary" from staff s join departments d on s.dept_id = d.dept_id group by d.dept_name;



--5-i want to know the most gain day per year
--

select distinct to_char(rm.day_and_time,'yyyy') year,


(
select day from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') and subquery.gain in 
(select max(gain) from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') )
) day


,


(
select max(gain) from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') ) gain 




from RECEITES rm
order by year desc;













select distinct to_char(rm.day_and_time,'yyyy') year,


(
select day from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') and subquery.gain in 
(select max(gain) from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') )
) day


,


(
select max(gain) from (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) subquery
where subquery.year = to_char(rm.day_and_time,'yyyy') ) gain 




from RECEITES rm
order by year desc;






select a.year,b.day,a.max_gain_per_day
from (select distinct to_char(rm.day_and_time,'yyyy') year,max(all_gain.gain) max_gain_per_day
from
 RECEITES rm
 left join (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
left JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) all_gain 
on all_gain.year = to_char(rm.day_and_time,'yyyy')
group by to_char(rm.day_and_time,'yyyy')
order by year desc) a 
left join (select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
left JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc) b 
on b.gain = a.max_gain_per_day;





--creating view to make it easier
create view all_days_gain as select distinct to_char(r.DAY_AND_TIME,'yyyy') year ,to_char(r.DAY_AND_TIME,'yyyy-mm-dd') day , nvl((SELECT 
SUM(NVL(O2.PRODUCT_PRICE,0)) + SUM(NVL(O2.ITEM_PRICE,0)) 
FROM ORDERS O2 
join RECEITES r2 
on O2.RECEITE_ID = R2.RECEITE_ID 
WHERE to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(r2.DAY_AND_TIME,'yyyy-mm-dd')
),0) gain
from RECEITES R
left JOIN ORDERS O
ON O.RECEITE_ID = R.RECEITE_ID
group by R.DAY_AND_TIME,O.RECEITE_ID,TO_CHAR(R.DAY_AND_TIME, 'YYYY')
ORDER BY gain desc;



select * from all_days_gain;





select a.year,b.day,a.max_gain_per_day
from (select distinct to_char(rm.day_and_time,'yyyy') year,max(all_gain.gain) max_gain_per_day
from
 RECEITES rm
 left join all_days_gain all_gain 
on all_gain.year = to_char(rm.day_and_time,'yyyy')
group by to_char(rm.day_and_time,'yyyy')
order by year desc) a 
left join all_days_gain b 
on b.gain = a.max_gain_per_day;






--6-i want to get the most active hour per week day
--



select DISTINCT to_char(rr.DAY_AND_TIME,'yyyy-mm-dd') "Day" ,

(select 
to_char(r.DAY_AND_TIME,'HH12 AM') 
from receites r
  where to_char(r.DAY_AND_TIME,'yyyy-mm-dd') = to_char(rr.DAY_AND_TIME,'yyyy-mm-dd') 
  group by 
to_char(r.DAY_AND_TIME,'yyyy-mm-dd'),
to_char(r.DAY_AND_TIME,'HH12 AM')
ORDER BY to_char(r.DAY_AND_TIME,'yyyy-mm-dd'),
count(*) desc 
fetch first 1 row only
 ) "Most Active Hour"
from receites rr
group by 
to_char(rr.DAY_AND_TIME,'yyyy-mm-dd'),rr.DAY_AND_TIME
ORDER BY to_char(rr.DAY_AND_TIME,'yyyy-mm-dd');




--7-i want to know the most sold item
--
--most sold product
select  p.product_name , count(*) from orders o 
left join products p 
on o.product_id = p.product_id
left join items i
on o.item_id = i.item_id
group by p.product_name
order by count(*) desc
 offset 1 rows
 fetch  first row only;

--most sold item
select  i.item_name , count(*) from orders o 
left join products p 
on o.product_id = p.product_id
left join items i
on o.item_id = i.item_id
group by i.item_name
order by count(*) desc
 offset 1 rows
 fetch  first row only;




--8- if salary is bigger than 10k 
--

select employee_name,decode(salary,salary > 10000,'More than 10k','Less than 10k') "Salary" from staff;


--
--9- if product revenue (sales only) is bigger than 5k

select  p.product_name ,case  when sum(nvl(o.product_price,0)) > 5000 then 'More than 5k' else 'less than 5k' end as Sales from orders o 
left join products p 
on o.product_id = p.product_id
where p.product_name is not null
group by p.product_name;



--10- i want a report of how much each staff sold per item , and the total of the staff revenue and his department and his manager


select * from receites;
select e.employee_Name staff,
p.product_name || i.item_name "ITEM/PRODUCT",
count(*) sold,
CASE WHEN SUM(O.PRODUCT_PRICE) IS NOT NULL THEN  SUM(O.PRODUCT_PRICE)
ELSE SUM(O.ITEM_PRICE)
END sales,
(select d.dept_name from departments d where d.dept_id = e.dept_id) department,
(select e2.employee_name from staff e2 join departments d2 on e2.employee_id = d2.dept_manager where d2.dept_id = e.dept_id) manager
from receites r 
right join orders o 
on o.RECEITE_ID = r.RECEITE_ID
join staff e 
on r.SALESMAN = e.employee_id
left join products p 
on o.product_id = p.product_id
left join items i 
on o.item_id = i.item_id
group by e.employee_Name,p.product_name, i.item_name ,e.dept_id
order by e.employee_Name;







--how many employees in each department
select d.dept_name ,count(*) as "Staff"
from staff s
join departments d
on s.dept_id = d.dept_id
group by  d.dept_name;



--each employee with his manager
select e.employee_id,e.employee_name,d.dept_name,
 (select s.employee_name from staff s where s.employee_id = d.dept_manager) as "MANAGER" , e.salary
from staff e
join departments d 
on e.dept_id = d.dept_id
order by d.dept_id;






