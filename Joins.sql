/*Try pulling all the data from the accounts table, and all the data from the orders table.*/
select *
from accounts a
join orders o on a.id=o.account_id;

/*Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc
from the accounts table.*/
select o.standard_qty, o.gloss_qty, o.poster_qty, ac.website, ac.primary_poc
from orders o
join accounts ac
on ac.id=o.account_id;

/*Provide a table for all web_events associated with account name of Walmart. 
There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.*/
select ac.name, ac.primary_poc, w.occured_at, w.channel
from accounts ac
join web_events w
on w.account_id=ac.id
where ac.name ='Walmart';

/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/
select * from sales_reps;
select * from region;
select * from accounts;

select r.name as region_name, sr.name, ac.name as account_name
from region r
join sales_reps sr on sr.region_id=r.id
join accounts ac on ac.sales_rep_id= sr.id
order by ac.name;

/*Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.*/
select * from orders; --order_id ; account_id
select * from accounts; ---account_id, sales_rep_id
select * from region; --region_id, region_name
select * from sales_reps; ---sales_reps_id, region_id

select r.name as region_name, ac.name as account_name,(o.total_amt_usd/(o.total+0.01)) as unit_price
from orders o 
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id= sr.id
join region r on sr.region_id = r.id;

/*Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/
select r.name as region_name, sr.name as sales_rep_name, ac.name as account_name
from sales_reps sr
join region r on sr.region_id = r.id
join accounts ac on sr.id=ac.sales_rep_id
where r.name like '%Midwest%'
order by ac.name;

__OR___

select r.name as region_name, sr.name as sales_rep_name, ac.name as account_name
from accounts ac
join sales_reps sr on sr.id=ac.sales_rep_id
join region r on sr.region_id = r.id
where r.name = 'Midwest'
order by ac.name;

/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/
select r.name as region_name, sr.name as sales_rep_name, ac.name as account_name
from accounts ac
join sales_reps sr on sr.id=ac.sales_rep_id
join region r on sr.region_id = r.id
where sr.name like 'S%'
and r.name = 'Midwest'
order by ac.name;
___OR___
SELECT region.name AS region_name, sales_reps.name AS sales_rep_name, accounts.name AS account_name
FROM region
JOIN sales_reps ON region.id = sales_reps.region_id
JOIN accounts ON accounts.sales_rep_id = sales_reps.id
WHERE region.name LIKE 'Midwest'
	AND LOWER(sales_reps.name) LIKE 's%'
ORDER BY 3;

/*Provide a table that provides the region for each sales_rep along with their associated accounts. 
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
Your final table should include three columns: the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.*/
select r.name as region_name, sr.name as sales_rep_name, ac.name as account_name
from accounts ac
join sales_reps sr on sr.id=ac.sales_rep_id
join region r on sr.region_id = r.id
where sr.name like '%_K%'
and r.name = 'Midwest'
order by ac.name;

/*Provide the name for each region for every order, as well as the account name and 
the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100. 
Your final table should have 3 columns: region name, account name, and unit price. 
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).*/
select r.name as region_name, ac.name as account_name,(o.total_amt_usd/(o.total+0.01)) as unit_price
from orders o 
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id= sr.id
join region r on sr.region_id = r.id
where o.standard_qty >100;

/*Provide the name for each region for every order, as well as the account name and 
the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 
and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator
here is helpful (total_amt_usd/(total+0.01).*/
select r.name as region_name, ac.name as account_name,(o.total_amt_usd/(o.total+0.01)) as unit_price
from orders o 
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id= sr.id
join region r on sr.region_id = r.id
where (o.standard_qty >100 and poster_qty>50)
order by unit_price;

/*Provide the name for each region for every order, as well as the account name and 
the unit price they paid (total_amt_usd/total) for the order. 
However, you should only provide the results if the standard order quantity exceeds 100 
and the poster order quantity exceeds 50. 
Your final table should have 3 columns: region name, account name, and unit price. 
Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here
is helpful (total_amt_usd/(total+0.01).*/
select r.name as region_name, ac.name as account_name,round((o.total_amt_usd/(o.total+0.01)),2) as unit_price
from orders o 
join accounts ac on o.account_id = ac.id
join sales_reps sr on ac.sales_rep_id= sr.id
join region r on sr.region_id = r.id
where (o.standard_qty >100 and poster_qty>50)
order by unit_price desc;

/*What are the different channels used by account id 1001?
Your final table should have only 2 columns: account name and the different channels. 
You can try SELECT DISTINCT to narrow down the results to only the unique values.*/
select * from orders; --order_id ; account_id
select * from accounts; ---account_id, sales_rep_id
select * from region; --region_id, region_name
select * from sales_reps; ---sales_reps_id, region_id
select * from web_events; --account_id

select distinct w.channel, ac.name as account_name
from web_events w
join accounts ac on ac.id=w.account_id
where ac.id =1001;

/*Find all the orders that occurred in 2015.
Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.*/
select o.occured_at as occurence , ac.name as account_name, o.total as order_total, o.total_amt_usd as order_total_amt_usd
from orders o
join accounts ac on ac.id = o.account_id
where o.occured_at between '2015-01-01 00:00:00' AND '2016-01-01 00:00:00'
order by o.occured_at desc;

