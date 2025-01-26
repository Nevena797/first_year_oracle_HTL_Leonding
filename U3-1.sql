/*Übung 3 9 – 21 EmpDept-Abfragen*/

/*alle empl mit Name...Wildcard-Suche*/

SELECT * FROM EMP WHERE ENAME LIKE '%S%';
SELECT * FROM EMP WHERE ENAME LIKE '%H';
SELECT * FROM EMP WHERE ENAME LIKE 'S%T%';
SELECT * FROM EMP WHERE ENAME LIKE '%S%T%'; // % KANN AUCH KEIN ZEICHEN SEIN

SELECT * FROM EMP WHERE ENAME LIKE '_L%';
SELECT * FROM EMP WHERE ENAME LIKE '__L%';
SELECT * FROM EMP WHERE ename LIKE '____'; //genau 4 Zeichen

/*9. Ausgabe derjenigen Mitarbeiter, die mehr Provision als Gehalt erhalten. */

SELECT * FROM EMP;

SELECT * FROM EMP WHERE COMM > SAL;

/*10. Ausgabe aller Mitarbeiter aus Abteilung 30, deren Gehalt größer gleich
1500,- ist. */

SELECT * FROM EMP
WHERE SAL >= 1500 AND DEPTNO = 30;
//Exkurs Gesamtgehalt - ohne Blake (TRUE AND null ergibt unbekannt(=null))

SELECT * FROM EMP
WHERE DEPTNO >=30 AND (SAL + COMM)>= 1500;
//damit Blake dabei ist: (Funktion nvl - rechnet er 0 dazu) - die Funktion wandelt NULL in 0 um, deshalb ,0

SELECT * FROM EMP
WHERE DEPTNO >=30 
AND
(SAL + NVL(COMM,0)) >= 1500;

SELECT ENAME,
        SAL,
        COMM,
        NVL(COMM,0),
        SAL + NVL(COMM,0)
FROM EMP
WHERE ((sal + COMM)>=1500 OR SAL >=1500);

/*11.Ausgabe aller Manager, die nicht zu Abteilung 30 gehören.*/

SELECT * FROM EMP;

SELECT ENAME,
        JOB,
        DEPTNO
FROM EMP
WHERE JOB = 'MANAGER' AND DEPTNO !=30;
//oder Manager = Vorgesetzter -> hat Mitarbeiter
SELECT * FROM EMP;

SELECT * FROM EMP E
JOIN EMP M ON M.EMPNO = E.MGR;

SELECT * FROM EMP;


SELECT DISTINCT M.EMPNO,
                M.ENAME,
                M.DEPTNO
FROM EMP E 
JOIN EMP M
ON M.EMPNO = E.MGR 
WHERE M.DEPTNO <> 30;
//gibt nur Nummern aus:

SELECT DISTINCT MGR
FROM EMP 
WHERE MGR IS NOT NULL;

//man will die Manager anzeigen

SELECT * FROM EMP M
JOIN EMP E ON E.MGR= M.EMPNO;


/*12.Ausgabe aller Mitarbeiter aus Abteilung 10, die weder Manager noch Büro-
angestellter (CLERK) sind.*/

SELECT * FROM EMP;
SELECT * FROM EMP
WHERE DEPTNO = 10
AND 
job <> 'MANAGER' 
AND
job <> 'CLERK';

SELECT * FROM EMP
WHERE DEPTNO = 10 
AND
JOB NOT IN('CLERK','MANAGER');
//wenn man nur Clerk und Manager will:

SELECT * FROM EMP
WHERE DEPTNO = 10
AND
JOB IN('CLERK','MANAGER');

//VARIANTE STEURUNGSTABELE

CREATE TABLE EXCLUDEJOBS(
JOB VARCHAR(9)
);

INSERT INTO EXCLUDEJOBS
VALUES('CLERK');

SELECT * FROM EMP 
WHERE DEPTNO = 10
AND 
NOT JOB IN
(
SELECT JOB
FROM EXCLUDEJOBS
);

//OHNE SUB SELECT IST NICHT LOESBAHR(ABER DADUER EMP. * ANSEHEN)

SELECT * FROM EMP;
SELECT * FROM EXCLUDEJOBS;

