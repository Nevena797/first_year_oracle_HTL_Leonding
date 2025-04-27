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































    









