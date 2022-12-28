/*Via the video, you might be interested in how to calculate the MEDIAN. T
hough this is more advanced than what we have covered so far try finding - 
what is the MEDIAN total_usd spent on all orders?*/
/*Since there are 6912 orders - we want the average of the 3457 and 3456 order amounts when ordered. 
This is the average of 2483.16 and 2482.55. This gives the median of 2482.855*/
select * 
from(select total_amt_usd
	 from orders
	 order by total_amt_usd 
	 limit((SELECT COUNT(*) FROM orders)/2)) AS Table1
	 order by total_amt_usd desc
	 limit 2 ;
	 
/*Which account (by name) placed the earliest order?
Your solution should have the account name and the date of the order.*/
select * from accounts; ---id
select * from orders; --- account_id , occured_at

select ac.name as account_name,o.occured_at as date_of_order
from orders o
join accounts ac on ac.id= o.account_id
order by occured_at 
limit 1;
--when we use aggregate function, group by becomes mandatory, which will not produce single row result as it is grouped by name
select ac.name as account_name,min(o.occured_at) as date_of_order
from orders o
join accounts ac on ac.id= o.account_id
group by ac.name;

/*Find the total sales in usd for each account. 
You should include two columns - the total sales for each company's orders in usd and the company name.*/
select * from accounts; ---id
select * from orders; --- account_id , occured_at

select sum(o.total_amt_usd) as total_sales, ac.name as company_name
from orders o
join accounts ac on ac.id= o.account_id
group by ac.name
order by total_sales;

/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/
select * from web_events; --- occured_at , channel, account_id
select * from accounts; ---id

select max(wb.occured_at) as date, wb.channel, (ac.name) as account_name
from web_events wb
join accounts ac on ac.id = wb.account_id
group by ac.name , wb.channel
order by date desc
limit 1;
---without using aggregate functions
SELECT occured_at, channel, name AS account_name
FROM web_events
JOIN accounts ON accounts.id = web_events.account_id
ORDER BY occured_at DESC
LIMIT 1;

/*Find the total number of times each type of channel from the web_events was used. 
Your final table should have two columns - the channel and the number of times the channel was used.*/
select count(channel) as channel_count , channel
from web_events
group by channel
order by channel_count;

/*Who was the Sales Rep associated with the earliest web_event?*/
select * from sales_reps; --sid, regionid, name
select * from web_events; ---account_id, --occured_at
select * from region; --region_id
select * from accounts; ---sales_rep_id

select sr.name as name , wb.occured_at as occurance 
from sales_reps sr
join region r on r.id = sr.region_id
join accounts ac on sr.id = ac.sales_rep_id
join web_events wb on ac.id = wb.account_id
order by wb.occured_at asc
limit 1;

/*Who was the primary contact associated with the earliest web_event?*/
select sr.name as name , wb.occured_at as occurance , ac.primary_poc as primary_contact
from sales_reps sr
join region r on r.id = sr.region_id
join accounts ac on sr.id = ac.sales_rep_id
join web_events wb on ac.id = wb.account_id
order by wb.occured_at asc
limit 1;

/*What was the smallest order placed by each account in terms of total usd. 
Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/
select min(o.total_amt_usd) as order_placed, ac.name as company_name
from orders o
join accounts ac on ac.id= o.account_id
group by ac.name
order by order_placed;

/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps.
Order from fewest reps to most reps.*/
select * from sales_reps; --sid, regionid, name
select * from web_events; ---account_id, --occured_at
select * from region; --region_id
select * from accounts; ---sales_rep_id

select count(sr.name) as number_of_sales_reps, r.name as region_name
from sales_reps sr
join region r on sr.region_id = r.id
group by region_name
order by number_of_sales_reps;

----saving the output in a view
create view try as (select count(sr.name) as number_of_sales_reps, r.name as region_name
from sales_reps sr
join region r on sr.region_id = r.id
group by region_name
order by number_of_sales_reps);
select * from try;

/*For each account, determine the average amount of each type of paper they purchased across their orders. 
Your result should have four columns - one for the account name and one for the average quantity purchased 
for each of the paper types for each account.*/
select * from orders;
select ac.name as account_name,
round(avg(o.standard_qty),2) as avq_qty_std,
round(avg(o.gloss_qty),2) as avq_qty_gloss,
round(avg(poster_qty),2) as avq_qty_poster
from orders o
join accounts ac on o.account_id= ac.id
group by account_name;

/*For each account, determine the average amount spent per order on each paper type. Your result should have
four columns - one for the account name and one for the average amount spent on each paper type.*/
select ac.name as account_name,
round(avg(o.standard_qty),2) as avq_qty_std,
round(avg(o.gloss_qty),2) as avq_qty_gloss,
round(avg(poster_qty),2) as avq_qty_poster
from orders o
join accounts ac on o.account_id= ac.id
group by account_name;

