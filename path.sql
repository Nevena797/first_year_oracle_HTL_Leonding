SELECT * FROM PARTS;

WITH PARTSCTE(SUB,SUPER,PRICE)AS(
SELECT
    SUB,
    SUPER,
    PRICE 
    FROM PARTS
    WHERE SUPER IN ('P3','P9')
    
UNION ALL
    SELECT 
    PARTS.SUB,
    PARTS.SUPER,
    PARTS.PRICE
    FROM PARTS
JOIN PARTSCTE
ON PARTS.SUB = PARTS.SUPER
)
SELECT * FROM PARTSCTE;
/* 1. Alle Unterteile eines Teils (z.?B. P1) anzeigen – Hierarchische Abfrage*/
SELECT sub, super, price, LEVEL
FROM parts
START WITH sub = 'P1'
CONNECT BY PRIOR sub = super;

/* 2. Gesamtkosten aller Teile unterhalb eines Teils (inkl. Wurzelteil)*/

SELECT SUM(price) AS total_price
FROM parts
START WITH sub = 'P1'
CONNECT BY PRIOR sub = super;

 /*3. Alle Endteile (Blätter) anzeigen – Teile, die keine Unterteile haben */
 
SELECT SUB,PRICE
FROM PARTS
WHERE SUB NOT IN (SELECT DISTINCT SUPER FROM PARTS WHERE SUPER IS NOT NULL);

/* 4. Zyklische Strukturen erkennen/verhindern */
SELECT SUB, SUPER, PRICE, LEVEL, CONNECT_BY_ISCYCLE /* unterdrückt endlose Schleifen*/
FROM PARTS
START WITH SUB = 'P1'
CONNECT BY NOCYCLE PRIOR SUB = SUPER;

/*5.Anzeige der Hierarchie als Strukturbaum (formatierte Ausgabe)*/

SELECT LPAD('',LEVEL *2) || SUB AS PART_TREE,PRICE
FROM PARTS
START WITH SUB = 'P1'
CONNECT BY PRIOR SUB = SUPER;

WITH PARTCTE(SUB, SUPER, PRICE) AS (
  SELECT SUB, SUPER, PRICE
  FROM PARTS
  WHERE SUPER IN ('P3', 'P9')

  UNION ALL


  SELECT P.SUB, P.SUPER, P.PRICE
  FROM PARTS P
  JOIN PARTCTE C ON C.SUB = P.SUPER
)
SELECT * FROM PARTCTE;

/*6 Aufgabe: Alle direkten 
und indirekten Unterteile eines gegebenen Teils (z.B. P1) anzeigen*/

WITH PARTSCTE(SUB,SUPER,PRICE) AS(
SELECT SUB,SUPER,PRICE
FROM PARTS
WHERE SUB = 'P1'
UNION ALL
SELECT P.SUB,P.SUPER,P.PRICE
FROM PARTS P
JOIN PARTSCTE C
ON C.SUB = P.SUPER
)
SELECT * FROM PARTSCTE;

/*3. Aufgabe: Berechnen Sie die Gesamtkosten 
eines Teils und aller seiner Unterteile */

WITH PARTCTE (SUB,SUPER,PRICE) AS (
  SELECT SUB, SUPER, PRICE FROM PARTS WHERE SUB = 'P1'
  UNION ALL
  SELECT P.SUB, P.SUPER, P.PRICE
  FROM PARTS P
  JOIN PARTCTE C ON C.SUB = P.SUPER
)
SELECT SUM(PRICE) AS total_price
FROM PARTCTE;

/*4. Aufgabe: Leiten Sie alle finiten Komponenten (Listen) ab */
SELECT * FROM PARTS;

SELECT SUB 
FROm PARTS
WHERE SUB NOT IN
(SELECT DISTINCT SUPER
FROM PARTS 
WHERE SUPER IS NOT NULL);

/*5. Aufgabe: Teilehierarchie mit Verschachtelungsebene darstellen */

SELECT SUB,SUPER,PRICE,LEVEL
FROM PARTS
START WITH SUB = 'P1'
CONNECT BY PRIOR SUB = SUPER;

/*-- 2. Alle Unterteile von P3 und P9 über rekursive CTE */

WITH PARTCTE(SUB, SUPER, PRICE) AS (
    SELECT SUB, SUPER, PRICE FROM PARTS WHERE SUPER IN ('P3', 'P9')
    UNION ALL
    SELECT P.SUB, P.SUPER, P.PRICE
    FROM PARTS P
    JOIN PARTCTE C ON C.SUB = P.SUPER
)
SELECT * FROM PARTCTE;

