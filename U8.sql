/*Übung 8 - zu PARTS*/
/*1 Erzeugen der PARTS-Tabelle (parts.sql) */

drop table parts
/
create table parts (sub varchar2(3) not null primary key,
                    super varchar2(3),
                    price number(5,2))
/
insert into parts values ('P1',NULL,130)
/
insert into parts values ('P2','P1',15)
/
insert into parts values ('P3','P1',65)
/
insert into parts values ('P4','P1',20)
/
insert into parts values ('P9','P1',45)
/
insert into parts values ('P5','P2',10)
/
insert into parts values ('P6','P3',10)
/
insert into parts values ('P7','P3',20)
/
insert into parts values ('P8','P3',25)
/
insert into parts values ('P12','P7',10)
/
insert into parts values ('P10','P9',12)
/
insert into parts values ('P11','P9',21)
/
COMMIT;



/*2. Anzeigen der gesamten Hierarchie derjenigen Teile, aus denen P3 und P9
bestehen
SUB SUPER PRICE
--- --- ----------
P10 P9 12
P11 P9 21
P12 P7 10
P6 P3 10
P7 P3 20
P8 P3 25
*/

SELECT * FROM PARTS;

WITH PARTCTE(SUB, SUPER, PRICE) AS (
--Anchor part (base case)
    SELECT
        SUB,--Part/component
        SUPER,--Product in which the part is used
        PRICE --Part price
    FROM PARTS
    WHERE SUPER IN ('P3', 'P9') --Finds all parts (SUB) that are direct components of P3 or P9 (SUPER)
    --SUPER = 'p3' OR SUPER = 'P9'
    
UNION ALL
--Recursive part
    SELECT
        PARTS.SUB,      
        PARTS.SUPER,    
        PARTS.PRICE     
    FROM PARTS
JOIN PARTCTE        
ON PARTCTE.SUB = PARTS.SUPER --"find parts that are components of already found parts"
)
SELECT * FROM PARTCTE;

------------------------------------------------------------------------------------------
/*DEMO*/ 
SELECT * FROM EMP;

SELECT * 
FROM EMP 11
JOIN EMP 12 ON 12.EMPNO = 11.MGR
JOIN EMP 13 ON 13.EMPNO = 12.MGR;

WITH EMPCTE AS(
    SELECT *
    FROM EMP 11
    JOIN EMP 12 ON 12.EMPNO = 11.MGR
    JOIN EMP 13 ON 13.EMPNO = 12.MGR
);
SELECT * FROM EMPCTE;


SELECT * FROM (
    SELECT *
    FROM EMP 11
    JOIN EMP 12 ON 12.EMPNO = 11.MGR
    JOIN EMP 13 ON 13.EMPNO = 12.MGR
);
--- CTE is like SUBSELECT

SELECT EMPNO, ENAME, MGR,1 AS LVL FROM EMP
WHERE MGR IS NULL
UNION ALL
SELECT EMPNO, ENAME, MGR, 2 AS LVL FROM EMP
WHERE MGR = 7839
UNION ALL
SELECT EMPNO, ENAME, MGR,3 AS LVL FROM EMP
WHERE MGR IN (7839,7698,7762);

WITH EMPCTE (EMPNO, ENAME, MGR, LVL) AS (
    SELECT EMPNO, ENAME, MGR, 1 AS LVL
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL

    SELECT EMP.EMPNO, EMP.ENAME, EMP.MGR, EMPCTE.LVL + 1
    FROM EMP
    JOIN EMPCTE ON EMPCTE.EMPNO=EMP.MGR
)
SELECT * FROM EMPCTE;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    SELECT EMPNO, ENAME, MGR, 1 AS LVL, ENAME AS PATH
    FROM EMP
    WHERE MGR IS NULL

    UNION ALL

    SELECT EMP.EMPNO, EMP.ENAME, EMP.MGR, EMPCTE.LVL + 1, EMPCTE.PATH || '->' || EMP.ENAME
    FROM EMP
    JOIN EMPCTE ON EMP.MGR = EMPCTE.EMPNO
)
SELECT * FROM EMPCTE;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, PATH) AS (
    SELECT EMPNO, ENAME, MGR, 1 AS LVL, ENAME AS PATH
    FROM EMP
    WHERE MGR = 7839 -- firs nivo will be 7839 MGR

    UNION ALL

    SELECT EMP.EMPNO, EMP.ENAME, EMP.MGR, EMPCTE.LVL + 1, EMPCTE.PATH || '->' || EMP.ENAME
    FROM EMP
    JOIN EMPCTE ON EMP.MGR = EMPCTE.EMPNO
)
SELECT * FROM EMPCTE;

/*3. An welcher Hierarchiestufe wird P12 in P1 verwendet */

SELECT * FROM PARTS;

