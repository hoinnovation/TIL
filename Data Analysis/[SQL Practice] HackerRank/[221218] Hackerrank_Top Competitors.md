# Hackerrank
## `Medium` Top Competitors
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/full-score/problem)

### 문제
- 출력 : hacker_id, name of hackers
- 조건 : 두개 이상 챌린지에서 만점를 얻은 해커
- 정렬 조건 : 
  * 만점받은 챌린지 개수로 내림차순
  * 두명 이상이 만점을 받은 수가 같은 경우 hacker_id로 오름 차순


### MY SQL 정답

 ```SQL

    SELECT H.hacker_id, H.name
    FROM Hackers AS H LEFT JOIN Submissions AS S ON H.hacker_id = S.hacker_id
    LEFT JOIN Challenges AS C ON S.challenge_id = C.challenge_id
    LEFT JOIN Difficulty AS D ON C.difficulty_level = D.difficulty_level 
    WHERE D.score = S.score
    GROUP BY H.hacker_id, H.name
    HAVING COUNT(DISTINCT S.submission_id) >=2
    ORDER BY COUNT(DISTINCT S.submission_id) DESC , H.hacker_id ASC
