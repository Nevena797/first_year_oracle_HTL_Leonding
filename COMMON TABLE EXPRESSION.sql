/*COMMON TABLE EXPRESSION
"with clause" */


SELECT * FROM EMP;

/*We are looking for: an employee ?? his boss ?? the boss's boss
The result will be all employees who:
have a manager assigned (MGR is not NULL)
and this manager also has a manager (boss of the boss)
If an employee does not have a manager or their boss does not have a manager,
that employee will not appear in the result (because of the JOIN, not LEFT JOIN).
*/

SELECT * FROM EMP mitarbeiter
JOIN EMP boss ON boss.EMPNO = mitarbeiter.MGR
JOIN EMP boss2 ON boss2.empno = boss.mgr;

WITH EmpCTE AS(
SELECT 
    EMPNO,
    ENAME,
    MGR
FROM emp
UNION ALL
SELECT 
    EMPNO,
    ENAME,
    MGR
FROM emp
)

SELECT * FROM EmpCTE



WITH EmpCTE AS(
SELECT 
    EMPNO,
    ENAME,
    MGR
FROM emp
WHERE mgr is NULL
)

SELECT * FROM EmpCTE;

/*This CTE is not recursive —manually select:
First the boss without a manager
Then the people below him
It does not automatically continue to the subordinates of the subordinates.
*/
WITH EmpCTE AS (
  SELECT 
    EMPNO,
    ENAME,
    MGR
  FROM EMP
  WHERE MGR IS NULL   --select employees without a manager (MGR IS NULL)
  ---usually the biggest boss in the company—for example, the president

  UNION ALL --merge the results of the two queries,NOT removing duplicate entries

  SELECT 
    EMPNO,
    ENAME,
    MGR
  FROM EMP
  WHERE MGR = 7839  --select all employees whose boss is employee number 7839
)
SELECT * FROM EmpCTE;

WITH EMPCTE AS( -- temporary table
SELECT EMPNO,
        ENAME,
        MGR
FROM EMP
WHERE MGR IS NULL --select employees without a manager (MGR IS NULL)
  ---usually the biggest boss in the company—for example, the president

UNION ALL --merge the results of the two queries,NOT removing duplicate entries

SELECT
    EMPNO,
    ENAME,
    MGR
FROM EMP
WHERE MGR IN(7566,7698,7782) --subordinates at the middle management level
)
SELECT * FROM EMPCTE;


WITH EMPCTE (EMPNO,ENAME,MGR)AS (
SELECT 
    EMPNO,
    ENAME,
    MGR
FROM EMP
WHERE MGR IS NULL -- Find all employees without a manager (MGR IS NULL). For example, KING

UNION ALL --add the results from the base part and the recursion — and continue until there are no new matches

SELECT 
    EMP.EMPNO,
    EMP.ENAME,
    EMP.MGR
FROM EMP
JOIN EMPCTE ON EMPCTE.EMPNO = EMP.MGR -- connect the employees (EMP) with the bosses I already found (EMPCTE)
--using JOIN on EMP.MGR = EMPCTE.EMPNO.
)

SELECT * FROM EMPCTE;

--EMPCTE builds on itself: it starts with the bosses and then finds every employee
--whose MGR matches an EMPNO that has already been found.
--We use UNION ALL because in recursion
--we need to keep all records (without removing duplicates).

WITH EMPCTE (EMPNO, ENAME, MGR, LVL) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL


    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)

SELECT *
FROM EMPCTE
ORDER BY LVL, ENAME;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL
    FROM EMP
    WHERE MGR IS NULL
)
SELECT * FROM EMPCTE CTE1
CROSS JOIN EMPCTE CTE2 ;

--do not work so

WITH EMPCTE (EMPNO, ENAME, MGR, LVL) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL
    FROM EMP
    WHERE MGR IS NULL
)
SELECT * FROM EMPCTE CTE1;
SELECT * FROM EMPCTE CTE2 ;

-- lvl not a function! name column

WITH EMPCTE (EMPNO, ENAME, MGR, HUGO) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS HUGO
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL


    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.HUGO + 1
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)

