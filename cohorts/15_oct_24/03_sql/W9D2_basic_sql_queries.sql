-- first statement
SELECT * FROM trans;

							SELECT * FROM trans;

-- what db am I using?
USE bank;
SELECT * FROM trans;

-- how many rows am I seeing? why show fewer than the db?
SELECT 
    *
FROM
    trans
LIMIT 100;

-- can I select specific columns?
SELECT type, amount FROM trans;

-- combine with limit
SELECT type, amount FROM trans LIMIT 100;

-- What's more relevant in reducing processing time and resources? Check duration.
-- See column vs row-based storage: https://dataschool.com/data-modeling-101/row-vs-column-oriented-databases/
-- TL;DR. Traditionally, row-based storage has been used and is the standard for MySQL and PostgreSQL. 
-- However, given huge amounts of records, aggregations can start becoming too cumbersome, which is what prompted the creation of columnar storage, as seen in big data storage, e.g. BigQuery, RedShift, Snowflake
-- Don't worry, we'll talk about the other side later in the course ;)

-- aggregation time! what's the first thing I want to know about any data source?
SELECT COUNT(*) FROM trans;
SELECT COUNT(*) AS trans_no FROM trans;

-- what type of loans do I have?
SELECT * FROM loan;
SELECT DISTINCT status FROM loan;

-- sorting results...
SELECT DISTINCT status FROM loan ORDER BY status DESC;

-- ==================================================
-- CHECK FOR UNDERSTANDING
-- ==================================================

-- 1. Use an appropriate `SELECT` statement to retrieve a list of unique card types from the `bank` database. 
-- 2. Get a list of all the district names in the bank database. Suggestion is to use the `files_for_activities/case_study_extended` here to work out which column is required here because we are looking for the names of places, not just the IDs. You should have 77 rows.
-- 3. Revise your query to also show the Region, and limit the results to just 30 rows. Sort the results alphabetically by district name A>Z before selecting the 30.
WITH limited AS (SELECT DISTINCT
    A2, A3
FROM
    bank.district
LIMIT 30)
SELECT * FROM limited
ORDER BY A2 DESC;

SELECT DISTINCT
    A2, A3
FROM
    bank.district
ORDER BY A2 DESC
LIMIT 30;



-- ==================================================
-- COMPARISON OPERATORS AND FILTERING
-- ==================================================

-- Filtering rows based on a specific condition
SELECT * FROM bank.loan
WHERE status = 'B';

-- The operators <> and != are equivalent
SELECT * FROM bank.loan
WHERE status != 'B';

SELECT * FROM bank.loan
WHERE status <> 'B';

-- Using IN clause for multiple possible values
SELECT 
    *
FROM
    bank.loan
WHERE
    status IN ('B' , 'b') OR amount < 200000
ORDER BY amount DESC;

-- Add logical operators - AND, NOT, OR

-- ==================================================
-- ARITHMETIC OPERATORS
-- ==================================================

-- Display the difference between columns
SELECT *, amount-payments AS to_be_paid
FROM bank.loan;

-- Use aliases to make resulting query easier to read

-- Displaying specific columns with calculated values
SELECT loan_id, account_id, date, duration, status, 
       (amount-payments)/1000 AS 'balance in Thousands'
FROM bank.loan;

SELECT loan_id, account_id, date, duration, status, 
       ROUND(payments * 100 / amount, 2) AS pct_paid
FROM bank.loan;

-- Example of modulus operator to get remainder
SELECT duration, duration / 12 AS duration_yrs
FROM bank.loan;

SELECT DISTINCT duration % 12 AS leftover_months
FROM bank.loan;

-- ==================================================
-- CHECK FOR UNDERSTANDING
-- ==================================================

-- 1. Select districts and salaries (from the `district` table) where salary is greater than 10000. Return columns as `district_name` and `average_salary`.
-- 2. Select those loans whose contract finished and were not paid. **Hint**: You should be looking at the `loan` column and you will need the extended case study information to tell you which value of status is required.
-- 3. Select cards of type `junior`. Return just first 10 in your query.
-- 4. Select those loans whose contract finished and not paid back.
# Return the debt value from the status you identified in the last activity, together with loan id and account id.
 
