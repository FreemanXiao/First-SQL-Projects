-- GB 760 Mid-Term Exam Part A
-- Xiao Zhang

-- Snowflake Preparation
USE ROLE accountadmin; -- only on Snowflake
USE WAREHOUSE compute_wh; -- only on Snowflake
USE DATABASE yelp; -- both Snowflake and MySQL
USE SCHEMA public; -- only on Snowflak
use yelp;

-- Part A Q1
-- 1
CREATE OR REPLACE VIEW category_average_starts AS
select c.category_name, count(distinct b.business_id) as number, avg(r.stars) as average_stars
from business b
left join category c using(business_id)
left join review r using(business_id)
where b.business_id in(
    Select b.business_id
    from business b
    left join category c using(business_id)
    left join review r using(business_id)
    where c.category_name = 'Restaurants')
and c.category_name != 'Restaurants'
group by c.category_name;

-- 2 & 3
-- final result. 
select category_name, average_stars,number
from category_average_starts
where number >= 100
Order by average_stars desc, number desc, category_name asc;
-- Just create a view for the result
CREATE OR REPLACE VIEW category_average_rating AS
select category_name, average_stars,number
from category_average_starts
where number >= 100
Order by average_stars desc, number desc, category_name asc;


-- Part A Q2
-- Creat view of business_average_rating
CREATE OR REPLACE VIEW business_average_rating AS
select r.business_id, b.name, avg(r.stars) as business_average_stars
from review r
left join category c using(business_id)
left join business b using(business_id)
where c.category_name = 'Restaurants'
group by r.business_id, b.name;

-- Creat view of whole data... just everything
CREATE OR REPLACE VIEW whole_data AS
select c.business_id, c.category_name, bu.name, ca.average_stars,bu.business_average_stars
from category c
left join category_average_rating ca using(category_name)
left join business_average_rating bu using(business_id);

-- final result, I get it right!!!!!
select business_id, name, avg(business_average_stars) as average_rating,
max(average_stars)as maximum_of_the_average_ratings
from whole_data
group by business_id, name
having avg(business_average_stars) > max(average_stars)
order by maximum_of_the_average_ratings desc, average_rating desc, name asc; 
