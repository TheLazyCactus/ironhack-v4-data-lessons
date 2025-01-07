-- ==================================================
-- SETTING UP THE DATABASE
-- ==================================================

-- Setting the working database
USE bank;

-- ==================================================
-- SUBQUERIES
-- ==================================================

-- One typical use case could be to compare the loan amount of a bank customer against the mean loan amount. 

-- Computing the average loan amount for all loans
SELECT ROUND(AVG(amount),2) AS 'Average' FROM bank.loan;

-- The previous query, produces a single value that can be used for comparison purposes inside another query.
-- Now, we are going to use the previous query as a subquery.
-- Using the average computed in the previous query, retrieve all loans with amounts greater than the overall average
SELECT * FROM bank.loan 
WHERE amount > (SELECT ROUND(AVG(amount)) AS 'Average' FROM bank.loan);

-- Another more sophisticated example.
-- Now let's determine which loan status has an average amount bigger than the mean loan amount.
-- We already know the mean loan amount. It's the first query that we used as a subquery.
-- Compute the average loan amount grouped by loan status
SELECT status, ROUND(AVG(amount),2) AS 'Average' FROM bank.loan
GROUP BY status;

-- Now we can use the first query, as a subquery to filter out some status.
-- Retrieve loan statuses where the average loan amount for that status is greater than the overall average loan amount
SELECT status, ROUND(AVG(amount),2) AS 'Average' FROM bank.loan
GROUP BY status
HAVING Average > (SELECT ROUND(AVG(amount)) AS 'Average1' FROM bank.loan)
ORDER BY Average DESC;


-- ==================================================
-- CHECK FOR UNDERSTANDING
-- ==================================================

-- Find out the average of the number of transactions by account. 

-- ***Hint***: Compute first the number of transactions by account.

-- ==================================================

-- ==================================================
-- NESTED SUBQUERIES
-- ==================================================

-- Subqueries can be nested up to any level. In other words, you can create a query that uses a subquery which in turn uses another subquery, and so on. 

-- Imagine that we're asked to get all the accounts with a status that has an average amount bigger
-- than the average amount. Sounds crazy right?
-- Whenever to face a statement like this, keep calm and beak it down in elements that you will need. Then,
-- construct the queries to create those elements, and then, the final query.

-- Compute the overall average loan amount
SELECT ROUND(AVG(amount),2) AS 'Average1' FROM bank.loan; 

-- Compute the average loan amount for each loan status
SELECT status, AVG(amount) AS 'Average' FROM bank.loan
GROUP BY status;

-- Filter loan statuses where the average loan amount for the status is greater than the overall average loan amount
SELECT status FROM (
  SELECT status, AVG(amount) AS 'Average' FROM bank.loan
  GROUP BY status
  HAVING Average > (SELECT ROUND(AVG(amount),2) AS 'Average1' FROM bank.loan)
) AS s;

-- Finally, (if we are still alive) we can use a query to get the loans in those statuses.
-- Here is the beast!!
-- Using the filtered statuses from the previous query, retrieve all loans with those statuses
SELECT * FROM bank.loan
WHERE status IN (SELECT status FROM (
  SELECT status, AVG(amount) AS 'Average' FROM bank.loan
  GROUP BY status
  HAVING Average > (SELECT ROUND(AVG(amount),2) AS 'Average1' FROM bank.loan)
) AS s);


-- ==================================================
-- CHECK FOR UNDERSTANDING
-- ==================================================

-- 1. Get a list of accounts from Central Bohemia using a subquery.
-- 2. Rewrite the previous as a join query.
-- 3. Discuss which method will be more efficient.

-- ==================================================


-- 1.:
SELECT * 
FROM bank.account 
WHERE district_id IN (
    SELECT A1
    FROM bank.district
    WHERE A3 = 'central Bohemia'
);


-- 2.:

SELECT a.*
FROM bank.account a
JOIN bank.district d 
    ON a.district_id = d.district_id
WHERE d.A2 = 'central Bohemia';


3.

-- Subquery:

-- Performance: Can be less efficient, as the subquery generates an intermediate result set.
-- Use case: Easier for simple filtering but less optimized for large data sets.
-- JOIN:

-- Performance: Typically more efficient because SQL engines optimize joins and avoid intermediate results.
-- Use case: Preferred for complex queries and larger data sets where relationships between tables are clear.