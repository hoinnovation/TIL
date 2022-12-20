
# Hackerrank
## `Medium` Weather Observation Station 19
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/weather-observation-station-19/problem)
  
### 문제
* 출력 컬럼 : 유클리드 거리를 구해라
* 조건 : 
  * 1) 유클리드 거리 : 루트((b-a)의 제곱 + (d-c)의 제곱)
    * a는 LAT_N의 최소, b는 최대 
    * c는 LONG_W의 최소, d는 최대
  * 2) 소수점 네자리까지 출력
* 정렬 조건 : 없음


### MY SQL 정답
```SQL
-- 1안. 함수 사용 -> 거듭 제곱 함수 :  POWER(밑, 지수)
    SELECT ROUND(SQRT(POW(MAX(LAT_N)-MIN(LAT_N),2)+POW(MAX(LONG_W)-MIN(LONG_W),2)),4) AS U
    FROM STATION
```
```SQL
-- 2안. 함수 몰라도 식으로 계산
    SELECT 
    ROUND(SQRT((MAX(LAT_N)-MIN(LAT_N))*(MAX(LAT_N)-MIN(LAT_N))+
        (MAX(LONG_W)-MIN(LONG_W))*(MAX(LONG_W)-MIN(LONG_W))),4) AS U
    FROM STATION
```