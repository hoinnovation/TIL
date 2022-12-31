
# Hackerrank
## `Medium` 15 Days of Learning SQL
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 및 조건 : 기준 날짜, 시작일 부터 기준 날짜까지 매일 제출한 해커의 수, 기준 날짜에 최다 제출 한 hacker_id, 기준 날짜에 최다 제출 한 hacker의 name
    * 시작일은 '2016-03-01', 종료일은 '2016-03-15'
    * 2명 이상의 해커가 최다 제출 한 haker이면 hacker_id가 낮은 hacker 출력
* 정렬 조건 : 
  * 날짜별 오름차순 

### MYSQL 내 답변
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
     WHERE T1.submission_date< T2.submission_date
     AND T1.hacker_id = T2.hacker_id)
    GROUP BY submission_date
```

(2) 기준 날짜에 최다 제출 한 hacker_id, 기준 날짜에 최다 제출 한 hacker의 name
  * 2명 이상의 해커가 최다 제출 한 haker이면 hacker_id가 낮은 hacker 출력
```SQL

SELECT submission_date, hacker_id
FROM(SELECT submission_date
            ,hacker_id
            ,ROW_NUMBER() OVER(PARTITION BY submission_date ORDER BY submission_cnt DESC, hacker_id ASC) AS submission_rank
    FROM  (SELECT submission_date
              ,hacker_id
              ,COUNT(submission_id) AS submission_cnt
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
          WHERE T1.submission_date< T2.submission_date
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


### 내 답변 풀이 결과 
 * 에러 발생 
   * ERROR 1064 (42000) at line 4: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '(PARTITION BY submission_date ORDER BY submission_cnt DESC, hacker_id ASC) AS su' at line 19
 * 다음 목표
   * 왜 발생했는지 쿼리 살펴보기


### MY SQL 다른 사람 답변
* [참고 사이트](https://github.com/BlakeBrown/HackerRank-Solutions/blob/master/SQL/5_Advanced%20Join/5_15%20Days%20of%20Learning%20SQL/15%20Days%20of%20Learning%20SQL.mysql) 

```SQL
SELECT SUBMISSION_DATE,
(SELECT COUNT(DISTINCT HACKER_ID)  
 FROM SUBMISSIONS S2  
 WHERE S2.SUBMISSION_DATE = S1.SUBMISSION_DATE AND    
(SELECT COUNT(DISTINCT S3.SUBMISSION_DATE) 
 FROM SUBMISSIONS S3 WHERE S3.HACKER_ID = S2.HACKER_ID AND S3.SUBMISSION_DATE < S1.SUBMISSION_DATE) = DATEDIFF(S1.SUBMISSION_DATE , '2016-03-01')),
(SELECT HACKER_ID FROM SUBMISSIONS S2 WHERE S2.SUBMISSION_DATE = S1.SUBMISSION_DATE 
GROUP BY HACKER_ID ORDER BY COUNT(SUBMISSION_ID) DESC, HACKER_ID LIMIT 1) AS TMP,
(SELECT NAME FROM HACKERS WHERE HACKER_ID = TMP)
FROM
(SELECT DISTINCT SUBMISSION_DATE FROM SUBMISSIONS) S1
GROUP BY SUBMISSION_DATE;

```