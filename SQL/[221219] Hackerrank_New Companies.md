
# Hackerrank
## `Medium` New Companies
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/binary-search-tree-1/problem)
  
### 문제
* 출력 컬럼 :company_code 
    ,founder name
    ,total number of lead managers
    ,total number of senior managers
    ,total number of managers
    ,total number of employees
* 조건 : 중복포함 가능, company_code는 숫자가 아닌 문자 정렬 
* 정렬 조건 : company_code 오름차순


### MY SQL 정답
```SQL
-- JOIN 사용
    SELECT C.company_code
        ,C.founder
        ,COUNT(DISTINCT L.lead_manager_code)
        ,COUNT(DISTINCT S.senior_manager_code)
        ,COUNT(DISTINCT M.manager_code)
        ,COUNT(DISTINCT E.employee_code)
    FROM Company AS C LEFT JOIN Lead_Manager AS L ON C.company_code = L.company_code
    LEFT JOIN Senior_Manager AS S ON L.lead_manager_code = S.lead_manager_code
    LEFT JOIN Manager AS M ON S.senior_manager_code = M.senior_manager_code
    LEFT JOIN Employee AS E ON M.manager_code = E.manager_code
    GROUP BY C.company_code, C.founder
    ORDER BY C.company_code
```
```SQL
-- 서브쿼리 사용
    SELECT N
        ,CASE WHEN P IS NULL THEN 'Root'
                WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner' 
                ELSE 'Leaf' END AS 'value of the node'
    FROM BST
    ORDER BY N
```