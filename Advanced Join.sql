/*Say you're an analyst at Parch & Posey and you want to see:
each account who has a sales rep and each sales rep that has an account 
(all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account 
(some of the columns in these returned rows will be empty)*/

select sr.name ,ac.name
from sales_reps sr
join accounts ac on sr.id=ac.sales_rep_id;
---using full outer join
SELECT accounts.id,accounts.name,sales_reps.id, sales_reps.name
FROM accounts
FULL OUTER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id;

/* To see rows where 1) Companies without sales rep OR 2)sales rep without accouts */
select sr.name ,ac.name
from sales_reps sr
full outer join accounts ac on sr.id=ac.sales_rep_id
where ac.sales_rep_id is null or sr.id is null;

/*Inequality Join
 write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number 
 and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name
The query results should be a table with three columns: 
the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), 
and the sales representative's name (e.g. Samuel Racine)*/

select ac.name as account_name, ac.primary_poc as primary_contact_name, sr.name as sales_rep_name
from accounts ac
left join sales_reps sr on ac.sales_rep_id = sr.id
where ac.primary_poc < sr.name
order by 3 ;
----A comparison operator returns a boolean, either TRUE, FALSE or NULL.a string less than another one comes before in dictionary order

/*Getting list of web events which happens one day duration one after another*/
SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occured_at AS we1_occured_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occured_at AS we2_occured_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2  ---using the same table : self join
   ON we1.account_id = we2.account_id
  AND we1.occured_at > we2.occured_at  ----comparing the timestamp
  AND we1.occured_at <= we2.occured_at + INTERVAL '1 day'  ----if we1 is less than or equal to we2, then add a day
ORDER BY we1.account_id, we2.occured_at;

/* UNION ALL vs UNION */
/*Nice! UNION only appends distinct values. 
More specifically, when you use UNION, the dataset is appended, and any rows in the appended table 
that are exactly identical to rows in the first table are dropped. 
If you’d like to append all the values from the second table, use UNION ALL. 
You’ll likely use UNION ALL far more often than UNION.*/

select a.id from accounts a
union
select o.account_id from orders o;

select * from accounts as tb1
where tb1.name like 'Walmart'
UNION
select * from accounts as tb2
where tb2.name like 'Walmart'; ----returned only one value

select * from accounts as tb1
where tb1.name like 'Walmart'
UNION ALL
select * from accounts as tb2
where tb2.name like 'Disney'; -- returned two values for walmart

select id from region
where id = '3'
union all
select id from sales_reps
where region_id= '3'; 
/*---- here id for region is region_id, but id for sales_reps is sales_reps_id hence when we use union all, 
its returning the id values from both tables, even though they reprsent different value sets*/

/*Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and 
name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. 
If you do this correctly, your query results should have a count of 2 for each name.*/
with double_accounts as (select * from accounts a1
	union all
	select * from accounts a2)
select count(*) ,name
from double_accounts
group by name;

---351 rows

