
# Hackerrank
## `Medium` Placements
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/placements/problem)
  
### 문제
* 출력 컬럼 : name
* 조건 : 가장 친한 친구가 자기보다 급여가 높은 경우(초과) 출력
* 정렬 조건 :  친구의 급여 오름차순


### MY SQL 정답
```SQL
    SELECT M_Info.Name
    FROM
    (SELECT S.ID, S.Name, P.Salary AS My_Slary
    FROM Students AS S LEFT JOIN Packages AS P ON S.ID = P.ID) AS M_Info
    LEFT JOIN
    (SELECT F.ID, F.Friend_ID, P.Salary AS Friend_Salary
    FROM Friends AS F LEFT JOIN Packages AS P ON F.Friend_ID = P.ID) AS F_Info
    ON M_Info.ID = F_Info.ID
    WHERE M_Info.MY_Slary < F_Info.Friend_Salary
    ORDER BY F_Info.Friend_Salary
```