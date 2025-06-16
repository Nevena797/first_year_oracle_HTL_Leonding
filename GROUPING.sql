SELECT * FROM EMP;

SELECT ENAME, JOB, SAL FROM EMP
UNION ALL
SELECT ' ' AS ENAME, JOB, SUM(SAL) FROM EMP
GROUP BY JOB
UNION ALL
SELECT ' ', 'Total', SUM(SAL) FROM EMP
ORDER BY JOB, ENAME;

SELECT ENAME, JOB, SUM(SAL) FROM EMP
GROUP BY ROLLUP(JOB, ENAME); -- rollup hilft, weniger text zu schreiben

SELECT JOB,SUM(SAL) FROM EMP
GROUP BY ROLLUP(JOB);

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT ENAME,JOB,DEPTNO,SUM(SAL)
FROM EMP
GROUP BY
ROLLUP (DEPTNO,JOB,ENAME);

--entspricht dieser Query:

SELECT ename, job, deptno, sal
FROM emp
UNION ALL
SELECT ' ' AS ename, job, deptno, SUM(sal)
FROM emp
GROUP BY job,deptno
UNION ALL
SELECT ' '     AS ename, 'Total' AS job, deptno, SUM(sal)
FROM emp
GROUP BY deptno
UNION ALL
SELECT ' '     AS ename, 'Total' AS job, 999, SUM(sal)
FROM emp
ORDER BY deptno,job, ename;

SELECT DEPTNO,JOB,COUNT(*)
FROM EMP
GROUP BY DEPTNO,JOB;

SELECT ENAME,SAL
FROM EMP
ORDER BY SAL DESC;

SELECT DEPTNO,JOB,SUM(SAL)
FROM EMP
GROUP BY DEPTNO,JOB
ORDER BY DEPTNO,JOB;

--entspricht auch dieser Query:
SELECT ENAME,JOB,DEPTNO,SUM(SAL)
FROM EMP
GROUP BY
    GROUPING SETS((DEPTNO,JOB,ENAME), /*Eine drier Kombi*/  -- 1. ???-????????: ????? ???????? ? ??????? ?? job ? deptno
                (DEPTNO,JOB),-- 2. ????????? ?? job ? ??????? ?? ????? deptno
                (DEPTNO)-- 3. ????????? ?? ????? (?????????? ?? ????????)
                --,()--GRANDTOTAL  -- 4. (??? ?? ??????) ??????? ???? – GRAND TOTAL
                );
            
SELECT ENAME,JOB,DEPTNO,SUM(SAL)
FROM EMP
GROUP BY
    GROUPING SETS((DEPTNO,JOB,ENAME),
                  (DEPTNO,JOB),
                  (DEPTNO),
                  ()
                  );
                  
SELECT ENAME,JOB,DEPTNO,SUM(SAL)
FROM EMP
GROUP BY
    CUBE(DEPTNO,JOB,ENAME);--Alle mögliche kombinationen
    
-- null ersetzen
SELECT 
    NVL(ENAME,'SUMME'),
    NVL(JOB,'SUMME'),
    NVL(TO_CHAR(DEPTNO),'SUMME'),
    SUM(SAL)
FROM EMP 
GROUP BY ROLLUP(DEPTNO, JOB, ENAME);

SELECT ENAME, GROUPING_ID(ENAME), JOB, DEPTNO, SUM(SAL)
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,
           JOB,
           ENAME);

SELECT 
    CASE WHEN GROUPING_ID(ENAME)=0 THEN ENAME ELSE 'SUMME' END AS ENAME, -- grouping_id oder synonym grouping
    CASE WHEN GROUPING_ID(JOB)=0 THEN JOB ELSE 'SUMME' END AS JOB,
    CASE WHEN GROUPING_ID(DEPTNO)=0 THEN TO_CHAR(DEPTNO) ELSE 'SUMME' END AS DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,
           JOB,
           ENAME);
           
