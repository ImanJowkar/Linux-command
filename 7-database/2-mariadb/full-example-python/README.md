# create database, tables and other objects

```sql
CREATE DATABASE school_db;
USE school_db;



CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    enrollment_date DATE NOT NULL
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_name VARCHAR(100) NOT NULL,
    grade CHAR(1) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


INSERT INTO students (first_name, last_name, enrollment_date) VALUES
('John', 'Doe', '2023-09-01'),
('Jane', 'Smith', '2023-09-01'),
('iman', 'Johnson', '2024-09-02'),
('jack', 'Johnson', '2024-06-01'),
('jafar', 'Johnson', '2022-12-08'),
('sam', 'Johnson', '2021-02-01'),
('bob', 'Johnson', '2025-01-01');

INSERT INTO grades (student_id, course_name, grade) VALUES
(1, 'Mathematics', 'A'),
(1, 'Science', 'B'),
(2, 'Mathematics', 'C'),
(3, 'Mathematics', 'C'),
(5, 'Science', 'C'),
(6, 'Science', 'C'),
(6, 'Science', 'B'),
(7, 'Science', 'B'),
(7, 'Science', 'A');



```


####  create a trigger that updates the enrollment_date to the current date if someone tries to insert a date in the past.

```sql
DELIMITER //

CREATE TRIGGER before_student_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.enrollment_date < CURDATE() THEN
        SET NEW.enrollment_date = CURDATE();
    END IF;
END //

DELIMITER ;


```


#### create a view that shows student names along with their grades.

```sql

CREATE VIEW student_grades AS
SELECT s.first_name, s.last_name, g.course_name, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id;

select * from student_grades;

```

#### create a stored procedure to add a new student.

```sql

DELIMITER //

CREATE PROCEDURE AddStudent(IN f_name VARCHAR(50), IN l_name VARCHAR(50), IN e_date DATE)
BEGIN
    INSERT INTO students (first_name, last_name, enrollment_date) VALUES (f_name, l_name, e_date);
END //

DELIMITER ;

```


#### create a stored procedure to get grades by student ID.

```sql
DELIMITER //

CREATE PROCEDURE GetStudentGrades(IN s_id INT)
BEGIN
    SELECT course_name, grade FROM grades WHERE student_id = s_id;
END //

DELIMITER ;

```

#### create a function that calculates the GPA for a student.

```sql 

DELIMITER //

CREATE FUNCTION CalculateGPA(s_id INT) RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE total_points INT DEFAULT 0;
    DECLARE total_grades INT DEFAULT 0;
    DECLARE gpa DECIMAL(3,2);

    SELECT SUM(CASE grade WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2 WHEN 'D' THEN 1 ELSE 0 END),
           COUNT(*)
    INTO total_points, total_grades
    FROM grades
    WHERE student_id = s_id;

    IF total_grades > 0 THEN
        SET gpa = total_points / total_grades;
    ELSE
        SET gpa = 0.00;
    END IF;

    RETURN gpa;
END //

DELIMITER ;

```


#### create an event that runs every minute and deletes students whose enrollment_date is more than 1 year in the past.

```sql

DELIMITER //

CREATE EVENT CleanUpOldStudents
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- Delete related rows in the grades table
    DELETE FROM grades WHERE student_id IN (
        SELECT student_id FROM students WHERE enrollment_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    );

    -- Delete rows from the students table
    DELETE FROM students WHERE enrollment_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //

DELIMITER ;


```

`you have to enable event_scheduler;`

```bash
mysql -u root -p

SHOW VARIABLES LIKE 'event_scheduler';

SET GLOBAL event_scheduler = ON;

# or you can add this variable in mysql-config-fiel

event_scheduler = ON


```


#### test the event works

```sql
INSERT INTO students (first_name, last_name, enrollment_date) VALUES
('Old', 'Student1', '2020-01-01'), -- More than 1 year ago
('Old', 'Student2', '2022-05-01'), -- More than 1 year ago
('Recent', 'Student3', '2023-10-01'); -- Less than 1 year ago

```


##### Python Script to Connect to MySQL and Use Stored Procedures and Views

```bash
python3 -m venv venv
sourve venv/bin/activate
pip install mysql-connector-python

python3 app.py

```