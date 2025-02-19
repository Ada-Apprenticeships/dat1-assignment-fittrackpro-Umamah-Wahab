-- FitTrack Pro Database Schema
 
-- Initial SQLite setup
.open src/fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Drop tables if they exist to start fresh 
DROP TABLE IF EXISTS equipment_maintenance_log;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS equipment;  
DROP TABLE IF EXISTS staff;  
DROP TABLE IF EXISTS members;  
DROP TABLE IF EXISTS locations; 

-- TODO: Create the following tables:
-- 1. location
-- Locations table - stores information about different gym locations
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(225) NOT NULL,
    address VARCHAR(225) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email TEXT NOT NULL CHECK(email GLOB '*@*.*'),
    opening_hours TEXT CHECK (opening_hours GLOB '[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]')
);
-- 2. members
-- Members table - stores member information
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name VARCHAR(225) NOT NULL,
    last_name VARCHAR(225) NOT NULL,
    email VARCHAR(225) NOT NULL CHECK(email GLOB '*@*.*') UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL CHECK(date_of_birth GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    join_date DATE NOT NULL CHECK(join_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    address VARCHAR(250),
    emergency_contact_name VARCHAR(20) NOT NULL,
    emergency_contact_phone VARCHAR(20) NOT NULL
);
-- 3. staff
-- Staff table - stores staff information
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name VARCHAR(225) NOT NULL,
    last_name VARCHAR(225) NOT NULL,
    email VARCHAR(225) NOT NULL CHECK(email GLOB '*@*.*') UNIQUE,
    phone_number VARCHAR(20) NOT NULL,
    position VARCHAR(30) NOT NULL CHECK(position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    location_id INTEGER,
    hire_date DATE NOT NULL CHECK(hire_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
-- Equipment table - tracks gym equipment
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name VARCHAR(225) NOT NULL,
    type VARCHAR(30) NOT NULL CHECK(type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL CHECK(purchase_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    last_maintenance_date DATE NOT NULL CHECK(last_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') CHECK(last_maintenance_date > purchase_date),
    next_maintenance_date DATE NOT NULL CHECK(next_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') CHECK(next_maintenance_date > last_maintenance_date),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 5. classes
-- Classes table - defines different types of classes offered
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name VARCHAR(225) NOT NULL,
    description TEXT NOT NULL,
    capacity INTEGER CHECK(capacity>0) NOT NULL,
    duration INTEGER CHECK(duration>0) NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 6. class_schedule
-- Class schedule table - manages class scheduling
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER,
    staff_id INTEGER,
    start_time DATETIME NOT NULL CHECK(start_time GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    end_time DATETIME NOT NULL CHECK(end_time GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]') CHECK(end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- 7. memberships
-- Memberships table - defines membership types and their details
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    type VARCHAR(20) NOT NULL CHECK(type IN ('Premium', 'Basic')),
    start_date DATE NOT NULL CHECK(start_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    end_date DATE NOT NULL CHECK(end_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]') CHECK(end_date>start_date),
    status VARCHAR(20) NOT NULL CHECK(status IN('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 8. attendance
-- Attendance table - tracks member visits
CREATE TABLE attendance (  
    attendance_id INTEGER PRIMARY KEY,  
    member_id INTEGER,  
    location_id INTEGER,  
    check_in_time DATETIME NOT NULL,  
    check_out_time DATETIME NOT NULL,  
    FOREIGN KEY (member_id) REFERENCES members(member_id),  
    FOREIGN KEY (location_id) REFERENCES locations(location_id),  
    CHECK (check_out_time > check_in_time)  
);  

 
-- 9. class_attendance
-- Class attendance table - tracks class participation
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(20) NOT NULL CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 10. payments
-- Payments table - tracks all financial transactions
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    amount REAL CHECK(amount = ROUND(amount, 2)) NOT NULL,
    payment_date DATETIME NOT NULL CHECK(payment_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]'),
    payment_method VARCHAR(20) NOT NULL CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type VARCHAR(30) NOT NULL CHECK(payment_type IN('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 11. personal_training_sessions
-- Personal training sessions table
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATE NOT NULL CHECK(session_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
    start_time VARCHAR(20) NOT NULL,
    end_time VARCHAR(20) NOT NULL CHECK(end_time>start_time),
    notes TEXT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 12. member_health_metrics
-- Member health metrics table
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date DATE NOT NULL,
    weight REAL NOT NULL CHECK(weight = ROUND(weight, 1)),
    body_fat_percentage REAL NOT NULL CHECK(body_fat_percentage = ROUND(body_fat_percentage, 1)),
    muscle_mass REAL NOT NULL CHECK(muscle_mass = ROUND(muscle_mass, 1)),
    bmi REAL NOT NULL CHECK(bmi = ROUND(bmi, 1)),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 13. equipment_maintenance_log
-- Equipment maintenance log
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date VARCHAR(30),
    description TEXT,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal
.read scripts/sample_data.sql