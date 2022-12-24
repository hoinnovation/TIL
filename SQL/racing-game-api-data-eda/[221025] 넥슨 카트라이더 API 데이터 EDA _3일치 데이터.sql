--  테이블 명 : single_1004_1007
--  테이블 설명 : 넥슨 API에서 수집한 카트라이더 개인전 매치, 유저 데이터
--  수집 기간 : 2021-10-04 00:00:00 ~ 2022-10-07 00:00:00

USE kart_data_test;

SELECT *
FROM single_1004_1007;

# 1. matchtype확인
# 결과 : 
# {"id":"ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878","name":"아이템 팀 배틀모드"}
# {"id":"7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0","name":"아이템 개인전"}
# {"id":"7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a","name":"스피드 개인전"}
SELECT DISTINCT matchtype
FROM single_1004_1007;

# (1)-1 스피드 개인전 매치 건수 : 16,820건
SELECT COUNT(DISTINCT matchId)
FROM single_1004_1007
WHERE matchtype ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1)-2 아이템 개인전 매치 건수 : 7,777건
SELECT COUNT(DISTINCT matchId)
FROM single_1004_1007
WHERE matchtype ='7ca6fd44026a2c8f5d939b60aa56b4b1714b9cc2355ec5e317154d4cf0675da0';

# (1)-3 아이템 팀 배틀모드매치 건수 : 1,994건
SELECT COUNT(DISTINCT matchId)
FROM single_1004_1007
WHERE matchtype ='ee2426e23fa56f7a695084e1fc07fe6bb03a0b3b0c71c4e1f1b7e7e78e6c6878';


# 2. 스피드 개인전 테이블 생성 
CREATE TABLE single_speed_1004_1007
SELECT *
FROM single_1004_1007
WHERE matchtype ='7b9f0fd5377c38514dbb78ebe63ac6c3b81009d5a31dd569d1cff8f005aa881a';

# (1) 주요 데이터 확인
# 매치 건 수 :  16,820건
# 유저 수 : 15,816명
# 매치에서 사용 된 트랙 수 : 294개

# 매치 건 수 :  16,820건
SELECT COUNT(DISTINCT matchId)
FROM single_speed_1004_1007;

# 유저 수 : 15,816명
-- 게임 플레이 중간에 나간 유저(457명)도 포함된 숫자 
SELECT COUNT(DISTINCT accountNo)
FROM single_speed_1004_1007;

-- 게임 플레이 중간에 나간 유저 : 457명
SELECT COUNT(DISTINCT accountNo)
FROM single_speed_1004_1007
WHERE matchRank=0;

# 매치에서 사용 된 트랙 수 : 294개
SELECT COUNT(DISTINCT trackId)
FROM single_speed_1004_1007;


-- ---------------------------------------------------

# (2) match_start_time과 match_end_time -> 확인 필요

# (2)-1 match_end_time-match_start_time은 1등 matchtime도 아니고, 꼴등 matchtime도 아니다. 
SELECT match_start_time, match_end_time, matchTime, matchRank, matchId
FROM single_speed_1004_1007
WHERE matchRank=8;

-- ---------------------------------------------------
# (3) acountNo에 음수 값이 없다. 
SELECT DISTINCT accountNo
FROM single_speed_1004_1007
ORDER BY 1 ASC;

-- ---------------------------------------------------
# (4) 유저 수는 accountNo로 계산해야한다. 
-- 동일한 accountNo에 characterName이 여러개 인 경우가 있다. 

# (4)-1 characterName 1개 당 accountNo는 1개다.
# 검증 결과 : characterName : 15953, accountNO : 15816 이다. 
SELECT COUNT(DISTINCT characterName), COUNT(DISTINCT accountNo)
FROM single_speed_1004_1007;

# (4)-2 accountNo는 동일한데, characterName이 1개 이상인 경우가 있다.
# 닉네임을 바꾼 경우가 이에 해당하는 값인 것 같다. 
SELECT accountNo, COUNT(DISTINCT characterName) AS cnt
FROM single_speed_1004_1007
GROUP BY 1
ORDER BY 2 DESC;

SELECT DISTINCT characterName, match_start_time, match_end_time
FROM single_speed_1004_1007
WHERE accountNo=1074252842;

