SELECT * FROM EMP;
SELECT * FROM DEPT;
 
SELECT * FROM USER_CONSTRAINTS;
 
SELECT DISTINCT(CONSTRAINT_TYPE) FROM USER_CONSTRAINTS;

SELECT  * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMP';

SELECT *
FROM EMP
JOIN DEPT ON DEPT.DEPTNO=EMP.DEPTNO;

ALTER TABLE EMP
DROP CONSTRAINT EMP_FOREIGN_KEY;

SELECT * FROM USER_CONSTRAINTS 
WHERE CONSTRAINT_TYPE ='U';

ALTER TABLE EMP
ADD CONSTRAINT UQ_EMP_ENAME UNIQUE(ENAME);

SELECT * FROM USER_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'U';

SELECT * FROM EMP
JOIN PLAYERS ON PLAYERS.PLAYERNO = EMP.EMPNO;

SELECT * FROM PLAYERS;

SELECT * FROM EMP;

SELECT * FROM EMP
JOIN DEPT ON DEPT.DEPTNO = EMP.DEPTNO; // ist inner join gemeint
--14 satze


SELECT * FROM EMP
LEFT JOIN DEPT 
ON DEPT.DEPTNO = EMP.DEPTNO;
--14 Satze

SELECT * 
FROM DEPT
JOIN EMP 
ON EMP.DEPTNO= DEPT.DEPTNO;

--anti join

SELECT * FROM DEPT;

SELECT * FROM EMP;

SELECT * FROM DEPT
LEFT OUTER JOIN EMP
ON EMP.DEPTNO = DEPT.DEPTNO
WHERE EMP.DEPTNO IS NULL;

SELECT *
FROM DEPT D
WHERE NOT EXISTS (
    SELECT 1
    FROM EMP E
    WHERE E.DEPTNO = D.DEPTNO
);

SELECT * FROM BLUE;

SELECT * FROM RED;

select * from blue
join red on red.id = blue.id;

select * from blue
left join red on red.id = blue.id;

select nvl(blue.id,red.id) as "ID", blue.abc,red.xyz
from blue
left join red 
on red.id = blue.id;

select
*
from blue
left outer join red on red.id = blue.id
where red.id is null;

select *
from blue
inner join red on red.id = blue.id
where red.id=2;

select *
from blue
inner join red on red.id = blue.id
and red.id=2;

select *
from blue
left join red on red.id = blue.id
and red.id=2 and red.id=2;

