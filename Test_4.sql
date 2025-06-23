SELECT 1 Aufgabe FROM DUAL;
/*
Erläutern Sie ausführlich wofür das im Unterricht besprochene Akronym SQL steht.
Inwiefern deckt sich die Langform dieses Begriffes mit der Realität?
(2)
*/
SQL steht für:Structured Query Language,(auf Deutsch: Strukturierte Abfragesprache)
Structured Query Language


SELECT 2 Aufgabe FROM DUAL;
/*
Erstellen Sie eine SQL-Abfrage, wie folgt:
Zeigen Sie die Team-Nummer (MATCHES.TEAMNO), Stadt (PLAYERS.TOWN),
Spielername (PLAYERS.NAME) und die Summe aus gewonnenen, abzüglich 
der verlorenen Spiele.
Achten Sie auf die (Zwischen-)Summen.

    TEAMNO TOWN       NAME                WLDIFF
---------- ---------- --------------- ----------
         1 Inglewood  Baker                    1
         1 Inglewood  Newcastle               -3
         1 Inglewood                          -2
         1 Stratford  Hope                    -3
         1 Stratford  Brown                    3
         1 Stratford  Everett                 -2
         1 Stratford  Parmenter                4
         1 Stratford                           2
         1                                     0
         2 Eltham     Collins                  1
         2 Eltham     Moorman                  1
         2 Eltham                              2
         2 Plymouth   Bailey                  -3
         2 Plymouth                           -3
         2 Inglewood  Newcastle               -3
         2 Inglewood                          -3
         2                                    -4
                                              -4

18 rows selected. 

(1)
*/
SELECT * FROM matches;
SELECT * FROM players;

/*1*/
SELECT
    m.teamno,
    p.town,
    p.name,
    SUM(m.won - m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno, p.town, p.name);

/*2*/
SELECT
    m.teamno,
    p.town,
    p.name,
    SUM(m.won-m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno,p.town,p.name)
ORDER BY
    GROUPING(m.teamno),
    m.teamno,
    GROUPING(p.town),
    p.town,
    GROUPING(p.name),
    p.name;

/*3 whit Gesamt no NULL*/
SELECT
    CASE WHEN GROUPING(m.teamno) = 1 THEN 'Gesamt' ELSE TO_CHAR(m.teamno) END AS TEAMNO,
    CASE WHEN GROUPING(p.town) = 1 THEN 'Gesamt' ELSE p.town END AS TOWN,
    CASE WHEN GROUPING(p.name) = 1 THEN 'Gesamt' ELSE p.name END AS NAME,
    SUM(m.won - m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno, p.town, p.name);

/*4 CUBE*/
SELECT
    CASE WHEN GROUPING(m.teamno) = 1 THEN 'Gesamt' ELSE TO_CHAR(m.teamno) END AS TEAMNO,
    CASE WHEN GROUPING(p.town) = 1 THEN 'Gesamt' ELSE p.town END AS TOWN,
    CASE WHEN GROUPING(p.name) = 1 THEN 'Gesamt' ELSE p.name END AS NAME,
    SUM(m.won - m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY CUBE(m.teamno, p.town, p.name)
ORDER BY 
    GROUPING(m.teamno),
    m.teamno,
    GROUPING(p.town),
    p.town,
    GROUPING(p.name),
    p.name;

/*4 whit grouping set*/

SELECT
    CASE WHEN GROUPING(m.teamno) = 1 THEN 'Gesamt' ELSE TO_CHAR(m.teamno) END AS TEAMNO,
    CASE WHEN GROUPING(p.town) = 1 THEN 'Gesamt' ELSE p.town END AS TOWN,
    CASE WHEN GROUPING(p.name) = 1 THEN 'Gesamt' ELSE p.name END AS NAME,
    SUM(m.won - m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name),  
    (m.teamno, p.town),          
    (m.teamno),                  
    ()                           
);

