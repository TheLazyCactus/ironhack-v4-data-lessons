USE bank;

-- Compute the average loan amount for all loans and the maximum loan amount

SELECT 
    ROUND(AVG(amount), 0) AS average_loan,
    MAX(amount) AS max_loan,
    MIN(amount) AS min_loan
FROM
    loan
LIMIT 100;

-- If we desire to make completion simpler, it would be nice if we could leverage this descriptive statistic query
-- inside of another query

SELECT *
FROM loan
WHERE amount > (SELECT ROUND(AVG(amount),0) FROM loan);

-- To practice
-- tellme what are the unique valus of the status column (1 query)
select distinct(status) FROM loan;
--  Compute the average loan for each of the unique status (1 query)
SELECT 
	status,
	ROUND(AVG(amount),0) AS avg_loan_amount
    FROM loan
    GROUP BY status
    ORDER BY avg_loan_amount DESC;

-- We want to see the status avg_loan_amount BUT only the status whose avg_loan_amount is above the OVERALL loan amount

SELECT 
	status,
	ROUND(AVG(amount),0) AS avg_loan_amount
    FROM loan
    GROUP BY status
    HAVING avg_loan_amount > (SELECT ROUND(AVG(amount), 0) AS overall_loan_avg FROM loan)
    ORDER BY avg_loan_amount DESC;
-- We use WHERE when we want to filter from the main table object
-- WHERE comes befor group by
-- We use HAVING when we want to filter from the computed aggregated query we just created
 -- HAVING comes after group by
 
 SELECT 
	status,
	ROUND(AVG(amount),0) AS avg_loan_amount
    FROM loan
    WHERE amount > 1000 -- from the loan table I only want to select the entries whose amount is > 100
    GROUP BY status -- I want to group it by the status column
    HAVING avg_loan_amount > (SELECT ROUND(AVG(amount), 0) AS overall_loan_avg FROM loan) -- from the aggregated data
    -- I want to see only the status where the avg_loan_amount is above the overall avg loan amount
    ORDER BY avg_loan_amount DESC; -- Finally I want to order by the avg_loan_amount descending
    
    -- let's check our table back
    
    SELECT * FROM loan;
    
    -- from the loan table, we want to see all of the entries where the logic from above matches
    -- MEANING: all entries where the avg_loan_amount for each status is above the overall average_loan_amount
    
     SELECT *
     FROM loan
     Where status IN (
		SELECT DISTINCT status_aggregated FROM
			(SELECT status AS status_aggregated,
			ROUND(AVG(amount),0) AS avg_loan_amount
			FROM loan
			WHERE amount > 1000 -- from the loan table I only want to select the entries whose amount is > 100
			GROUP BY status -- I want to group it by the status column
			HAVING avg_loan_amount > (SELECT ROUND(AVG(amount), 0) AS overall_loan_avg FROM loan) -- from the aggregated data
			-- I want to see only the status where the avg_loan_amount is above the overall avg loan amount
			ORDER BY avg_loan_amount DESC) AS grouped_status
			); -- Finally I want to order by the avg_loan_amount descending
        
-- 1. GET a list of accounts from central bohemia using subqueries

SELECT 
    account_id AS central_bohemia_accounts
FROM
    account a
WHERE
    EXISTS( SELECT 
            1
        FROM
            district d
        WHERE
            d.A1 = a.district_id
                AND d.A3 = 'central Bohemia');
                
SELECT
A3 AS region,
COUNT(A1) AS total_district_ids
FROM district
GROUP BY region;


SELECT * FROM account
WHERE district_id IN (
SELECT DISTINCT A1 AS district_id
FROM district
WHERE A3 = 'central Bohemia')
;


-- Same logic but now with a join query:
SELECT *
FROM account
JOIN district
ON account.district_id = district.A1
WHERE district.A3 = 'central Bohemia';



/* EXTRA*/

-- We want to get the total accounts by each district_id
SELECT
district_id,
COUNT(account_id) AS total_accounts
From account 
GROUP BY district_id;
-- Where is a filter, group by you doing an aggregation