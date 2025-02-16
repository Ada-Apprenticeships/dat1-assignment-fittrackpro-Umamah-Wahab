-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- TODO: Create the following tables:
-- 1. location
-- Locations table - stores information about different gym locations
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone TEXT NOT NULL,
    opening_hours TEXT NOT NULL
);
-- 2. members
-- Members table - stores member information
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    join_date DATE NOT NULL,
    address TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT
);
-- 3. staff
-- Staff table - stores staff information
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    role TEXT NOT NULL,
    location_id INTEGER,
    hire_date DATE NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
-- Equipment table - tracks gym equipment
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    equipment_type TEXT NOT NULL,
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE,
    next_maintenance_date DATE,
    location_id INTEGER,
    status TEXT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 5. classes
-- Classes table - defines different types of classes offered
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER NOT NULL,
    duration_minutes INTEGER NOT NULL
);
-- 6. class_schedule
-- Class schedule table - manages class scheduling
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER,
    instructor_id INTEGER,
    location_id INTEGER,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (instructor_id) REFERENCES staff(staff_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 7. memberships
-- Memberships table - defines membership types and their details
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    membership_type TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 8. attendance
-- Attendance table - tracks member visits
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 9. class_attendance
-- Class attendance table - tracks class participation
CREATE TABLE class_attendance (
    attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER,
    member_id INTEGER,
    status TEXT NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 10. payments
-- Payments table - tracks all financial transactions
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method TEXT NOT NULL,
    payment_type TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 11. personal_training_sessions
-- Personal training sessions table
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    trainer_id INTEGER,
    member_id INTEGER,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES staff(staff_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 12. member_health_metrics
-- Member health metrics table
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date DATE NOT NULL,
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    body_fat_percentage DECIMAL(4,2),
    blood_pressure TEXT,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 13. equipment_maintenance_log
-- Equipment maintenance log
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date DATE NOT NULL,
    maintenance_type TEXT NOT NULL,
    description TEXT,
    performed_by INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (performed_by) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal