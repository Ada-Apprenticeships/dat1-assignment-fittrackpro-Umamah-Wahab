-- Initial SQLite setup
.open fittrackpro.db
.mode column

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
    1,  -- Replace with actual member_id
    99.99,  -- Replace with actual amount
    DATE('now'),  -- Current date, or specify another date
    'credit_card',  -- Payment method (credit_card, cash, debit, etc.)
    'membership_fee'  -- Type of payment (membership_fee, day_pass, etc.)
);

-- 2. Calculate total revenue from membership fees for each month of the last year
-- TODO: Write a query to calculate total revenue from membership fees for each month of the current year
-- 2.2 Calculate total revenue from membership fees for each month of the last year
-- Uses strftime for date formatting and aggregation by month
SELECT 
    strftime('%Y-%m', payment_date) as month,
    ROUND(SUM(amount), 2) as total_revenue
FROM payments
WHERE 
    payment_type = 'membership_fee'
    AND payment_date >= date('now', '-1 year')
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
WHERE payment_type = 'day_pass'
ORDER BY payment_date DESC;
