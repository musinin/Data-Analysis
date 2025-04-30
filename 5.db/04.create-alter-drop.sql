-- 1. 작업 데이터베이스 선택 (univDB)
USE univDB;

-- 2-1. 테이블 만들기 (컬럼명, 자료형)
SELECT * FROM 과목;
CREATE TABLE 과목2
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4),
    이름 VARCHAR(20),
    강의실 SMALLINT,
    개설학과 VARCHAR(20),
    시수 SMALLINT
);

-- 2-2. 테이블 만들기 (기본키 지정 1)
CREATE TABLE 과목3
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4) PRIMARY KEY,
    이름 VARCHAR(20),
    강의실 SMALLINT,
    개설학과 VARCHAR(20),
    시수 SMALLINT
);

-- 2-3. 테이블 만들기 (기본키 지정 2)
CREATE TABLE 과목4
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4),
    이름 VARCHAR(20),
    강의실 SMALLINT,
    개설학과 VARCHAR(20),
    시수 SMALLINT,
    -- PRIMARY KEY (과목번호)
    CONSTRAINT PK_과목4 PRIMARY KEY (과목번호)
);

-- 2-4. 테이블 만들기 (제약조건 - NULL 허용 여부)
CREATE TABLE 과목5
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4) NOT NULL,
    이름 VARCHAR(20) NOT NULL,
    강의실 SMALLINT NULL,
    개설학과 VARCHAR(20) NOT NULL,
    시수 SMALLINT NOT NULL,
    CONSTRAINT PK_과목5 PRIMARY KEY (과목번호)
);

-- 2-5. 테이블 만들기 (제약조건 - DEFAULT)
CREATE TABLE 과목6
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4) NOT NULL,
    이름 VARCHAR(20) NOT NULL,
    강의실 SMALLINT NULL,
    개설학과 VARCHAR(20) NOT NULL,
    시수 SMALLINT DEFAULT(3) ,	-- 값이 지정되지 않으면 3을 사용
    CONSTRAINT PK_과목6 PRIMARY KEY (과목번호)
);

-- 2-6. 테이블 만들기 (제약조건 - CHECK 제약 조건)
CREATE TABLE 과목7
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 CHAR(4) NOT NULL,
    이름 VARCHAR(20) NOT NULL,
    강의실 SMALLINT NULL,
    개설학과 VARCHAR(20) NOT NULL,
    시수 SMALLINT DEFAULT(3) CHECK(시수 > 0),
    CONSTRAINT PK_과목7 PRIMARY KEY  (과목번호)
    -- , CONSTRAINT CHK_시수 CHECK(시수 > 0)
);

INSERT INTO 과목7
VALUES ('C001', '테스트1', 1, '테스트1', -1);

-- 2-7. 테이블 만들기 (자동증가 컬럼)
CREATE TABLE 과목8
( 	-- 컬럼이름 자료형 제약조건1 제약조건2 ...
	과목번호 INT NOT NULL AUTO_INCREMENT, -- 이 컬럼의 값은 INSERT 할때마다 1, 2, 3, ... 순서로 자동 저장
    이름 VARCHAR(20) NOT NULL,
    강의실 SMALLINT NULL,
    개설학과 VARCHAR(20) NOT NULL,
    시수 SMALLINT DEFAULT(3) CHECK(시수 > 0),
    -- PRIMARY KEY (과목번호)
    CONSTRAINT PK_과목8 PRIMARY KEY  (과목번호)
    -- , CONSTRAINT CHK_시수 CHECK(시수 > 0)
);

INSERT INTO 과목8 (이름, 강의실, 개설학과)
VALUES ('테스트1', 1, '테스트1');
INSERT INTO 과목8 (이름, 강의실, 개설학과)
VALUES ('테스트2', 2, '테스트1');

-- 2-8. 테이블 만들기 (관계 만들기 - UNIQUE)
CREATE TABLE `학생2` (
  `학번` char(4) NOT NULL,
  `이름` varchar(20) NOT NULL,
  `주소` varchar(50) DEFAULT '미정',
  `학년` int NOT NULL,
  `나이` int DEFAULT NULL,
  `성별` char(1) NOT NULL,
  `휴대폰번호` char(14) DEFAULT NULL,
  `소속학과` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`학번`),
  UNIQUE (`휴대폰번호`)
);

-- 2-8. 테이블 만들기 (관계 만들기 - Foreign key)
CREATE TABLE `수강2` (
  `학번` char(6) NOT NULL,
  `과목번호` char(4) NOT NULL,
  `신청날짜` date NOT NULL,
  `중간성적` int DEFAULT '0',
  `기말성적` int DEFAULT '0',
  `평가학점` char(1) DEFAULT NULL,
  PRIMARY KEY (`학번`,`과목번호`),
  FOREIGN KEY (`학번`) REFERENCES 학생2(학번),
  FOREIGN KEY (`과목번호`) REFERENCES 과목7(과목번호)
);

-- 2-10. 테이블 사이의 데이터 복제 (복사) : 과목 -> 과목 7
insert into 과목7
select * from 과목;

select * from 과목7;

-- 2-11. 다른 테이블을 기반으로 복제된 테이블 만들기
CREATE TABLE 학생3
AS
SELECT * FROM 학생; 

SELECT * FROM 학생3;

-- 3-1. 테이블 수정 (변경)
ALTER TABLE 과목6
ADD COLUMN 과목설명 VARCHAR(500) NULL, 
CHANGE COLUMN 이름 이름 VARCHAR(50) NOT NULL,
CHANGE COLUMN 시수 학점 SMALLINT NOT NULL
-- , DROP COLUMN 강의실
-- , ADD CONSTRAINT `constraint_name` FOREIGN KEY(`column_name`) REFFRENCES `TABLE_NAME`(`column_name`)
;

-- 4-1. 테이블 제거 (삭제)
DROP TABLE IF EXISTS 과목2;
DROP TABLE 과목3;
DROP TABLE 과목4;
DROP TABLE 과목5;
DROP TABLE 과목6;

DROP TABLE 과목7; -- 오류 : 다른 테이블이 과목7 테이블을 외래키로 참조 -> 참조 테이블을 제거한 후 삭제 가능

DROP TABLE 수강2;
DROP TABLE 과목7;