SELECT 3 Aufgabe FROM DUAL;
/*
Erstellen Sie eine SQL-Abfrage, wie folgt:
Zeigen Sie die Team-Nummer (MATCHES.TEAMNO), Stadt (PLAYERS.TOWN),
Spielername (PLAYERS.NAME) und die Summe aus gewonnenen, abzüglich 
der verlorenen Spiele.
Achten Sie auf die (Zwischen-)Summen.

TEAMNO                                   TOWN       NAME                WLDIFF
---------------------------------------- ---------- --------------- ----------
1                                        Inglewood  Baker                    1
1                                        Inglewood  Newcastle               -3
1                                        Inglewood  Summe                   -2
1                                        Stratford  Hope                    -3
1                                        Stratford  Brown                    3
1                                        Stratford  Everett                 -2
1                                        Stratford  Parmenter                4
1                                        Stratford  Summe                    2
1                                        Summe      Summe                    0
2                                        Eltham     Collins                  1
2                                        Eltham     Moorman                  1
2                                        Eltham     Summe                    2
2                                        Plymouth   Bailey                  -3
2                                        Plymouth   Summe                   -3
2                                        Inglewood  Newcastle               -3
2                                        Inglewood  Summe                   -3
2                                        Summe      Summe                   -4
Summe                                    Summe      Summe                   -4

18 rows selected.  

(1)
*/
SELECT * from matches;
SElect * from players;

SELECT  
CASE WHEN GROUPING(m.teamno) = 1 THEN 'Summe' ELSE TO_CHAR(m.teamno) END AS Teamno,
CASE WHEN GROUPING(p.town) = 1 THEN 'Summe' ELSE p.town END AS TOWN,
CASE WHEN GROUPING(p.name) = 1 THEN 'Summe' ELSE p.name END AS NAME,
SUM(m.won-m.lost) AS WLDIFF
FROM matches m
join players p
ON m.playerno=p.playerno
GROUP BY ROLLUP(m.teamno,p.town,p.name);
        
/*GROUPING_ID*/

SELECT 
CASE 
    WHEN GROUPING_ID(m.teamno,p.town,p.name)=7 THEN 'Summe' -- all NULL
    WHEN GROUPING_ID(m.teamno,p.town,p.name)IN (6,4) THEN 'Summe' --only teamno and town are NULL
    ELSE TO-CHAR(m.teamno)
END AS TEAMNO,

CASE
    WHEN GROUPING_ID(m.teamno,p.town,p.name) IN(7,6,2) THEN 'Summe'
    ELSE p.town
END AS TOWN,

CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (7, 1) THEN 'Summe'
    ELSE p.name
  END AS NAME,
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno, p.town, p.name)
ORDER BY GROUPING_ID(m.teamno, p.town, p.name);

SELECT
CASE 
WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (7, 6, 4) THEN 'Summe'
    ELSE TO_CHAR(m.teamno)
  END AS TEAMNO,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (7, 6, 2) THEN 'Summe'
    ELSE p.town
  END AS TOWN,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (7, 1) THEN 'Summe'
    ELSE p.name
  END AS NAME,

  SUM(m.won - m.lost) AS WLDIFF
FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno, p.town, p.name);

SELECT 
  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (4, 5, 6, 7) THEN 'Summe' 
    ELSE TO_CHAR(m.teamno)
  END AS TEAMNO,

  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (2, 3, 6, 7) THEN 'Summe'
    ELSE p.town
  END AS TOWN,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (1, 3, 5, 7) THEN 'Summe'
    ELSE p.name
  END AS NAME,

  SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno
GROUP BY ROLLUP(m.teamno, p.town, p.name);



SELECT 4 Aufgabe FROM DUAL;

/*
Erstellen Sie eine SQL-Abfrage, wie folgt:
Zeigen Sie die Team-Nummer (MATCHES.TEAMNO), Stadt (PLAYERS.TOWN),
Spielername (PLAYERS.NAME) und die Summe aus gewonnenen, abzüglich 
der verlorenen Spiele.
Achten Sie auf die (Zwischen-)Summen.

TEAMNO                                   TOWN       NAME                WLDIFF
---------------------------------------- ---------- --------------- ----------
1                                        Stratford  Hope                    -3
Summe                                    Summe      Hope                    -3
1                                        Inglewood  Baker                    1
Summe                                    Summe      Baker                    1
1                                        Stratford  Brown                    3
Summe                                    Summe      Brown                    3
2                                        Plymouth   Bailey                  -3
Summe                                    Summe      Bailey                  -3
2                                        Eltham     Collins                  1
Summe                                    Summe      Collins                  1
1                                        Stratford  Everett                 -2
Summe                                    Summe      Everett                 -2
2                                        Eltham     Moorman                  1
Summe                                    Summe      Moorman                  1
1                                        Inglewood  Newcastle               -3
2                                        Inglewood  Newcastle               -3
Summe                                    Summe      Newcastle               -6
1                                        Stratford  Parmenter                4
Summe                                    Summe      Parmenter                4
Summe                                    Summe      Summe                   -4

20 rows selected. 

(1)
*/


