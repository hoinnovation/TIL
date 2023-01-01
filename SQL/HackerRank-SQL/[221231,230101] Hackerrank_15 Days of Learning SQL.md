
# Hackerrank
## `Hard` 15 Days of Learning SQL
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 및 조건 : 기준 날짜, 시작일 부터 기준 날짜까지 매일 제출한 해커의 수, 기준 날짜에 최다 제출 한 hacker_id, 기준 날짜에 최다 제출 한 hacker의 name
    * 시작일은 '2016-03-01', 종료일은 '2016-03-15'
    * 2명 이상의 해커가 최다 제출 한 haker이면 hacker_id가 낮은 hacker 출력
* 정렬 조건 : 
  * 날짜별 오름차순 


### MYSQL 풀이

### 풀이 1. window function 사용 
 * 에러 발생 (12/31 작성)
   * ERROR 1064 (42000) at line 4: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '(PARTITION BY submission_date ORDER BY submission_cnt DESC, hacker_id ASC) AS su' at line 19
 * 다음 목표
   * 왜 발생했는지 쿼리 살펴보기 (1/1 작성)
    * 계속해서 ERROR 발생해서, `WINDOW FUNCTION Error Code: 1064`로 검색
       * [Error 1064: How to Fix SQL Syntax Error 1064?](https://www.nucleustechnologies.com/blog/how-to-fix-sql-syntax-error-1064/)
    * 위의 글에 해당되는 내용이 없어서, 다른 사람들의 MY SQL 답변 중 WINDOW FUNCTION 사용한 쿼리를 돌려보니, 동일한 syntax error 발생
    * 해커랭크에서 MY SQL 버전 문제로 WINDOW FUNCTION 사용하면 나와 동일한 에러 발생하는 경우 찾음
      * 질문 : [Window function syntax error at over clause](https://stackoverflow.com/questions/70873740/window-function-syntax-error-at-over-clause)
      * 답변 :  Most likely, your MySQL version is less than 8+, and therefore does not support window functions. Here is an alternative to your current query which should run on your MySQL version:
    * Oracle은 window function 동작하여, 현재 답변은 oracle로 진행하고, mysql은 windofunction 사용하지 않고 풀기로 결정 

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


### ORACLE

### 풀이 1. window function 사용 
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
          WHERE T1.submission_date< T2.submission_date
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

* WRONG ANSWER 발생(1/1 작성)
  * 문제 1. 2016-03-07, 2016-03-09~2016-03-15 날짜가 빠져있음
  * 문제 2. 시간이 지날 수록 hacker_cnt가 줄어들어야하는데, 잘못 집계되었음   
    ```SQL
    2016-03-01 8 81314 Denise
    2016-03-02 19 39091 Ruby
    2016-03-03 27 18105 Roy
    2016-03-04 10 533 Patrick
    2016-03-05 5 7891 Stephanie
    2016-03-06 3 84307 Evelyn
    2016-03-08 37 10985 Timothy
    ```
* 다음 목표
  * 두가지 문제 해결 필요 


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