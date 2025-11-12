create database project;
use project;
show tables;
desc bank_data_analitycs;
-- Total Loan Amount Funded 
SELECT SUM(`Funded Amount`) AS total_funded_amount FROM bank_data_analitycs; -- 731880400

-- Total Loans
SELECT COUNT(`Account ID`) AS total_loans FROM bank_data_analitycs; -- 65468

-- Total Collection
SELECT sum(`Total Rec Prncp` + `Total Rrec int` + `Total Rec Late Fee` + `Collection Recovery Fee`) 
as Total_Collection
from bank_data_analitycs; --  808196003.294495

-- Total Interest
SELECT SUM(`Total Rrec int`) AS total_interest FROM bank_data_analitycs; -- '155093615.90999866'

-- Branch wise performance
SELECT `Branch Name`,
       SUM(`Total Rrec int`) AS interest,
       SUM(`Total Fees`) AS fees,
       SUM(`Total Pymnt`) AS total_payment
FROM bank_data_analitycs
GROUP BY `Branch Name`;

-- State Wise Loan 
SELECT `State Name`,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY `State Name`;

-- Religion Wise Loan

SELECT `Religion`,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY `Religion`;

-- Product group Wise Loan
SELECT `Product Code`,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY `Product Code`;

-- Disbursement Trend 
SELECT FORMAT(`Disbursement Date`, 'yyyy-MM') AS disbursement_month,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY FORMAT(`Disbursement Date`, 'yyyy-MM')
ORDER BY disbursement_month;


-- Grade Wise Loan

SELECT `Grrade`,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY `Grrade`;

-- Default loan Rate 
SELECT COUNT(`Account ID`) AS default_loan_count
FROM bank_data_analitycs
WHERE `Is Default Loan` = 'Y';  -- 1020

-- Delinquint Client Count

SELECT COUNT(DISTINCT `Client id`) AS delinquent_clients
FROM bank_data_analitycs
WHERE `Is Delinquent Loan` = 'Y';  -- 7100
-- Delinquent Client Count
SELECT ROUND(
    (SELECT COUNT(*) FROM bank_data_analitycs WHERE `Is Delinquent Loan` = 'Y') * 100.0 /
    (SELECT COUNT(*) FROM bank_data_analitycs),
    2
) AS delinquent_loan_rate;  -- 10.84

SELECT ROUND(
    (SELECT COUNT(*) FROM bank_data_analitycs WHERE `Is Default Loan` = 'Y') * 100.0 /
    (SELECT COUNT(*) FROM bank_data_analitycs),
    2
) AS default_loan_rate; -- 1.56


-- Loan STatus Wise Loan
SELECT `Loan Status`,
       COUNT(`Account ID`) AS loan_count,
       SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY `Loan Status`;
-- Average Group Wise Loan
SELECT 
  CASE 
    WHEN `Age` BETWEEN 18 AND 25 THEN '18-25'
    WHEN `Age` BETWEEN 26 AND 35 THEN '26-35'
    WHEN `Age` BETWEEN 36 AND 50 THEN '36-50'
    ELSE '51+' 
  END AS age_group,
  COUNT(`Account ID`) AS loan_count,
  SUM(`Loan Amount`) AS total_loan_amount
FROM bank_data_analitycs
GROUP BY age_group;


-- No Verified Lons 
SELECT COUNT(`Account ID`) AS Verified_loans
FROM bank_data_analitycs
WHERE `Verification Status` = 'Verified'; -- 12809

-- debit and credit kpi
show tables;
desc debit_and_credit_banking_data;

-- Total credit amount
SELECT SUM(Amount) AS total_credit_amount
FROM debit_and_credit_banking_data
WHERE `Transaction Type` = 'Credit'; -- '127603386.40999912'


-- Total Debit Amount
SELECT SUM(Amount) AS total_debit_amount
FROM debit_and_credit_banking_data
WHERE `Transaction Type` = 'Debit'; -- '127285269.22000013'


-- Credit to Debit Ratio
SELECT 
  ROUND(
    SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) /
    NULLIF(SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END), 0),
    2
  ) AS credit_to_debit_ratio
FROM debit_and_credit_banking_data; -- 1.002

-- Net Transaction AMount 
SELECT 
  SUM(CASE WHEN `Transaction Type` = 'Credit' THEN Amount ELSE 0 END) -
  SUM(CASE WHEN `Transaction Type` = 'Debit' THEN Amount ELSE 0 END) AS net_transaction_amount
FROM debit_and_credit_banking_data; -- '318117.18999898434'

-- Account Activity Ratio
SELECT `Account Number`,
COUNT(*) / MAX(Balance) AS account_activity_ratio
FROM debit_and_credit_banking_data
GROUP BY `Account Number`;

-- Trasactions per day/week/month

-- Per Day
SELECT DATE(`Transaction Date`) AS day, COUNT(*) AS transactions_per_day
FROM debit_and_credit_banking_data
GROUP BY day;

-- Per Week
SELECT YEARWEEK(`Transaction Date`) AS week, COUNT(*) AS transactions_per_week
FROM debit_and_credit_banking_data
GROUP BY week;

-- Per Month
SELECT DATE_FORMAT(`Transaction Date`, '%Y-%m') AS month, COUNT(*) AS transactions_per_month
FROM debit_and_credit_banking_data
GROUP BY month;

-- Total Trasactions Amount By Branch
SELECT Branch, SUM(Amount) AS total_transaction_amount
FROM debit_and_credit_banking_data
GROUP BY Branch;


















































 
