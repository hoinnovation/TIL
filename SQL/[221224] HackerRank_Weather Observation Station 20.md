
# Hackerrank
## `Medium` Weather Observation Station 20
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/weather-observation-station-20/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : LAT_N의 중앙값(median)
  * 중앙값 : 어떤 주어진 값들을 크기의 순서대로 정렬했을 때 가장 중앙에 위치하는 값
* 조건 : 소수점 넷째자리에서 반올림 
* 정렬 조건 : 없음

### 사용할 WINDOW 함수 
* PERCENT_RANK: 해당 파티션의 맨 위 끝 행을 0, 맨 아래 끝 행을 1로 놓고 현재 행이 위치하는 백분위 순위 값을 구하는 함수 `(SQL Server(MSSQL)에서는 지원하지 않는다)`
  * (RANK순위값 -1)/ (총 COUNT -1)과 같다.
    * `1개면 0`, `2개면 0,1`, `3개면 0,0.5,1`가 각 수의 백분위 순위로 할당 된다. 

### 풀이 과정
* (1) PERCENT_RANK함수를 사용하여 백분위 순위 값을 구한다.
* (2) 백분위 순위가 0.5, 중앙에 위치 하는 값을 구한다.

### MY SQL 정답
```SQL
    SELECT ROUND(LAT_N,4)
    FROM (SELECT LAT_N, PERCENT_RANK() OVER(ORDER BY LAT_N) AS per_rank
          FROM STATION) AS T
    WHERE per_rank = 0.5
```