SELECT ENAME, JOB, DEPTNO, SUM(SAL)
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,
           JOB, ENAME);/*4 nivo include ENAME*/
           
SELECT ENAME, JOB, DEPTNO, SUM(SAL) /* 3 nivo */
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,
           (JOB, ENAME));
           
/*Ubunung Grouping.SQL*/


/*1.Schreiben Sie das folgende Statement so um, 
dass es das idente Ergebnis liefert, aber weniger
Code geschrieben ist:
select ename, job, deptno, sum(sal) from emp
group by grouping sets(
    (deptno, job, ename),
    (deptno, job),
    (deptno),
    ()
    )*/
SELECT ENAME,JOB,DEPTNO,SUM(SAL) FROM EMP
GROUP BY ROLLUP
    (DEPTNO,JOB,ENAME);
    
/*2.Schreiben Sie das folgende Statement so um, 
dass es das idente Ergebnis liefert, aber weniger
Code geschrieben ist:
select job, deptno, sum(sal) from emp
group by grouping sets(
    (deptno, job),
    (deptno),
    (job),
    ()
    )*/
SELECT JOB,DEPTNO,SUM(SAL)
FROM EMP
GROUP BY
    CUBE(JOB,DEPTNO);
    --ORDER BY DEPTNO,JOB
--ACHTUNG - ORDER BY gibt Punkteabzug bei Test, wenn Sortierung nicht gefragt ist!! 


/*3.Erstellen Sie eine Abfrage uber die Tabelle EMP,
die den JOB und die DEPTNO samt Gehaltssumme (SAL)
wie folgt zeigt:

JOB           DEPTNO   SUM(SAL)
--------- ---------- ----------
CLERK             10       1300
MANAGER           10       2450
PRESIDENT         10       5000
(null)            10       8750
CLERK             20       1900
ANALYST           20       6000
MANAGER           20       2975
(null)            20      10875
CLERK             30        950
MANAGER           30       2850
SALESMAN          30       5600
(null)            30       9400
12 rows selected. */

SELECT JOB,DEPTNO,SUM(SAL) FROM EMP
GROUP BY GROUPING SETS(
    (JOB,DEPTNO),
    (DEPTNO)
    );
    
--ODER
SELECT JOB,DEPTNO,SUM(SAL) FROM EMP
GROUP BY JOB,DEPTNO
UNION ALL
SELECT NULL,DEPTNO,SUM(SAL) FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO,JOB;--falls gefragt
/*ROLLUP liefert anderes Ergebnis (Grand total inkludiert, 13 Zeilen): */

SELECT JOB, DEPTNO, SUM(SAL) FROM EMP
GROUP BY ROLLUP 
    (DEPTNO, JOB); 

--Richtige Anwendung von ROLLUP:    
SELECT JOB, DEPTNO, SUM(SAL) FROM EMP
GROUP BY ROLLUP 
    (DEPTNO, JOB)
HAVING NOT(GROUPING(JOB)=1 AND GROUPING(DEPTNO) = 1); 

/*4.
Erstellen Sie eine Abfrage über die Tabelle EMP,
die den JOB und die DEPTNO samt Gehaltssumme (SAL)
wie folgt zeigt:

JOB       DEPTNO                                     SUM(SAL)
--------- ---------------------------------------- ----------
Summe     Summe                                         29025
CLERK     Summe                                          4150
ANALYST   Summe                                          6000
MANAGER   Summe                                          8275
SALESMAN  Summe                                          5600
PRESIDENT Summe                                          5000
Summe     10                                             8750
CLERK     10                                             1300
MANAGER   10                                             2450
PRESIDENT 10                                             5000
Summe     20                                            10875

JOB       DEPTNO                                     SUM(SAL)
--------- ---------------------------------------- ----------
CLERK     20                                             1900
ANALYST   20                                             6000
MANAGER   20                                             2975
Summe     30                                             9400
CLERK     30                                              950
MANAGER   30                                             2850
SALESMAN  30                                             5600
18 rows selected. 
*/
SELECT 
    CASE WHEN GROUPING_ID(JOB)=0 THEN JOB ELSE 'SUMME' END AS JOB,
    CASE WHEN GROUPING_ID(DEPTNO)=0 THEN TO_CHAR(DEPTNO) ELSE 'SUMME' END AS DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY
    CUBE(DEPTNO,JOB);
    
