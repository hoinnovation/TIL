# Hackerrank
## `Medium` Occupations
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/occupations/problem)

### 문제
* 출력 컬럼 : Doctor, Professor, Singer, and Actor
* 조건 : Occupation(직업) 열을 피봇 하여 해당 Occupation(직업) 아래에 이름이 표시되도록 출력
  * Occupation(직업)에 해당하는 이름이 없으면 NULL 출력
* 정렬 조건 : 각 이름이 알파벳순으로 정렬


### 풀이과정
* (1) Ocuupation별, Name은 알파벳 순으로 정렬하여 row number을 사용해 rank를 매겨준다. 

    ```SQL

    SELECT *
      ,ROW_NUMBER()OVER(PARTITION BY Occupation ORDER BY Name) AS rank
    FROM OCCUPATIONS

    -- 출력 결과 
    -- Eve Actor 1
    -- Jennifer Actor 2
    -- Ketty Actor 3
    -- Samantha Actor 4
    -- Aamina Doctor 1
    -- Julia Doctor 2
    -- Priya Doctor 3
    -- Ashley Professor 1
    -- Belvet Professor 2
    -- Britney Professor 3
    -- Maria Professor 4
    -- Meera Professor 5
    -- Naomi Professor 6
    -- Priyanka Professor 7
    -- Christeen Singer 1
    -- Jane Singer 2
    -- Jenny Singer 3
    -- Kristeen Singer 4 
    ```
* (2) CASE WHEN으로 각 Ocuupation별로 name을 출력해준다.

    ```SQL

        SELECT  ranking
                ,CASE WHEN Occupation = "Doctor" THEN Name END AS Doctor
                ,CASE WHEN Occupation = "Professor" THEN Name END AS Professor
                ,CASE WHEN Occupation = "Singer" THEN Name END AS Singer
                ,CASE WHEN Occupation = "Actor" THEN Name END AS Actor
        FROM (SELECT *
                    ,ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS ranking 
              FROM OCCUPATIONS) AS T1

    -- 출력 결과 
    --     1 NULL NULL NULL Eve
    --     2 NULL NULL NULL Jennifer
    --     3 NULL NULL NULL Ketty
    --     4 NULL NULL NULL Samantha
    --     1 Aamina NULL NULL NULL
    --     2 Julia NULL NULL NULL
    --     3 Priya NULL NULL NULL
    --     1 NULL Ashley NULL NULL
    --     2 NULL Belvet NULL NULL
    --     3 NULL Britney NULL NULL
    --     4 NULL Maria NULL NULL
    --     5 NULL Meera NULL NULL
    --     6 NULL Naomi NULL NULL
    --     7 NULL Priyanka NULL NULL
    --     1 NULL NULL Christeen NULL
    --     2 NULL NULL Jane NULL
    --     3 NULL NULL Jenny NULL
    --     4 NULL NULL Kristeen NULL
    ```

* (3) NULL값을 제거해주기 위해, ranking으로 그룹핑해서 집계함수를 사용해준다. `(집계함수는 해당 그룹에서 NULL을 제외하고 출력한다. NULL을 연산자체에서 제외하는 방식을 취하고 있기 때문이다. 값이 없는 경우는 NULL값을 출력하는거랑 헷갈리면 안된다.)`

    ```SQL

        SELECT  ranking
                ,MAX(CASE WHEN Occupation = "Doctor" THEN Name END) AS Doctor
                -- ,CASE WHEN Occupation = "Professor" THEN Name END AS Professor
                -- ,CASE WHEN Occupation = "Singer" THEN Name END AS Singer
                -- ,CASE WHEN Occupation = "Actor" THEN Name END AS Actor
        FROM (SELECT *
                    ,ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS ranking 
              FROM OCCUPATIONS) AS T1
        GROUP BY ranking

    --출력 결과 : 1,2,3은 NULL값을 제외하고 출력, 4,5,6,7은 값이 없기 때문에 NULL이 출력된다. 
    --    1 Aamina
    --    2 Julia
    --    3 Priya
    --    4 NULL
    --    5 NULL
    --    6 NULL
    --    7 NULL
    ```


### MY SQL 정답

```SQL
        SELECT  MAX(CASE WHEN Occupation = "Doctor" THEN Name END) AS Doctor
                ,MAX(CASE WHEN Occupation = "Professor" THEN Name END) AS Professor
                ,MAX(CASE WHEN Occupation = "Singer" THEN Name END) AS Singer
                ,MAX(CASE WHEN Occupation = "Actor" THEN Name END) AS Actor
        FROM (SELECT *
                    ,ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS ranking 
              FROM OCCUPATIONS) AS T1
        GROUP BY ranking

```
