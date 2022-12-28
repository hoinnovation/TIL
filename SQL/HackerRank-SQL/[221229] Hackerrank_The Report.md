
# Hackerrank
## `Medium` The Report
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/the-report/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : Name, Grade, Mark
* 조건 : Grade < 8인 학생은 Name을 "NULL"을 출력
* 정렬 조건 : Grade 내림차순, Name 오름차순, Mark 오름차순

### 의미


### MY SQL 정답
```SQL

    SELECT CASE WHEN T2.Grade < 8 THEN "NULL"
            ELSE T1.name END AS name
           ,T2.Grade
           ,T1.Marks
    FROM Students AS T1
    LEFT JOIN Grades AS T2
    ON T2.Min_Mark <= T1.Marks AND T1.Marks <= T2.Max_Mark
    ORDER BY T2.Grade DESC, T1.name ASC, T1.Marks ASC 

```