/*5.Erstellen Sie eine Abfrage uber die Tabelle EMP,
die den JOB und die DEPTNO samt Gehaltssumme (SAL)
wie folgt zeigt:

JOB                                                    DEPTNO                                     SUM(SAL)
------------------------------------------------------ ---------------------------------------- ----------
CLERK                                                  10                                             1300
MANAGER                                                10                                             2450
PRESIDENT                                              10                                             5000
Zwischensumme 10                                                                                      8750
CLERK                                                  20                                             1900
ANALYST                                                20                                             6000
MANAGER                                                20                                             2975
Zwischensumme 20                                                                                     10875
CLERK                                                  30                                              950
MANAGER                                                30                                             2850
SALESMAN                                               30                                             5600
Zwischensumme 30                                                                                      9400
                                                       Totalsumme                                    29025
13 rows selected. 
*/
SELECT 
    CASE
    WHEN GROUPING_ID(JOB) = 1 AND GROUPING_ID(DEPTNO) = 1 THEN ' '
    WHEN GROUPING_ID(JOB) = 0 THEN JOB
    ELSE 'Zwischensumme' || TO_CHAR(DEPTNO)
    END AS JOB,
    case 
        WHEN GROUPING_ID(JOB) = 1  AND GROUPING_ID(DEPTNO) = 0 THEN ' '
        WHEN GROUPING_ID(DEPTNO) = 0 then TO_CHAR(DEPTNO) 
        ELSE 'Totalsumme' END AS DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,JOB); /*DEPTNO + JOB ; DEPTNO + NULL ;NULL + NULL*/
    
/*6.
Erstellen Sie eine Abfrage uber die Tabelle EMP,
die den JOB und die DEPTNO samt Gehaltssumme (SAL)
wie folgt zeigt.
Achten Sie auf die Sortierung.

JOB                                                    DEPTNO                                          SAL
------------------------------------------------------ ---------------------------------------- ----------
                                                       Totalsumme                                    29025
Zwischensumme 10                                                                                      8750
CLERK                                                  10                                             1300
MANAGER                                                10                                             2450
PRESIDENT                                              10                                             5000
Zwischensumme 20                                                                                     10875
ANALYST                                                20                                             6000
CLERK                                                  20                                             1900
MANAGER                                                20                                             2975
Zwischensumme 30                                                                                      9400
CLERK                                                  30                                              950
MANAGER                                                30                                             2850
SALESMAN                                               30                                             5600
13 rows selected. 
*/

SELECT 
    CASE
        WHEN GROUPING_ID(JOB) = 1 AND GROUPING_ID(DEPTNO) = 1 THEN ' '
        WHEN GROUPING_ID(JOB) = 0 THEN JOB 
        ELSE 'Zwischensumme ' || TO_CHAR(DEPTNO) 
        END AS JOB,
    CASE
        WHEN GROUPING_ID(JOB) = 1 AND GROUPING_ID(DEPTNO) = 0 THEN ' '
        WHEN GROUPING_ID(DEPTNO) = 0 THEN TO_CHAR(DEPTNO)  
        ELSE 'Totalsumme' END AS DEPTNO,
    SUM(SAL)
FROM EMP
GROUP BY
    ROLLUP(DEPTNO,JOB);    

Teststoff konkretisieren:

- Grouping sets
- Eine Thoriefrage
- Datumsfunktionen aus Datentypen.sql


    