SELECT *
FROM EMPCTE
ORDER BY HUGO, ENAME;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL


    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)

SELECT *
FROM EMPCTE;

SELECT * FROM DUAL;

SELECT 1 + 2, '1' || '2', 1 + '2',/*1 + 'a' -> do not - invalid number !*/ FROM DUAL;

SELECT 1 FROM DUAL
UNION ALL
SELECT 2 FROM DUAL; -- there is a spache before --1 and --2


SELECT '1' FROM DUAL
UNION ALL
SELECT '2' FROM DUAL;
-- there is no spache before --1 and --2, it is after!

SELECT 1 FROM DUAL
UNION ALL
SELECT '2' FROM DUAL;
--expretion must have same datatype - do not do it

SELECT 1 FROM DUAL
UNION ALL
SELECT TO_NUMBER('2') FROM DUAL;
 -- there is a spache before --1 and --2
 
SELECT TO_CHAR(1) FROM DUAL
UNION ALL
SELECT '2' FROM DUAL;

-- there is no spache before --1 and --2, it is after!


SELECT * FROM EMP;
/*PATH shows the entire path from the top boss to each employee. */
/*LVL gives you the level of obedience.*/


WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL

    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)

SELECT *
FROM EMPCTE
ORDER BY PATH;  -- Orders the result to visualize hierarchy



--Alle Untergegebenen (alle Levels) von "Jones"

SELECT * FROM EMP;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE ENAME = 'JONES' -- HAVING ENAME ='JONES'-> it is not OK, NOT HAVING EXPRESION

    UNION ALL

    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)

SELECT *
FROM EMPCTE
ORDER BY PATH;  -- Orders the result to visualize hierarchy


WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL
    UNION ALL
    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT *
FROM EMPCTE
WHERE PATH LIKE '%JONES%';

--JONES soll nicht angeführt
--JONES should not be included," 
--which suggests that employees who are below JONES are being searched for, but without including JONES himself.

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL
    UNION ALL
    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT *
FROM EMPCTE
WHERE PATH LIKE '%JONES_%'; --searches for all employees 
--whose pathname contains "JONES_",
---where the underscore (_) is a special character in SQL
--for the LIKE operator, meaning "any single character".

--Note: Here '%JONES_%' does not just search for "JONES",
---it searches for "JONES" plus one additional character after it.
--This is different from '%JONES%', which would find all records containing "JONES".


--die direkt untergegeben sollen nicht angeführt
WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL
    UNION ALL
    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT *
FROM EMPCTE
WHERE PATH LIKE '%JONES_%'
AND LVL >=4; --filters the results to include only employees who are at level 4 or higher in the hierarchy

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL
    UNION ALL
    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT *
FROM EMPCTE
WHERE PATH LIKE '%JONES_%'
AND LVL >= (SELECT LVL FROM EMPCTE WHERE ENAME = 'JONES') + 2; -- the same like LVL >= 4;

--Alle Mitarbeiter, die auf Hierarchie - Ebene von
--den MItarbeitern von "JONES" sind
--unabhängig, ob sie an Jones berichten, oder nicht)

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    -- Find bosses without a manager (MGR IS NULL), PATH = ENAME
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL
    UNION ALL
    -- For each employee, append its name to the path (PATH) with '->'
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1,  -- Upgrades level (LVL)
        C.PATH || '->' || E.ENAME  -- Append employee name to path
    FROM EMP E
    INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT *
FROM EMPCTE
WHERE --PATH LIKE '%JONES_%' AND
LVL >= (SELECT LVL FROM EMPCTE WHERE ENAME = 'JONES') + 1; 

---factorial

WITH MYCTE (COUNTNUMBER, RESULT)
AS (
  SELECT 1 AS COUNTNUMBER, 1 AS RESULT FROM DUAL --START WHIT COUNTNUMBER = 1 AND RESULT = 1
  UNION ALL
  SELECT COUNTNUMBER + 1, RESULT * (COUNTNUMBER + 1) FROM MYCTE -- each step increases COUNTNUMBER by 1
  --and multiplies RESULT by the new value of COUNTNUMBER
  WHERE COUNTNUMBER < 10
)
SELECT * FROM MYCTE;