# (4)-3 동일한 characterName을 가지면 accountNo가 1개이다. 
-- characterName 1개 당 accountNo는 1개 이다.
SELECT characterName, COUNT(DISTINCT accountNo) AS cnt
FROM single_speed_1004_1007
GROUP BY 1
ORDER BY 2 DESC;

-- ---------------------------------------------------


# (5) licensce는 항상 ""를 가진다.
# 검증 결과 : 검증완료(license 삭제해도 된다)
SELECT DISTINCT license
FROM single_speed_1004_1007;

-- ---------------------------------------------------

# (6) rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지이다.

# (6)-1 rankinggrade2는 플레이어의 라이센스로 0은 없음, 1~6은 초보부터 pro까지, 게임 종료시 ""
# 검증결과 : 0, 1~6가 있다.
SELECT DISTINCT rankinggrade2
FROM single_speed_1004_1007
ORDER BY 1;


-- ---------------------------------------------------

# (7) matchRank는 해당 매치에서의 순위로 1~8이 있고, 리타이어시 99, 게임 종료 시 0 이다.
#(7).1 해당 매치에서의 순위, 리타이어시 99, 게임 종료시“”
# 검증결과 -> 0,99,1~8까지 있다.
SELECT DISTINCT matchRank
FROM single_speed_1004_1007
ORDER BY 1;

#(7)-2 99가 리타이어라면, matchRetired가 1일 것이다.
# 검증 : 검증 완료, 99인 경우만 matchRetired가 1이다.
SELECT DISTINCT matchRetired
FROM single_speed_1004_1007
WHERE matchRank=99;

SELECT DISTINCT matchRetired
FROM single_speed_1004_1007
WHERE matchRank!=99;


#(7)-3 0이 게임 종료라면, matchTime, matchRetired, matchWin이 0이다.
# 검증 :matchTime은 null값인데, 0으로 바꿔줄 필요가 있고, matchRetired, matchWin은 0이다. 
SELECT DISTINCT matchTime
FROM single_speed_1004_1007
WHERE matchRank=0;

SELECT DISTINCT matchRetired
FROM single_speed_1004_1007
WHERE matchRank=0;

SELECT DISTINCT matchWin
FROM single_speed_1004_1007
WHERE matchRank=0;


-- ---------------------------------------------------

# (5). matchRetired가 1이면(리타이어 시), matchTime이 NULL이다.
# 검증 결과 : 검증완료
SELECT DISTINCT matchTime
FROM single_speed_1004_1007
WHERE matchRetired=1;


-- ---------------------------------------------------

# (6). 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match를 제거해 줄지 결정 필요

#(6)-1. matchWin은 승리는 1, 패배는 0, 게임 종료시 ""
#검증 결과 : 검증 완료
SELECT DISTINCT matchwin
FROM single_speed_1004_1007;

#(6)-2. 개인전이기 때문에, matchWin이 1(승리)이면, matchRank는 1일 것이다.
#검증 결과 : matchRank에 1,99값이 있다. -> matchRank가 99인데 matchwin이 1인 경우 5건이고 나머지는 0이다. 
SELECT DISTINCT matchRank
FROM single_speed_1004_1007
WHERE matchwin = 1;

# matchRank가 99인데 matchwin이 1인 경우 5건이고 나머지는 0이다. 
SELECT matchWin, count(matchWin)
FROM single_speed_1004_1007
WHERE matchRank = 99
GROUP BY 1;

SELECT *
FROM single_speed_1004_1007
WHERE matchRank = 99
ORDER BY matchWin DESC;

# 위의 경우는 리타이어된 사람과 중간에 이탈한 사람으로 구성된 match이다. 
SELECT *
FROM single_speed_1004_1007
WHERE matchId = '0051000b8c7501a7' ;


-- ---------------------------------------------------

# (7). matchTime은 같은 matchid더라도 순위에 따라 다르게 나오는 값이다. 
--  마지막 3자리가 밀리세컨드 부분, 그 앞에는 시, 분 ,초의 값이다.
--  밀리세컨드 단위로 순위가 많이 갈린다. 

