
# Hackerrank
## `Medium` Binary Tree Nodes
* 문제 바로가기 : [링크]( https://www.hackerrank.com/challenges/binary-search-tree-1/problem)

### 문제
* 출력 컬럼 :노드 유형
* 조건 : N : node, P : N의 부모
    - *Root*: If node is root node.
    - *Leaf*: If node is leaf node.
    - *Inner*: If node is neither root nor leaf node.
* 정렬 조건 : value of the node


### MY SQL 정답
```SQL
-- JOIN과 CASE구문 사용
    SELECT DISTINCT B1.N,
    CASE WHEN B1.P IS NULL THEN 'Root'
        WHEN B2.P IS NULL THEN 'Leaf'
        ELSE 'Inner'
        END AS node_value
    FROM BST AS B1 LEFT JOIN BST AS B2
    ON B1.N = B2.P
    ORDER BY B1.N
```
```SQL
-- 서브쿼리와 CASE구문 사용
    SELECT N
        ,CASE WHEN P IS NULL THEN 'Root'
                WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner' 
                ELSE 'Leaf' END AS 'value of the node'
    FROM BST
    ORDER BY N
```