WITH MYCTE (COUNTNUMBER, RESULT)
AS (
  SELECT 1 AS COUNTNUMBER, 1 AS RESULT FROM DUAL --START WHIT COUNTNUMBER = 1 AND RESULT = 1
  UNION ALL
  SELECT COUNTNUMBER + 1, RESULT + COUNTNUMBER FROM MYCTE -- each step increases COUNTNUMBER by 1
  --and  add RESULT by the new value of COUNTNUMBER
  WHERE COUNTNUMBER < 10
)
SELECT * FROM MYCTE;


WITH MYCTE (COUNTNUMBER, RESULT)
AS (
  SELECT 1 AS COUNTNUMBER2,1 AS RESULT FROM DUAL --START WHIT COUNTNUMBER = 1 AND RESULT = 1
  UNION ALL
  SELECT COUNTNUMBER + 1, RESULT + COUNTNUMBER + 1 FROM MYCTE -- each step increases COUNTNUMBER by 1
  --and  add RESULT by the new value of COUNTNUMBER
  WHERE COUNTNUMBER < 10
)
SELECT * FROM MYCTE;

--This SQL code calculates the percentage of each employee's salary to the total salary
--and filters only those employees whose salary is more than 10% of the total. Let's look at it in parts.
SELECT ENAME, --We extract the employee's name (ENAME) and his salary (SAL) from the EMP table
    SAL,
    SAL / (SELECT SUM(SAL) AS SALSUMALIAS FROM EMP) SALPCT --calculates the sum of all salaries in the table
FROM EMP
WHERE SAL /(SELECT SUM (SAL) AS SALSUMALIAS from EMP) > 0.1; 
--Divides each employee's salary by the total amount of salaries
--The result is the share (as a decimal number) of the total amount.
--Filters the rows to only include employees whose salary represents more than 0.1 (or 10%) of the total salary amount


WITH TOTAL_SAL AS (
    SELECT SUM(SAL) AS TOTAL FROM EMP
)
SELECT 
    ENAME,
    SAL,
    SAL / (SELECT TOTAL FROM TOTAL_SAL) AS SALPCT
FROM 
    EMP
WHERE 
    SAL / (SELECT TOTAL FROM TOTAL_SAL) > 0.1;

--Suche starten bei Adams (nicht KING)
--this time it searches the hierarchy up from employee 'ADAMS' to his managers
WITH EMPCTE (EMPNO,ENAME,MGR,LVL,PATH) AS (
SELECT
    EMPNO,
    ENAME,
    MGR,
    1 AS LVL,
    ENAME AS PATH
FROM EMP
WHERE ENAME = 'ADAMS'
UNION ALL
SELECT
    EMP.EMPNO,
    EMP.ENAME,
    EMP.MGR,
    C.LVL + 1 AS LVL,
    C.PATH || '<-' || EMP.ENAME AS PATH 
FROM EMP
JOIN EMPCTE C ON C.MGR = EMP.EMPNO --Important: The relationship is reversed compared to the previous examples
--INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT * FROM EMPCTE;

WITH EMPCTE (EMPNO,ENAME,MGR,LVL,PATH) AS (
SELECT
    EMPNO,
    ENAME,
    MGR,
    1 AS LVL,
    ENAME AS PATH
FROM EMP
WHERE ENAME = 'ADAMS'
UNION ALL
SELECT
    EMP.EMPNO,
    EMP.ENAME,
    EMP.MGR,
    C.LVL + 1 AS LVL,
    C.PATH || '<-' || EMP.ENAME AS PATH 
FROM EMP
JOIN EMPCTE C ON C.MGR = EMP.EMPNO --Important: The relationship is reversed compared to the previous examples
--INNER JOIN EMPCTE C ON E.MGR = C.EMPNO
)
SELECT * FROM EMPCTE
WHERE LVL=3;

































    









