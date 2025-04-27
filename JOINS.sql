/*JOINS Uebung*/

/*1 INNER JOIN - Shows only rows where there is a match in both tables.
-> Only employees who have an existing department.*/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT E.ENAME,
       D.DNAME
FROM EMP E
INNER JOIN DEPT D
  ON E.DEPTNO = D.DEPTNO;
  
/*2.LEFT OUTER JOIN = LEFT JOIN -All rows from the left table (EMP)
If there is no match in the right table (DEPT) ?  NULL for the fields from the right table. ; 
-> all employees, even those without an assigned department.*/

SELECT * 
FROM EMP E
LEFT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

/*3RIGHT OUTER JOIN = RIGHT JOIN
All rows from the right table (DEPT)
If there is no match in the left (EMP) ? NULL for the employees.
->all departments, even departments without employees.*/

SELECT * 
FROM EMP E
RIGHT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO ;


/*4 FULL OUTER JOIN 
All rows from both tables.
If there is no match on one side ? NULL for missing data.
-> all employees and all departments, even without a connection between them.
*/

SELECT *
FROM EMP E
FULL OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

/*5 CROSS JOIN Combines all rows from the first table with all rows from the second table.
-> 5 employees and 3 departments ?  get 5 × 3 = 15 rows.
*/

SELECT E.ENAME, D.DNAME
FROM EMP E
CROSS JOIN DEPT D;

/*6 SELF JOIN -A table links to itself.
 for example, when i want to find employees' managers.
We connect the employee with their manager (who is also an employee).
*/

SELECT E1.ENAME AS EMPLOYEE,
        E2.ENAME AS MANAGER
FROM EMP E1
LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;




