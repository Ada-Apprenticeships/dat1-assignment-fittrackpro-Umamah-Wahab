-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Equipment Management Queries

-- 1. Find equipment due for maintenance
-- TODO: Write a query to find equipment due for maintenance
-- 3.1 Find equipment due for maintenance in the next 30 days
-- Helps staff proactively schedule maintenance
SELECT 
    e.equipment_id,
    e.name,
    e.next_maintenance_date
FROM equipment e
WHERE 
    e.next_maintenance_date BETWEEN DATE('now') AND DATE('now', '+30 days')
ORDER BY e.next_maintenance_date;


-- 2. Count equipment types in stock
-- TODO: Write a query to count equipment types in stock
-- 3.2 Count equipment types in stock
-- Provides inventory overview grouped by equipment type

SELECT type, COUNT(type) AS count
FROM equipment
GROUP BY type;


-- 3. Calculate average age of equipment by type (in days)
-- TODO: Write a query to calculate average age of equipment by type (in days)
-- 3.3 Calculate average age of equipment by type (in days)
-- Helps with replacement planning and budgeting
SELECT 
    type AS equipment_type,
    ROUND(AVG(JULIANDAY('now') - JULIANDAY(purchase_date))) as avg_age_days
FROM equipment
GROUP BY type
ORDER BY avg_age_days DESC;