//SO GEHET ES NICHT
SELECT emp * FROM EMP
LEFT JOIN EXCLUDEJOBS
ON EXCLUDEJOBS.JOB
WHERE deptno = 10;

 
DROP TABLE EXCLUDEJOBS;

/*13.Ausgabe aller Mitarbeiter, die zwischen 1200,- und 1300,- verdienen.*/

SELECT * FROM EMP;
VARIANTE 1

SELECT * FROM EMP
WHERE SAL >= 1200 AND SAL <= 1300;

/* VARIANTE 2sal + comm */

SELECT * FROM EMP
WHERE SAL + (NVL(COMM,0)) >=1200
AND (NVL(COMM,0)) <= 1300;

SELECT * FROM SALGRADE;

//IN () WHAT WE WONT DO NOT TO HAVE

SELECT *
FROM SALGRADE
WHERE NOT (LOSAL < 1200 OR HISAL > 1300);

SELECT * FROM SALGRADE
WHERE LOSAL >=1200 AND HISAL <= 1300;

/*14.Ausgabe aller Mitarbeiter, deren Name 5 Zeichen lang ist und mit ALL beginnt.*/

//FILTER BEISPIEL STRING

SELECT * FROM EMP
WHERE ENAME BETWEEN 'S' AND 'WARD';

SELECT * FROM EMP
WHERE ENAME >'S' AND ENAME >= 'WARD';

SELECT * FROM EMP 
WHERE ENAME >'S' AND ENAME <'WARD';


SELECT * FROM EMP
WHERE LENGTH(ENAME) = 5
AND
ENAME LIKE 'ALL%';

SELECT * FROM EMP
WHERE ENAME LIKE 'ALL__';

SELECT * FROM EMP
WHERE LENGTH(ENAME) = 5 
AND
SUBSTR(ENAME,1,3) = 'ALL';

SELECT * FROM EMP
WHERE SUBSTR(ENAME,1,3) = 'ALL';

/*15.Zu jedem Mitarbeiter soll das ges. Gehalt (Gehalt + Provision) ausgegeben
werden.*/

SELECT *
FROM EMP;

SELECT ENAME,
        JOB,
        SAL,
        COMM,
        SAL + NVL(COMM,0) AS GESGEHALT 
FROM EMP;

/*16.Ausgabe aller Mitarbeiter, deren Provision über 25% des Gehalts liegt.*/

SELECT * FROM EMP
WHERE (sal/4) > COMM; 

SELECT 
        ENAME,
        SAL,
        COMM,
        (COMM/SAL)*100.0 AS COMMPERCENTAGE
FROM EMP
WHERE (COMM/SAL)*100 > 25;

SELECT ENAME,
        SAL,
        COMM,
TO_CHAR(COMM/SAL * 100.0, '9,999.99') || ' %' as "COMM %"
FROM EMP 
WHERE COMM/SAL * 100 > 25;


SELECT ENAME,
        SAL,
        COMM,
TO_CHAR(COMM/SAL * 100.0, '9,999.99') || ' %'  AS "COMM %"
FROM EMP
WHERE COMM/SAL > 0.25;

SELECT ENAME,
        SAL,
        COMM,
TO_CHAR(COMM/SAL * 100.0, '9,999.99') || ' %'  AS "COMM %"
FROM EMP
WHERE COMM > (SAL * 0.25);

/*17.Gesucht ist der durchschnittliche Gehalt aller Büroangestellten.*/

SELECT * FROM EMP;

SELECT AVG(SAL) AS 
DURCHSCHNITT 
FROM EMP WHERE JOB = 'CLERK';
 

/*SELECT ENAME,
        JOB,
        SAL,
        COMM,
        AVG(SAL + NVL(COMM,0)) OVER() AS DURCHSCHNITLICHEGEHALT
FROM EMP;*/
        

/*SELECT 
    ENAME,
    JOB,
    SAL,
    COMM,
    (SAL + NVL(COMM, 0)) AS DURCHSCHNITLICHEGEHALT
FROM EMP
GROUP BY 
    ENAME, JOB, SAL, COMM, (SAL + NVL(COMM, 0));*/
    
/*IM CLASS*/
SELECT * FROM EMP
WHERE JOB = 'CLERK';

