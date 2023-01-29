-- GB760: Homework 1 (save and submit this file on Canvas when complete)

-- Part A: Run the queries below to test
-- if you completed Part A successfully
USE yelp;
SELECT COUNT(*) FROM business; -- expected output: 150346
SELECT COUNT(*) FROM category; -- expected output: 668592
SELECT COUNT(*) FROM user; -- expected output: 1987897
SELECT COUNT(*) FROM review; -- expected output: 6990280

-- PART B: Write your SQL queries for each
-- question below the respective comment
-- for that question

-- Your Part B Q1 solution below
select distinct category_name
from category
order by category_name ASC; 

-- Your Part B Q2 solution below
select state, count(business_id) as business_count
from business
group by state
order by business_count desc
limit 3; 

-- Your Part B Q3 solution below
-- Expected answer: 52268
select count(*)
from category
where category_name = 'Restaurants'; 


-- Your Part B Q4 solution below
-- Expected answer: 4724471
select c.category_name, count(*) as review_count
from review r
left join category c using (business_id)
where c.category_name = 'Restaurants';

-- Your Part B Q5 solution below
select u.name, c.category_name, count(category_name) as restaurants_counts
from review r
	left join category c using (business_id)
	left join user u using (user_id)
where r.date >= '2021-01-01' and c.category_name = 'Restaurants'
group by u.name
order by restaurants_counts DESC
limit 3; 


-- PART C: Write your SQL queries below the respective comment for that
-- question. For text responses, write your response as a multi-line comment
-- (by starting each line with "--" just like this one)

-- Your Part C Q1 solution below
-- Subpart a
select u.uid, u.name, count(distinct b.state) as num_states, count(r.review_id) as num_reviews
from review r
	left join user u using(user_id)
	left join category c using(business_id)
	left join business b using(business_id)
where category_name = 'Restaurants'
group by u.uid, u.name
HAVING count(r.review_id) >= 500
order by num_states DESC, num_reviews DESC
limit 3; 


-- answer: uid:4852 name:Peter Home state: IN
		-- uid:38905 name:Craig Home state: PA
		-- uit:198824  name:Michelle Home state: PA

-- Subpart b
select u.uid, b.state, count(review_id) as num_reviews
from review r
	left join user u using(user_id)
	left join category c using(business_id)
	left join business b using(business_id)
where c.category_name = 'Restaurants' and u.uid in (4852,38905,198824)
group by b.state, u.uid
order by u.uid asc, num_reviews desc; 

-- Subpart c
(
select u.uid, b.state as home_state, avg(r.stars) as Average_Stars_in_Home_State
from review r
	left join user u using(user_id)
	left join category c using(business_id)
	left join business b using(business_id)
where c.category_name = 'Restaurants' and u.uid in (4852)
group by b.state
order by count(review_id) desc
limit 1
)
union 
(
select u.uid, b.state as home_state, avg(r.stars) as Average_Stars_in_Home_State
from review r
	left join user u using(user_id)
	left join category c using(business_id)
	left join business b using(business_id)
where c.category_name = 'Restaurants' and u.uid in (198824)
group by b.state
order by count(review_id) desc
limit 1
)
union
(
select u.uid, b.state as home_state, avg(r.stars) as Average_Stars_in_Home_State
from review r
	left join user u using(user_id)
	left join category c using(business_id)
	left join business b using(business_id)
where c.category_name = 'Restaurants' and u.uid in (38905)
group by b.state
order by count(review_id) desc
limit 1
); 

-- Subpart d

(
select a.uid, a.home_state, b.Average_Stars_Not_in_Home_state
from(
	select u.uid, b.state as home_state
	from review r
		left join user u using(user_id)
		left join category c using(business_id)
		left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (4852)
	group by b.state
	order by count(review_id) desc
	limit 1
    ) a
	left join(
	select u.uid, avg(r.stars) as Average_Stars_Not_in_Home_state
	from review r
			left join user u using(user_id)
			left join category c using(business_id)
			left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (4852) and b.state != "IN"
	group by u.uid)b using(uid)
)
union
(
select a.uid, a.home_state, b.Average_Stars_Not_in_Home_state
from(
	select u.uid, b.state as home_state
	from review r
	left join user u using(user_id)
		left join category c using(business_id)
		left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (198824)
	group by b.state
	order by count(review_id) desc
	limit 1
    ) a
	left join(
	select u.uid, avg(r.stars) as Average_Stars_Not_in_Home_state
	from review r
		left join user u using(user_id)
		left join category c using(business_id)
		left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (198824) and b.state != "PA"
	group by u.uid)b using(uid)
)
union
(
select a.uid, a.home_state, b.Average_Stars_Not_in_Home_state
from(
	select u.uid, b.state as home_state
	from review r
		left join user u using(user_id)
		left join category c using(business_id)
		left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (38905)
	group by b.state
	order by count(review_id) desc
	limit 1
	)a
	left join(
	select u.uid, avg(r.stars) as Average_Stars_Not_in_Home_state
	from review r
		left join user u using(user_id)
		left join category c using(business_id)
		left join business b using(business_id)
	where c.category_name = 'Restaurants' and u.uid in (38905) and b.state != "PA"
	group by u.uid)b using(uid)
)

-- Your Part C Q2 solution below

-- For our analytics project, we plan to use the Yelp dataset to look at 
-- how the covid-19 pandemic affected the number of reviews and average rating of reviews for different categories of businesses. 
-- We believe that all the data we need will be within the Yelp dataset, 
-- specifically the business, category, and review tables. 
-- We think that it will be interesting to see 
-- if customers responded to the economic and health changes of the pandemic 
-- by being more or less generous to different business categories. 
-- Some business categories necessitated greater change to operate throughout the pandemic, 
-- such as restaurants that had to increase their capacity for takeout and delivery. 
-- It will be important for us to consider and analyze 
-- whether year-to-year changes in reviews are a result of the prevalence of the pandemic or other factors, 
-- such as changing business popularity or quality of product/service.
-- Ultimately, our project will provide a snapshot of how business reviews changed throughout the pandemic.