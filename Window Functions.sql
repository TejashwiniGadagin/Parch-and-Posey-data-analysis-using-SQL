/*create a running total of standard_qty (in the orders table) over order time.*/
select standard_qty, date_trunc('month',occured_at) as month_time,
sum(standard_qty) over(partition by date_trunc('month',occured_at) order by occured_at) as running_std_qty
from orders;

/*create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. 
Your final table should have two columns: 
one with the amount being added for each new row, and a second with the running total.*/
select standard_amt_usd , 
sum(standard_amt_usd) over (order by occured_at) as runningtotal_std_amt_usd
from orders;

/*create a running total of standard_amt_usd (in the orders table) over order time, 
but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. 
Your final table should have three columns: One with the amount being added for each row, 
one for the truncated date, and a final column with the running total within each year.*/
select date_trunc('year',occured_at) as o_yr,
standard_amt_usd , 
sum(standard_amt_usd) over (partition by date_trunc('year',occured_at)order by occured_at) as runningtotal_std_amt_usd
from orders;
----using date_part
select date_part('year',occured_at) as o_yr,
standard_amt_usd , 
sum(standard_amt_usd) over (partition by date_part('year',occured_at)order by occured_at) as runningtotal_std_amt_usd
from orders;

/*-------------------------------*/

/*Ranking Total Paper Ordered by Account
Select the id, account_id, and total variable from the orders table, 
then create a column called total_rank that ranks this total amount of paper ordered 
(from highest to lowest) for each account using a partition. Your final table should have these four columns.*/
select id,account_id, total,
rank() over(partition by account_id order by total desc) as total_rank
from orders;
----using dense rank
select account_id, total, id,
dense_rank() over(partition by date_part('year',occured_at) order by total desc) as total_rank
from orders;

select account_id, total, id,
dense_rank() over main as total_rank
from orders
window main as (partition by date_part('year',occured_at) order by total desc);

/* --------------------------------------------------  */

/* ----------------- LEAD and LAG  ------------------------*/
/*LAG */
SELECT account_id,
       LAG(standard_qty,2) OVER (ORDER BY standard_qty) AS lag
from orders
order by lag desc;

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference
FROM (
       SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders 
       GROUP BY 1
      ) sub;


/* LELAD */
SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders 
       GROUP BY 1
     ) sub;
	 
/*you want to determine how the current order's total revenue 
("total" meaning from sales of all types of paper) 
compares to the next order's total revenue.
there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.*/
select occured_at, total_amt, 
lead(total_amt) over(order by total_amt) as lead , 
(lead(total_amt) over(order by total_amt) - total_amt) as lead_difference
from ( select occured_at, sum(total_amt_usd) as total_amt
	 	from orders
	  group by 1
	 ) as sb;
	 
 /*--------------------------------------------------*/
 
 /* Percentile */
 
 SELECT id, account_id, occured_at,standard_qty,
	NTILE(4) OVER (ORDER BY standard_qty) AS quartile,
	NTILE(5) OVER (ORDER BY standard_qty) AS quintile,
	NTILE(100) OVER (ORDER BY standard_qty) AS percentile
FROM orders
ORDER BY standard_qty DESC;
--ntile groups the data into the group of number specified

/*Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty 
for their orders. Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.*/

select id,account_id, occured_at, standard_qty,
ntile(4) over(order by standard_qty) as quartile
from orders
order by 4 desc;

select max(standard_qty)from orders;

/*Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty 
for their orders. Your resulting table should have the account_id, 
the occurred_at time for each order, the total amount of gloss_qty paper purchased, 
and one of two levels in a gloss_half column.
*/
select id,account_id, occured_at, gloss_qty,
ntile(2) over(order by gloss_qty) as quartile
from orders
order by 2 desc;

/*Use the NTILE functionality to divide the orders for each account into 100 levels 
in terms of the amount of total_amt_usd for their orders. 
Your resulting table should have the account_id, the occurred_at time for each order, 
the total amount of total_amt_usd paper purchased,
and one of 100 levels in a total_percentile column.*/
select id,account_id, occured_at, total_amt_usd,
ntile(100) over(partition by account_id order by total_amt_usd) as percentile
from orders
order by 2 desc;

---using first and last window ()
select id,account_id, occured_at, total_amt_usd,
first_value(id) over(partition by account_id order by total_amt_usd) as first_value_result
from orders
order by 2 desc;

select id,account_id, occured_at, total_amt_usd,
last_value(id) over(partition by account_id order by total_amt_usd) as last_value_result
from orders
order by 2 ;