SELECT 
    ROUND(AVG(SAL),0) AS DURCHSCHNITTSGEHALTGERUNDET,
    TRUNC(AVG(SAL),0) AS DURCHSCHNITSGEHALTABGESCHNITTEN
FROM EMP
WHERE JOB = 'CLERK';

SELECT 
    ROUND(AVG(SAL),0) ASDURCHSCHNITTSGEHALTGERUNDET,
    TRUNC(AVG(SAL),0) DURCHSCHNITSGEHALTABGESCHNITTEN,
    SUM(SAL) AS SUMSAL,
    COUNT(SAL) AS COUNTSAL
FROM EMP
WHERE JOB = 'CLERK';


/*durchschnitt der Comm aber alle Mitarbeiter auch jene, die keine Comm beziehen*/

SELECT
    AVG(NVL(COMM, 0)) AS AVGCOMM,
    SUM(NVL(COMM, 0)) AS SUMCOMM,
    COUNT(COMM) AS COUNTCOMM
FROM EMP;

/* durchschnitt der comm fur Mitarbeiter mit Comm*/

SELECT
    AVG(COMM) AS AVGCOMM,
    SUM(COMM) AS SUMCOMM,
    COUNT(COMM) AS COUNTCOMM
FROM EMP;

/*18.Gesucht ist die Anzahl der Mitarbeiter, die eine Provision erhalten haben.*/
/*Achtung 0 != NULL!!!*/

SELECT * FROM EMP;

SELECT 
    COUNT(*)
FROM EMP
WHERE COMM IS NOT NULL;
--4 Sätze

SELECT 
    COUNT(COMM)
FROM EMP
WHERE COMM > 0;
---- 3 Sätze

SELECT 
    COUNT(*)
FROM EMP
WHERE COMM > 0;
---- 3 Sätze

/*19.Gesucht ist der Anzahl der verschiedenen Jobs in Abteilung 30.*/

SELECT 
    DISTINCT(JOB) 
FROM EMP;

SELECT 
    COUNT(DISTINCT (JOB))
FROM EMP;

SELECT * FROM EMP
WHERE DEPTNO = 30; 
//4 X SALESMAN + MANAGER + CLERK

/*RICHTIG*/
SELECT 
    COUNT(DISTINCT (JOB))
FROM EMP
WHERE DEPTNO = 30;
//3 UNTERSCHIEDENE JOBS

/* 20.Gesucht ist die Anzahl der Mitarbeiter in Abteilung 30.*/
SELECT 
    COUNT(*)
FROM EMP
WHERE DEPTNO = 30;
//4 X SALESMAN + MANAGER + CLERK = 6 INSGESAMT 

//20a in der Abteilung mit Nahmen "SALESMAN"

SELECT * FROM EMP;
SELECT * FROM DEPT;

SELECT *
FROM EMP E
JOIN DEPT D
ON D.DEPTNO = E.DEPTNO;


SELECT COUNT(*)
FROM EMP E
JOIN DEPT D 
ON D.DEPTNO = E.DEPTNO
WHERE DNAME = 'SALES';

SELECT * FROM EMP;
SELECT * FROM SALGRADE; 
SELECT * FROM DEPT;


SELECT EMP.EMPNO,
        DEPT.DEPTNO,
        SALGRADE.GRADE 
FROM EMP
JOIN DEPT 
ON DEPT.DEPTNO = EMP.DEPTNO
JOIN SALGRADE 
ON SALGRADE.LOSAL <= EMP.SAL
AND SALGRADE.HISAL >= EMP.SAL
WHERE DNAME = 'SALES';

/*21.Ausgabe der Mitarbeiter, die zwischen 4.1.81 und 15.4.81 angestellt worden
sind.*/

SELECT * FROM EMP
WHERE HIREDATE >= TO_DATE('1981-01-04','YYYY-MM-DD')
AND HIREDATE <= TO_DATE('1981-04-16','YYYY-MM-DD');

SELECT * FROM EMP
WHERE HIREDATE >= TO_DATE('1981-01-04','YYYY-MM-DD')
AND HIREDATE < TO_DATE('1981-04-15','YYYY-MM-DD') + 1 ;