/*No! wrong*/
SELECT 
    CASE
    WHEN GROUPING_ID(m.teamno,p.town,p.name) IN (4,5,6,7) THEN 'Summe'
    ELSE TO_CHAR(m.teamno)
    END AS TEAMNO,
    
    CASE 
    WHEN GROUPING_ID(m.teamno,p.town,p.name) IN (2,3,6,7) THEN 'Summe'
    ELSE p.town
    END AS TOWN,
    
    CASE
    WHEN GROUPING_ID(m.teamno,p.town,p.name) IN (1,3,5,7) THEN 'Summe'
    ELSE p.name
    END AS NAME,

SUM(m.won-m.lost) AS WLDIFF

FROM matches m
JOIN players p
ON m.playerno = p.playerno
GROUP BY CUBE(m.teamno,p.town,p.name)
ORDER BY
 NAME,
 teamno;
 
 /*No! wrong*/
SELECT 
  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe'
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (4,5,6) THEN 'Summe'
    ELSE TO_CHAR(m.teamno)
  END AS TEAMNO,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (2,3,6,7) THEN 'Summe'
    ELSE p.town
  END AS TOWN,

  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (1,3,5,7) THEN 'Summe'
    ELSE p.name
  END AS NAME,

  SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name),  
    (p.name),                   
    ()                          
)
ORDER BY p.name, TEAMNO;

SELECT 
  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 1 THEN 'Summe' -- ???????? ???? ?? name
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe' -- ??????? ????
    ELSE TO_CHAR(m.teamno)
  END AS TEAMNO,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (1, 7) THEN 'Summe'
    ELSE p.town
  END AS TOWN,

  CASE
    WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (1, 7) THEN 'Summe'
    ELSE p.name
  END AS NAME,

  SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name),  -- ?????? ?????
    (p.name),                    -- ???? ?? ???
    ()                           -- ??????? ????
)

ORDER BY 
  p.name,
  TEAMNO;

SELECT 
  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 1 THEN 'Summe'
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe'
    ELSE TO_CHAR(m.teamno)
  END AS TEAMNO,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 1 THEN 'Summe'
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe'
    ELSE p.town
  END AS TOWN,

  CASE 
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 1 THEN p.name
    WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe'
    ELSE p.name
  END AS NAME,

  SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name), -- 
    (p.name),                   --
    ()                          -- 
)

ORDER BY NAME, TEAMNO;

/*right*/
SELECT 
CASE
WHEN GROUPING_ID(m.teamno, p.town, p.name) = 7 THEN 'Summe'
WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (4,5,6) THEN 'Summe'
ELSE TO_CHAR(m.teamno)
END AS TEAMNO,

CASE 
WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (2,3,6,7) THEN 'Summe'
ELSE p.town
END AS TOWN,

CASE
WHEN GROUPING_ID(m.teamno, p.town, p.name) IN (1,3,5,7) THEN 'Summe'
ELSE p.name
END AS NAME,

SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name),  
    (p.name),                   
    ()                          
);

SELECT 
CASE 
WHEN GROUPING(p.town) = 1 THEN 'Summe'
ELSE p.town
END AS TOWN,

CASE 
WHEN GROUPING(p.name) = 1 THEN 'Summe'
ELSE p.name
END AS NAME,

SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (m.teamno, p.town, p.name),  
    (p.name),                    
    ()                           
);

SELECT 5 Aufgabe FROM DUAL;
/*
Erstellen Sie eine SQL-Abfrage, wie folgt:
Zeigen Sie die Stadt (PLAYERS.TOWN), das Geburtsjahr des Spielers
(PLAYERS.YEAR_OF_BIRTH) und die Summe aus gewonnenen, abzüglich 
der verlorenen Spiele.
Achten Sie auf die (Zwischen-)Summen.
Achten Sie auf die Sortierreihenfolge der Sätze.

TOWN       YEAR_OF_BIRTH                                      WLDIFF
---------- ---------------------------------------------- ----------
           Summe                                                  -4
           Summe 1990                                              1
           Summe 1984                                              5
           Summe 1983                                             -2
           Summe 1991                                              3
           Summe 1982                                             -6
           Summe 1968                                             -2
           Summe 1976                                             -3
           Summe Eltham                                            2
           Summe Stratford                                         2
           Summe Inglewood                                        -5
           Summe Plymouth                                         -3
Stratford  1984                                                    4
Stratford  1976                                                   -3
Stratford  1968                                                   -2
Inglewood  1983                                                    1
Inglewood  1982                                                   -6
Plymouth   1983                                                   -3
Stratford  1991                                                    3
Eltham     1984                                                    1
Eltham     1990                                                    1

21 rows selected. 

(4)
*/

