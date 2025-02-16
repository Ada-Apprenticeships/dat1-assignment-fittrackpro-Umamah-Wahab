-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Attendance Tracking Queries

-- 1. Record a member's gym visit
-- TODO: Write a query to record a member's gym visit
-- 6.1 Record a member's gym visit
INSERT INTO attendance (
    member_id,
    location_id,
    check_in_time
) VALUES (
    1,  -- Replace with actual member_id
    1,  -- Replace with actual location_id
    DATETIME('now')
);

-- Update check-out time when member leaves
UPDATE attendance
SET check_out_time = DATETIME('now')
WHERE 
    attendance_id = 1  -- Replace with actual attendance_id
    AND check_out_time IS NULL;

-- 2. Retrieve a member's attendance history
-- TODO: Write a query to retrieve a member's attendance history
-- 6.2 Retrieve a member's attendance history
SELECT 
    DATE(check_in_time) as visit_date,
    TIME(check_in_time) as check_in_time,
    TIME(check_out_time) as check_out_time
FROM attendance
WHERE member_id = 1  -- Replace with actual member_id
ORDER BY check_in_time DESC;


-- 3. Find the busiest day of the week based on gym visits
-- TODO: Write a query to find the busiest day of the week based on gym visits
-- 6.3 Find the busiest day of the week based on gym visits
SELECT 
    CASE CAST(strftime('%w', check_in_time) AS INTEGER)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END as day_of_week,
    COUNT(*) as visit_count
FROM attendance
GROUP BY day_of_week
ORDER BY visit_count DESC;


-- 4. Calculate the average daily attendance for each location
-- TODO: Write a query to calculate the average daily attendance for each location
-- 6.4 Calculate average daily attendance for each location
SELECT 
    l.name as location_name,
    ROUND(
        COUNT(*) * 1.0 / 
        (SELECT COUNT(DISTINCT DATE(check_in_time)) 
         FROM attendance 
         WHERE location_id = l.location_id)
    , 2) as avg_daily_attendance
FROM attendance a
JOIN locations l ON a.location_id = l.location_id
GROUP BY l.location_id, l.name
ORDER BY avg_daily_attendance DESC;
