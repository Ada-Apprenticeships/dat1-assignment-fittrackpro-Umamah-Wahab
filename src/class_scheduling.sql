-- Initial SQLite setup
.open fittrackpro.sqlite
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
JOIN staff s ON cs.staff_id = s.staff_id;


-- 2. Find available classes for a specific date
-- TODO: Write a query to find available classes for a specific date
-- 4.2 Find available classes for a specific date
-- Calculates remaining spots in each class
SELECT 
    cs.class_id,
    c.name,
    cs.start_time,
    cs.end_time,
    (c.capacity - (SELECT COUNT(ca.class_attendance_id) FROM class_attendance ca WHERE cs.schedule_id = ca.schedule_id AND ca.attendance_status = 'Registered')) as available_spots
FROM class_schedule cs
LEFT JOIN classes c ON cs.class_id = c.class_id
LEFT JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE DATE(cs.start_time) = DATE('2025-02-01') 
GROUP BY cs.class_id
HAVING available_spots > 0
ORDER BY cs.start_time;

-- 3. Register a member for a class
-- TODO: Write a query to register a member for a class
-- 4.3 Register a member for a class
INSERT INTO class_attendance (
    schedule_id,
    member_id,
    attendance_status
) VALUES (
    (SELECT schedule_id FROM class_schedule WHERE class_id = 3 AND start_time LIKE '2025-02-01%' ),
    11,
    'Registered'
);

-- 4. Cancel a class registration
-- TODO: Write a query to cancel a class registration
-- 4.4 Cancel a class registration
DELETE FROM class_attendance
WHERE schedule_id = 7  
AND member_id = 2;  


-- 5. List top 5 most popular classes -- README SAYS TOP 3
-- TODO: Write a query to list top 5 most popular classes
-- 4.5 List top 3 most popular classes
SELECT 
    c.class_id,
    c.name as class_name,
    COUNT(ca.class_attendance_id) as registration_count
FROM classes c
JOIN class_schedule cs ON c.class_id = cs.class_id
JOIN class_attendance ca ON cs.schedule_id = ca.schedule_id
WHERE ca.attendance_status = 'Registered'
GROUP BY c.class_id, c.name
ORDER BY registration_count DESC
LIMIT 3;

-- 6. Calculate average number of classes per member
-- TODO: Write a query to calculate average number of classes per member
-- 4.6 Calculate average number of classes per member
WITH attendances AS
(
    SELECT m.member_id,
    (SELECT COUNT(*)
    FROM class_attendance ca
    WHERE m.member_id = ca.member_id)
    AS noOfClasses
    FROM members m
)
 
SELECT AVG(noOfClasses) AS average_no_classes
FROM attendances;
