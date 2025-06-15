 /*Data Defintion Laguage (DDL)*/
 
SELECT 1 + 2 + 3
FROM DUAL;

SELECT * FROM emp
--WHERE JOB LIKE '%MAN_';
--WHERE JOB LIKE '%MAN%';
--WHERE JOB LIKE 'MAN%';
WHERE JOB LIKE '%MAN';

SELECT * FROM PLAYERS;

SELECT 
    NAME,
    UPPER(NAME),
    LOWER(NAME)
FROM PLAYERS;

SELECT ENAME,
    INITCAP(ENAME) 
FROM EMP;

SELECT
    STREET,
    LOWER(STREET),
    INITCAP(LOWER(STREET))
FROM PLAYERS;

SELECT * FROM PLAYERS;

SELECT NAME,
        INITIALS,
        CONCAT(CONCAT(NAME,' '),INITIALS),
        NAME || ' ' || INITIALS
FROM PLAYERS;

SELECT NAME,
    SUBSTR(NAME,1,3),
    SUBSTR(NAME,4,1)
FROM PLAYERS;

SELECT NAME,
    LENGTH(NAME),
    LENGTH(NAME ||STREET)
FROM PLAYERS;

-- Benutzen von Aliase
SELECT NACHNAME,
       LENGTH(NACHNAME) LANGE
FROM (
    SELECT NAME NACHNAME
    FROM PLAYERS
)
WHERE NACHNAME LIKE '%e%';

SELECT
    NAME,
    INSTR(NAME, 'a'),-- an welcher Stelle der Buchstabe erstmals vorkommt
    INSTR(NAME, 'o', 3)-- Suche nach der 3. Stelle 
FROM PLAYERS;

SELECT
    NAME,
    RPAD(name, 20, '*'),
    RPAD(name, 20, '*')
FROM
    PLAYERS;

SELECT
    TRIM('P' FROM NAME)
    --TRIM('Pa' FROM NAME)/*do not work so*/
FROM
    PLAYERS;
    
SELECT TRIM('P' FROM NAME) FROM PLAYERS;

SELECT NAME,
    '|' || NAME || '|',
    '|' || LTRIM(NAME) || '|',
    '|' || RTRIM(NAME) || '|',
    '|' || TRIM(NAME) || '|'
FROM
(SELECT ' ' || NAME || ' ' NAME FROM PLAYERS);

SELECT TRIM('P' from name) FROM PLAYERS; /* Nur ein Zeichen moeglich*/
SELECT NAME FROM PLAYERS;
SELECT NAME, REPLACE(NAME, 'C', 'K') FROM PLAYERS;

SELECT 45.926, ROUND(45.926), TRUNC(45.926) FROM DUAL;

SELECT
    5,
    5/4,
    MOD(9,4)
FROM DUAL;

SELECT
    SYSDATE
FROM
    DUAL
WHERE
    SYSDATE = TO_DATE('15.06.25', 'DD.MM.YY');
    
SELECT SYSDATE
FROM DUAL
WHERE TRUNC(SYSDATE) = TO_DATE('15.06.25', 'DD.MM.YY');
    
SELECT
    SYSDATE,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
    TO_CHAR(TO_DATE('15.06.25', 'DD.MM.YY'), 'YYYY-MM-DD HH24:MI:SS')
FROM
    DUAL; 
    

