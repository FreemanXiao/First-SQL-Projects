-- Assginment 2
-- Group green

use yelp;

-- Part A
-- q1 we want the coffee in name but not in the category-
-- we want to select business id and name

select distinct a.business_id, a.name
from (select distinct business_id, name
from business
where name LIKE '%coffee%' and state = 'PA') a
where a.business_id not in(
	select b.business_id
	from(select business_id,category_name
		 from category 
		 where category_name LIKE '%coffee%') b)
order by a.business_id asc;

-- q2 -- we want to find the 
-- Creat view
create or replace view review_count as
select b.business_id, b.name, count(review_id) as Review_number, b.state, c.category_name
from review r
left join category c using(business_id)
left join business b using(business_id)
where c.category_name = 'Bars'
group by b.name, b.state, b.business_id;

select*
from review_count;
-- drop view review_count;

-- Store the maximum number of reviews received by a business in each state in a view called max_review_count.
create or replace view max_review_count as
select max(review_number) as max_review, state
from review_count
group by state
having max(review_number);
-- drop view max_review_count;

-- Join together
select c.state, c.business_id, c.name, c.max_review
from(select *
	 from review_count r
	 left join max_review_count m using(state)) c
where c.review_number = c.max_review
order by c.state asc; 

-- Part B
-- Q1 create opening date view
create or replace view opening_date as
select r.business_id, min(r.date) as opening_date
from review r
left join category c using(business_id)
where c.category_name = "Restaurants"
group by business_id;

-- Q2
-- show the busines id sub c and open data
create or replace view all_restaurants as
select a.business_id, a.category_name, od2.opening_date
from (select c.business_id, c.category_name
	  from category c
	  where c.business_id in(
			select business_id
			from opening_date))a
left join opening_date od2 using(business_id)
where a.category_name != "Restaurants"; 

-- create a view for 2018
create or replace view openings_in_2018 as
select category_name as category, count(business_id)as new_open
from(select a.business_id, a.category_name, od2.opening_date
	 from (select c.business_id, c.category_name
		   from category c
		   where c.business_id in(
				select business_id
				from opening_date))a
	  left join opening_date od2 using(business_id)
      where a.category_name != "Restaurants") b
where opening_date like '%2018%'
group by category_name;

-- Q3
-- create a view for 2019
create or replace view openings_in_2019 as 
select category_name as category, count(business_id)as new_open
from(select a.business_id, a.category_name, od2.opening_date
	 from (select c.business_id, c.category_name
		   from category c
		   where c.business_id in(
				select business_id
				from opening_date))a
	  left join opening_date od2 using(business_id)
      where a.category_name != "Restaurants") b
where opening_date like '%2019%'
group by category_name;

-- Q4
create or replace view change_rate as 
select o1.category, 
       round(((IFNULL(o2.new_open, 0)-IFNULL(o1.new_open, 0))/IFNULL(o1.new_open, 0)*100)) as Percentage_Change_in_New_Restaurants_from_2018_to_2019
from openings_in_2018 o1
left outer join openings_in_2019 o2 using(category)
where o1.new_open >= 20
order by abs(Percentage_Change_in_New_Restaurants_from_2018_to_2019) desc; 
-- Show the result
select *
from change_rate;

-- Q5
-- (i) Total change rate
-- 2018 total new resaurant
select count(DISTINCT business_id) as new_restaurants
from all_restaurants
where opening_date like '%2018%';
-- There are total 2705 new restaurant in 2018

-- 2019 total new resaurant
select count(DISTINCT business_id)as new_restaurants
from all_restaurants
where opening_date like '%2019%';
-- (2547-2705)/2547 = -0.0584103512
-- There are total 2547 new restaurant in 2019 and 2705 new restaurant in 2018,
-- The change rate is -5.84%

-- (ii) maximum percentage increase
select category, Percentage_Change_in_New_Restaurants_from_2018_to_2019
from change_rate
order by Percentage_Change_in_New_Restaurants_from_2018_to_2019 desc
limit 1; 
-- the restaurant subcategory with the maximum percentage increase in new restaurants from 2018 to 2019 is 
-- Hot Dogs with a 71% increase precentage. 

-- (iii) minimum percentage increase
select category, Percentage_Change_in_New_Restaurants_from_2018_to_2019
from change_rate
order by Percentage_Change_in_New_Restaurants_from_2018_to_2019 asc
limit 1; 
-- the restaurant subcategory with the maximum percentage decrease in new restaurants from 2018 to 2019 is
-- Convenience Stores with 42% decreace percentage. 