/*3. Alle Teile unter P1 (einschließlich P1) durch Rekursion */

WITH PARTCTE (SUB, SUPER, PRICE, LVL, PATH) AS (
    -- Anchor: Starte bei P1 (Wurzelteil)
    SELECT SUB, SUPER, PRICE, 1 AS LVL, SUB AS PATH
    FROM PARTS
    WHERE SUB = 'P1'

    UNION ALL

    -- Rekursion: Finde Teile, die von vorherigen abhängen
    SELECT P.SUB, P.SUPER, P.PRICE, C.LVL + 1, C.PATH || ' ? ' || P.SUB
    FROM PARTS P
    JOIN PARTCTE C ON P.SUPER = C.SUB
)
SELECT * FROM PARTCTE
ORDER BY LVL;

/* Zeige alle Komponenten unterhalb von P3 mit Hierarchie-Level und Pfad */

WITH PARTCTE (SUB, SUPER, PRICE, LVL, PATH) AS (
    -- Erste Stufe: Direktteile von P3
    SELECT SUB, SUPER, PRICE, 1 AS LVL, SUB AS PATH
    FROM PARTS
    WHERE SUPER = 'P3'

    UNION ALL

    -- Rekursive Stufen: Teile von vorher gefundenen Teilen
    SELECT P.SUB, P.SUPER, P.PRICE, C.LVL + 1, C.PATH || '->' || P.SUB
    FROM PARTS P
    JOIN PARTCTE C ON P.SUPER = C.SUB
)
SELECT * FROM PARTCTE;

/*3. An welcher Hierarchiestufe wird P12 in P1 verwendet */

WITH PARTSCTE(SUB,SUPER,LVL)AS 
(  -- Basisfall: Starte von P1
SELECT SUB,SUPER,1 AS LVL
FROM PARTS
WHERE SUPER = 'P1'

UNION ALL
-- Rekursiver Teil

SELECT P.SUB,P.SUPER,C.LVL +1
FROM PARTS P
JOIN PARTSCTE C ON P.SUPER = C.SUB
)
SELECT SUB,SUPER,LVL FROM PARTSCTE
WHERE SUB = 'P12';

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


WITH PARTCTE (SUB, SUPER, PRICE, LVL, TEILNAME, PATH) AS (
    SELECT
        SUB,
        SUPER,
        PRICE,
        0 AS LVL,
        SUB || ' ($' || TO_CHAR(PRICE) || ')' AS TEILNAME,
        SUB AS PATH
    FROM PARTS
    WHERE SUB = 'P3'  -- Starte mit Teil P3

    UNION ALL

    SELECT
        P.SUB,
        P.SUPER,
        P.PRICE,
        CTE.LVL + 1 AS LVL,
        LPAD(' ', 4 * (CTE.LVL + 1)) || P.SUB || ' ($' || TO_CHAR(P.PRICE) || ')' AS TEILNAME,
        CTE.PATH || '-' || P.SUB AS PATH
    FROM PARTS P
    JOIN PARTCTE CTE ON CTE.SUB = P.SUPER
)
SELECT TEILNAME
FROM PARTCTE
WHERE LVL > 0
ORDER BY PATH;

/*? Ziel: Zeige alle Teile, die in P1 enthalten sind, hierarchisch eingerückt*/
WITH PARTCTE (SUB, SUPER, PRICE, LVL, TEILNAME, PATH) AS (
    -- Start: Wurzelteil P1
    SELECT
        SUB,
        SUPER,
        PRICE,
        0 AS LVL,
        SUB || ' ($' || TO_CHAR(PRICE) || ')' AS TEILNAME,
        SUB AS PATH
    FROM PARTS
    WHERE SUB = 'P1'

    UNION ALL

    -- Rekursion: finde untergeordnete Teile
    SELECT
        P.SUB,
        P.SUPER,
        P.PRICE,
        CTE.LVL + 1,
        LPAD(' ', 4 * (CTE.LVL + 1)) || P.SUB || ' ($' || TO_CHAR(P.PRICE) || ')' AS TEILNAME,
        CTE.PATH || '-' || P.SUB
    FROM PARTS P
    JOIN PARTCTE CTE ON P.SUPER = CTE.SUB
)
SELECT TEILNAME
FROM PARTCTE
WHERE LVL > 0
ORDER BY PATH;


