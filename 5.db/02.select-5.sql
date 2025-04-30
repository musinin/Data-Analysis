-- 1. 작업 데이터베이스 변경 (sakila)
USE sakila;

-- 2. 테이블 목록보기
SHOW tables;

-- 3. film 테이블 구조 보기
DESC film;

-- 4. film 테이블 데이터 조회
SELECT * 
FROM film;

SELECT film_id, title, release_year, length, rating
FROM film;

-- 5. 상영시간이 90분 이내인 영화 조회
SELECT *
FROM film
WHERE length <= 90;

-- 6. rating 별로 영화 개수 조회
SELECT rating, COUNT(*) 영화편수
FROM film
group by rating ;

-- 7. 고객정보 조회
SELECT *
FROM customer;

-- 8. 고객 아이디, 이름, 이메일 조회
SELECT 
	customer_id, 
    concat(first_name,' ',last_name) name, 
    email
FROM customer;

-- 9. 1번 매장의 유효 고객 조회
select * 
from customer
where store_id = 1 and active = 1;

-- 10. 대여 테이블 데이터를 반납일 순으로 조회
select *
from rental
where return_date is not null
order by return_date DESC;

-- ----------------------------------------------------

-- 11. 'MARY SMITH' 고객의 대여 내역 조회
select * from customer;
select * from rental;

SELECT *
FROM rental
WHERE customer_id = (SELECT customer_id
					 FROM customer
                     WHERE first_name = 'MARY'
						   AND
                           last_name = 'SMITH');





