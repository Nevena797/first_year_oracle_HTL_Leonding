/*Tabelen*/

DROP TABLE MyTable;
CREATE TABLE MyTable(
        ID int,
        Beshreibung varchar2(20)
);
INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

SELECT * FROM MyTable;

/*Primary Key column-level*/

DROP TABLE MyTable;
CREATE TABLE MyTable(
    ID INT CONSTRAINT PK_MyTable PRIMARY KEY,
    Beschreibung VARCHAR2(20)
);

INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

SELECT * FROM MyTable;

INSERT INTO MyTable VALUES(2,'Zwei');

/*->INSERT INTO MyTable VALUES(2,'Zwei')
Error report -
ORA-00001: unique constraint (KD240283.PK_MYTABLE) violated */
SELECT * FROM MyTable;

/*Primary Key table-level*/
DROP TABLE MyTable;
CREATE TABLE MyTable(
    ID int,
    Beschreibung varchar2(20),
    CONSTRAINT PK_MyTable PRIMARY KEY(ID)
    );
INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

SELECT * FROM MyTable;

/*Primary Key per Alter*/

DROP TABLE MyTable;
CREATE TABLE MyTable(
            ID int,
            Beschreibung varchar2(20)
);
ALTER TABLE MyTable
ADD CONSTRAINT PK_MyTable PRIMARY KEY (ID);

INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

/*Default*/

DROP TABLE MyTable;
CREATE TABLE MyTable(
    ID int,
    Beschreibung varchar2(20) DEFAULT 'nix'
);

INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');
INSERT INTO MyTable (ID) VALUES (3);
SELECT * FROM MyTable;

/*CREATE TABLE AS SELECT*/
DROP TABLE EMPDEPT;
CREATE TABLE EMPDEPT AS
SELECT EMP.EMPNO,
        EMP.ENAME,
        DEPT.DNAME
FROM EMP
JOIN DEPT
ON DEPT.DEPTNO = EMP.DEPTNO;

SELECT * FROM EMPDEPT;

/*UNIQUE CONSTRAINT*/
DROP TABLE MyTable;
CREATE TABLE MyTable(
    ID INT CONSTRAINT PK_MyTable UNIQUE,
    Beschreibung VARCHAR2(20)
);

INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

SELECT * FROM MyTable;

INSERT INTO MyTable VALUES(2,'Zwei'); --ORA-00001: unique constraint (KD240283.PK_MYTABLE) violated
INSERT INTO MyTable VALUES(null,'gar nix');
INSERT INTO MyTable VALUES(null,'wieder nix'); ---- klappt fehlerfrei!

SELECT * FROM MyTable;

/*Check*/
DROP TABLE MyTable;
CREATE TABLE MyTable(
    ID int NOT NULL,
    Beschreibung VARCHAR2(20) CONSTRAINT CK_Beschreibung CHECK(length(Beschreibung) > 3)
    );
    
INSERT INTO MyTable VALUES(1,'Eins');
INSERT INTO MyTable VALUES(2,'Zwei');

SELECT * FROM MyTable;
INSERT INTO MyTable VALUES(null,'gar nix');--cannot insert NULL into ("KD240283"."MYTABLE"."ID")
INSERT INTO MyTable VALUES(2,'nix'); --ORA-02290: check constraint (KD240283.CK_BESCHREIBUNG) violated

/*FOREIGN*/

DROP TABLE MyTable;

CREATE TABLE MyTable(
ID INT CONSTRAINT FK_MyTable_ID REFERENCES DEPT(DEPTNO),
Beschreibung VARCHAR2(20) CONSTRAINT CK_Beschreibung CHECK (LENGTH(Beschreibung) > 3)
);

INSERT INTO MyTable VALUES(10,'Eins');
INSERT INTO MyTable VALUES(20,'Zwei');

SELECT * FROM MyTable;

INSERT INTO MyTable VALUES(null,'gar nix');
INSERT INTO MyTable VALUES(50,'nix');--ORA-02290: check constraint (KD240283.CK_BESCHREIBUNG) violated



