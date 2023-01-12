
# Hackerrank
## `Medium` The PADS
* 문제 바로가기 : [링크](https://www.hackerrank.com/challenges/the-pads/problem?isFullScreen=true)
  
### 문제 (1)
* 출력 컬럼 : 이름(직업의 첫 글자)
* 조건 : 
  * NAME(이름) 뒤에 각 OCCUPATION(직업)의 첫 글자를 괄호로 묶어서 출력하라 
    * 예시 : NAME(이름)이 Aamina이고, OCCUPATION(직업)이 Doctor이면 Aamina(D)로 출력
* 정렬 조건 : NAME(이름)을 알파벳순으로 정렬

### 문제 (2)
* 출력 컬럼 : There are a total of `occupation_count` `occupation`s.
* 조건 : 직업 별로 출력하라 
  * `occupation_count` : 직업 수
  * `occupation` : 직업 (단, 소문자로 출력)
* 정렬 조건 : `occupation_count`(직업 수), `occupation`(직업)


### MY SQL 정답
```SQL
    -- 문제 (1)
    SELECT CONCAT(Name,'(',SUBSTR(Occupation,1,1),')')  
    FROM OCCUPATIONS
    ORDER BY Name;

    -- 문제 (2)
    SELECT CONCAT('There are a total of ',COUNT(Occupation),' ',LOWER(Occupation),'s.')  
    FROM OCCUPATIONS
    GROUP BY Occupation
    ORDER BY COUNT(Occupation), Occupation;

```
