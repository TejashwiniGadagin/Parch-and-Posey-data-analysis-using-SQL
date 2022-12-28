/*Pulls the first 5 rows and all columns from the orders table 
that have a dollar amount of gloss_amt_usd greater than or equal to 1000.*/

select * 
from orders
where orders.gloss_amt_usd >1000
limit 5;

/*Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.*/
select * 
from orders
where orders.total_amt_usd <1000
limit 10;

/*Filter the accounts table to include the company name, website, and the primary point of contact (primary_poc) 
just for the Exxon Mobil company in the accounts table.*/

select * from accounts;

SELECT name,website,primary_poc
from accounts
where name ='Exxon Mobil';

/*Create a column that divides the standard_amt_usd by the standard_qty 
to find the unit price for standard paper for each order. 
Limit the results to the first 10 orders, and include the id and account_id fields.*/

select * from orders;

select id,account_id,
round(standard_amt_usd/standard_qty,2) as unit_ptice
from orders
limit 10;

/*finds the percentage of revenue that comes from poster paper for each order.
You will need to use only the columns that end with _usd. 
(Try to do this without using the total column.) Display the id and account_id fields also.*/

select * from orders;

select id, account_id, round(poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd),2) as percentage_of_revenue
from orders
limit 20;

/*All the companies whose names start with 'C'.*/
select * from accounts
where name like 'C%';

/*All companies whose names contain the string 'one' somewhere in the name.*/
select * from accounts
where name like '%one%';

/*All companies whose names end with 's'.*/
select * from accounts
where name like '%S';

/*Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.*/
select name,primary_poc,sales_rep_id
from accounts
where name in ('Walmart','Target','Nordstorm');

/*Use the web_events table to find all information regarding individuals who were contacted via 
the channel of organic or adwords.*/
select * from web_events
where channel in ('organic','adwords');

/*Use the accounts table to find the account name, primary poc, and sales rep id for all stores 
except Walmart, Target, and Nordstrom.*/
select name,primary_poc,sales_rep_id
from accounts
where name not in ('Walmart','Target','Nordstorm');

/*Use the web_events table to find all information regarding individuals who were contacted via
any method except using organic or adwords methods.*/
select * 
from web_events
where channel not in ('organic','adwords');

/*all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0.*/
select * 
from orders
where standard_qty > 1000 and poster_qty = '0' and gloss_qty='0';

/*Using the accounts table, find all the companies whose names do not start with 'C' and end with 's'.*/
select * 
from accounts
where name not like 'C%' and name like '%s';

/*When you use the BETWEEN operator in SQL, do the results include the values of your endpoints, or not? 
Figure out the answer to this important question by writing a query that 
displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
Then look at your output to see if the BETWEEN operator included the begin and end values or not.*/
select occured_at , gloss_qty
from orders
where gloss_qty between 24 and 29
order by gloss_qty;

/*Use the web_events table to find all information regarding individuals who were contacted via 
the organic or adwords channels, and started their account at any point in 2016, sorted from newest to oldest.*/
select * 
from web_events
where channel in('organic','adwords')
and occured_at between '2016-01-01 00:00:00' and '2016-12-31 23:59:59'
order by occured_at desc;

/*Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. 
Only include the id field in the resulting table.*/
select * from orders;
select id
from orders
where (gloss_qty > 4000 or poster_qty > 4000);

/*Write a query that returns a list of orders 
where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.*/
select *
from orders
where (standard_qty = 0
and (gloss_qty >1000 or poster_qty > 1000));

/*Find all the company names that start with a 'C' or 'W', 
and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.*/
select * from accounts;
select *
from accounts
where (name like 'C%' or name like 'W%' )
AND
((primary_poc like '%ana%' or primary_poc like '%Ana%') AND primary_poc not like '%eana%');
 
 
 