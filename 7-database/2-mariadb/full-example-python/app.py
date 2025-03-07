import mysql.connector

# Function to connect to the database
def connect_to_db():
    return mysql.connector.connect(
        host="localhost",
        user="your_username",
        password="your_password",
        database="school_db"
    )

# Function to call the AddStudent stored procedure
def add_student(first_name, last_name, enrollment_date):
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.callproc('AddStudent', (first_name, last_name, enrollment_date))
    conn.commit()
    cursor.close()
    conn.close()
    print("Student added successfully.")

# Function to call the GetStudentGrades stored procedure
def get_student_grades(student_id):
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.callproc('GetStudentGrades', (student_id,))
    for result in cursor.stored_results():
        grades = result.fetchall()
        for grade in grades:
            print(grade)
    cursor.close()
    conn.close()

# Function to use the student_grades view
def view_student_grades():
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM student_grades")
    for row in cursor.fetchall():
        print(row)
    cursor.close()
    conn.close()

# Main function to demonstrate usage
if __name__ == "__main__":
    # Add a new student
    add_student('Bob', 'Brown', '2023-10-01')
    add_student('sam', 'ra', '2024-10-01')
    add_student('HA', 'te', '2025-10-01')

    # Get grades for student with ID 1
    print("Grades for student ID 1:")
    get_student_grades(1)

    # View all student grades
    print("All student grades:")
    view_student_grades()