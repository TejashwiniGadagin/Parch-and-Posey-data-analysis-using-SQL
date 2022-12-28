/*Find the total amount of poster_qty paper ordered in the orders table.*/
select * from orders;
select sum(poster_qty) from orders;

/*Find the total amount of standard_qty paper ordered in the orders table.*/
select sum(standard_qty) from orders;

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
select sum(total_amt_usd) from orders;

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table.*/
select (standard_amt_usd+gloss_amt_usd) as total_amount_spent from orders;

/*Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation 
and a mathematical operator.*/
select sum(standard_amt_usd)/sum(standard_qty) as result from orders;

/*When was the earliest order ever placed? You only need to return the date.*/
select min(occured_at) from orders;


