-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
-- 7.1 List all staff members by role
SELECT 
    staff_id,
    first_name ,
    last_name,
    position AS role
FROM staff;


-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days
-- 7.2 Find trainers with personal training sessions in next 30 days
SELECT 
    s.staff_id as trainer_id,
    s.first_name || ' ' || s.last_name as trainer_name,
    COUNT(pts.session_id) as session_count
FROM staff s
JOIN personal_training_sessions pts ON s.staff_id = pts.staff_id
WHERE 
    s.position = 'Trainer'
    AND pts.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
GROUP BY trainer_id;

