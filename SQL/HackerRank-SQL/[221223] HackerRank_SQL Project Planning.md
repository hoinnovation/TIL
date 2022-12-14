
# Hackerrank
## `Medium` SQL Project Planning
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/sql-projects/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : 프로젝트 시작 날짜, 프로젝트 종료 날짜
* 조건 : End_Date가 연속된 Task는 동일한 프로젝트
* 정렬 조건 : 프로젝트가 완료되는데 걸리는 시간(`프로젝트 종료일 - 프로젝트 시작일`) 오름 차순, 프로젝트 시작일 오름차순

### 풀이 과정
#### (1) 풀이과정 input, output
* Projects 테이블 input
    ```
        Task_id Start_Date End_Date
        1 2015-10-01 2015-10-02
        24 2015-10-02 2015-10-03
        2 2015-10-03 2015-10-04
        23 2015-10-04 2015-10-05
        3 2015-10-11 2015-10-12
        22 2015-10-12 2015-10-13
        4 2015-10-15 2015-10-16
        21 2015-10-17 2015-10-18
        5 2015-10-19 2015-10-20
        20 2015-10-21 2015-10-22
        6 2015-10-25 2015-10-26
        19 2015-10-26 2015-10-27
        7 2015-10-27 2015-10-28
        18 2015-10-28 2015-10-29
        8 2015-10-29 2015-10-30
        17 2015-10-30 2015-10-31
        9 2015-11-01 2015-11-02
        16 2015-11-04 2015-11-05
        10 2015-11-07 2015-11-08
        15 2015-11-06 2015-11-07
        11 2015-11-05 2015-11-06
        14 2015-11-11 2015-11-12
        12 2015-11-12 2015-11-13
        13 2015-11-17 2015-11-18
    ```
* 결과 Output
    ```
    2015-10-15 2015-10-16
    2015-10-17 2015-10-18
    2015-10-19 2015-10-20
    2015-10-21 2015-10-22
    2015-11-01 2015-11-02
    2015-11-17 2015-11-18
    2015-10-11 2015-10-13
    2015-11-11 2015-11-13
    2015-10-01 2015-10-05
    2015-11-04 2015-11-08
    2015-10-25 2015-10-31
    ```
    ```
    풀이 과정 이해를 돕기 위해 위의 결과를 Start_Date 기준으로 오름 차순 정렬
    2015-10-01 2015-10-05
    2015-10-11 2015-10-13
    2015-10-15 2015-10-16
    2015-10-17 2015-10-18
    2015-10-19 2015-10-20
    2015-10-21 2015-10-22
    2015-10-25 2015-10-31
    2015-11-01 2015-11-02
    2015-11-04 2015-11-08
    2015-11-11 2015-11-13
    2015-11-17 2015-11-18
    ```


#### (2) 풀이 과정 설명
* (1) Start_Date에 End_Date가 없는 Start_Date 출력 
  * 출력된 Start_Date는 프로젝트의 Start_Date를 의미
    ```SQL
    SELECT Start_Date
    FROM Projects
    WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)
    ```
    ```
    -- 출력 결과
        2015-10-01
        2015-10-11
        2015-10-15
        2015-10-17
        2015-10-19
        2015-10-21
        2015-10-25
        2015-11-01
        2015-11-04
        2015-11-11
        2015-11-17
    ```  

* (2) End_Date에 Start_Date가 없는 End_Date 출력 
  * 출력된 End_Date는 프로젝트의 End_Date를 의미
    ```SQL
    SELECT End_Date
    FROM Projects
    WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)
    ```
    ```
    -- 출력 결과
        2015-10-05
        2015-10-13
        2015-10-16
        2015-10-18
        2015-10-20
        2015-10-22
        2015-10-31
        2015-11-02
        2015-11-08
        2015-11-13
        2015-11-18
    ```  

* (3) (1)의 결과가 Start_Date이고 (2)의 결과가 End_Date이다. 두 테이블을 JOIN해서, Start_Date별로 가장 작은 End_Date 출력해주면 된다.
    *  (3-1) 두 테이블을 `Start_DATE < End_Date` 조건으로 JOIN해준다.
        ```SQL
        SELECT *
        FROM(SELECT Start_Date
             FROM Projects
             WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)) AS T1,
            (SELECT End_Date
             FROM Projects
             WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) AS T2
        WHERE Start_Date < End_Date
        ```
        ```
        -- 출력 결과
        *출력 결과를 보면 --로 표시한게 output결과와 동일한데, Start_Date별로 가장 작은 End_Date임을 알수 있다. 
            --2015-10-01 2015-10-05
            2015-10-01 2015-10-13
            2015-10-01 2015-10-16
            2015-10-01 2015-10-18
            2015-10-01 2015-10-20
            2015-10-01 2015-10-22
            2015-10-01 2015-10-31
            2015-10-01 2015-11-02
            2015-10-01 2015-11-08
            2015-10-01 2015-11-13
            2015-10-01 2015-11-18
            --2015-10-11 2015-10-13
            2015-10-11 2015-10-16
            2015-10-11 2015-10-18
            2015-10-11 2015-10-20
            2015-10-11 2015-10-22
            2015-10-11 2015-10-31
            2015-10-11 2015-11-02
            2015-10-11 2015-11-08
            2015-10-11 2015-11-13
            2015-10-11 2015-11-18
            --2015-10-15 2015-10-16
            2015-10-15 2015-10-18
            2015-10-15 2015-10-20
            2015-10-15 2015-10-22
            2015-10-15 2015-10-31
            2015-10-15 2015-11-02
            2015-10-15 2015-11-08
            2015-10-15 2015-11-13
            2015-10-15 2015-11-18
            --2015-10-17 2015-10-18
            2015-10-17 2015-10-20
            2015-10-17 2015-10-22
            2015-10-17 2015-10-31
            2015-10-17 2015-11-02
            2015-10-17 2015-11-08
            2015-10-17 2015-11-13
            2015-10-17 2015-11-18
            --2015-10-19 2015-10-20
            2015-10-19 2015-10-22
            2015-10-19 2015-10-31
            2015-10-19 2015-11-02
            2015-10-19 2015-11-08
            2015-10-19 2015-11-13
            2015-10-19 2015-11-18
            --2015-10-21 2015-10-22
            2015-10-21 2015-10-31
            2015-10-21 2015-11-02
            2015-10-21 2015-11-08
            2015-10-21 2015-11-13
            2015-10-21 2015-11-18
            --2015-10-25 2015-10-31
            2015-10-25 2015-11-02
            2015-10-25 2015-11-08
            2015-10-25 2015-11-13
            2015-10-25 2015-11-18
            --2015-11-01 2015-11-02
            2015-11-01 2015-11-08
            2015-11-01 2015-11-13
            2015-11-01 2015-11-18
            --2015-11-04 2015-11-08
            2015-11-04 2015-11-13
            2015-11-04 2015-11-18
            --2015-11-11 2015-11-13
            2015-11-11 2015-11-18
            --2015-11-17 2015-11-18
        ```  
    *  (3-2) Start_Date로 GROUP BY하여 가장 작은 End_Date 출력
        ```SQL
            SELECT Start_Date, MIN(End_Date)
            FROM(SELECT Start_Date
                FROM Projects
                WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)) AS T1,
                (SELECT End_Date
                FROM Projects
                WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) AS T2
            WHERE Start_Date < End_Date
            GROUP BY Start_Date
        ```
        ```
        출력결과
            2015-10-01 2015-10-05
            2015-10-11 2015-10-13
            2015-10-15 2015-10-16
            2015-10-17 2015-10-18
            2015-10-19 2015-10-20
            2015-10-21 2015-10-22
            2015-10-25 2015-10-31
            2015-11-01 2015-11-02
            2015-11-04 2015-11-08
            2015-11-11 2015-11-13
            2015-11-17 2015-11-18
        ```


### MY SQL 정답
* (4) 정렬 조건 설정
  * 프로젝트가 완료되는데 걸리는 시간(`프로젝트 종료일 - 프로젝트 시작일`) 오름 차순
  * 프로젝트 시작일 오름차순
```SQL
    SELECT Start_Date, MIN(End_Date)
    FROM(SELECT Start_Date
         FROM Projects
         WHERE Start_Date NOT IN 
            (SELECT End_Date FROM Projects)) AS T1,
        (SELECT End_Date
         FROM Projects
         WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) AS T2
    WHERE Start_Date < End_Date
    GROUP BY Start_Date
    ORDER BY MIN(End_Date)-Start_Date ASC, Start_Date ASC
```