#검증결과 : 검증 완료
SELECT matchRank, characterName, matchRetired, matchWin,matchTime 
FROM  single_speed_1004_1007
ORDER BY 1;

-- ---------------------------------------------------

# (8). 
#검증결과 : 검증 완료
SELECT match_start_time, match_end_time, start, end
FROM  single_speed_1004_1007
order by 1;



-- ---------------------------------------------------


# 2. 주요 지표 계산   
# 게임 종료 유저 제외하고, 모든 유저가 리타이어된 매치(2464건) 경우 포함할지 결정 필요!!!!

# 트랙별 사용 건 수 (게임 종료한 유저 만 있는 match 제외한 match에서 선택된 트랙으로 계산)  
SELECT T2.map_name, T1.cnt_match
FROM (SELECT trackId, COUNT(DISTINCT matchId) AS cnt_match
FROM single_speed_1004_1007
WHERE matchRank!=0  #게임 종료한 유저는 제외
GROUP BY 1
ORDER BY 2 DESC) AS T1 
LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId;

SELECT *
FROM single_speed_1004_1007;

# 트랙별 주행 시간
# 트랙별 matchTime을 합한 뒤 matchTime이 있는 유저수로 나눈다. -> matchTime이 있는 유저수로 나눌지, 리타이어한 유저수도 포함한 유저수로 나눌지 결정 필요
# (1) matchTime이 있는 유저수로만 나눈 경우
SELECT T2.map_name, T1.SUM_time, T1.AVG_time
FROM (SELECT trackId
	   ,SUM(matchTime) AS SUM_time
       ,AVG(matchTime) AS AVG_time
FROM single_speed_1004_1007
WHERE matchRank!=0 AND matchTime IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC) AS T1 
LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId;

# (2) 리타이어한 유저수도 포함한 Play한 유저수로만 나눈 경우
SELECT T2.map_name, T1.SUM_time, T1.AVG_time
FROM (SELECT trackId
	   ,SUM(matchTime) AS SUM_time
       ,AVG(matchTime) AS AVG_time
FROM single_speed_1004_1007
WHERE matchRank!=0
GROUP BY 1
ORDER BY 2 DESC) AS T1 
LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId;

# 트랙별 리타이어률
# 게임 종료 한 유저를 제외 한 매치에서 트랙별로 리타이어한 유저수를 구한뒤, 트랙을 플레이한 전체 유저 숫자로 나눠준다. 

# with문 생성 : 매치별 리타이어한 유저 수, 플레이 한 유저 수, 맵 네임 계산 테이블 지정
with retire_player AS
( # 매치별 리타이어한 유저 수 계산
SELECT matchId
	   ,COUNT(accountNo) AS cnt_retire_player
FROM single_speed_1004_1007
WHERE matchRank=99
GROUP BY 1), 
all_player AS 
( # 매치별 플레이한 유저 수 계산 (게임 종료 한 유저 제외)
SELECT matchId
	   ,COUNT(accountNo) AS cnt_player
FROM single_speed_1004_1007
WHERE matchRank!=0
GROUP BY 1),
match_map AS
( # 매치별 맵 네임 
SELECT TM.matchId, TN.map_name
FROM
(SELECT matchId, trackId
FROM single_speed_1004_1007) AS TM
LEFT JOIN 
track_name AS TN
ON TM.trackId = TN.trackId)
SELECT T4.map_name
	   ,SUM(cnt_retire_player) AS cnt_retire_player
       ,SUM(cnt_player) AS cnt_player
       ,(SUM(cnt_retire_player)/SUM(cnt_player))*100 AS percent_retire
FROM 
( # matchId 별 리타이어한 유저 수, 플레이 한 전체 유저 수 계산
SELECT T1.matchId
		,COALESCE(T2.cnt_retire_player,0) AS cnt_retire_player  #cnt_retire_player가 NULL값이면 리타이어된 유저가 없다는 말이어서 0으로 변환준다.
		,T1.cnt_player
FROM all_player AS T1 LEFT JOIN retire_player AS T2 ON T1.matchId = T2.matchId) AS T3
LEFT JOIN match_map AS T4  
ON T3.matchId = T4.matchId
GROUP BY 1;

