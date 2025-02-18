-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.sqlite
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
    phone_number VARCHAR(20) NOT NULL,
    email TEXT NOT NULL, CHECK(email GLOB '*@*.*')
    opening_hours VARCHAR(30) CHECK(opening_hours GLOB '[0-9][0-9]:[0-9][0-9]-[0-9][0-9]:[0-9][0-9]')NOT NULL
);
-- 2. members
-- Members table - stores member information
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT CHECK(email GLOB '*@*.*') UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    join_date DATE CHECK(join_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')NOT NULL,
    address TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone VARCHAR(20)
);
-- 3. staff
-- Staff table - stores staff information
CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT CHECK(email GLOB '*@*.*') UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    position TEXT CHECK(position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance'))NOT NULL,
    location_id INTEGER,
    hire_date DATE NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
-- Equipment table - tracks gym equipment
CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT CHECK(type IN ('Cardio', 'Strength')) NOT NULL,
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE CHECK(last_maintenance_date > purchase_date),
    next_maintenance_date DATE CHECK(next_maintenance_date > last_maintenance_date),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 5. classes
-- Classes table - defines different types of classes offered
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
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
    start_time DATETIME NOT NULL,
    end_time DATETIME CHECK(end_time > start_time) NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- 7. memberships
-- Memberships table - defines membership types and their details
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    type VARCHAR(20) CHECK(type IN ('Premium', 'Basic')) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE CHECK(end_date>start_date)
    status VARCHAR(20) CHECK(status IN('Active', 'Inactive'))NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 8. attendance
-- Attendance table - tracks member visits
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME CHECK(check_out_time>check_in_time)),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 9. class_attendance
-- Class attendance table - tracks class participation
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(20) CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')) NOT NULL,
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
    payment_method VARCHAR(20) CHECK(payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal')) NOT NULL,
    payment_type VARCHAR(30) CHECK(payment_type IN('Monthly membership fee', 'Day pass')) NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 11. personal_training_sessions
-- Personal training sessions table
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATE NOT NULL,
    start_time varchar(20) NOT NULL,
    end_time VARCHAR(20) CHECK(end_time>start_time) NOT NULL,
    notes TEXT NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 12. member_health_metrics
-- Member health metrics table
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date DATE CHECK(measurement_date < DATE('now','+1 day')))NOT NULL,
    weight REAL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 13. equipment_maintenance_log
-- Equipment maintenance log
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date DATE NOT NULL,
    description TEXT,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal