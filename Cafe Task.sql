--items (item id - PK, item name, item price)
--
--products (Product id - PK, Product name, Product price)
--
--staff (Employee id - PK, Employee name, Department id - FK, Salary, Sales id - FK)
--->Departments (Department id - PK, Department name, Department Manager - FK)
--->Attendance (Attendance id - PK, Employee id - FK, Attended - Boolean, Day Date - FK, Start time, End time, work time)
--
--customers (Customer id - PK, Customer Name)
--->Recites (Recite id - PK, Customer id - FK, Day date - FK, Order id - FK, Employee id - FK)
--->Orders (Order id - Pk, details id - FK)
--->Order details (details id - PK,product id - FK,PRODUCT_PRICE, Item id - FK, ITEM_PRICE) 
--
--Sales(Sales id - PK, Sales amount, Day Date - FK, Employee_id - FK, SALES_DETAILS - FK)
--->SALES DETAILS(SALES_DETAILS - PK, Product id - FK,PRODUCT_PRICE, Item id - FK, ITEM_PRICE)
--
--Day (Day date - PK, Sales amount, Orders, Customers)


--items (item id - PK, item name, item price)
CREATE TABLE ITEMS (
ITEM_ID INT PRIMARY KEY,
ITEM_NAME VARCHAR2(200),
ITEM_PRICE NUMBER NOT NULL
);


--products (Product id - PK, Product name, Product price)
CREATE TABLE PRODUCTS (
PRODUCT_ID INT PRIMARY KEY,
PRODUCT_NAME VARCHAR2(200),
PRODUCT_PRICE NUMBER NOT NULL
);


--->Departments (Department id - PK, Department name, Department Manager - FK)
CREATE TABLE DEPARTMENTS (
DEPT_ID INT PRIMARY KEY,
DEPT_NAME VARCHAR2(50),
DEPT_MANAGER INT
);


--staff (Employee id - PK, Employee name, Department id - FK, Salary, Sales id - FK)
CREATE TABLE STAFF (
EMPLOYEE_ID INT PRIMARY KEY,
EMPLOYEE_NAME VARCHAR2(100),
DEPT_ID INT REFERENCES DEPARTMENTS(DEPT_ID),
SALARY NUMBER,
SALES_ID NUMBER
);

ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT DEPT_MANAGER_FK  FOREIGN KEY (DEPT_MANAGER) REFERENCES STAFF(EMPLOYEE_ID);

--->Attendance (Attendance id - PK, Employee id - FK, Attended - Boolean, Day Date - FK, Start time, End time, work time)
CREATE TABLE Attendance(
ATTENDANCE_ID INT PRIMARY KEY,
EMPLOYEE_ID INT REFERENCES STAFF(EMPLOYEE_ID),
ATTENDED BOOLEAN,
DAY_DATE DATE,
START_TIME DATE,
END_TIME DATE,
WORK_TIME DATE 
);

--customers (Customer id - PK, Customer Name)
CREATE TABLE CUSTOMERS (
CUSTOMER_ID INT PRIMARY KEY,
CUSTOMER_NAME VARCHAR2(100)
);

--->Recites (Recite id - PK, Customer id - FK, Day date - FK, Order id - FK, Employee id - FK)
CREATE TABLE RECITES (
RECITE_ID INT PRIMARY KEY ,
CUSTOMER_ID INT REFERENCES CUSTOMERS(CUSTOMER_ID),
DAY_DATE DATE,
ORDER_ID INT,
EMPLOYEE_ID INT REFERENCES STAFF(EMPLOYEE_ID)
);

--->Orders (Order id - Pk, details id - FK)
CREATE TABLE ORDERS(
ORDER_ID INT PRIMARY KEY,
DETAILS_ID INT
);

ALTER TABLE RECITES 
ADD CONSTRAINT RECITES_ORDER_FK  FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID);


--->Order details (details id - PK,product id - FK,PRODUCT_PRICE, Item id - FK, ITEM_PRICE) 
CREATE TABLE ORDER_DETAILS(
DETAILS_ID INT PRIMARY KEY,
PRODUCT_ID INT REFERENCES PRODUCTS(PRODUCT_ID),
PRODUCT_PRICE NUMBER,
ITEM_ID INT REFERENCES ITEMS(ITEM_ID),
ITEM_PRICE NUMBER
);


ALTER TABLE ORDERS 
ADD CONSTRAINT ORDER_DETAILS_FK  FOREIGN KEY (DETAILS_ID) REFERENCES ORDER_DETAILS(DETAILS_ID);


--Sales(Sales id - PK, Sales amount, Day Date - FK, Employee_id - FK, SALES_DETAILS - FK)
CREATE TABLE SALES (
SALES_ID INT PRIMARY KEY,
SALES_AMOUNT NUMBER,
DAY_DATE DATE,
EMPLOYEE_ID INT REFERENCES STAFF(EMPLOYEE_ID),
SALES_DETAILS_ID INT
);

--->SALES DETAILS(SALES_DETAILS - PK, Product id - FK,PRODUCT_PRICE, Item id - FK, ITEM_PRICE)
CREATE TABLE SALES_DETAILS (
SALES_DETAILS_ID INT PRIMARY KEY,
PRODUCT_ID INT REFERENCES PRODUCTS(PRODUCT_ID),
PRODUCT_PRICE NUMBER,
ITEM_ID INT REFERENCES ITEMS(ITEM_ID),
ITEM_PRICE NUMBER
);

--Day (Day date - PK, Sales amount, Orders, Customers)
CREATE TABLE DAY_DATE (
DAY_DATE DATE PRIMARY KEY,
SALES_AMOUNT NUMBER,
ORDERS_COUNT INT,
CUSTOMERS_COUNT INT
);

ALTER TABLE ATTENDANCE 
ADD CONSTRAINT ATTENDANCE_DAY_FK  FOREIGN KEY (DAY_DATE) REFERENCES DAY_DATE(DAY_DATE);

ALTER TABLE RECITES 
ADD CONSTRAINT RECITE_DATE_FK  FOREIGN KEY (DAY_DATE) REFERENCES DAY_DATE(DAY_DATE);

ALTER TABLE SALES 
ADD CONSTRAINT SALES_DATE_FK  FOREIGN KEY (DAY_DATE) REFERENCES DAY_DATE(DAY_DATE);


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











