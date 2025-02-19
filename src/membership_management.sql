-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column
.mode box
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
    ms.type,
    m.join_date
FROM members m
LEFT JOIN memberships ms ON m.member_id = ms.member_id
WHERE 
    ms.status = 'Active'
ORDER BY ms.start_date DESC;


-- 2. Calculate the average duration of gym visits for each membership type
-- TODO: Write a query to calculate the average duration of gym visits for each membership type
-- 5.2 Calculate average duration of gym visits for each membership type
SELECT 
    ms.type AS membership_type,
    ROUND(AVG(
        (JULIANDAY(a.check_out_time) - JULIANDAY(a.check_in_time)) * 24 * 60
    ), 2) as avg_visit_duration_minutes
FROM memberships ms
JOIN attendance a ON ms.member_id = a.member_id
GROUP BY ms.type;


-- 3. Identify members with expiring memberships this year
-- TODO: Write a query to identify members with expiring memberships this year
-- 5.3 Identify members with expiring memberships this year

SELECT m.member_id, m.first_name, m.last_name, m.email, me.end_date
FROM members m
LEFT JOIN memberships me ON me.member_id = m.member_id
WHERE strftime('%Y', me.end_date) = strftime('%Y', 'now');

