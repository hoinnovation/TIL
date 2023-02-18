
# Hackerrank
## `Hard` Interviews
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/interviews/problem?isFullScreen=true)
  
### 문제
![image](https://user-images.githubusercontent.com/45919197/210580781-806ad0c5-9b13-44e3-8b9c-56855bd53617.png)
* 출력 컬럼 : contest_id, hacker_id, name, the sums of total_submissions, the sums of total_accepted_submissions, the sums of total_views, and total_unique_views
* 조건 : 
  * 4개의 열(the sums of total_submissions, the sums of total_accepted_submissions, the sums of total_views, and total_unique_views)의 합이 0인 경우 결과에서 제외
  * 특정 contest는 두 개 이상의 대학에서 지원자를 선발하는 데 사용될 수 있지만, 각 대학은 1개의 심사 대회만 개최
* 정렬 조건 : contest_id별로 정렬

### MY SQL 정답
```SQL
    SELECT 
    T1.contest_id
    ,T1.hacker_id
    ,T1.name
    ,SUM(T4.total_submissions)
    ,SUM(T4.total_accepted_submissions)
    ,SUM(T5.total_views)
    ,SUM(T5.total_unique_views)
    FROM Contests AS T1
    LEFT JOIN Colleges AS T2
    ON T1.contest_id = T2.contest_id
    LEFT JOIN Challenges AS T3
    ON T2.college_id = T3.college_id
    LEFT JOIN
      (SELECT challenge_id
      ,SUM(total_submissions) AS total_submissions
      ,SUM(total_accepted_submissions) AS total_accepted_submissions
      FROM Submission_Stats
      GROUP BY challenge_id) AS T4
    ON T3.challenge_id = T4.challenge_id
    LEFT JOIN
      (SELECT challenge_id
      ,SUM(total_views) AS total_views
      ,SUM(total_unique_views) AS total_unique_views
      FROM View_Stats
      GROUP BY challenge_id) AS T5
    ON T3.challenge_id = T5.challenge_id
    GROUP BY T1.contest_id, T1.hacker_id, T1.name
    HAVING SUM(T4.total_submissions) + SUM(T4.total_accepted_submissions) + SUM(T5.total_views) + SUM(T5.total_unique_views) > 0
    ORDER BY T1.contest_id


```