/*Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/
select * from sales_reps; --sid, regionid, name
select * from web_events; ---account_id, --occured_at
select * from region; --region_id
select * from accounts; ---sales_rep_id

select sr.name as sales_rep_name , wb.channel as channel , count(wb.channel) as number_of_occurences
from sales_reps sr
join accounts ac on sr.id = ac.sales_rep_id
join web_events wb on ac.id = wb.account_id
group by sales_rep_name,channel
order by number_of_occurences desc;

/*Determine the number of times a particular channel was used in the web_events table for each region. 
Your final table should have three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first.*/
select * from sales_reps; --sid, regionid, name
select * from web_events; ---account_id, --occured_at
select * from region; --region_id ,name
select * from accounts; ---sales_rep_id

select distinct(r.name) as region_name , wb.channel as channel , count(wb.channel) as number_of_occurences
from region r
join sales_reps sr on sr.region_id = r.id
join accounts ac on sr.id = ac.sales_rep_id
join web_events wb on ac.id = wb.account_id
group by region_name,channel
order by number_of_occurences desc;

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;

SELECT DISTINCT id, name
FROM accounts;

/*Have any sales reps worked on more than one account?*/
select sr.name as sales_rep_name , sr.id as sales_rep_id , count(ac.id)
from sales_reps sr
join accounts ac on sr.id = ac.sales_rep_id
group by sr.name,sr.id
having count(ac.id) > 1
order by count desc;

/*How many of the sales reps have more than 5 accounts that they manage?*/
select sr.name as sales_rep_name , sr.id as sales_rep_id , count(ac.id)
from sales_reps sr
join accounts ac on sr.id = ac.sales_rep_id
group by sr.name,sr.id
having count(ac.id) > 5
order by count desc;

/*How many accounts have more than 20 orders?*/
select ac.name as account, o.total
from accounts ac
join orders o on ac.id=o.account_id
group by ac.id,2
having (o.total)>20
order by o.total;

/*Which account has the most orders?*/
select ac.name as account, max(o.total) as most_orders
from accounts ac
join orders o on ac.id=o.account_id
group by 1
order by most_orders desc;

/*Which accounts spent more than 30,000 usd total across all orders?*/
select ac.name as account, sum(o.total_amt_usd) as amt_spent
from accounts ac
join orders o on ac.id=o.account_id
group by 1
having (sum(o.total_amt_usd) > 30000)
order by amt_spent desc;

/*Which accounts spent less than 1,000 usd total across all orders?*/
select ac.name as account, sum(o.total_amt_usd) as amt_spent
from accounts ac
join orders o on ac.id=o.account_id
group by 1
having (sum(o.total_amt_usd) < 1000)
order by amt_spent desc;

SELECT accounts.name AS account_name, SUM(total_amt_usd) AS total_amount
FROM accounts
JOIN orders ON accounts.id = orders.account_id
GROUP BY accounts.id
HAVING SUM(total_amt_usd) < 1000
ORDER BY total_amount;

/*Which account has spent the most with us?*/
select ac.name as account, (sum(o.total_amt_usd)) as amt_spent
from accounts ac
join orders o on ac.id=o.account_id
group by 1
order by amt_spent desc
limit 1;

/*Which account has spent the least with us?*/
select ac.name as account, (sum(o.total_amt_usd)) as amt_spent
from accounts ac
join orders o on ac.id=o.account_id
group by 1
order by amt_spent asc
limit 1;

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/
select * from sales_reps; --sid, regionid, name
select * from web_events; ---account_id, --occured_at , --channel
select * from region; --region_id
select * from accounts; ---sales_rep_id

select ac.name as account ,wb.channel, count(wb.channel)
from accounts ac
join web_events wb on ac.id = wb.account_id
where lower(wb.channel) = 'facebook'
group by 1,2
having count(wb.channel) >6;

/*Which account used facebook most as a channel?*/
select ac.name as account ,wb.channel, count(wb.channel)
from accounts ac
join web_events wb on ac.id = wb.account_id
where lower(wb.channel) = 'facebook'
group by 1,2
order by 3 desc
limit 1;

/*Which channel was most frequently used by most accounts?*/
select wb.channel, count(wb.channel)
from accounts ac
join web_events wb on ac.id = wb.account_id
group by 1
order by 2 desc
limit 1;
--without using JOINS
SELECT channel, COUNT(*) AS total_usage
FROM web_events
GROUP BY channel
ORDER BY total_usage DESC
LIMIT 1;

/*Which channel was most frequently used by most accounts? (including account name)*/
select wb.channel, count(wb.channel),ac.name as account_name
from accounts ac
join web_events wb on ac.id = wb.account_id
group by 1,3
order by 2 desc
limit 1;

