-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Membership Management Queries

-- 1. List all active memberships
-- TODO: Write a query to list all active memberships
-- 5.1 List all active memberships with member details
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    ms.membership_type,
    ms.start_date
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE 
    ms.status = 'active'
    AND ms.end_date >= DATE('now')
ORDER BY ms.start_date DESC;


-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
-- 5.2 Calculate average duration of gym visits for each membership type
SELECT 
    ms.membership_type,
    ROUND(AVG(
        (JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 * 60
    ), 2) as avg_visit_duration_minutes
FROM memberships ms
JOIN attendance a ON ms.member_id = a.member_id
WHERE 
    a.check_out_time IS NOT NULL
    AND ms.status = 'active'
GROUP BY ms.membership_type
ORDER BY avg_visit_duration_minutes DESC;


-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
-- 5.3 Identify members with expiring memberships this year
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    m.email,
    ms.end_date
FROM members m
JOIN memberships ms ON m.member_id = ms.member_id
WHERE 
    ms.status = 'active'
    AND ms.end_date BETWEEN DATE('now') 
    AND DATE('now', 'start of year', '+1 year', '-1 day')
ORDER BY ms.end_date;

