/*Example Test*/


CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    dept_name VARCHAR2(30),
    hire_date DATE,
    salary NUMBER
);

-- ??????? ?? ????????
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    category VARCHAR2(30),
    product_name VARCHAR2(50),
    price NUMBER
);

-- ??????? ?? ????????
CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    emp_id NUMBER REFERENCES employees(emp_id),
    product_id NUMBER REFERENCES products(product_id),
    sale_date DATE,
    quantity NUMBER
);

INSERT INTO employees VALUES (1, 'Ivan Petrov', 'Sales', TO_DATE('2012-04-10', 'YYYY-MM-DD'), 1500);
INSERT INTO employees VALUES (2, 'Maria Georgieva', 'Sales', TO_DATE('2018-09-01', 'YYYY-MM-DD'), 1800);
INSERT INTO employees VALUES (3, 'Georgi Kolev', 'IT', TO_DATE('2015-06-15', 'YYYY-MM-DD'), 2200);
INSERT INTO employees VALUES (4, 'Nikolay Dimitrov', 'IT', TO_DATE('2017-11-20', 'YYYY-MM-DD'), 2100);
INSERT INTO employees VALUES (5, 'Elena Stoyanova', 'HR', TO_DATE('2020-01-05', 'YYYY-MM-DD'), 1600);
INSERT INTO employees VALUES (6, 'Stefan Ivanov', 'Sales', TO_DATE('2022-02-10', 'YYYY-MM-DD'), 1400);

INSERT INTO products VALUES (101, 'Electronics', 'Laptop', 1500);
INSERT INTO products VALUES (102, 'Electronics', 'Smartphone', 800);
INSERT INTO products VALUES (103, 'Office', 'Printer', 300);
INSERT INTO products VALUES (104, 'Office', 'Scanner', 400);
INSERT INTO products VALUES (105, 'Kitchen', 'Toaster', 50);

INSERT INTO sales VALUES (1001, 1, 101, TO_DATE('2024-01-05', 'YYYY-MM-DD'), 2);
INSERT INTO sales VALUES (1002, 1, 103, TO_DATE('2024-01-06', 'YYYY-MM-DD'), 1);
INSERT INTO sales VALUES (1003, 2, 102, TO_DATE('2024-02-10', 'YYYY-MM-DD'), 3);
INSERT INTO sales VALUES (1004, 2, 105, TO_DATE('2024-03-02', 'YYYY-MM-DD'), 10);
INSERT INTO sales VALUES (1005, 3, 104, TO_DATE('2024-01-20', 'YYYY-MM-DD'), 1);
INSERT INTO sales VALUES (1006, 4, 101, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 1);
INSERT INTO sales VALUES (1007, 1, 102, TO_DATE('2024-04-05', 'YYYY-MM-DD'), 2);
INSERT INTO sales VALUES (1008, 2, 105, TO_DATE('2024-05-08', 'YYYY-MM-DD'), 5);
INSERT INTO sales VALUES (1009, 6, 105, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 4);
INSERT INTO sales VALUES (1010, 6, 103, TO_DATE('2024-06-15', 'YYYY-MM-DD'), 1);


SELECT * FROM employees;
SELECT * FROM products;
select * FROM sales;

SELECT 
*
FROM employees e
JOIN sales s
ON e.emp_id= s.emp_id
JOIN products p
ON p.product_id = s.product_id;

SELECT 
        e.dept_name,
        p.category,
        SUM(p.price * s.quantity) AS total_sales,
        GROUPING(e.dept_name) AS g_dept,
        GROUPING(p.category) AS g_cat
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY 
    GROUPING SETS (
        (e.dept_name, p.category),  -- nur Kategorie
        (e.dept_name),              -- nur Abteilung
        (p.category),              --  beides zusammen
        ()                         --  Gesamtsumme
    )
ORDER BY
    GROUPING(e.dept_name),
    GROUPING(p.category);

SELECT 
    CASE WHEN GROUPING(e.dept_name) = 1 THEN 'Total' ELSE e.dept_name END AS department,
    CASE WHEN GROUPING(p.category) = 1 THEN 'Total' ELSE p.category END AS category,
    SUM(p.price * s.quantity) AS total_sales
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY GROUPING SETS (
    (e.dept_name, p.category),
    (e.dept_name),
    (p.category),
    ()
)
ORDER BY
    GROUPING(e.dept_name),
    GROUPING(p.category);
