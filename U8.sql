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

SELECT * FROM PARTS;

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

WITH PARTCTE(SUB, SUPER, PRICE) AS (
    SELECT
        SUB,
        SUPER,
        PRICE
    FROM PARTS
    WHERE SUPER IN ('P3', 'P9')
    --SUPER = 'p3' OR SUPER = 'P9'
    UNION ALL
    SELECT
        PARTS.SUB,      
        PARTS.SUPER,    
        PARTS.PRICE     
    FROM PARTS
    JOIN PARTCTE        
    ON PARTCTE.SUB = PARTS.SUPER 
)
SELECT * FROM PARTCTE;