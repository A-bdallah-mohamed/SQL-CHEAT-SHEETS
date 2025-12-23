--items (item id - PK, item name, item price)
--
--products (Product id - PK, Product name, Product price)
--
--staff (Employee id - PK, Employee name, Department id - FK, Salary)
--->Departments (Department id - PK, Department name, Department Manager - FK)
--->Attendance (Attendance id - PK, Employee id - FK, Attended - Boolean, Start time, End time, work time)
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

--->Attendance (Attendance id - PK, Employee id - FK, Attended - Boolean, Start time, End time, work time)
CREATE TABLE Attendance(
ATTENDANCE_ID NUMBER,
EMPLOYEE_ID NUMBER,
ATTENDED BOOLEAN,
DAY_DATE DATE,
START_TIME DATE,
END_TIME DATE,
WORK_TIME DATE ,
CONSTRAINT ATTENDANCE_PK PRIMARY KEY (ATTENDANCE_ID),
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
ITEM_ID NUMBER,
ITEM_PRICE NUMBER,
CONSTRAINT ORDER_PK PRIMARY KEY (ORDER_ID),
CONSTRAINT PRODUCT_IN_ORDER_FK FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
CONSTRAINT ITEM_IN_ORDER_FK FOREIGN KEY (ITEM_ID) REFERENCES ITEMS(ITEM_ID)
);

ALTER TABLE RECEITES 
ADD CONSTRAINT RECEITES_ORDER_FK  FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID);


--
--as a shop owner 
--
--1-i want to follow up my staff attendance 
--
--2-i want to know customer visits per day
--
--3-i want to know revenue (revenue is the net from sales minus salary it`s calculated per month)
--
--4-i want to know how much salaries per department
--
--5-i want to know the most gain day per year
--
--6-i want to get the most active hour per week day
--
--7-i want to know the most sold item
--
--8- if salary is bigger than 10k 
--
--9- if item revenue (sales only) is bigger than 5k
--
--10- i want a report of how much each staff sold per item , and the total of the staff revenue and his department and his manager











