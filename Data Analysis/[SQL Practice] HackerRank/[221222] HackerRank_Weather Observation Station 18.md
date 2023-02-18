
# Hackerrank
## `Medium` Weather Observation Station 18
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/weather-observation-station-18/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : P1(a,b)과 P2(c,d)사이 맨허튼거리 → |a - c | + |b - d |.
* 조건 : 
  * P1(a,b)와 P2(c,d) 2D평면에서 두점을 의미
    * 1) a : STATION의 LAT_N 최소값
    * 2) b : STATION의 LONG_W 최소값
    * 3) c : STATION의 LAT_N 최대값
    * 4) d : STATION의 LONG_W 최대값
  * 소수점 넷째자리에서 반올림 
* 정렬 조건 : 없음


### MY SQL 정답
```SQL
    SELECT ROUND(ABS(MIN(LAT_N)-MAX(LAT_N)) + ABS(MIN(LONG_W)-MAX(LONG_W)),4) AS 'Manhattan Distance'
    FROM STATION
```