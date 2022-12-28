/*number of events that occur for each day for each channel*/
select date_part('day',occured_at) as day_occ, channel, count(*)
from web_events
group by 1,2
order by 3 desc ;

/*find the average number of events for each channel. Average per day*/
select * from web_events;
select channel, avg(no_of_events) as average_number_of_events
from (select date_part('day',occured_at) as day_occ, count(*) as no_of_events, channel
		from web_events
		group by 1,3) as sq
group by 1
order by 2;

/*list of orders happended at the first month in P&P history , ordered by occurred_at */
select * from orders
order by 3;

SELECT * 
FROM orders
WHERE DATE_TRUNC('month',occured_at) =
	(SELECT DATE_TRUNC('month',MIN(occured_at))
	FROM orders)
ORDER BY occured_at;

/*list of orders happended at the first day in P&P history , ordered by occurred_at */
SELECT * 
FROM orders
WHERE DATE_TRUNC('day',occured_at) =
	(SELECT DATE_TRUNC('day',MIN(occured_at))
	FROM orders)
ORDER BY occured_at;

/*average of paper quantity happended at the first month in P&P history*/
SELECT round(avg(total),2) 
FROM orders
WHERE DATE_TRUNC('month',occured_at) =
	(SELECT DATE_TRUNC('month',MIN(occured_at))
	FROM orders);
	
/*account id,name and its most frequenet used channel*/
select * from accounts; --id, name
select * from web_events

select ac.id as account_id, ac.name as acc_name, count(wb.channel) as frq
from accounts ac
join web_events wb on ac.id= wb.account_id
group by 1,2
order by 4 desc;

SELECT tbl_3_accounts_with_channels.id, tbl_3_accounts_with_channels.name,
	tbl_3_accounts_with_channels.channel,
	tbl_3_accounts_with_channels.usage_per_channel AS max_usage_times
FROM
	(SElECT accounts.id, accounts.name, channel, COUNT(*) AS usage_per_channel
		FROM accounts
		JOIN web_events ON accounts.id = web_events.account_id
		GROUP BY 1,2,3
		ORDER BY 1) tbl_3_accounts_with_channels
JOIN (SELECT tbl_1_accounts_with_channels.id,tbl_1_accounts_with_channels.name,MAX(usage_per_channel) AS max_channel
		FROM
			(SElECT accounts.id, accounts.name, channel, COUNT(*) AS usage_per_channel
			FROM accounts
			JOIN web_events ON accounts.id = web_events.account_id
			GROUP BY 1,2,3
			ORDER BY 1) tbl_1_accounts_with_channels
		GROUP BY 1,2
		ORDER BY 2) tbl_2_accounts_with_max_channel
ON tbl_3_accounts_with_channels.id = tbl_2_accounts_with_max_channel.id
	AND tbl_3_accounts_with_channels.usage_per_channel = tbl_2_accounts_with_max_channel.max_channel
ORDER BY  tbl_3_accounts_with_channels.id;

/*sales rep total sales for each region*/
select * from orders; ---sum(total_amt_usd),account_id
select * from accounts; ---id, sales_rep_id
select * from sales_reps; --- sales_rep_id, region_id
select * from region; --region_id, name

select sr.name as sales_rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
from orders o
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id = sr.id
join region r on sr.region_id = r.id
group by 1,2
order by 3 desc;

---as sub query----
select tb1.sales_rep_name, max(tb1.total_sales) as t_mt_us
from (select sr.name as sales_rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
	  	from orders o
		join accounts ac on o.account_id = ac.id
		join sales_reps sr on ac.sales_rep_id = sr.id
		join region r on sr.region_id = r.id
		group by 1,2
	  ) as tb1
group by 1
order by 2 desc;

/*maximum total sales in each region*/
select tb1.region_name , max(tb1.total_sales) as max_sales
from (select sr.name as sales_rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
			from orders o
			join accounts ac on o.account_id = ac.id
			join sales_reps sr on ac.sales_rep_id = sr.id
			join region r on sr.region_id = r.id
	 		group by 1,2
	 ) as tb1
group by 1
order by max_sales desc;

/*** Final ***/
/*1) Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
/*(select tb1.sales_rep_name, max(tb1.total_sales) as t_mt_us
from (select sr.name as sales_rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
	  	from orders o
		join accounts ac on o.account_id = ac.id
		join sales_reps sr on ac.sales_rep_id = sr.id
		join region r on sr.region_id = r.id
		group by 1,2
	  ) as tb1
group by 1
order by 2 desc) as tb3
join (
(select tb1.region_name , max(tb1.total_sales) as max_sales
from (select sr.name as sales_rep_name, r.name as region_name, sum(o.total_amt_usd) as total_sales
			from orders o
			join accounts ac on o.account_id = ac.id
			join sales_reps sr on ac.sales_rep_id = sr.id
			join region r on sr.region_id = r.id
	 		group by 1,2
	 ) as tb1
group by 1
order by max_sales desc) as tb4*/

SELECT region_name,sales_rep_name,total_sales_per_rep AS largest_amount_of_sales
FROM 
	(SELECT r.id AS region_id,r.name AS region_name, sr.id AS sales_rep_id, sr.name AS sales_rep_name, 
	 	SUM(o.total_amt_usd) AS total_sales_per_rep
	FROM orders o
	JOIN accounts a ON a.id = o.account_id
	JOIN sales_reps sr ON sr.id = a.sales_rep_id
	JOIN region r ON r.id = sr.region_id
	GROUP BY 1,2,3,4
	ORDER BY 2,3) tbl3_region_salesrep_with_total_sales
JOIN (SELECT tbl1_region_salesrep_with_total_sales.region_id,MAX(total_sales_per_rep) AS max_sales
	FROM
		(SELECT r.id AS region_id,r.name AS region_name, sr.id AS sales_rep_id, sr.name AS sales_rep_name, SUM(o.total_amt_usd) AS total_sales_per_rep
		FROM orders o
		JOIN accounts a ON a.id = o.account_id
		JOIN sales_reps sr ON sr.id = a.sales_rep_id
		JOIN region r ON r.id = sr.region_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3) tbl1_region_salesrep_with_total_sales
	GROUP BY 1) tbl2_region_with_max_sales
ON tbl3_region_salesrep_with_total_sales.region_id = tbl2_region_with_max_sales.region_id
	AND tbl3_region_salesrep_with_total_sales.total_sales_per_rep = tbl2_region_with_max_sales.max_sales
ORDER BY 3 DESC;

/****************************************/
/*largest sales region*/
/*total numbers of orders per region */
