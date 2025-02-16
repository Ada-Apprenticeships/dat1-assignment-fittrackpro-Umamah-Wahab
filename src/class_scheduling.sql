-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Class Scheduling Queries

-- 1. List all classes with their instructors
-- TODO: Write a query to list all classes with their instructors
-- 4.1 List all classes with their instructors
SELECT 
    cs.class_id,
    c.name as class_name,
    s.first_name || ' ' || s.last_name as instructor_name
FROM class_schedule cs
JOIN classes c ON cs.class_id = c.class_id
JOIN staff s ON cs.instructor_id = s.staff_id
ORDER BY cs.start_time;


-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
-- 4.2 Find available classes for a specific date
-- Calculates remaining spots in each class
SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - COUNT(ca.attendance_id)) as available_spots
FROM class_schedule cs
JOIN classes c ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE DATE(cs.start_time) = DATE('2024-02-16')  -- Replace with desired date
GROUP BY cs.schedule_id
HAVING available_spots > 0
ORDER BY cs.start_time;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
-- 4.3 Register a member for a class
INSERT INTO class_attendance (
    schedule_id,
    member_id,
    status
) VALUES (
    1,  -- Replace with actual schedule_id
    1,  -- Replace with actual member_id
    'registered'
);

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
-- 4.4 Cancel a class registration
UPDATE class_attendance
SET status = 'cancelled'
WHERE 
    schedule_id = 1  -- Replace with actual schedule_id
    AND member_id = 1;  -- Replace with actual member_id


-- 5. List top 5 most popular classes
-- TODO: Write a query to list top 5 most popular classes
-- 4.5 List top 3 most popular classes
SELECT 
    c.class_id,
    c.name as class_name,
    COUNT(ca.attendance_id) as registration_count
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE ca.status = 'registered'
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
-- 4.6 Calculate average number of classes per member
SELECT 
    ROUND(CAST(COUNT(ca.attendance_id) AS FLOAT) / 
          CAST(COUNT(DISTINCT m.member_id) AS FLOAT), 2) as avg_classes_per_member
FROM members m
LEFT JOIN class_attendance ca ON m.member_id = ca.member_id
WHERE ca.status = 'registered';

