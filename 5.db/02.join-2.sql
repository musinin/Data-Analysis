-- madang_db로 작업 데이터베이스 변경
USE madang_db;

-- 1. 고객별 (고객이름 같이 조회) 구매액 합계 ( customer, orders )
select c.custid, c.name, sum(o.saleprice)
from customer c 
left outer join orders o on c.custid = o.custid
GROUP BY c.custid, c.name;


-- 2. 고객아이디, 고객이름, 도서명, 주문 정보 ( customer, book, orders )
select c.custid, c.name, b.bookname, o.*
from customer c 
inner join orders o on c.custid = o.custid
inner join book b on b.bookid = o.bookid;

-- 3.  박지성 고객이 구매한 도서의 출판사 수 ( customer, orders, book )
select c.name, count(DISTINCT publisher) 출판사수
from customer c 
inner join orders o on c.custid = o.custid
inner join book b on b.bookid = o.bookid
where c.name = '박지성';

-- 4.  박지성 고객이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이 ( customer, orders, book )
select c.name, b.bookname, b.price, (b.price - o.saleprice) 가격차
from customer c 
inner join orders o on c.custid = o.custid
inner join book b on b.bookid = o.bookid
where c.name = '박지성';

-- 5. 고객의 이름과 고객이 구매한 도서 목록 ( customer, orders, book )
select c.name, b.bookname
from customer c 
inner join  orders o on c.custid = o.custid
inner join  book b on b.bookid = o.bookid;

