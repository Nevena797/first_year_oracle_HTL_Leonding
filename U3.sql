/*1-7 Tennis-Abfragen  Übung 3 */

/*1. Ausgabe von PLAYERNO, NAME der Spieler, die nach 1980 geboren sind.*/


SELECT PLAYERNO,
        NAME 
FROM Players;

SELECT PLAYERNO,
            NAME,
            YEAR_OF_BIRTH
FROM PLAYERS
WHERE YEAR_OF_BIRTH > 1980;

/*2. Ausgabe von PLAYERNO, NAME und TOWN aller weiblichen Spieler, die
nicht in Stratford wohnen.*/

SELECT PLAYERNO, NAME, TOWN FROM PLAYERS;

SELECT PLAYERNO, NAME, TOWN FROM Players WHERE Sex = 'F';

SELECT PLAYERNO,
            NAME,
            TOWN
FROM PLAYERS
WHERE SEX='F' 
AND TOWN !='Stratford';

SELECT PLAYERNO,
            NAME,
            TOWN
FROM PLAYERS
WHERE SEX ='F' 
AND TOWN <> 'Stratford';

SELECT PLAYERNO,
            NAME,
            TOWN
FROM PLAYERS
WHERE SEX = 'F' AND TOWN <> 'Midhurst';
        

/*3. Ausgabe der Spielernummern der Spieler, die zwischen 1990 und 2000 dem
Club beigetreten sind. */

SELECT * FROM PLAYERS;

SELECT PLAYERNO
    FROM PLAYERS
WHERE YEAR_JOINED >= 1990 AND YEAR_JOINED <= 2000; 
        
SELECT PLAYERNO
    FROM PLAYERS
WHERE YEAR_JOINED BETWEEN 1990 AND 2000;

/* 4. Ausgabe von SpielerId, Name, Geburtsjahr der Spieler, die in einem Schaltjahr
geboren sind.*/
/*Schaltjahr :=
a)Jahr is durch 4 ohne Rest teilbahr
b)Wenn das Jahr durch 100 ohne Rest teilbahr ist ,ist nur dann
ein Schalthajr,wenn es auch durch 400 ohne Rest teilbahr ist.*/


SELECT * FROM PLAYERS;

SELECT YEAR_OF_BIRTH FROM PLAYERS;

SELECT * FROM PLAYERS
WHERE MOD(YEAR_OF_BIRTH,4) = 0;
/* WENN NICHT TRUE, KOMMT NICHTS ANGEZEIGT*/

SELECT * FROM PLAYERS
WHERE(MOD(YEAR_OF_BIRTH,4) = 0 AND MOD(YEAR_OF_BIRTH,100)!=0)
OR
(MOD(YEAR_OF_BIRTH,400)=0);

SELECT * FROM dual
WHERE 
    (MOD(1900,4) = 0 AND MOD(1900,100)!=0)
OR (MOD(1900,400) = 0);

SELECT 
    PLAYERNO,
    NAME,
    YEAR_OF_BIRTH
FROM 
    PLAYERS
WHERE 
    MOD(YEAR_OF_BIRTH, 4) = 0
    AND (MOD(YEAR_OF_BIRTH, 100) != 0 OR MOD(YEAR_OF_BIRTH, 400) = 0);


/*5. Ausgabe der Strafennummern der Strafen zwischen 50,- und 100,-.*/

SELECT * FROM PENALTIES;

SELECT PAYMENTNO,
        AMOUNT
FROM PENALTIES
WHERE AMOUNT >=50 AND AMOUNT <=100;

/* BETWEEN NICHT BEIM DATUM IN ORACKLE BENUTZEN*/

SELECT * FROM EMP ORDER BY ENAME;

SELECT * FROM EMP
--ORDER BY ENAME;
WHERE ENAME BETWEEN 'ALEEN' AND 'SCOTT'
ORDER BY ENAME;

/*6. Ausgabe von SpielerId, Name der Spieler, die nicht in Stratford oder Douglas
leben.*/

SELECT * FROM PLAYERS;

SELECT * FROM PLAYERS
WHERE TOWN <>'Stratford'
AND
TOWN <> 'Douglas';

SELECT * FROM PLAYERS
WHERE TOWN !='Stratford'
AND
TOWN != 'Douglas';

SELECT * 
FROM PLAYERS
WHERE NOT TOWN 
IN('Stratford','Douglas');

SELECT * 
FROM PLAYERS
WHERE TOWN NOT 
IN('Stratford','Douglas');

/*7. Ausgabe von SpielerId und Name der Spieler, deren Name 'is' enthält.*/

SELECT 
    PLAYERNO,
    NAME
FROM PLAYERS
WHERE NAME LIKE '%is%';

/*8. Ausgabe aller Hobbyspieler.*/

SELECT NAME,
    LEAGUENO
FROM PLAYERS
WHERE LEAGUENO IS NULL;

//EXKURS

SELECT * FROM EMP;

/*FALSH!!! SO NICHT SCHREIBEN, WEIL DA IM DATUM UHRYEIT MITGESPEICHERT WIRD
UND DAS DATUMBEGINT MIT O UHR(DESHALB IST DIESE TAG NICHT DABEI)*/

/*SELECT * FROM EMP
WHERE HIREDATE BETWEEN TO_DATE('1980-12-17','YYYY-MM-DD')
AND
TO_DATE('1982-02-21','YYYY-MM-DD');
*/

/*SO IST RICHTIG*/
SELECT * FROM EMP 
WHERE HIREDATE >= TO_DATE('1980-12-17','YYYY-MM-DD')
AND HIREDATE < TO-DATE('1982-02-21', 'YYYY-MM-DD');

SELECT * FROM EMP 
WHERE HIREDATE >= TO_DATE('1980-01-01','YYYY-MM-DD')
AND HIREDATE < TO_DATE('1983-01-01','YYYY-MM-DD');

SELECT * FROM emp 
WHERE HIREDATE >= to_date('1980-01-01', 'YYYY-MM-DD') 
AND HIREDATE <= to_date('1982-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS') ;






