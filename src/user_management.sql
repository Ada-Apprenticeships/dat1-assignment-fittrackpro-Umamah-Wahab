-- Initial SQLite setup
.open fittrackpro.db
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
    email = 'new.email@example.com',
    phone = '555-0123',
    address = '123 New Street'
WHERE member_id = 1;

-- 3. Count total number of members
-- TODO: Write a query to count the total number of members
-- 1.3 Count total number of members
SELECT COUNT(*) as total_members
FROM members;

-- 4. Find member with the most class registrations
-- TODO: Write a query to find the member with the most class registrations
-- 1.4 Find member with the most class registrations
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.attendance_id) as registration_count
FROM members m
LEFT JOIN class_attendance ca ON m.member_id = ca.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count DESC
LIMIT 1;

-- 5. Find member with the least class registrations
-- TODO: Write a query to find the member with the least class registrations
-- 1.5 Find member with the least class registrations
SELECT 
    m.member_id,
    m.first_name,
    m.last_name,
    COUNT(ca.attendance_id) as registration_count
FROM members m
LEFT JOIN class_attendance ca ON m.member_id = ca.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY registration_count ASC
LIMIT 1;

-- 6. Calculate the percentage of members who have attended at least one class
-- TODO: Write a query to calculate the percentage of members who have attended at least one class
-- 1.6 Calculate the percentage of members who have attended at least one class
SELECT 
    ROUND(
        (CAST(COUNT(DISTINCT ca.member_id) AS FLOAT) / 
        CAST(COUNT(DISTINCT m.member_id) AS FLOAT) * 100),
        2
    ) as attendance_percentage
FROM members m
LEFT JOIN class_attendance ca ON m.member_id = ca.member_id;
