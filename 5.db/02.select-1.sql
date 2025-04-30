-- 2. select 만으로 구성된 Query
SELECT USER();

-- 1. 작업 데이터베이스 선택
USE univdb;

-- 2. 전체 학생의 이름과 주소 검색
SELECT 이름, 주소
FROM 학생;

-- 3. 전체 학생의 모든 정보 검색
SELECT 학번, 이름, 주소, 학년, 나이, 성별, 휴대폰번호, 소속학과
FROM 학생;

SELECT *	-- * : 모든컬럼
FROM 학생;

-- 4. 학과 목록을 조회
SELECT 소속학과
FROM 학생;

SELECT DISTINCT 소속학과	-- DISTINCT : 중복제거
FROM 학생;

-- 5-1. 컴퓨터 학과 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
WHERE 소속학과 = '컴퓨터';	-- SQL에서 문자열은 ''(작은따옴표) 사용 '와"는 구분

-- 5-2. 3학년 이상인 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
WHERE 학년 >= 3;

-- 5-3. 3학년 이상인 컴퓨터 학과 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
WHERE 소속학과 = '컴퓨터' AND 학년 >= 3;	-- 두개 이상의 조건 결합시 AND, OR 사용

-- 6-1. 컴퓨터 학과가 아닌 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
-- WHERE 소속학과 != '컴퓨터';	
-- WHERE 소속학과 <> '컴퓨터';		책이 소개하는 표준방식
WHERE NOT (소속학과 = '컴퓨터');

-- 6-2. 1,2,3학년 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
-- WHERE 학년 = 1 OR 학년 = 2 OR 학년 = 3;
-- WHERE 학년 IN(1, 2, 3);
-- WHERE 학년 >= 1 AND 학년 <= 3;
WHERE 학년 BETWEEN 1 AND 3;

-- 6-3. 1,2,3학년이거나 컴퓨터 학과가 아닌 학생의 이름, 학년, 소속학과, 휴대폰번호 조회
SELECT 이름, 학년, 소속학과, 휴대폰번호
FROM 학생
WHERE (학년 BETWEEN 1 AND 3) OR (NOT (소속학과 = '컴퓨터')) ;

-- 7-1. 학년 순으로 모든 학생의 이름, 학년, 소속학과 조회
SELECT 이름, 학년, 소속학과
FROM 학생
-- ORDER BY 학년;
-- ORDER BY 학년 ASC;	-- 오름차순 정렬 (작은 값 -> 큰값)
ORDER BY 학년 DESC;	-- 내림차순 정렬 (큰값 -> 작은 값)

-- 7-2. 학과 및 학년 순으로 모든 학생의 이름, 학년, 소속학과 조회
SELECT 이름, 학년, 소속학과
FROM 학생
ORDER BY 소속학과 ASC, 학년 DESC;

-- 8-1. 학생 수 조회
SELECT COUNT(*)			-- 모든 행의 개수
FROM 학생;

SELECT COUNT(학번)		-- 학번 컬럼의 값이 null이 아닌 행의 개수
FROM 학생;

SELECT COUNT(휴대폰번호)	-- 휴대폰번호 컬럼의 값이 null이 아닌 행의 개수
FROM 학생;

-- 8-2. 학과 수 조회
-- SELECT COUNT(DISTINCT 소속학과) AS 학과수	-- 중복을 제거한 행의 개수
SELECT COUNT(DISTINCT 소속학과) 학과수
FROM 학생;

-- 9. 학생의 나이 평균, 최대, 최저값 조회
SELECT AVG(나이) 평균나이, MAX(나이) 최연장, MIN(나이) 최연소
FROM 학생;

-- 10-1. 성별 최고나이, 최저나이 조회
SELECT 성별, MAX(나이) 최고나이, MIN(나이) 최저나이
FROM 학생
GROUP BY 성별;

SELECT 이름, 성별, MAX(나이) 최고나이, MIN(나이) 최저나이	-- 오류 : GROUP BY에서 사용된 컬럼만 조회 가능
FROM 학생
GROUP BY 성별;

-- 10-2. 나이별 학생수 조회
SELECT 나이, COUNT(*) 학생수
FROM 학생
GROUP BY 나이;

-- 10-3. 나이별 학생수가 2 이상인 나이별 학생수 조회 
SELECT 나이, COUNT(*) 학생수
FROM 학생
-- WHERE COUNT(*) >= 2 	-- 오류 : GROUP BY있는 구문의 WHERE에서 집계합수 사용불가
GROUP BY 나이
HAVING COUNT(*) >= 2; 	-- HAVING : GROUP BY 이후 실행되는 조검검사 구문

 -- 11-1. 성이 이인 학생 조회
SELECT *
FROM 학생
WHERE 이름 LIKE '이%';

 -- 11-2. 주소지가 서울인 학생 조회
SELECT *
FROM 학생
-- WHERE 주소 LIKE '%서울%';	성능이 낮아질수 있다
WHERE 주소 LIKE '서울%';

-- 12-1. 휴대폰번호가 없는(NULL) 학생 조회 (NULL = 무엇이 들어있는지 모름, 없는게 아님 garbege상태와 같다고 볼수 있다)
SELECT *
FROM 학생
-- WHERE 휴대폰번호 = NULL;		-- NULL은 알수 없는 값이기 때문에 = 연산자로 직접 비교 불가
WHERE 휴대폰번호 is NULL;

-- 12-2. 휴대폰번호가 있는 학생 조회
SELECT *
FROM 학생
-- WHERE 휴대폰번호 != NULL;		-- NULL은 알수 없는 값이기 때문에 = 연산자로 직접 비교 불가
WHERE 휴대폰번호 is NOT NULL;




