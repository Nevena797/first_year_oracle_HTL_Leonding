SELECT 
  job,
  deptno,
  sal
FROM (
  SELECT 
    CASE
      WHEN GROUPING(deptno) = 1 THEN ' '
      WHEN GROUPING(job) = 1 THEN 'Zwischensumme ' || TO_CHAR(deptno)
      ELSE job
    END AS job,
    
    CASE
      WHEN GROUPING(deptno) = 1 THEN ' '
      WHEN GROUPING(job) = 1 THEN ' '
      ELSE job
    END AS job_sortorder,

    CASE
      WHEN GROUPING(deptno) = 1 THEN 'Totalsumme'
      WHEN GROUPING(job) = 1 THEN ' '
      ELSE TO_CHAR(deptno)
    END AS deptno,

    CASE
      WHEN GROUPING(deptno) = 1 THEN ' '
      WHEN GROUPING(job) = 1 THEN TO_CHAR(deptno)
      ELSE TO_CHAR(deptno)
    END AS deptno_sortorder,

    SUM(sal) AS sal
  FROM emp
  GROUP BY ROLLUP(deptno, job)
) x
ORDER BY deptno_sortorder, job_sortorder;

SELECT 
  job, 
  deptno, 
  SUM(sal) AS sal,
  GROUPING(job),
  GROUPING(deptno),
  GROUPING_ID(job, deptno)  -- 2d = 10b
FROM emp
GROUP BY ROLLUP(deptno, job);

-- WINDOW FUNCTION
SELECT sal FROM emp;
SELECT SUM(sal) FROM emp;
SELECT ename, sal FROM emp;
SELECT ename, sal, sal / 29025 * 100 FROM emp;
SELECT ename, sal, sal / (SELECT SUM(sal) FROM emp) * 100 FROM emp;
SELECT ename, sal, SUM(sal) OVER() FROM emp;

SELECT ename, deptno, sal, 
       SUM(sal) OVER(PARTITION BY deptno) SumDeptno, 
       SUM(sal) OVER() as SumTotal 
FROM emp;


SELECT ename, deptno, job, sal,
       SUM(sal) OVER(PARTITION BY job, deptno) AS SumJobDeptno,
       SUM(sal) OVER(PARTITION BY deptno) AS SumDeptno,
       SUM(sal) OVER() AS SumTotal
FROM emp;

SELECT ename, sal, RANK() OVER(ORDER BY sal) AS SalRank FROM emp;

SELECT ename, sal,
       RANK() OVER(ORDER BY sal) AS SalRank,
       DENSE_RANK() OVER(ORDER BY sal) AS SalDenseRank
FROM emp;

SELECT ename, sal,
       RANK() OVER(ORDER BY sal) AS SalRank,
       DENSE_RANK() OVER(ORDER BY sal) AS SalDenseRank,
       ROW_NUMBER() OVER(ORDER BY sal) AS SalRowNbr
FROM emp;

SELECT ename, sal,
       RANK() OVER(ORDER BY sal) AS SalRank,
       DENSE_RANK() OVER(ORDER BY sal) AS SalDenseRank,
       ROW_NUMBER() OVER(ORDER BY sal, ename DESC) AS SalRowNbr
FROM emp;

SELECT ename, sal,
       RANK() OVER(ORDER BY sal) AS SalRank,
       DENSE_RANK() OVER(ORDER BY sal) AS SalDenseRank,
       ROW_NUMBER() OVER(ORDER BY sal, ename DESC) AS SalRowNbr,
       (SELECT COUNT(*) FROM emp e2 WHERE e2.sal < e1.sal) AS RownrbS
FROM emp e1;