SELECT account_id, loan_id, amount-payments AS debt FROM loan WHERE status = 'B' ORDER BY account_id;

-- 5. Calculate the urban population for all districts. 
SELECT 
    A2 AS district,
    A4 AS total_population,
    A10 AS pct_urban,
    ROUND(A4 * A10 / 100) AS urban_population
FROM
    district
ORDER BY
	A10 DESC
WHERE
    A10 <= 50;
    
SELECT 
    A2 AS district,
    A4 AS total_population,
    A10 AS pct_urban,
    ROUND(A4 * A10 / 100) AS urban_population
FROM
    district
WHERE
    A10 <= 50
ORDER BY
	A10 DESC
LIMIT 5;


# Hint: You are looking for the number of inhabitants and the % of urban inhabitants in each district. Return columns as district_name and urban_population.
-- 6. On the previous query result - rerun it but filtering out districts where the rural population is greater than 50%.

SELECT * FROM district;
SELECT MIN(A16), AVG(A16), MAX(A16) FROM district; -- could be monthly, but 99K/month?
SELECT MIN(A15), AVG(A15), MAX(A15) FROM district; -- minimum 0 salary? 85K/month max?
SELECT MIN(A11), AVG(A11), MAX(A11) FROM district; -- minimum salary of 8K?

-- ==================================================
-- NUMERIC FUNCTIONS
-- ==================================================

-- Aggregations
SELECT SUM(A4) FROM district;

-- Other numeric functions - ROUND, CEILING, FLOOR
SELECT A10, CEILING(A10), FLOOR(A10) FROM district;

-- in Python: import math; math.ceil(number), math.floor(number) 

-- ==================================================
-- STRING FUNCTIONS
-- ==================================================

-- To obtain the length of a string we can use the function `length()`
SELECT LENGTH('himanshu') AS string_len;
SELECT 'himanshu' AS string_len;
SELECT 'himanshu', 'heiashu' AS string_2;

SELECT * FROM bank.order;
SELECT *, LENGTH(k_symbol) AS 'Symbol_length' FROM bank.order;

-- We can concatenate two strings using the function `concat()`
SELECT *, CONCAT(order_id, account_id) AS 'concat' FROM bank.order;

-- Functions to lowercase `lower()` and uppercase `upper()` a string
SELECT *, LOWER(A2), UPPER(A3) FROM bank.district;

-- Function to retrieve a given number of characters of a string starting from the left: `left()`
-- There is an equivalent function to retrieve a given number of characters of a string starting from the right
-- `right()`
SELECT A2, LEFT(A2,5), RIGHT(A2,5) FROM bank.district;

-- Functions to drop white spaces of a string `ltrim()` and `rtrim()` -- equivalent to strip()
SELECT LTRIM(' Hello ');
-- 'Hello '
SELECT RTRIM(' Hello ');
-- ' Hello'

-- Selecting by pattern matching
SELECT * FROM district
WHERE A3 LIKE 'Bohemia';

SELECT * FROM district
WHERE A3 LIKE '%Bohemia%';

SELECT * FROM district
WHERE A3 LIKE 'Bohemia%';

SELECT * FROM district
WHERE A3 LIKE '%Bohemia';

-- Filtering out rows with non-null and non-empty values
SELECT * FROM order;
SELECT * FROM bank.order;
SELECT * FROM bank.`order`;

SELECT * FROM bank.order
WHERE k_symbol IS NULL;

SELECT * FROM bank.order
WHERE k_symbol = '';

SELECT * FROM bank.order
WHERE k_symbol = ' ';

SELECT * FROM bank.order
WHERE k_symbol = '  ';

SELECT * FROM bank.order
WHERE k_symbol IS NULL OR k_symbol IN ('', ' ');

INSERT INTO bank.order VALUES (1, 2, 3, 4, 5, NULL);

SELECT * FROM bank.order
WHERE k_symbol IS NULL;

-- Selecting by range

-- Group by


