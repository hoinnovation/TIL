# Hackerrank
## `Medium` Ollivander's Inventory
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/harry-potter-and-wands/problem?isFullScreen=true)

### 문제
* 출력 컬럼 : id, age, coins_needed, and power of the wand
* 조건 : power가 높고, age가 높은(오래된) 지팡이를 구입하는데 필요한 최소 골드수를 결정하라
  * (1) 지팡이는 non-evil이어야한다. (is_evil이 0이어야한다)
  * (2) 동일한 power와 age가 동일한 지팡이 중 구입하는데 최소 골드를 출력 
* 정렬 조건 : power 내림차순, 그 다음은 age 내림 차순으로 정렬


### 풀이과정
* (1) code`(code가 같으면 age가 같다)`와 power가 동일한 지팡이 중에 가장 골드가 적게 드는 지팡이 출력한다. 

    ```SQL

        SELECT code, power, MIN(coins_needed)
        FROM Wands
        GROUP BY code, power

    ```
* (2) id를 출력하기 위해 code와 power와 coins_needed가 같다는 조건으로 Wands를 join해준다. 

    ```SQL

        SELECT T2.id, T1.coins_needed, T1.power 
        FROM (SELECT code
                    ,power
                    ,MIN(coins_needed) AS coins_needed
              FROM Wands
              GROUP BY code, power) AS T1
        LEFT JOIN Wands AS T2
        ON T1.code = T2.code AND T1.power = T2.power AND T1.coins_needed = T2.coins_needed

    ```

### MY SQL 정답

* (3-1) 답변 1: Wands_Property 테이블과 조인해준뒤, non-evil한 지팡이`(is_evil= 0)`를 출력하기 위해 조건을 설정해주고 출력해줘야하는 컬럼과 정렬 조건을 지정해준다. 

    ```SQL

        SELECT T2.id, T3.age, T1.coins_needed, T1.power 
        FROM (SELECT code
                    ,power
                    ,MIN(coins_needed) AS coins_needed
              FROM Wands
              GROUP BY code, power) AS T1
        LEFT JOIN Wands AS T2
        ON T1.code = T2.code AND T1.power = T2.power AND T1.coins_needed = T2.coins_needed
        LEFT JOIN Wands_Property AS T3
        ON T1.code = T3.code
        WHERE T3.is_evil = 0 
        ORDER BY T1.power DESC, T3.age DESC
    ```


* (3-2) 답변 2 : non-evil한 지팡이`(is_evil= 0)`를 출력한 테이블과 (2) 결과 테이블을 INNER JOIN해준다. 그리고 출력해줘야하는 컬럼과 정렬 조건을 지정해준다. 
  * 주의 사항 : Wands_Property 테이블에서 WHERE is_evil = 0한 컬럼만 출력하여 조인 해줄 경우 INNER JOIN해줘야한다. is_evil이 0이 아닌 건 age가 NULL값으로 출력되기 때문이다.

    ```SQL
        SELECT T2.id, T3.age, T1.coins_needed, T1.power 
        FROM (SELECT code
                    ,power
                    ,MIN(coins_needed) AS coins_needed
              FROM Wands
              GROUP BY code, power) AS T1
        LEFT JOIN Wands AS T2
        ON T1.code = T2.code AND T1.power = T2.power AND T1.coins_needed = T2.coins_needed
        INNER JOIN (SELECT code, age
                   FROM Wands_Property
                   WHERE is_evil = 0 ) AS T3
        ON T1.code = T3.code
        ORDER BY T1.power DESC, T3.age DESC
    ```