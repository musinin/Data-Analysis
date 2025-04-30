-- 작업 데이터베이스 선택 (madang_db)
USE madang_db;

-- 2. 가장 비싼 도서의 이름, 가격 조회
select * from book;
select max(price) from book;
select * from book where price = 35000;

select * from book where price = (select max(price) from book);

-- 3. 도서 구매 실적이 있는 고객 조회
select distinct custid from orders;

select * 
from customer
where custid in (1, 2, 3, 4);

select * 
from customer
where custid in (select distinct custid from orders);

-- 4. '대한미디어'에서 출간한 도서를 구매한 고객 정보 조회
select *
from customer
where custid in (select custid 
				 from orders
                 where bookid in (select bookid
								 from book
                                 where publisher = '대한미디어'));
                                 
-- 5. 고객별 판매액 조회 (고객 이름도 같이 조회) 스칼라부속지리 (=상관부속지리)
select custid, 
	   (select name from customer where customer.custid = orders.custid) name, 
       sum(saleprice)
from orders
group by custid;

select custid, 
	   (select name from customer c where c.custid = o.custid) name, 
       sum(saleprice)
from orders o -- 별칭(alias) 사용 : orders 대신 o를 이름으로 사용하는 선언
group by custid;


-- 6. 출판사별로 출간한 도서의 평균가격보다 비싼 도서 조회
select publisher, avg(price)
from book
-- group by publisher;
where publisher ='굿스포츠';

select *
from book b1
-- where price > 현재 처리중인 행의 출판사가 출간한 도서의 평균가격;
where price > ( select avg(price)
			    from book b2
                where b1.publisher = b2.publisher);





