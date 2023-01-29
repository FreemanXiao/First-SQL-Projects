use yelp; 
-- create month project
Select rid, date_format(date,'%y%m') as review_month
from review
group by rid;

-- join
create or replace view review_month as
select *
from review r
left join (Select rid, date_format(date,'%y%m') as review_month
		   from review
		   group by rid) a using(rid);

-- Only select data from 2019-01 to 2021-12
select review_month, count(*)
from review_month
where review_month between 1901 and 2112
group by review_month
order by review_month asc;

-- focus on PA
select review_month, count(*), b.state
from review_month r
left join business b using(business_id)
where r.review_month between 1901 and 2112 and b.state = 'PA'
group by review_month, b.state
order by review_month asc;

select review_month, count(distinct business_id), b.state
from review_month r
left join business b using(business_id)
where r.review_month between 1901 and 2112 and b.state = 'PA'
group by review_month, b.state
order by review_month asc;








