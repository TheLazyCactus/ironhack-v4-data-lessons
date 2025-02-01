USE bank;

/* intro to TEMPORARY TABLE, CTE'S AND VIEW */

/* TEMPORARY TABLE */
CREATE TEMPORARY TABLE loan_and_account
SELECT
l.loan_id,
l.account_id,
l.amount,
l.payments,
l.status,
a.district_id,
a.frequency,
a.date
FROM loan AS l
JOIN account AS a
ON l.account_id = a.account_id;

/* Fetching the new table */

SELECT * FROM loan_and_account;
/* DELETE the table if you want */
DROP TEMPORARY TABLE IF EXISTS loan_and_account ;

 -- Let's create another table
 CREATE TEMPORARY TABLE disp_accounts
 SELECT
 d.disp_id,
 d.client_id,
 d.account_id,
 d.type,
 a.district_id,
 a.frequency
 FROM disp AS d
 JOIN account AS a
 ON d.account_id = a.account_id;
 
 CREATE TEMPORARY TABLE status_above_avg_amount_table
 SELECT status AS status_aggregated, ROUND(AVG(amount), 0) AS avg_loan_amount

		FROM loan

		WHERE amount > 1000 -- from the loan table I only want to select the entries whose amount is > 1000

		GROUP BY status -- i want to group it by the status column

		HAVING avg_loan_amount > ( SELECT ROUND(AVG(amount), 0) AS overall_loan_avg FROM loan ) -- from the aggregated data,

		-- I want to see only the status where the avg_loan_amount is above the OVERALL avg loan amount

		ORDER BY avg_loan_amount DESC;
        

SELECT *
FROM loan
WHERE status IN (SELECT DISTINCT status_aggregated FROM status_above_avg_amount_table);

-- another alternative
SELECT
l.*
, s.avg_loan_amount
FROM loan as l
JOIN status_above_avg_amount_table as s
ON l.status = s.status_aggregated;


/* CTE = Common Table Expression */

WITH
-- Overall average loan value in CTE
overall_average_amount_cte as (
SELECT ROUND(AVG(amount), 0) AS overall_avg_loan FROM loan
)

--  grouped table with status whose avg loan amount is above overall avg
, status_grouped as (
SELECT 
	status AS status_aggregated,
	ROUND(AVG(amount),0) AS avg_loan_amount
FROM loan
WHERE amount > 1000 -- from the loan table I only want to select the entries whose amount is > 100
GROUP BY status -- I want to group it by the status column
HAVING avg_loan_amount > (SELECT overall_avg_loan FROM overall_average_amount_cte) -- from the CTE we created
-- I want to see only the status where the avg_loan_amount is above the overall avg loan amount
ORDER BY avg_loan_amount DESC)

-- all the loans that whose status are above the overall average
SELECT l.* 
, avg_loan_amount
FROM loan as l
JOIN status_grouped AS s
ON l.status = S.status_aggregated;
	
    
/* Creating a view - It has similar benefit than a table but not storing data in memory,
while still being accessible by every user*/


CREATE VIEW loan_status_above_average AS
WITH
-- Calculate the overall average loan amount
overall_average_amount_cte AS (
    SELECT ROUND(AVG(amount), 0) AS overall_avg_loan
    FROM loan
),
-- Identify statuses with an average loan amount above the overall average
status_grouped AS (
    SELECT 
        status AS status_aggregated,
        ROUND(AVG(amount), 0) AS avg_loan_amount
    FROM loan
    WHERE amount > 1000
    GROUP BY status
    HAVING ROUND(AVG(amount), 0) > (SELECT overall_avg_loan FROM overall_average_amount_cte)
    ORDER BY avg_loan_amount DESC
)
-- Select loans with statuses identified above
SELECT 
    l.*, 
    s.avg_loan_amount
FROM loan AS l
JOIN status_grouped AS s
ON l.status = s.status_aggregated;

