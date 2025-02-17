-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- User Management Queries

-- 1. Retrieve all members
-- TODO: Write a query to retrieve all members
-- 1.1 Retrieve all members
-- This query gets basic member information ordered by join date
SELECT member_id, first_name, last_name, email, join_date
FROM members
ORDER BY join_date DESC;

-- 2. Update a member's contact information
-- TODO: Write a query to update a member's contact information
-- 1.2 Update a member's contact information
-- Replace the values in SET with the new information
-- and the member_id in WHERE with the target member's ID
UPDATE members
SET 
    email = 'emily.jones.updated@email.com',
    phone_number = '555-9876'
WHERE member_id = 5;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
-- 1.3 Count total number of members
SELECT COUNT(*) AS total_members
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
-- 1.4 Find member with the most class registrations

WITH registration_counts AS(
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    (SELECT COUNT(ca.class_attendance_id) FROM class_attendance ca WHERE attendance_status = 'Registered' AND ca.member_id = m.member_id) AS registration_count
FROM members m
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC)

select *
FROM registration_counts
WHERE registration_count = (SELECT MAX(registration_count) FROM registration_counts);


-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
-- 1.5 Find member with the least class registrations
WITH registration_counts AS(
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    (SELECT COUNT(ca.class_attendance_id) FROM class_attendance ca WHERE attendance_status = 'Registered' AND ca.member_id = m.member_id) AS registration_count
FROM members m
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC)

select *
FROM registration_counts
WHERE registration_count = (SELECT MIN(registration_count) FROM registration_counts);

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
-- 1.6 Calculate the percentage of members who have attended at least one class

WITH attendance_counts AS
(
SELECT COUNT(*) AS count
FROM class_attendance ca 
WHERE ca.attendance_status = 'Attended'
) 

SELECT (count*100/(SELECT COUNT(*) FROM members)) AS percentage
FROM attendance_counts 
WHERE count >0;