WITH PARTSCTE(SUB, SUPER, LVL) AS (
  -- Basisfall: Starte von P1
  SELECT SUB, SUPER, 1 AS LVL
  FROM PARTS
  WHERE SUPER = 'P1'

  UNION ALL

  -- Rekursiver Teil
  SELECT P.SUB, P.SUPER, C.LVL +1
  FROM PARTS P
  JOIN PARTSCTE C ON P.SUPER = C.SUB
)
SELECT SUB, SUPER, LVL FROM PARTSCTE
WHERE SUB = 'P12'; -- Filtert nur das gewünschte Ergebnis

/*4. Wie viele Teile zu P1 kosten mehr als $20 */

SELECT * FROM PARTS;

WITH CTEPARTS(SUB, SUPER, PRICE, ANZ_TEILE) AS (
  -- Basisfall: Alle Teile, die direkt unter 'P1' hängen
  SELECT SUB, SUPER, PRICE ,1 AS ANZ_TEILE 
  FROM PARTS
  WHERE SUPER = 'P1'

  UNION ALL

  -- Rekursion: Gehe eine Ebene tiefer, zähle die Tiefe hoch  
  SELECT P.SUB, P.SUPER, P.PRICE, C.ANZ_TEILE + 1
  FROM PARTS P
  JOIN CTEPARTS C ON C.SUB = P.SUPER
)
-- Endgültiges Ergebnis: Zähle alle Teile mit PRICE > 20
SELECT COUNT(*) AS ANZAHL_TEILE FROM CTEPARTS
WHERE PRICE > 20;

--zu EMP-DEPT


/*5. Ausgabe aller direkt und indirekt zu JONES gehörenden Mitarbeiter (ohne
JONES selbst, mit entsprechender Einrückung pro Hierarchie) */

SELECT * FROM EMP;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, MITARBEITER, PATH) AS (
    SELECT
        EMPNO,
        ENAME,
        MGR,
        0 AS LVL,
        TO_CHAR(EMPNO) || ' ' || ENAME AS MITARBEITER,
        TO_CHAR(EMPNO) AS PATH
    FROM EMP
    WHERE ENAME = 'JONES'
    
    UNION ALL
    

    SELECT
        E.EMPNO,
        E.ENAME,
        E.MGR,
        CTE.LVL + 1 AS LVL,
        LPAD(' ', 9 * (CTE.LVL + 1)) || TO_CHAR(E.EMPNO) || ' ' || E.ENAME AS MITARBEITER,

    CTE.PATH || '-' || TO_CHAR(E.EMPNO) AS PATH
    FROM EMP E
    JOIN EMPCTE CTE ON CTE.EMPNO = E.MGR
)
SELECT MITARBEITER
FROM EMPCTE
WHERE LVL > 0
ORDER BY PATH;

WITH EMPCTE (EMPNO,ENAME,MGR,LVL,MITARBEITER,PATH) AS (
SELECT EMPNO,ENAME,MGR,0 LVL,
TO_CHAR(EMPNO) ||'' || ENAME AS MITARBEITER
TO_CHAR(EMPNO) PATH
FROM EMP
WHERE ENAME = 'JONES'

UNION ALL

SELECT E.EMPNO,E.NAME,E.MGR,CTE.LVL +1 LVL,
LPAD(' ',3 * LVL,' ') TO_CHAR(E.EMPNO) || ' ' || E.NAME AS MITARBEITER,
C.PATH || '->' || TO_CHAR(E.EMPNO) PATH
FROM EMP E
JOIN EMPCTE C.EMPNO = E.MGR
)

SELECT * MITARBEITER
FROM EMPCTE
WHERE LVL > 0
ORDER BY PATH;


/*EXKURS LPAD */

SELECT * FROM MATCHES;

SELECT
    M.PLAYERNO,
    M.WON,
    RPAD('#', M.WON, '*'),
    LPAD('#', M.WON, '*'),
    LPAD(M.PLAYERNO, M.WON, '*'),
    NVL(LPAD(M.PLAYERNO, M.WON, '*'), '#')
FROM MATCHES M
JOIN PLAYERS P 
ON P.PLAYERNO = M.PLAYERNO;

/*6. Ausgabe aller direkten und indirekten Vorgesetzten von SMITH (inklusive
SMITH)*/

/*Unlike the previous examples, this code appears to start at SMITH and move up the hierarchy,
finding all of his managers.
This is the reverse of a search - starting from a subordinate and finding
all of his managers up to the top of the organization.*/

SELECT * FROM EMP;

WITH EMPCTE (EMPNO, ENAME, MGR, LVL, MITARBEITER, PATH) AS (
-- Base case (initial employee)
    SELECT
        EMPNO,
        ENAME,
        MGR,
        1 AS LVL,
        TO_CHAR(EMPNO) || ' ' || ENAME AS MITARBEITER,
        TO_CHAR(EMPNO) AS PATH
    FROM EMP
    WHERE ENAME = 'SMITH'
    
    UNION ALL
    
    SELECT
        E.EMPNO,
        E.ENAME,
        E.MGR,
        C.LVL + 1 AS LVL, --We increase the level (LVL)

        LPAD(' ', 9 * (C.LVL + 1)) || TO_CHAR(E.EMPNO) || ' ' || E.ENAME AS MITARBEITER,

        --We are expanding the tracking path
        C.PATH || '->' || TO_CHAR(E.EMPNO) AS PATH
        --Changing the preview indentation
    FROM EMP E
    JOIN EMPCTE C ON E.EMPNO = C.MGR --We are adding new employees to the hierarchy.
    --E.EMPNO = C.MGR means that we are looking for employees 
    --(E from the EMP table) whose identification number (E.EMPNO)
    --matches the manager number (C.MGR) of the employees already found in the recursive table (C or EMPCTE)
)
SELECT 
    MITARBEITER
