/*Example Test*/

CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    dept_name VARCHAR2(30),
    hire_date DATE,
    salary NUMBER
);


CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    category VARCHAR2(30),
    product_name VARCHAR2(50),
    price NUMBER
);


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
Commit;

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
    
SELECT * FROM employees;
SELECT * FROM products;
select * FROM sales;  
    
SELECT 
    e.emp_name,
    e.hire_date,
    SUM(p.price * s.quantity) AS total_sales,
    GROUPING(e.emp_name) AS g_emp,
    GROUPING(e.hire_date) AS g_date
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY ROLLUP (e.emp_name, e.hire_date)
ORDER BY GROUPING(e.emp_name), GROUPING(e.hire_date);

SELECT
    CASE WHEN GROUPING(e.emp_name) = 1 THEN 'Gesamt' ELSE e.emp_name
    END AS Mitarbeiter,

    CASE WHEN GROUPING(e.hire_date) = 1 THEN 'Gesamt' ELSE TO_CHAR(e.hire_date, 'YYYY')
    END AS Einstellungsjahr,
    SUM(p.price * s.quantity) AS Gesamt_Umsatz,

    CASE WHEN GROUPING(e.emp_name) = 0 AND SUM(p.price * s.quantity) > (
            SELECT AVG(p.price * s.quantity)
            FROM sales s
            JOIN products p ON s.product_id = p.product_id
        ) THEN 'TOP'
        ELSE NULL END AS Kommentar
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY ROLLUP (e.emp_name, e.hire_date)
HAVING NOT (
    GROUPING(e.emp_name) = 1 AND GROUPING(e.hire_date) = 0
) 
ORDER BY 
    GROUPING(e.emp_name) DESC,
    GROUPING(e.hire_date) DESC,
    e.emp_name,
    e.hire_date;
    
SELECT 
    e.emp_name,
    SUM(p.price * s.quantity) AS total_sales
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY e.emp_name;

SELECT
    e.emp_name,
    EXTRACT(YEAR FROM e.hire_date) AS Jahr,
    SUM(p.price * s.quantity) AS total_sales
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY e.emp_name,EXTRACT(YEAR FROM e.hire_date);

SELECT
    e.emp_name,
    EXTRACT(YEAR FROM e.hire_date) AS Jahr,
    SUM(p.price * s.quantity) AS total_sales
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY ROLLUP (e.emp_name, EXTRACT(YEAR FROM e.hire_date));

SELECT AVG(p.price * s.quantity)
FROM sales s
JOIN products p ON p.product_id = s.product_id;

/*CASE*/
SELECT emp_name,salary,
    CASE WHEN salary > 2000 THEN 'Hight salary'
    ELSE 'Low salary'
    END 
AS salary_state
FROM employees;

SELECT emp_name,SUM(quantity) AS Amount,
CASE WHEN SUM(quantity) > 10 THEN 'active'
ELSE 'not active'
END AS status
FROM sales s
JOIN employees e ON e.emp_id=s.emp_id
GROUP BY emp_name;

SELECT emp_name,
SUM(price*quantity) AS ALLIN,
CASE WHEN GROUPING(emp_name) = 1 THEN 'Total'
ELSE 'real person'
END AS red_tip
FROM employees e
JOIN sales s ON s.emp_id = e.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY ROLLUP(emp_name);

SELECT
    emp_name,
    SUM(p.price * s.quantity) AS AllIn,
    CASE 
        WHEN GROUPING(emp_name) = 0 AND
             SUM(p.price * s.quantity) > (
                 SELECT AVG(p.price * s.quantity)
                 FROM sales s
                 JOIN products p ON p.product_id = s.product_id
             )
        THEN 'TOP'
        ELSE NULL
    END AS coment
FROM employees e
JOIN sales s ON s.emp_id = e.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY ROLLUP(emp_name);

/*3*/
SELECT * FROM employees;
SELECT * FROM products;
select * FROM sales;  

SELECT
    CASE 
        WHEN GROUPING(p.category) = 1 THEN 'Gesamt'
        ELSE p.category
    END AS Kategorie,

    CASE 
        WHEN GROUPING(e.dept_name) = 1 THEN 'Gesamt'
        ELSE e.dept_name
    END AS Abteilung,

    COUNT(*) AS Anzahl_Verkaeufe,
    SUM(s.quantity) AS Gesamt_Menge,
    SUM(p.price * s.quantity) AS Gesamt_Umsatz,

    GROUPING(p.category) AS G_Kategorie,
    GROUPING(e.dept_name) AS G_Abteilung

FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id

GROUP BY CUBE(p.category, e.dept_name)

ORDER BY 
    GROUPING(p.category),
    p.category,
    GROUPING(e.dept_name),
    e.dept_name;
    
SELECT
  p.category,
  e.dept_name,
  SUM(s.quantity) AS total_quantity,
  GROUPING(p.category) AS g_cat,
  GROUPING(e.dept_name) AS g_dept
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
JOIN products p ON p.product_id = s.product_id
GROUP BY CUBE(p.category, e.dept_name)
ORDER BY
  GROUPING(p.category),
  p.category,
  GROUPING(e.dept_name),
  e.dept_name;

SELECT
    dept_name,
    SUM(salary) AS total_salary,
    GROUPING(dept_name) AS g_dept
FROM employees
GROUP BY ROLLUP(dept_name)
ORDER BY GROUPING(dept_name), dept_name;

SELECT category,
        dept_name,
        SUM(quantity) AS total_q,
        GROUPING(category) AS g_cat,
        GROUPING(dept_name) AS g_dept
FROM products p
JOIN sales s ON s.product_id = p.product_id
JOIN employees e ON s.emp_id = e.emp_id
GROUP BY CUBE(category, dept_name)
ORDER BY(category),
category,
grouping(dept_name),
dept_name;

SELECT
    CASE 
        WHEN GROUPING(category) = 1 THEN 'Gesamt'
        ELSE category
    END AS Kategorie,

    CASE 
        WHEN GROUPING(dept_name) = 1 THEN 'Gesamt'
        ELSE dept_name
    END AS Abteilung,

    SUM(quantity) AS total_q
FROM products p
JOIN sales s ON s.product_id = p.product_id
JOIN employees e ON s.emp_id = e.emp_id
GROUP BY CUBE(category, dept_name)
ORDER BY 
    GROUPING(category),
    category,
    GROUPING(dept_name),
    dept_name;
    

SELECT
    e.emp_name,
    COUNT(*) AS anzahl_verkaeufe,
    NVL(
        TRUNC(MIN(s.sale_date)) - TO_DATE('01.01.' || TO_CHAR(SYSDATE, 'YYYY'), 'DD.MM.YYYY'),
        0
    ) AS tage_seit_jahresbeginn
FROM employees e
JOIN sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_name
HAVING COUNT(*) >= 10;

/*Erstellen Sie eine Übersicht über Verkäufe:
- Pro Jahr (aus sale_date)
- Pro Kategorie
- Gesamtumsatz
- Anzahl der beteiligten Mitarbeiter 
Verwenden Sie GROUPING SETS ((Jahr), (Kategorie), ())
und UNION ALL mit Mitarbeitern ohne Verkäufe*/
-- Teil 1: Verkäufe
-- Teil 1: Verkäufe
-- Teil 1: Verkäufe
SELECT
    TO_CHAR(s.sale_date, 'YYYY') AS jahr,
    p.category,
    SUM(p.price * s.quantity) AS umsatz,
    COUNT(DISTINCT s.emp_id) AS anzahl_mitarbeiter
FROM sales s
JOIN products p ON p.product_id = s.product_id
GROUP BY GROUPING SETS (
    (TO_CHAR(s.sale_date, 'YYYY')),
    (p.category),
    ()
)
UNION ALL
-- Teil 2: Mitarbeiter ohne Verkäufe
SELECT
    NULL AS jahr,
    NULL AS category,
    0 AS umsatz,
    COUNT(*) AS anzahl_mitarbeiter
FROM employees e
WHERE NOT EXISTS (
    SELECT 1 FROM sales s WHERE s.emp_id = e.emp_id
);

SELECT * FROM employees;
SELECT * FROM products;
SELECT * FROM sales;  

SELECT 
    e.emp_name AS Mitarbeitername,
    NVL(SUM(s.quantity),0) AS Gesamtmenge,
    ROUND(NVL(AVG(p.price),0),2) AS Durchschnittspreis,
CASE
    WHEN AVG(p.price) < 500 THEN 'Low'
    WHEN AVG(p.price) BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'High'
END AS kommentar
FROM employees e
LEFT JOIN sales s ON e.emp_id = s.emp_id
LEFT JOIN products p ON p.product_id = s.product_id
GROUP BY e.emp_name;
