
# Hackerrank
## `Hard` 15 Days of Learning SQL
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 및 조건 : 기준 날짜, 시작일 부터 기준 날짜까지 매일 제출한 해커의 수, 기준 날짜에 최다 제출 한 hacker_id, 기준 날짜에 최다 제출 한 hacker의 name
    * 시작일은 '2016-03-01', 종료일은 '2016-03-15'
    * 2명 이상의 해커가 최다 제출 한 haker이면 hacker_id가 낮은 hacker 출력
* 정렬 조건 : 
  * 날짜별 오름차순 


### MYSQL

### 1. window function 사용 풀이 및 정답
* MYSQL 버전 문제로 window function사용 불가로 ERROR 1064 발생할 수 있음
* 발생 안하는 경우 정답으로, error 발생하는 경우는 `2.서브쿼리`로 풀기

(1) 시작일 부터 기준 날짜까지 매일 제출한 해커의 수
  * 기준 날짜가 '2016-03-03'일 때, 기준 날짜인 '2016-03-03'에 submission_date가 있는 hacker중에 '2016-03-01'과 '2016-03-02'도 submission_date가있는 hacker를 찾아 총 몇명인지 출력해야한다.
  * 기준 날짜('2016-03-03')에서 시작일('2016-03-01')을 뺀 숫자(`2`)가, 기준날짜('2016-03-03') 미만의 submission_date('2016-03-01','2016-03-02')의 개수(`2`)와 일치하는 hacker를 찾으면 된다. 

```SQL
    SELECT submission_date
           ,COUNT(DISTINCT hacker_id) AS hacker_cnt
    FROM  Submissions AS T1
    WHERE DATE_DIFF(submission_date,'2016-03-01') =
    (SELECT COUNT(DISTINCT T2.submission_date)
     FROM Submissions AS T2
     WHERE T1.submission_date > T2.submission_date
     AND T1.hacker_id = T2.hacker_id)
    GROUP BY submission_date
```

(2) 기준 날짜에 최다 제출 한 hacker_id, 기준 날짜에 최다 제출 한 hacker의 name
  * 2명 이상의 해커가 최다 제출 한 haker이면 hacker_id가 낮은 hacker 출력
```SQL

SELECT submission_date, hacker_id
FROM(SELECT submission_date
            ,hacker_id
            ,sub_cnt
            ,row_number() OVER(PARTITION BY submission_date ORDER BY sub_count DESC, hacker_id) AS sub_rank
    FROM  (SELECT submission_date
              ,hacker_id
              ,COUNT(*) AS sub_cnt
            FROM  Submissions
            GROUP BY submission_date, hacker_id) AS T1) AS T2
WHERE submission_rank = 1
```

(3) (1)과 (2), 그리고 name을 출력하기 위해 Hackers를 join해주고, 날짜별 오름차순으로 출력해준다.

 ```SQL
  SELECT S1.submission_date
        ,S1.hacker_cnt
        ,S2.hacker_id
        ,H.name
  FROM 
      (SELECT submission_date
            ,COUNT(DISTINCT hacker_id) AS hacker_cnt
      FROM  Submissions AS T1
      WHERE DATE_DIFF(submission_date,'2016-03-01') =
            (SELECT COUNT(DISTINCT T2.submission_date)
            FROM Submissions AS T2
            WHERE T1.submission_date > T2.submission_date --기준 날짜 미만이어야한다.
            AND T1.hacker_id = T2.hacker_id)
            GROUP BY submission_date) AS S1
      LEFT JOIN 
      (SELECT submission_date, hacker_id
      FROM(SELECT submission_date
                  ,hacker_id
                  ,ROW_NUMBER () OVER(PARTITION BY submission_date ORDER BY submission_cnt DESC, hacker_id ASC) AS submission_rank
            FROM(SELECT submission_date
                      ,hacker_id
                      ,COUNT(submission_id) AS submission_cnt
                FROM  Submissions
                GROUP BY submission_date, hacker_id) AS T1) AS T2
      WHERE submission_rank = 1) AS S2
      ON S1.submission_date = S2.submission_date
      LEFT JOIN Hackers AS H
      ON S2.hacker_id = H.hacker_id
  ORDER BY S1.submission_date ASC
```

### 2. 서브쿼리 사용 풀이 (`MY SQL 다른 사람 답변`)
* [참고 사이트](https://github.com/BlakeBrown/HackerRank-Solutions/blob/master/SQL/5_Advanced%20Join/5_15%20Days%20of%20Learning%20SQL/15%20Days%20of%20Learning%20SQL.mysql) 

 ```SQL
      SELECT submission_date 
            ,(SELECT COUNT(DISTINCT hacker_id) AS hacker_cnt 
            FROM Submissions AS T2
            WHERE T1.submission_date = T2.submission_date AND
                  (DATEDIFF(submission_date,'2016-03-01') =
                  (SELECT COUNT(DISTINCT T3.submission_date)
                  FROM Submissions AS T3
                  WHERE T1.submission_date > T3.submission_date 
                  AND T2.hacker_id = T3.hacker_id)))
      ,(SELECT hacker_id 
            FROM Submissions T4
            WHERE T1.submission_date = T4.submission_date 
            GROUP BY hacker_id 
            ORDER BY COUNT(submission_id) DESC, hacker_id 
            LIMIT 1) AS T5
            ,(SELECT NAME 
            FROM Hackers 
            WHERE hacker_id = T5)
      FROM (SELECT DISTINCT submission_date FROM Submissions)  AS T1     
      GROUP BY submission_date
```


### ORACLE

### window function 사용 문제 풀이
* my sql 답변에서, 아래의 내용 변경
  * Alias를 나타내는 AS를 삭제
  * DATE_DIFF함수를 `submission_date - TO_DATE('2016-03-01','yyyy-mm-dd')`로 변경

```SQL
  SELECT S1.submission_date
        ,S1.hacker_cnt
        ,S2.hacker_id
        ,H.name
  FROM 
      (SELECT submission_date
            ,COUNT(DISTINCT hacker_id) hacker_cnt
      FROM  Submissions T1
      WHERE submission_date - to_date('2016-03-01','yyyy-mm-dd') =
            (SELECT COUNT(DISTINCT T2.submission_date)
            FROM Submissions T2
            WHERE T1.submission_date > T2.submission_date
            AND T1.hacker_id = T2.hacker_id)
            GROUP BY submission_date) S1
      LEFT JOIN 
      (SELECT submission_date, hacker_id
      FROM(SELECT submission_date
                  ,hacker_id
                  ,sub_cnt
                  ,ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY sub_cnt DESC, hacker_id ASC) sub_rank
            FROM(SELECT submission_date
                      ,hacker_id
                      ,COUNT(*) sub_cnt
                FROM  Submissions
                GROUP BY submission_date, hacker_id) T1) T2
      WHERE sub_rank = 1) S2
      ON S1.submission_date = S2.submission_date
      LEFT JOIN Hackers H
      ON S2.hacker_id = H.hacker_id
  ORDER BY S1.submission_date ASC;

```