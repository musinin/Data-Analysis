-- 1. 작업데이터베이스 선택(univDB)
USE univDB;

-- 2. cross join
select *
from 학생, 수강
order by 학생.학번;

select *
from 학생 cross join 수강
order by 학생.학번;

-- 3. 학생의 수강정보 조회 (학생의 이름 포함)
select * from 수강; 		-- 학생이름 정보 없음
select * from 학생;		-- 학생이름 정보 포함

select * 
from 학생 s, 수강 a
where s.학번 = a.학번; 

select * 
from 학생 s inner join 수강 a
on s.학번 = a.학번;

-- 4. 'c002' 과목을 수강한 학생의 학번, 이름, 과목번호, 중간성적 조회
select s.학번, s.이름, a.과목번호, a.중간성적
from 학생 s, 수강 a
where s.학번 = a.학번 and a.과목번호 = 'c002' ;

select s.학번, s.이름, a.과목번호, a.중간성적
from 학생 s inner join 수강 a
on s.학번 = a.학번 
where a.과목번호 = 'c002' ;

-- 5. '정보보호' 과목을 수강한 학생의 학번, 이름, 과목번호 조회
select s.학번, s.이름, l.과목번호
from 학생 s, 수강 a, 과목 l
where s.학번 = a.학번 
	  and a.과목번호 = l.과목번호 
      and l.이름 = '정보보호';

select s.학번, s.이름, l.과목번호
from 학생 s
inner join 수강 a
on s.학번 = a.학번
inner join  과목 l
on a.과목번호 = l.과목번호 
where l.이름 = '정보보호';

-- 6. 주소가 같은 학생들의 이름을 쌍으로 검색 (셀프조인)
select * from 학생 a;
select * from 학생 b;
-- a.name b.name
-- 송윤아 4 이영애 2

select a.이름, a.학년, b.이름, b.학년 
from 학생 a, 학생 b
where a.주소 = b.주소 and a.학년 > b.학년 ;

-- 7. 모든 학생의 학번, 이름, 수강과목, 학점 조회
select s.학번, s.이름, a.과목번호, a.평가학점
from 학생 s, 수강 a 
where s.학번 = a.학번;

select s.학번, s.이름, a.과목번호, a.평가학점
from 학생 s 
-- inner join 수강 a	 	-- inner join : 양쪽 테이블에 모두 존재하는 데이터만 조회
left outer join 수강 a	-- left outer join: 왼쪽 테이블은 모두, 오른쪽 테이블은 둘다 존재하는 데이터만 조회
on s.학번 = a.학번;

select s.학번, s.이름, a.과목번호, a.평가학점
from 수강 a 
right outer join 학생 s	-- right outer join: 오른쪽 테이블은 모두, 왼쪽 테이블은 둘다 존재하는 데이터만 조회
on s.학번 = a.학번;

 

