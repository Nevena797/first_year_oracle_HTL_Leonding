/*Übung */
/*2 Erzeugen der Tabellen DEPT und EMP aus der Datei dept_emp.sql.*/

drop table emp;
drop table dept;
drop table salgrade;

CREATE TABLE DEPT (
 DEPTNO              NUMBER(2) CONSTRAINT DEPT_PRIMARY_KEY PRIMARY KEY,
 DNAME               VARCHAR2(14),
 LOC                 VARCHAR2(13));

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) CONSTRAINT EMP_PRIMARY_KEY PRIMARY KEY , 
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) CONSTRAINT EMP_SELF_KEY REFERENCES EMP (EMPNO),
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) NOT NULL CONSTRAINT EMP_FOREIGN_KEY REFERENCES DEPT (DEPTNO));

 /* disable constraint until we have the data in */
alter table emp disable constraint EMP_SELF_KEY;

INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,TO_DATE('17/12/1980','DD/MM/YYYY'),800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,TO_DATE('20/02/1981','DD/MM/YYYY'),1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,TO_DATE('22/02/1981','DD/MM/YYYY'),1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,TO_DATE('02/04/1981','DD/MM/YYYY'),2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,TO_DATE('28/09/1981','DD/MM/YYYY'),1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,TO_DATE('01/05/1981','DD/MM/YYYY'),2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,TO_DATE('09/06/1981','DD/MM/YYYY'),2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,TO_DATE('09/12/1982','DD/MM/YYYY'),3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,TO_DATE('17/11/1981','DD/MM/YYYY'),5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,TO_DATE('08/09/1981','DD/MM/YYYY'),1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,TO_DATE('12/01/1983','DD/MM/YYYY'),1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,TO_DATE('03/12/1981','DD/MM/YYYY'),950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,TO_DATE('03/12/1981','DD/MM/YYYY'),3000,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,TO_DATE('23/01/1982','DD/MM/YYYY'),1300,NULL,10);

alter table emp enable constraint EMP_SELF_KEY;
  
CREATE TABLE SALGRADE (
 GRADE               NUMBER,
 LOSAL               NUMBER,
 HISAL               NUMBER);
 
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

DROP TABLE DUMMY;
 
CREATE TABLE DUMMY (
 DUMMY               NUMBER );
 
INSERT INTO DUMMY VALUES (0);
COMMIT;

/*2. Einfache Ausgabe 1 */

SELECT 
    DNAME AS ABTEILUNGSNAME,
FROM DEPT;

/*3. Datumsausgabe Ausgabe von EMPNO, ENAME und HIREDATE (Format DD. Month YYYY) zu jedem Angestellten.*/

SELECT 
    EMPNI,
    ENAME,
    HIREDATE
FROM EMP;

SELECT  
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE, 'DD Month YYYYY') AS HIREDATE
FROM EMP;

SELECT 
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE, 'DD.Month Year') AS HIREDATE
FROM EMP;

SELECT
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE, 'YYYY-MM-DD') AS HIREDATE
FROM EMP;

SELECT
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE,'Year') AS HIREDATE
FROM EMP;

SELECT 
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE,'YEAR') AS HIREDATE
FROM EMP;

SELECT 
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE,'YYYY-MM-DD') AS HIREDATE
FROM EMP;

/* Exkurs:Nur jene die am 1980-12-17 angestellt wurden */
SELECT 
    EMPNO,
    ENAME,
    TO_CHAR(HIREDATE, 'YYYY-MM-DD')AS HIREDATE
    FROM EMP 
WHERE HIREDATE = TO_DATE('1980-12-17','YYYY-MM-DD');


/*4. Datumsausgabe
Ausgabe von ENAME und Anzahl der Tage seit Eintritt in die
Firma (Spaltenüberschrift TAGE) zu jedem Angestellten.*/

SELECT * FROM EMP;
SELECT * FROM DUAL; //dual ist eine leere Tabelle in Oracle
SELECT SYSDATE from DUAL; /*sysdate ist immer das aktuelle Datum 
(ACHTUNG: Uhrzeit ist auch dabei, nur diese wird nicht angezeigt)*/


SELECT 
    TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS')
FROM DUAL;

SELECT 
    ENAME,
    TO_CHAR(HIREDATE,'YYYY-MM-DD HH:MI:SS') AS HIREDATE,
    TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS') AS "SYSDATE",
    TRUNC(SYSDATE-HIREDATE)TAGE 
FROM EMP;

/*5.Einfache Ausgabe 2
Ausgabe der Jobs (je Job nur 1 Ausgabe). */

SELECT JOB
FROM EMP;

SELECT 
    DISTINCT JOB,
    DEPTNO
FROM EMP;

/*6. MinMax-Ausgabe Ausgabe des minimalen, maximalen und durchschnittlichen Gehalts. */

SELECT SAL FROM EMP;

SELECT MIN(SAL) FROM EMP;

SELECT MIN(SAL) 
    FROM EMP 
WHERE SAL>= 3000;

SELECT 
    MIN(SAL) AS MINSAL,
    MAX(SAL) AS MAXSAL,
    AVG(SAL) AS AVGSAL
FROM EMP;

SELECT
    MIN(SAL) AS MINSAL, 
    MAX(SAL) AS MAXSAL,
    TRUNC(AVG(SAL),4) AS AVGSALTRUNK
FROM EMP;

SELECT
    MIN(SAL) AS MINSAL,
    MAX(SAL) AS MAXSAL,
    ROUND(AVG(SAL),4) AS AVGSALROUND
FROM EMP;

SELECT * FROM EMP;

SELECT 
    MIN(SAL) AS MINSAL,
    MAX(SAL) AS MAXSAL,
    COUNT(SAL) AS COUNTSAL,
    COUNT(COMM) AS COUNTCOMM,
    COUNT(*) AS COUNTSTAR
FROM EMP;

SELECT
    MIN(SAL) AS MINSAL,
    MAX(SAL) AS MAXSAL,
    COUNT(SAL) AS COUNTSAL,
    COUNT(COMM) AS COUNTCOMM,
    COUNT(*) AS COUNTSTAR,
    SUM(SAL) AS SUMSAL,
    SUM(SAL) /COUNT(SAL) AS AVGSAL2,
    SUM(SAL) + SUM(COMM) AS SUMCOMM
FROM EMP;

/*7. Zählen 1
Statement zur Ermittlung von „Wie viele Angestellte gibt es?“.*/

SELECT CAUNT(*) FROM EMP;

/*8. Zählen 2
Statement zur Ermittlung von „Wie viele unterschiedliche Jobs gibt es?“.*/

SELECT COUNT(DISTINCT JOB) FROM EMP;
