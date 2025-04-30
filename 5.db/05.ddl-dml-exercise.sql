-- 작업 데이터베이스 변경 (univDB)
USE univDB;

-- [ 테이블 만들기 ]

-- 1. tbl_member
--    memberid 문자열 PK
--    passwd 문자열 NOT NULL
--    email 문자열 NOT NULL UNIQUE
--    usertype 문자열 NULL
--    regdate datetime
--    active BOOLEAN 

CREATE TABLE tbl_member
(	memberid VARCHAR(50) PRIMARY KEY,
    passwd VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    usertype VARCHAR(10),
	regdate DATETIME,
	active BOOLEAN
);

-- 2. tbl_board
--    boardno int PK 자동증가
--    writer 문자열 NOT NULL
--    title 문자열 NOT NULL
--    content 문자열 not null
--    writedate DATETIME
--    modifydate DATETIME
--    readcount int 
--    외래키 writer -> tbl_member(memberid)  

CREATE TABLE tbl_board
(	boardno INT NOT NULL AUTO_INCREMENT,
    writer VARCHAR(100) NOT NULL,
    title VARCHAR(100) NOT NULL,
    content VARCHAR(100) NOT NULL,
    writedate DATETIME,
    modifydate DATETIME,
    readcount int,
    PRIMARY KEY (boardno),
	FOREIGN KEY (writer) REFERENCES tbl_member(memberid)
);

-- 3. tbl_comment
--    commentno int pk 자동증가
--    writer 문자열 NOT NULL
--    boardno INT not null
--    content 문자열 not null
--    writedate DATETIME
--    modifydate DATETIME
--    외래키 boardno -> tbl_board(boardno)
--    외래키 writer -> tbl_member(memberid)

CREATE TABLE tbl_comment
(	commentno INT NOT NULL AUTO_INCREMENT,
    writer VARCHAR(100) NOT NULL,
    boardno INT NOT NULL,
    content VARCHAR(100) NOT NULL,
    writedate DATETIME,
    modifydate DATETIME,
    readcount int,
    PRIMARY KEY (commentno),
	FOREIGN KEY (boardno) REFERENCES tbl_board(boardno),
    FOREIGN KEY (writer) REFERENCES tbl_member(memberid)
);

-- [ 테이블 수정 ]
-- 1. tbl_member 
--    usergrade int 컬럼 추가
--    regdate 컬럼 -> joindate 컬럼으로 변경

ALTER TABLE tbl_member 
ADD COLUMN usergrade int NULL, 
CHANGE COLUMN regdate joindate DATETIME;

-- 2. tbl_board
--    category 문자열 not null 컬럼 추가

ALTER TABLE tbl_board 
ADD COLUMN category VARCHAR(50) NOT NULL;

-- [ 데이터 추가 ]

-- 1. tbl_member 테이블 데이터 추가
select * from tbl_member;
--    'iamuserone', 'iamuserone', 'iamuserone@example.com', 'user', now(), true
--    'iamusertwo', 'iamusertwo', 'iamusertwo@example.com', 'user', now(), true
--    'iamuserthree', 'iamuserthree', 'iamuserthree@example.com', 'user', now(), true
--    'iamadminone', 'iamadminone', 'iamadminone@example.com', 'admin', now(), true

INSERT INTO tbl_member (memberid, passwd, email, usertype, joindate, active)
VALUES ('iamuserone', 'iamuserone', 'iamuserone@example.com', 'user', now(), true),
	   ('iamusertwo', 'iamusertwo', 'iamusertwo@example.com', 'user', now(), true),
       ('iamuserthree', 'iamuserthree', 'iamuserthree@example.com', 'user', now(), true),
       ('iamadminone', 'iamadminone', 'iamadminone@example.com', 'admin', now(), true);
select * from tbl_member;

-- 2. tbl_board 테이블 데이터 추가
select * from tbl_board;
--    'iamuserone', '게시글 연습 1', '게시글 작성 연습입니다.', now(), now(), 0, 1 
--    'iamuserone', '게시글 연습 2', '게시글 작성 연습입니다.', now(), now(), 0, 1
--    'iamuserone', '게시글 연습 3', '게시글 작성 연습입니다.', now(), now(), 0, 1

INSERT INTO tbl_board (writer, title, content, writedate, modifydate, readcount, category)
VALUES ('iamuserone', '게시글 연습 1', '게시글 작성 연습입니다.', now(), now(), 0, 1 ),
	   ('iamuserone', '게시글 연습 2', '게시글 작성 연습입니다.', now(), now(), 0, 1),
       ('iamuserone', '게시글 연습 3', '게시글 작성 연습입니다.', now(), now(), 0, 1);
select * from tbl_board;
 
-- 3. tbl_comment 테이블 데이터 추가
select * from tbl_comment;
--    - 아래 1, 2, 3은 글번호인데 2번에서 삽입된 글번호 사용
--    'iamusertwo', 1, '게시글 1에 대한 댓글', now(), now()
--    'iamusertwo', 2, '게시글 2에 대한 댓글', now(), now()
--    'iamusertwo', 3, '게시글 3에 대한 댓글', now(), now()

INSERT INTO tbl_comment (writer, boardno, content, writedate, modifydate)
VALUES('iamusertwo', 1, '게시글 1에 대한 댓글', now(), now()),
	  ('iamusertwo', 2, '게시글 2에 대한 댓글', now(), now()),
      ('iamusertwo', 3, '게시글 3에 대한 댓글', now(), now());
select * from tbl_comment;

-- [ 데이터 수정 ]
-- iamuserone 사용자의 password는 'Pa$$word'로 이메일은 'iamuserone@naver.com'으로 변경
update tbl_member
set passwd = 'Pa$$word', email = 'iamuserone@naver.com'
where memberid = 'iamuserone';

-- 1번 게시글의 제목은 '수정된 게시글 1'로 modifydate는 now() 로 변경
update tbl_board
set title = '수정된 게시글 1', modifydate = now()
where boardno = 1;

-- [ 데이터 삭제 ]
-- iamuserthree 사용자 삭제
delete from tbl_member 
where memberid = 'iamuserthree';

select * from tbl_member;
select * from tbl_board;


