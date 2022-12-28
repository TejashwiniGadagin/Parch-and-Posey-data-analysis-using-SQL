select * from accounts;

--to get the total count of rows in the column:
select count(*) from accounts; --351
select count(*) from orders; --6912
select count(*) from sales_reps; --50
select count(*) from web_events; -- 9073
select count(*) from region; --4

--to get the data from accounts table using various clauses
select accounts.name,sales_rep_id 
from accounts
group by accounts.name,sales_rep_id
order by accounts.name
limit 15;

--to get the last 50 rows
select *
from accounts
order by sales_rep_id desc
limit 50;

select distinct(account_id) from orders;

select *
from web_events;
select distinct (account_id) from web_events;

/*10 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.*/
select id, occured_at,total_amt_usd
from orders
order by occured_at asc
limit 10;

/*Use the web_events table to find all information regarding individuals 
--who were contacted via the channel of organic or adwords.*/
select * from web_events
where channel in ('organic','adwords');

/*top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd*/
select id, account_id, total_amt_usd
from orders
order by total_amt_usd desc
limit 5;

/*the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd*/
select id, account_id, total_amt_usd
from orders
order by total_amt_usd 
limit 20;

/*the lowest 20 non zero orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd*/
select id, account_id, total_amt_usd
from orders
group by id
having (total_amt_usd) > 0
order by total_amt_usd 
limit 5;

--find the min and max value of total_amt_usd
select min(total_amt_usd), max(total_amt_usd)
from orders;

/*Write a query that displays the order ID, account ID, and total amount used for all the orders, 
sorted first by the account ID (in ascending order), 
and then by the total amount used (in descending order).*/

select id,account_id, total_amt_usd
from orders
order by account_id , total_amt_usd desc;

/*displays order ID, account ID, and total dollar amount for each order,
but this time sorted first by total dollar amount (in descending order), 
and then by account ID (in ascending order).*/
select id,account_id, total_amt_usd
from orders
order by total_amt_usd desc, account_id ;
