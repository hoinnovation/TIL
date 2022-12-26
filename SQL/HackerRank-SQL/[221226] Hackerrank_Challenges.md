
# Hackerrank
## `Medium` Challenges
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/challenges/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : hacker_id, name, the total number of challenges created by each student
  * 중앙값 : 어떤 주어진 값들을 크기의 순서대로 정렬했을 때 가장 중앙에 위치하는 값
* 조건 : 한 명 이상의 학생이 the total number of challenges가 같은 경우, the total number of challenges가 최대 값이아닌 경우, 해당 학생을 결과에서 제외
  * 예를 들어서, 아래와 같은 결과가 나왔을 경우 Rose와 Angela의 total number는 6이고, Frank와 patrick의 total number은 3이다. 
  * 이 경우 total number의 최대값이 6이므로, Rose와 Angela는 출력하고 Frank와 Patrick은 결과 값이세 제외하면 된다.
    * 12299 Rose 6
    * 34856 Angela 6
    * ~~79345 Frank 3~~
    * ~~80491 Patrick 3~~
    * 81041 Lisa 1
* 정렬 조건 : the total number of challenges 내림차순, hacker_id 오름차순

### 사용할 WINDOW 함수 
* DENSE_RANK : 같은 순위가 존재해도, 다음 순위를 건너뛰지 않고 매긴다.(_*DENSE 뜻 : 밀집된, 따닥따닥 붙어있는_)
  * 예시 : 1,2,2,3,4,5,5,6…..
* LEAD : 특정 수만큼 뒤에있는 데이터를 구하는 함수 `(SQL Server(MSSQL)에서는 지원하지 않는다)`
  * LEAD(num) OVER(ORDER BY id) : 본인보다 1만큼 뒤에 있는 숫자를 구한다 
  * LEAD(num,3) OVER(ORDER BY id) : 본인보다 3만큼 뒤에 있는 숫자를 구한다 
  

### 풀이 과정
* (1) hacker_id별로 challenges_created를 구한다.
* (2) (1)결과를 바탕으로 lag_one과 rank_cnt를 구한다.
  * challenges_created 내림차순 기준으로 본인보다 1만큼 뒤에 있는 숫자인 lag_one을 구한다.
  * challenges_created 내림차순 기준으로 순위를 매겨 rank_cnt를 구한다.
* (4) 본인의 challenges_created와 본인보다 1만큼 뒤에 있는 숫자인 lag_one이 같으면서, rank_cnt가 1이 아닌 rank_cnt를 DISTINCT를 이용해 중복값을 제거하여 구해준다.
* (5) (4)로 구한 rank_cnt에 해당하지 않는 hacker_id와 challenges_created를 구한다.
* (6) Hackers와 join하여 hacker_id, name, challenges_created를 출력하고, 정렬조건(challenges_created 내림차순, hacker_id 오름차순)을 걸어준다.

### MY SQL 정답
```SQL

    WITH hacker_search AS(
    SELECT hacker_id
        ,DENSE_RANK()OVER(ORDER BY challenges_created DESC) AS rank_cnt
        ,challenges_created
        ,LEAD(challenges_created) OVER(ORDER BY challenges_created DESC) AS lag_one
    FROM(SELECT hacker_id
                ,COUNT(challenge_id) AS challenges_created
        FROM Challenges
        GROUP BY hacker_id) AS T1 )


    SELECT T1.hacker_id, T2.name, T1.challenges_created
    FROM(SELECT hacker_id, challenges_created 
        FROM hacker_search
        WHERE rank_cnt not in (SELECT DISTINCT rank_cnt
                                FROM hacker_search
                                WHERE challenges_created = lag_one AND rank_cnt !=1)) AS T1
    LEFT JOIN Hackers AS T2
    ON T1.hacker_id = T2.hacker_id
    ORDER BY T1.challenges_created DESC, T1.hacker_id ASC


```