FROM EMPCTE
ORDER BY PATH;

--The recursion continues until no more matches can be found (i.e. until we reach the top of the hierarchy

/*7. Ausgabe des durchschnittlichen Gehalts für jede Hierarchiestufe*/

SELECT * FROM EMP;

WITH SALCTE (EMPNO, ENAME, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        ENAME,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP
    WHERE MGR IS NULL
    --WHERE MGR IN (7698,7782,7566)
    
    UNION ALL
    
    SELECT 
        E.EMPNO,
        E.ENAME,
        E.MGR,
        E.SAL,
        C.LVL + 1
    FROM EMP E
    JOIN SALCTE C ON C.EMPNO = E.MGR
)
SELECT 
    TO_CHAR(AVG(SAL), '9,999.00') AS AVG_SAL,
    LVL AS EBENE
FROM SALCTE
GROUP BY LVL
ORDER BY LVL;

--17.03.2025

SELECT * FROM EMP;

WITH AVG_SAL (EMPNO, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP
WHERE MGR IS NULL

UNION ALL
    
    SELECT 
        E.EMPNO,
        E.MGR,
        E.SAL,
        AVSA.LVL + 1
    FROM EMP E
    JOIN AVG_SAL AVSA ON AVSA.EMPNO = E.MGR 
)
SELECT * FROM AVG_SAL;

WITH AVG_SAL (EMPNO, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP

WHERE MGR IN(7698,7782)
    
    UNION ALL
    
    SELECT 
        E.EMPNO,
        E.MGR,
        E.SAL,
        AVSA.LVL + 1
    FROM EMP E
    JOIN AVG_SAL AVSA ON AVSA.EMPNO = E.MGR 
)
SELECT * FROM AVG_SAL;

WITH AVG_SAL (EMPNO, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP

WHERE MGR IN(7698,7782,7566)
    
    UNION ALL
    
    SELECT 
        E.EMPNO,
        E.MGR,
        E.SAL,
        AVSA.LVL + 1
    FROM EMP E
    JOIN AVG_SAL AVSA ON AVSA.EMPNO = E.MGR 
)
SELECT * FROM AVG_SAL;

SELECT * FROM EMP WHERE EMPNO = 7782;

WITH AVG_SAL (EMPNO, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP
    WHERE MGR IN (7698) OR MGR IS NULL

    UNION ALL

    SELECT 
        E.EMPNO,
        E.MGR,
        E.SAL,
        AVSA.LVL + 1 AS LVL
    FROM EMP E
    JOIN AVG_SAL AVSA ON E.MGR = AVSA.EMPNO 
)
SELECT * 
FROM AVG_SAL;


WITH AVG_SAL (EMPNO, MGR, SAL, LVL) AS (
    SELECT 
        EMPNO,
        MGR,
        SAL,
        1 AS LVL
    FROM EMP
    -- Missing WHERE condition here will result in:
    -- 1. All employees starting at level 1
    -- 2. Potential duplication of employees in the recursive part
    -- Typically, this would include: WHERE MGR IS NULL
    UNION ALL --UNION ALL preserves duplicates (important for recursion)
    
    SELECT 
        E.EMPNO,
        E.MGR,
        E.SAL,
        AVSA.LVL + 1
    FROM EMP E
    JOIN AVG_SAL AVSA ON AVSA.EMPNO = E.MGR 
)
SELECT * FROM AVG_SAL;

--Fakultat--
SELECT 5 * 4 * 3 *2 * 1 FROM DUAL;

-- 5! = 5 * 4! = 5 * (4 * 3!) = 5 * (4 * (3 * 2!)) = 5 * (4 * (3 * (2 * 1!))) 

WITH FACTORIALCTE (NUM, FACTORIAL) AS (
-- Anchor member
SELECT 1, 1 FROM DUAL
    
UNION ALL
-- Recursive member
SELECT 
    NUM + 1,
    FACTORIAL * (NUM + 1)
FROM FACTORIALCTE
    WHERE NUM < 5
)
SELECT * FROM FACTORIALCTE;


WITH COUNTCTE (NUM) AS (
-- Anchor member
SELECT 1 NUM
FROM DUAL

UNION ALL
-- Recursive member
SELECT 
    NUM + 1
FROM COUNTCTE
    WHERE NUM < 5
)
SELECT * FROM COUNTCTE;


