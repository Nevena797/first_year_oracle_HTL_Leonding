SELECT
    SAL,
    COMM,
    NVL(SAL + COMM, 0),
    NVL2(SAL + COMM, 'sal incl comm', 'sal only'),
    CASE
        WHEN COMM IS NOT NULL THEN
            'sal incl comm'
        ELSE
            'sal only'
    END
FROM
    EMP;

SELECT * FROM EMP; 

SELECT
    DNAME,
    CASE DNAME
        WHEN 'ACCOUNTING' THEN '123'
        WHEN 'RESEARCH'   THEN '456'
        ELSE              '789'
    END AS DEPT_CODE
FROM DEPT;

    -- andere schreibweise:
    
SELECT 
    CASE
        WHEN DEPTNO = 10 THEN '999'
        WHEN DNAME = 'ACCOUNTING' THEN '123'
        WHEN DNAME = 'RESEARCH'   THEN '456'
        ELSE '789'
    END,

    DECODE(
        DNAME, 
            'ACCOUNTING', '123', 
            'RESEARCH',   '456',
            '789'
    )
FROM DEPT;

-- Gegenteilige Fuktion zu NVL

SELECT
    ENAME,
    NULLIF(ENAME, 'SMITH')
FROM
    EMP;
    
-- mit case when:

SELECT
    ENAME,
    NULLIF(ENAME, 'SMITH'),
    CASE WHEN ENAME = 'SMITH' THEN NULL ELSE ENAME END,
    CASE ENAME WHEN 'SMITH' THEN NULL ELSE ENAME END
FROM EMP;

SELECT
    ENAME,
    SAL,
    COMM,
    NVL(SAL + COMM, SAL),
    COALESCE(SAL + COMM, SAL, 0)
FROM
    EMP;

/*Gruppenfunktionen (auch Aggregatfunktionen)*/

SELECT ENAME,SAL FROM EMP; -- 14 rows

SELECT
    SUM(SAL),--
    AVG(SAL),
    MIN(SAL),
    MAX(SAL),
    COUNT(SAL)
FROM EMP;

SELECT * FROM EMP;
SELECT * FROM SALGRADE;

--NON-EQUI JOINS

SELECT 
    *
FROM EMP E
JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

SELECT 
    E.ENAME,
    E.SAL,
    S.GRADE
FROM EMP E
JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

SELECT * FROM EMP E
JOIN SALGRADE S
--ON e.sal >= s.losal <= s.hisal; /* do not*/
ON E.SAL >= S.LOSAL AND E.SAL <= S.HISAL;

SELECT * FROM EMP;
DELETE FROM EMP; /* 14 rows deleted */
DROP TABLE EMP; /*Table EMP dropped.*/

TRUNCATE TABLE EMP; /*Invalid truncate command - missing CLUSTER or TABLE keyword */
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPT';





