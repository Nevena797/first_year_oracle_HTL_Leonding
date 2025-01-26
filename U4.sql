/*Übung 4 Tennis-Abfragen */

/*1. Ausgabe von TEAMNO der Teams, in denen nicht der Spieler mit der Nummer
27 Kapitän ist.*/

SELECT * FROM TEAMS;


SELECT * FROM TEAMS
WHERE PLAYERNO !=27;

SELECT * FROM TEAMS
WHERE PLAYERNO <> 27;

/*2. Ausgabe von PLAYERNO, NAME und INITIALS der Spieler, die mindestens
ein Match gewonnen haben.*/

SELECT * FROM PLAYERS;
SELECT * FROM MATCHES;

SELECT *
FROM PLAYERS P
JOIN MATCHES M
ON M.PLAYERNO = P.PLAYERNO;

SELECT P.PLAYERNO,
            P.NAME,
            P.INITIALS
FROM PLAYERS P
JOIN MATCHES M
ON M.PLAYERNO = P.PLAYERNO
WHERE M.WON > M.LOST;


SELECT P.PLAYERNO,
        P.NAME,
        P.INITIALS
FROM PLAYERS P
JOIN MATCHES M
ON M.PLAYERNO = P.PLAYERNO
WHERE M.WON > 0;

/* 3. Ausgabe von SpielerNr und Name der Spieler, die mindestens eine Strafe
erhalten haben.*/

SELECT * FROM PENALTIES;
SELECT * FROM PLAYERS;

SELECT PL.PLAYERNO,
        PL.NAME
FROM PLAYERS PL
JOIN PENALTIES PN
ON P.PLAYERNO = PN.PLAYERNO;

/*4. 4. Ausgabe von SpielerNr und Name der Spieler, die mindestens eine Strafe
über 50.- erhalten haben.*/

SELECT * FROM PENALTIES;

SELECT DISTINCT PL.PLAYERNO,PL.NAME
FROM PLAYERS PL
JOIN PENALTIES PE ON PE.PLAYERNO = PL.PLAYERNO
WHERE PE.AMOUNT >= 50;

/*5. Ausgabe von SpielerNr und Name der Spieler, die im selben Jahr wie R. Parmenter
geboren sind.*/

SELECT * FROM PLAYERS;

SELECT *
FROM PLAYERS
WHERE NAME = 'Parmenter' 
AND INITIALS = 'R';

SELECT *
FROM PLAYERS
WHERE YEAR_OF_BIRTH = 1984;

SELECT *
FROM PLAYERS
WHERE YEAR_OF_BIRTH = (
SELECT YEAR_OF_BIRTH
FROM PLAYERS
WHERE NAME = 'Parmenter' AND INITIALS = 'R'
)
AND NOT (NAME = 'Parmenter' and INITIALS = 'R');
--and name <> 'Parmeter' and Initials <> 'R';

SELECT * FROM PLAYERS
WHERE YEAR_OF_BIRTH = (
SELECT YEAR_OF_BIRTH
FROM PLAYERS
WHERE NAME = 'Parmenter' AND INITIALS = 'R'
)
AND
NAME <> 'Parmeter' AND INITIALS = 'R';

/*6. Ausgabe von SpielerNr und Name des ältesten Spielers aus Stratford */

SELECT MIN(YEAR_OF_BIRTH)
FROM PLAYERS;

SELECT * 
FROM PLAYERS
WHERE YEAR_OF_BIRTH = 1968;

SELECT * FROM PLAYERS;

SELECT * 
FROM PLAYERS
WHERE YEAR_OF_BIRTH = (
SELECT MIN(YEAR_OF_BIRTH)
FROM PLAYERS
WHERE TOWN = 'Stratford')
AND TOWN = 'Stratford';

/*Übung 4 zu EMP-DEPT */

/*7. Gesucht sind alle Abteilungen, die keine Mitarbeiter beschäftigen.*/

SELECT * FROM EMP;

SELECT * FROM DEPT;

SELECT 
    DISTINCT DEPTNO
FROM EMP;

SELECT * FROM DEPT
WHERE DEPTNO = 40; 

SELECT * 
FROM DEPT
INNER JOIN EMP
ON EMP.DEPTNO = DEPT.DEPTNO;

SELECT *
FROM DEPT DE
LEFT OUTER JOIN EMP EMP
ON DE.DEPTNO = EMP.DEPTNO
WHERE ENAME IS NULL;

/*SUBQUERY*/

SELECT DISTINCT DEPTNO FROM EMP;

SELECT * FROM DEPT
WHERE DEPTNO NOT IN(10,20,30);
/*-> So ist nicht richtig. Das muss funktionieren auch, wenn die daten sich ändern */ 

/*Richtig*/

SELECT * FROM DEPT
WHERE DEPTNO NOT IN(
SELECT DISTINCT DEPTNO FROM EMP);

/*8. Gesucht sind alle Mitarbeiter, die den gleichen Job wie JONES haben */
SELECT * FROM EMP
WHERE ENAME = 'JONES';

/*-> falsch */
SELECT * FROM EMP
WHERE JOB = 'MANAGER';

/*-RICHTIG*/

SELECT *
FROM EMP 
WHERE JOB = (
SELECT JOB FROM EMP WHERE ENAME = 'JONES');

/*9. Anzeigen aller Mitarbeiter, die mehr verdienen als irgendein Mitarbeiter aus
Abteilung 30 */

SELECT * FROM EMP;

SELECT MIN(SAL) FROM EMP
WHERE DEPTNO = 30;

SELECT * FROM EMP WHERE SAL >
(
SELECT MIN(SAL) FROM EMP WHERE DEPTNO=30
);

/*10.Anzeigen aller Mitarbeiter, die mehr verdienen als jeder Mitarbeiter aus Abteilung
30*/

SELECT * FROM EMP;

SELECT MAX(SAL) FROM EMP
WHERE DEPTNO = 30;

SELECT * FROM EMP
WHERE SAL >
(
SELECT MAX(SAL) FROM EMP WHERE DEPTNO = 30
);

/* 11.Anzeigen aller Mitarbeiter aus Abteilung 10, deren Job von keinem Mitarbeiter
aus Abteilung 30 ausgeübt wird */

SELECT * FROM EMP WHERE DEPTNO = 10;

SELECT DISTINCT JOB FROM EMP WHERE DEPTNO = 30;

/*->falsch */

SELECT * FROM EMP WHERE DEPTNO = 10
AND JOB NOT IN ('MANAGER', 'CLERK', 'SALESMAN'); 

SELECT * FROM EMP 
WHERE DEPTNO = 10
AND JOB NOT IN (
SELECT DISTINCT JOB
FROM EMP WHERE DEPTNO = 30
);

SELECT * 
FROM EMP 
WHERE DEPTNO = 10
AND JOB NOT IN (
SELECT JOB FROM EMP
WHERE DEPTNO = 30
);

/*12.Gesucht sind die Mitarbeiterdaten (EMPNO, ENAME, JOB, SAL) des Mitarbeiters
mit dem höchsten Gehalt */

SELECT MAX(SAL) FROM EMP;

SELECT * FROM EMP
WHERE SAL = 5000;

SELECT * FROM EMP
WHERE SAL =(
SELECT MAX(SAL) FROM EMP
);