/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?*/
select date_part('year',occured_at) as year_of_sale ,
date_part('month',occured_at) as month_of_sale,
sum(total_amt_usd) as total_sales
from orders
group by 1,2
order by 3 desc;
/*Answer: When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. 
If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales 
for each of these years (12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented. 
Sales have been increasing year over year, with 2016 being the largest sales to date. 
At this rate, we might expect 2017 to have the largest sales.*/

/*Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/
select date_part('year',occured_at) as year_of_sale ,
date_part('month',occured_at) as month_of_sale,
sum(total_amt_usd) as total_sales
from orders
group by 1,2
order by 3 desc
limit 1;
/*Answer: In order for this to be 'fair', we should remove the sales from 2013 and 2017. 
For the same reasons as discussed above.
The greatest sales amounts occur in December (12) */

/*Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset?*/
select date_part('year',occured_at) as year_of_sale ,
sum(total) as total_orders
from orders
group by 1
order by 2 desc
limit 1;
/*Answer: 2016 by far has the most amount of orders, 
but again 2013 and 2017 are not evenly represented to the other years in the dataset.*/

/*Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset?*/
select date_part('year',occured_at) as year_of_sale ,
date_part('month',occured_at) as month_of_sale,
sum(total_amt_usd) as total_sales
from orders
group by 1,2
order by 3 desc
limit 1;

/*In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/
select * from orders;
select date_part('year',o.occured_at) as year_of_sale ,
date_part('month',o.occured_at) as month_of_sale,
sum(o.gloss_amt_usd) as total_amt
from orders o
join accounts ac on o.account_id=ac.id
where ac.name like '%Walmart%'
group by 1,2
order by 3 desc
limit 1;

/*Write a query to display 
for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’
- depending on if the order is $3000 or more, or smaller than $3000.*/

select account_id, total_amt_usd,
case
	when total_amt_usd > 3000 THEN 'Large'
	else 'Small'
end
from orders

/*Write a query to display the number of orders in each of three categories,
based on the total number of items in each order. 
The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

select 
	case
		when total >= 2000 THEN 'At Least 2000'
		when total between '1000' and '2000' then 'Between 1000 and 2000'
		else 'Less than 1000'
	end as order_category,
	count (*) as nb_of_orders
from orders
group by 1;

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. 
The second level is between 200,000 and 100,000 usd. 
The lowest level is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. 
You should provide the account name, the total sales of all orders for the customer, and the level. 
Order with the top spending customers listed first.*/
select ac.name as account_name, sum(o.total_amt_usd) as total_amt,
	case
		when sum(total_amt_usd) > 200000 THEN 'Top Level'
		when sum(total_amt_usd) between '200000' and '100000' then 'Second Level'
		else 'Lowest Level'
	end as Levels_Of_Customer
from orders o
join accounts ac on o.account_id = ac.id
group by 1
order by 2 desc;

/*We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only in 2016 and 2017. 
Keep the same levels as in the previous question. Order with the top spending customers listed first.*/
select ac.name as account_name, sum(o.total_amt_usd) as total_amt,
	case
		when sum(total_amt_usd) > 200000 THEN 'Top Level'
		when sum(total_amt_usd) between '100000' and '200000' then 'Second Level'
		else 'Lowest Level'
	end as Levels_Of_Customer
from orders o
join accounts ac on o.account_id = ac.id
where date_part('year',o.occured_at) in ('2016','2017') -----between '2016' AND '2017'
group by 1
order by 2 desc;

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, 
and a column with top or not depending on if they have more than 200 orders.
Place the top sales people first in your final table.*/
select sr.name as sales_rep_name, count(*) as total_number_orders,
	case
		when (sum(o.total) >200) then 'Top'
		else 'Not' 
	end as total_orders
from orders o
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id = sr.id
group by 1
order by 2 desc; 		
---when we use count(*) of table, then we get both the values
select sr.name as sales_rep_name, count(*) as total_number_orders,
	case
		when (count(*) >200) then 'Top'
		else 'Not' 
	end as total_orders
from orders o
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id = sr.id
group by 1
order by 2 desc; 	
/*The previous didn't account for the middle, nor the dollar amount associated with the sales. 
Management decides they want to see these characteristics represented as well. 
We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders 
or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. 
Create a table with the sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. 
Place the top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!*/
select sr.name as sales_rep_name,sum(o.total_amt_usd) as dollar_amt, count(*),
	case
		when ((count(*) >200) or sum(o.total_amt_usd) >750000)  then 'Top'
		when ((count(*) >150)  or sum(o.total_amt_usd) >500000)  then 'Middle'
		else 'Low' 
	end as total_orders
from orders o
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id = sr.id
group by 1
order by 2 desc; 		
---when we use count(*) of table, then we get both the values
SELECT sales_reps.name, COUNT(*), SUM(total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders
JOIN accounts ON accounts.id = orders.account_id 
JOIN sales_reps ON sales_reps.id = accounts.sales_rep_id
GROUP BY sales_reps.name
ORDER BY 3 DESC;