# 확인 필요 => 게임 종료 유저 제외하고, 모든 유저가 리타이어된 매치(2464건) 경우 포함할지 결정 필요 
-- 모든 유저가 리타이어 된 경우 확인하는 쿼리
-- SELECT COUNT(*)
-- FROM all_player AS T1 LEFT JOIN retire_player AS T2 ON T1.matchId = T2.matchId
-- WHERE T2.cnt_retire_player = T1.cnt_player;



###### 위에서 구한 주요 지표 하나의 테이블로 합치기 
With track_cnt AS(
		SELECT T2.map_name, T1.cnt_match
		FROM (SELECT trackId, COUNT(DISTINCT matchId) AS cnt_match
		FROM single_speed_1004_1007
		WHERE matchRank!=0  #게임 종료한 유저는 제외
		GROUP BY 1
		ORDER BY 2 DESC) AS T1 
		LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId), 
matchtime_no_retire_user AS(
		SELECT T2.map_name, T1.SUM_time, T1.AVG_time
		FROM (SELECT trackId
			   ,SUM(matchTime) AS SUM_time
			   ,AVG(matchTime) AS AVG_time
		FROM single_speed_1004_1007
		WHERE matchRank!=0 AND matchTime !=0
		GROUP BY 1
		ORDER BY 2 DESC) AS T1 
		LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId),
matchtime_ALL_user AS
		(SELECT T2.map_name, T1.SUM_time, T1.AVG_time
		FROM (SELECT trackId
			   ,SUM(matchTime) AS SUM_time
			   ,AVG(matchTime) AS AVG_time
		FROM single_speed_1004_1007
		WHERE matchRank!=0
		GROUP BY 1
		ORDER BY 2 DESC) AS T1 
		LEFT JOIN track_name AS T2 ON T1.trackId = T2.trackId),
retire_cnt AS(
	SELECT T4.map_name
		   ,SUM(cnt_retire_player) AS cnt_retire_player
		   ,SUM(cnt_player) AS cnt_player
		   ,(SUM(cnt_retire_player)/SUM(cnt_player))*100 AS percent_retire
	FROM 
	( # matchId 별 리타이어한 유저 수, 플레이 한 전체 유저 수 계산
	SELECT T1.matchId
			,COALESCE(T2.cnt_retire_player,0) AS cnt_retire_player  #cnt_retire_player가 NULL값이면 리타이어된 유저가 없다는 말이어서 0으로 변환준다.
			,T1.cnt_player
	FROM ( # 매치별 플레이한 유저 수 계산 (게임 종료 한 유저 제외)
	SELECT matchId
		   ,COUNT(accountNo) AS cnt_player
	FROM single_speed_1004_1007
	WHERE matchRank!=0
	GROUP BY 1) AS T1 
	LEFT JOIN ( # 매치별 리타이어한 유저 수 계산
	SELECT matchId
		   ,COUNT(accountNo) AS cnt_retire_player
	FROM single_speed_1004_1007
	WHERE matchRank=99
	GROUP BY 1) AS T2 
	ON T1.matchId = T2.matchId) AS T3
	LEFT JOIN ( # 매치별 맵 네임 
	SELECT TM.matchId, TN.map_name
	FROM
	(SELECT matchId, trackId
	FROM single_speed_1004_1007) AS TM
	LEFT JOIN 
	track_name AS TN
	ON TM.trackId = TN.trackId) AS T4  
	ON T3.matchId = T4.matchId
	GROUP BY 1)

SELECT T1.map_name
,T1.cnt_match
,T2.SUM_time AS no_retire_SUM_time
,T2.AVG_time AS no_retire_SUM_time
,T3.SUM_time AS all_SUM_time
,T3.AVG_time AS all_AVG_time
,T4.cnt_retire_player
,T4.cnt_player
,T4.percent_retire
FROM track_cnt AS T1 LEFT JOIN
matchtime_no_retire_user AS T2 ON T1.map_name = T2.map_name LEFT JOIN
matchtime_ALL_user AS T3 ON T1.map_name = T3.map_name LEFT JOIN
retire_cnt AS T4 ON T1.map_name = T4.map_name
ORDER BY 2 DESC;