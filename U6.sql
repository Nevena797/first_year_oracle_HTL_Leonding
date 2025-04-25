/*Übung 6* - zu den Tennisclubtabellen/

/*1. NAME, INITIALS und Anzahl der gewonnenen Sätze für jeden Spieler*/


SELECT * FROM PLAYERS;
SELECT * FROM MATCHES;

SELECT 
    PL.NAME,
    PL.INITIALS, 
    SUM(MA.WON) AS AnzahlDerGewonnenSätze
FROM PLAYERS PL
LEFT JOIN MATCHES MA 
ON PL.PLAYERNO=MA.PLAYERNO
GROUP BY PL.NAME,PL.INITIALS;

/*gewonnen matches (neu: bei ON kann an eine 2.Bedingung schreiben*/


SELECT PL.NAME,
    PL.INITIALS, 
    COUNT(*) GewonnenMatches 
FROM PLAYERS PL
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO 
AND WON > LOST
GROUP BY  PL.NAME, PL.INITIALS;

/* AND gehrt zu ON dazu jetzt sind die null Spieler zurück, bei count wird alles gezählt */

SELECT PL.NAME,
    PL.INITIALS, 
    COUNT(M.PLAYERNO) GewonnenMatches 
    FROM PLAYERS PL 
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO 
AND WON > LOST
GROUP BY  PL.NAME, PL.INITIALS;

/*nun werden nur die gewonnen gezählt */

SELECT PL.NAME,
    PL.INITIALS, 
    COUNT(WON) GewonnenMatches 
FROM PLAYERS PL
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO
AND WON > LOST
GROUP BY  PL.NAME, PL.INITIALS; 
/* das sollte man eher nicht machen, man nimmt eher den primery key oder den foreignkey - nur wenn wirklich nicht anders möglich */

/* 2. NAME, PEN_DATE und AMOUNT absteigend sortiert nach AMOUNT */

SELECT * FROM MATCHES;
SELECT * FROM PLAYERS;
SELECT * FROM PENALTIES;

SELECT PL.NAME,
        PE.PEN_DATE,
        PE.AMOUNT
FROM PLAYERS PL
JOIN PENALTIES PE
ON PL.PLAYERNO = PE.PLAYERNO
GROUP BY PL.NAME, PE.PEN_DATE,PE.AMOUNT
ORDER BY PE.AMOUNT;


SELECT PL.NAME,
    PE.PEN_DATE,
    PE.AMOUNT FROM PLAYERS PL
JOIN PENALTIES PE 
ON PL.PLAYERNO = PE.PLAYERNO 
ORDER BY PE.AMOUNT DESC, PL.NAME; 

/* desc ist immer pro Spalte anzugeben, nicht das ganze ORDER BY */

/* 3. TEAMNO, NAME (des Kapitäns) pro Team */

SELECT T.TEAMNO,
    PL.NAME AS Kapitän
FROM TEAMS T
JOIN PLAYERS PL
ON  PL.PLAYERNO = T.PLAYERNO;

/* 4. NAME (Spielername), WON, LOST aller gewonnenen Matches */

SELECT PL.NAME,
        M.WON,
        M.LOST
FROM PLAYERS PL
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO
WHERE M.WON > M.LOST;

/*5. PLAYERNO, NAME und Strafsumme für jeden Mannschaftsspieler. Hat eine
Spieler noch keine Strafe erhalten, so soll er trotzdem ausgegeben werden.
Die Sortierung soll nach der Höhe der Strafe aufsteigend erfolgen */

SELECT PL.PLAYERNO,
       PL.NAME,
       NVL(SUM(PE.AMOUNT), 0) AS Strafsumme
FROM PLAYERS PL
LEFT JOIN PENALTIES PE ON PL.PLAYERNO = PE.PLAYERNO
GROUP BY PL.PLAYERNO, PL.NAME
ORDER BY Strafsumme DESC;

SELECT  PL.PLAYERNO,
        pl.NAME,
        SUM(PE.AMOUNT) AS Strafsumme
FROM PLAYERS PL 
LEFT JOIN PENALTIES PE
ON PL.PLAYERNO = PE.PLAYERNO
GROUP BY PL.PLAYERNO,PL.NAME
ORDER BY NVL(SUM(PE.AMOUNT),0) ASC;


/*zu EMP-DEPT */

/*6. In welcher Stadt arbeitet der Mitarbeiter Allen?*/

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT
    E.ENAME,
    E.DEPTNO,
    D.LOC
    FROM EMP E
JOIN DEPT d
ON  e.deptno = d.deptno
WHERE E.ENAME = 'ALLEN';

/*7. Gesucht sind alle Mitarbeiter, die mehr verdienen als ihr Vorgesetzter */

SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM empdept;

SELECT 
    Mitarbeiter.Ename AS MAName,
    Mitarbeiter.SAL AS MASAL,
    Boss.SAL
FROM EMP Mitarbeiter
JOIN EMP Boss
ON Boss.EMPNO = Mitarbeiter.MGR
WHERE Mitarbeiter.SAL > Boss.SAL; 

/*8. Ausgabe der Anzahl der Anstellungen in jedem Jahr */

SELECT 
    TO_CHAR(HIREDATE,'YYYY') AS JAHR,
    COUNT(*)
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YYYY');

SELECT COUNT(*) FROM EMP;

/*9. Ausgabe aller Mitarbeiter, die einen Job haben wie ein Mitarbeiter aus CHICAGO */

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT *
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT DISTINCT(JOB)
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE D.LOC = 'CHICAGO';

SELECT * FROM EMP
WHERE JOB IN(
SELECT DISTINCT(JOB)
FROM EMP E
JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE D.LOC = 'CHICAGO'
);