SELECT * FROM players;
SELECT * FROM matches;

SELECT
  CASE 
    WHEN GROUPING_ID(p.town, p.year_of_birth) IN (2, 3) THEN ' '
    ELSE p.town
  END AS TOWN,

  CASE 
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 3 THEN 'Summe'
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 2 THEN 'Summe ' || TO_CHAR(p.year_of_birth)
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 1 THEN 'Summe ' || p.town
    ELSE TO_CHAR(p.year_of_birth)
  END AS YEAR_OF_BIRTH,

  SUM(m.won - m.lost) AS WLDIFF

FROM matches m
JOIN players p ON m.playerno = p.playerno

GROUP BY GROUPING SETS (
    (p.town, p.year_of_birth),
    (p.town),
    (p.year_of_birth),
    ()
)

ORDER BY
  CASE 
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 3 THEN 0
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 2 THEN 1
    WHEN GROUPING_ID(p.town, p.year_of_birth) = 1 THEN 2
    ELSE 3
  END,
  p.town,
  p.year_of_birth;
  
SELECT 6 Aufgabe FROM DUAL;
/*
Erstellen Sie ein SQL Query mit dem folgenden Ergebnis:
Mitarbeitername (EMP.ENAME), 
Dauer der Anstellung (ergibt sich aus EMP.HIREDATE) 
in Jahren und Monaten (YM), Dauer der Anstellung in Tagen und
Stunden (DH).
Das Beispiel zeigt das Ergebnis, wenn die Abfrage am 16.6.2025 um
19:45 ausgeführt wird und wird bei jeder Ausführung ein anderes 
Ergebnis liefern, weil sich Ihre Abfrage auf den aktuellen 
Zeitstempel beziehen muss.
Beachten Sie die Sortierung nach absteigendem Dienstalter.

ENAME      YM     DH         
---------- ------ -------------------
SMITH      +44-05 +30 19:45:00.000000
ALLEN      +44-03 +27 19:45:00.000000
WARD       +44-03 +25 19:45:00.000000
JONES      +44-02 +14 19:45:00.000000
BLAKE      +44-01 +15 19:45:00.000000
CLARK      +44-00 +07 19:45:00.000000
TURNER     +43-09 +08 19:45:00.000000
MARTIN     +43-08 +19 19:45:00.000000
KING       +43-06 +30 19:45:00.000000
JAMES      +43-06 +13 19:45:00.000000
FORD       +43-06 +13 19:45:00.000000
MILLER     +43-04 +24 19:45:00.000000
SCOTT      +42-06 +07 19:45:00.000000
ADAMS      +42-05 +04 19:45:00.000000

14 rows selected. 

(3)
*/
SELECT 
  e.ename AS ENAME,
  '+' || EXTRACT(YEAR FROM NUMTODSINTERVAL(SYSTIMESTAMP - e.hiredate, 'DAY')) || '-' ||
  LPAD(EXTRACT(MONTH FROM NUMTODSINTERVAL(SYSTIMESTAMP - e.hiredate, 'DAY')), 2, '0') AS YM,
  '+' || TO_CHAR(SYSTIMESTAMP - e.hiredate, 'DD HH24:MI:SS.FF6') AS DH
FROM emp e
ORDER BY e.hiredate ASC; 

SELECT 
  e.ename AS ENAME,
  '+' || FLOOR(MONTHS_BETWEEN(SYSTIMESTAMP, e.hiredate) / 12) || '-' ||
  LPAD(MOD(FLOOR(MONTHS_BETWEEN(SYSTIMESTAMP, e.hiredate)), 12), 2, '0') AS YM,
  -- Dauer in Tagen und Uhrzeit: +DD HH24:MI:SS.FF6
  '+' || TO_CHAR(SYSTIMESTAMP - e.hiredate, 'DD HH24:MI:SS.FF6') AS DH
FROM emp e
ORDER BY e.hiredate ASC;  -- Dienstalter absteigend

