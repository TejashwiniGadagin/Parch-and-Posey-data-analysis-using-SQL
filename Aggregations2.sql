/*When did the most recent (latest) web_event occur?*/
select max(occured_at) from web_events;

/*Try to perform the result of the previous query without using an aggregation function.*/
select occured_at from web_events
order by occured_at desc
limit 1;

/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as 
the mean amount of each paper type purchased per order. 
Your final answer should have 6 values - one for each paper type for the average number of sales, 
as well as the average amount.*/
select * from orders;
select avg(standard_qty) as std_sales,avg(gloss_qty) as gloss_sales,avg(poster_qty) as poster_sales ,
avg(standard_amt_usd) as avg_std_amt, avg(gloss_amt_usd) as avg_gloss_amt, avg(poster_amt_usd) as avg_poster_amt
from orders;

/*Via the video, you might be interested in how to calculate the MEDIAN. T
hough this is more advanced than what we have covered so far try finding 
- what is the MEDIAN total_usd spent on all orders?*/
/*Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. 
This is the average of 2483.16 and 2482.55. This gives the median of 2482.855*/
select * 
from orders;

/*Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/
