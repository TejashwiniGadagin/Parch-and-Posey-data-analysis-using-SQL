/************** LEFT & RIGHT ***************/
/*1) In the accounts table, there is a column holding the website for each company.
The last three digits specify what type of web address they are using. 
A list of extensions (and pricing) is provided at https://iwantmyname.com/domains. 
Pull these extensions and provide how many of each website type exist in the accounts table. */
select right(website,3) as domain_name, count(*)
from accounts
group by 1
order by 2 desc;

/*2) There is much debate about how much the name (or even the first letter of a company name) matters. 
Use the accounts table to pull the first letter of each company name to see 
the distribution of company names that begin with each letter (or number).*/
select left(name,1) as company_name, count(*)
from accounts
group by 1
order by 2 desc;
/*above query returns 27 rows, as there are names starting with 'e'. When we use floor function, 
we eliminate any extra row counts due to this data inputs.*/

SELECT LEFT(UPPER(name),1) AS letter, COUNT(*) AS total
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/*3) Use the accounts table and a CASE statement to create two groups: 
one group of company names that start with a number 
and a second group of those company names that start with a letter. 
What proportion of company names start with a letter?*/
select * from accounts;
select sum(num) as nums,sum(letter) as letters
from (select name,
	 	case 
	  		when left(UPPER(name),1) in ('0','1','2','3','4','5','6','7','8','9') then 1 
	  		else 0
		end as num ,
		case 
	  		when left(UPPER(name),1) in ('0','1','2','3','4','5','6','7','8','9') then 0 
	  		else 1
	 	end as letter
	  from accounts
	 ) t1;

/*4) Consider vowels as a, e, i, o, and u. 
What proportion of company names start with a vowel, and what percent start with anything else?*/
select sum(vowel) as vowels,sum(letter) as letters
from (select name,
	 	case 
	  		when left(lower(name),1) in ('a','e','i','o','u') then 1 
	  		else 0
		end as vowel ,
		case 
	  		when left(lower(name),1) in ('a','e','i','o','u') then 0 
	  		else 1
	 	end as letter
	  from accounts
	 ) t1;

---using CTE
with alpha as (select name,
	 	case 
	  		when left(lower(name),1) in ('a','e','i','o','u') then 1 
	  		else 0
		end as vowel ,
		case 
	  		when left(lower(name),1) in ('a','e','i','o','u') then 0 
	  		else 1
	 	end as letter
	  from accounts)
	  
select sum(vowel) as vowels , sum(letter) as letters
from alpha;

/****** POSITION & STRPOS *************/
/*1)Use the accounts table to create first and last name columns that hold the first and last names
for the primary_poc.*/
select * from accounts;
select primary_poc,
left(primary_poc,strpos(primary_poc,' ')-1) as first_name,
right(primary_poc,length(primary_poc)-strpos(primary_poc,' ')) as last_name
from accounts;
---trial on website column
select website,
left(website,strpos(website,'.')-1) as web,
right(website,length(website)-strpos(website,'.')) as last_name,
right(website,strpos(website,'.')-1) as ext
from accounts

/*2) Now see if you can do the same thing for every rep name in the sales_reps table. 
Again provide first and last name columns.*/
SELECT name, 
	LEFT(name,STRPOS(name,' ')-1) AS first_name,
	RIGHT(name,LENGTH(name)-STRPOS(name,' ')) AS last_name
FROM sales_reps;

/****** CONCATE or || *************/

/*1/2)Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.*/
select * from accounts;
select (concat(first_name,'.',last_name,'@',company,'.com')) as email
from (select primary_poc as exx,
		lower(left(primary_poc,strpos(primary_poc,' ')-1)) as first_name,
		lower(right(primary_poc,length(primary_poc)-strpos(primary_poc,' '))) as last_name,
	  	lower(replace(name,' ','')) as company ----to eliminate spaces between values in company name
	from accounts  ) as tb1;
----using CTE	
WITH tbl1 AS(
	SELECT name,primary_poc,
	LOWER(LEFT(primary_poc,STRPOS(primary_poc,' ')-1)) AS first_name,
	LOWER(RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc,' '))) AS last_name,
	LOWER(REPLACE(name,' ','')) AS company_name
	FROM accounts
)
SELECT CONCAT(first_name,'.',last_name,'@',company_name)
FROM tbl1;

/*We would also like to create an initial password, which they will change after their first log in. 
The first password will be the first letter of the primary_poc's first name (lowercase), 
then the last letter of their first name (lowercase), 
the first letter of their last name (lowercase), 
the last letter of their last name (lowercase), 
the number of letters in their first name, 
the number of letters in their last name, 
and then the name of the company they are working with, 
all capitalized with no spaces.
*/
select * from accounts;
select upper(concat(left(first_name,1),right(first_name,1),left(last_name,1),right(last_name,1),length(first_name),
					length(last_name),company)) as pwd
from
(select primary_poc as exx,
		lower(left(primary_poc,strpos(primary_poc,' ')-1)) as first_name,
		lower(right(primary_poc,length(primary_poc)-strpos(primary_poc,' '))) as last_name,
	  	lower(replace(name,' ','')) as company ----to eliminate spaces between values in company name
	from accounts) as tb1;

---with CTE and || operator
WITH t1 AS(
	SELECT name,primary_poc,
	LOWER(LEFT(primary_poc,STRPOS(primary_poc,' ')-1)) AS first_name,
	LOWER(RIGHT(primary_poc,LENGTH(primary_poc) - STRPOS(primary_poc,' '))) AS last_name,
	LOWER(REPLACE(name,' ','')) AS company_name
	FROM accounts
)

SELECT first_name,last_name,company_name,
	LEFT(first_name,1) ||
	RIGHT(first_name,1) ||
	LEFT(last_name,1) ||
	RIGHT(last_name,1) ||
	LENGTH(first_name) ||
	LENGTH(last_name) ||
	UPPER(company_name)
FROM t1;



