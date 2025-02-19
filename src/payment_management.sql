-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Payment Management Queries

-- 1. Record a payment for a membership
-- TODO: Write a query to record a payment for a membership
-- This query inserts a new payment record with proper categorization
INSERT INTO payments (
    member_id,
    amount,
    payment_date,
    payment_method,
    payment_type
) VALUES (
    11, 
    50.00,  
    DATETIME('now', 'localtime'),  
    'Credit Card',  
    'Monthly membership fee' 
);

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
-- 2.2 Calculate total revenue from membership fees for each month of the last year
-- Uses strftime for date formatting and aggregation by month
SELECT 
    strftime('%Y-%m', payment_date) AS month,
    ROUND(SUM(amount), 2) AS total_revenue
FROM payments
WHERE 
    strftime('%Y', payment_date) = strftime('%Y', date('now', '-1 year'))  -- This dynamically uses the current year
GROUP BY month
ORDER BY month DESC;

-- 3. Find all day pass purchases
-- TODO: Write a query to find all day pass purchases
-- 2.3 Find all day pass purchases
-- Retrieves detailed information about one-time pass purchases
SELECT 
    payment_id,
    amount,
    payment_date,
    payment_method
FROM payments
WHERE payment_type = 'Day pass'
ORDER BY payment_date DESC;
