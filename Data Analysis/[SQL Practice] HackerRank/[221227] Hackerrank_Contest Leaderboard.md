
# Hackerrank
## `Medium` Contest Leaderboard
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/contest-leaderboard/problem?isFullScreen=true)
  
### 문제
* 출력 컬럼 : hacker_id, name, total score of a hacker
* 조건 : 
  * total score of a hacker는 모든 challenges에 대한 점수 합계 
    * 동일한 challenge에 여러번 답변을 제출했을 경우, 제출한 답변 중 최대 점수를 받은 값 만 더해준다.
  * total score가 0인 hacker는 제외
* 정렬 조건 : total score 내림차순, hacker_id 오름차순


### MY SQL 정답
```SQL

    SELECT T1.hacker_id, T2.name, T1.total_score
    FROM (SELECT hacker_id ,SUM(score) AS total_score
          FROM(SELECT hacker_id, challenge_id, MAX(score) AS score
               FROM Submissions
               GROUP BY hacker_id, challenge_id) AS T
          GROUP BY hacker_id) AS T1
    LEFT JOIN Hackers AS T2
    ON T1.hacker_id = T2.hacker_id
    WHERE T1.total_score != 0
    ORDER BY T1.total_score DESC, T1.hacker_id ASC

```