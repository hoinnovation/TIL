
# Hackerrank
## `Medium` Symmetric Pairs
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/symmetric-pairs/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : 2개의 행 (x1, y1), (x2, y2)이 있을 때 x1=y2이고 y1=x2로 서로 대칭인 행 출력  
* 조건 : x1 ≤ y1인 행만 출력 (대칭인 2개의 행 중에 1개만 출력)
* 정렬 조건 : x1 오름 차순


### MY SQL 정답
```SQL
    -- x1 과 y1이 다른 경우
    SELECT T1.X,T1.Y
    FROM Functions AS T1
    INNER JOIN Functions AS T2 
    ON T1.X = T2.Y AND T1.Y = T2.X
    WHERE T1.X < T1.Y
    UNION   
    -- x1 과 y1이 같은 경우 -> 서로 대칭인 행이 있는지 HAVING조건으로 확인 
    SELECT X,Y
    FROM Functions 
    WHERE X = Y
    GROUP BY X,Y
    HAVING COUNT(*) = 2
    ORDER BY X
    -- UNION에서 ORDER BY는 마지막 쿼리에 지정

```