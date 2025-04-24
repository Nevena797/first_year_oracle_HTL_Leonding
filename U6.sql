/*�bung 6* - zu den Tennisclubtabellen/

/*1. NAME, INITIALS und Anzahl der gewonnenen S�tze f�r jeden Spieler*/


SELECT * FROM PLAYERS;
SELECT * FROM MATCHES;

SELECT 
    PL.NAME,
    PL.INITIALS, 
    SUM(MA.WON) AS AnzahlDerGewonnenS�tze
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

/* AND gehrt zu ON dazu jetzt sind die null Spieler zur�ck, bei count wird alles gez�hlt */

SELECT PL.NAME,
    PL.INITIALS, 
    COUNT(M.PLAYERNO) GewonnenMatches 
    FROM PLAYERS PL 
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO 
AND WON > LOST
GROUP BY  PL.NAME, PL.INITIALS;

/*nun werden nur die gewonnen gez�hlt */

SELECT PL.NAME,
    PL.INITIALS, 
    COUNT(WON) GewonnenMatches 
FROM PLAYERS PL
LEFT JOIN MATCHES M
ON PL.PLAYERNO = M.PLAYERNO
AND WON > LOST
GROUP BY  PL.NAME, PL.INITIALS; 
/* das sollte man eher nicht machen, man nimmt eher den primery key oder den foreignkey - nur wenn wirklich nicht anders m�glich */

