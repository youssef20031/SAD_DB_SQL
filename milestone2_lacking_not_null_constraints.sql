CREATE DATABASE Advising_Team_147;

Go
CREATE PROCEDURE CreateAllTables
AS


create table advisor 
(
advisor_id int primary key identity(1,1),
name varchar(40),
email varchar(40),
office varchar(40),
password_ Varchar(40)
);

create table student 
(
student_id int primary key identity(1,1),
f_name varchar(40),
l_name varchar(40),
gpa decimal,
faculty varchar(40),
email varchar(40),
major varchar(40),
password_ varchar(40),
financial_status bit,
semester int,
acquired_hours int,
assigned_hours int,
advisor_id int,
foreign key (advisor_id) references advisor(advisor_id)
);

create table student_phone 
(
student_id int ,
phone_number int, 
primary key ( student_id, phone_number)
);

create table course 
(
course_id int primary key,
name varchar(40),
major varchar(40),
is_offered bit,
credit_hours int,
semester int
);

create table preqCourse 
(
prerequisite_course_id int ,
course_id int, 
primary key ( prerequisite_course_id, course_id),
foreign key (course_id) references course(course_id)

);

create table Instructor 
(
instructor_id int primary key,
name varchar(40),
email varchar(40),
faculty varchar(40),
office varchar(40)
);

create table Instructor_course
(
course_id int ,
instructor_id int ,
primary key ( course_id, instructor_id),
foreign key (course_id) references course(course_id),
foreign key(instructor_id) references Instructor(instructor_id)
);

create table Student_instructor_Course_Take
(
student_id int ,
instructor_id int,
course_id int ,
semester_code int,
exam_type varchar(40),
grade decimal Default(NULL),
primary key ( course_id, student_id, instructor_id),
foreign key(student_id) references student(student_id),
foreign key(instructor_id) references Instructor(instructor_id) ,
foreign key(course_id) references course(course_id)
);

create table semester
(
semester_code int primary key,
Start_date date,
End_date date
); 

create table course_semester 
(
course_id int ,
semester_code int ,
primary key ( course_id, semester_code)
);


create table slot
(
slot_id int primary key, 
day date,
time time,
location varchar(40),
course_id int,
instructor_id int,
foreign key(course_id) references course(course_id),
foreign key(instructor_id) references instructor(instructor_id)
);

create table graduation_plan
(
plan_id int,
semester_code int ,
semester_credit_hours int,
expected_grad_smester decimal,
advisor_id int,
student_id int,
primary key ( plan_id, semester_code),
foreign key (advisor_id) references advisor(advisor_id),
foreign key (student_id) references student(student_id)
);

create table GradPlan_course
(
plan_id int,
semester_code int ,
course_id int ,
primary key ( plan_id, semester_code, course_id),
foreign key (semester_code) references semester(semester_code),
foreign key (course_id) references course(course_id)
);

create table Request
(
request_id int primary key,
type_ varchar(40),
comment Varchar(40),
status_ varchar Default('Pending') check(status_ IN('Pending','Accepted','Rejected')),
credit_hours int,
student_id int ,
advisor_id int,
course_id int,
foreign key (advisor_id) references advisor(advisor_id),
foreign key (student_id) references student(student_id)
);

create table MakeUp_Exam
(
exam_id int primary key,
date date,
type_ varchar(40) DEFAULT('Normal') check(type_ IN('First_Makeup','Second_Makeup','Normal')),
course_id int,
foreign key (course_id) references course(course_id)
);

create table exam_student
(
exam_id int ,
student_id int ,
course_id int,
primary key (student_id, exam_id),
foreign key (student_id) references student(student_id),
foreign key (exam_id) references MakeUp_exam(exam_id)
);

create table payment
(
payment_id int primary key,
amount decimal,
deadline date,
n_installments int,
status_ varchar Default('notPaid') check(status_ IN('notPaid','Paid')),
fund_percentage float,
student_id int,
semester_code int,
start_date date,
foreign key (student_id) references student(student_id),
foreign key (semester_code) references semester(semester_code)
);

create table installments 
(
payment_id int,
deadline date,
amount decimal,
status_ varchar Default('notPaid') check(status_ IN('notPaid','Paid')),
start_date date,
primary key (payment_id, deadline),
foreign key (payment_id) references payment(payment_id)
);
GO
EXEC CreateAllTables

GO
CREATE PROCEDURE DropAllTables
AS
DROP TABLE advisor;
DROP TABLE student
DROP TABLE student_phone;
DROP TABLE course;
DROP TABLE preqCourse;
DROP TABLE Instructor;
DROP TABLE Instructor_course;
DROP TABLE Student_instructor_Course_Take;
DROP TABLE semester;
DROP TABLE course_semester;
DROP TABLE slot;
DROP TABLE graduation_plan;
DROP TABLE GradPlan_course;
DROP TABLE Request;
DROP TABLE MakeUp_Exam;
DROP TABLE exam_student;
DROP TABLE payment;
DROP TABLE installments;
GO

GO
CREATE PROCEDURE  clearAllTables
AS
TRUNCATE TABLE advisor;
TRUNCATE TABLE student
TRUNCATE TABLE student_phone;
TRUNCATE TABLE course;
TRUNCATE TABLE preqCourse;
TRUNCATE TABLE Instructor;
TRUNCATE TABLE Instructor_course;
TRUNCATE TABLE Student_instructor_Course_Take;
TRUNCATE TABLE semester;
TRUNCATE TABLE course_semester;
TRUNCATE TABLE slot;
TRUNCATE TABLE graduation_plan;
TRUNCATE TABLE GradPlan_course;
TRUNCATE TABLE Request;
TRUNCATE TABLE MakeUp_Exam;
TRUNCATE TABLE exam_student;
TRUNCATE TABLE payment;
TRUNCATE TABLE installments;
GO

GO
CREATE PROCEDURE  Procedures_StudentRegistration
@f_name varchar(40),
@l_name varchar(40),
@password_ varchar(40),
@faculty varchar(40),
@email varchar(40),
@major varchar(40),
@financial_status bit,
@semester int,
@id OUTPUT
AS
insert into student(f_name,l_name,password_,faculty,email,major,financial_status,semester)
values(@f_name,@l_name,@password_,@faculty,@email,@major,@financial_status,@semester)
SELECT @id = id
FROM student 
WHERE id=(SELECT max(id) FROM student);
GO

GO
CREATE PROCEDURE Procedures_AdvisorRegistration
@name varchar (40), 
@password_ varchar (40),
@email varchar (40),
@office varchar (40)
AS
insert into advisor(name, password_,email,office)
values(@name, @password_,@email,@office)
SELECT @id = advisor_id
FROM advisor 
WHERE advisor_id=(SELECT max(advisor_id) FROM advisor);
GO

GO
CREATE PROCEDURE Procedures_AdminListStudents
AS
SELECT *
FROM student
GO

GO
CREATE PROCEDURE Procedures_AdminListAdvisors
AS
SELECT *
FROM advisor
GO

GO
CREATE PROCEDURE AdminListStudentsWithAdvisors
AS
SELECT *
FROM student inner join advisor on student.advisor_id = advisor.advisor_id
GO

GO
CREATE PROCEDURE AdminAddingSemester
@start_date date, 
@end_date date, 
@semester int
AS
Set identity_insert semester ON;
insert into semester(Start_date,End_date,semester_code)
values(@start_date, @end_date, @semester)
GO

GO
CREATE PROCEDURE  Procedures_AdminAddingCourse
@major varchar (40), 
@semester int, 
@credit_hours int,
@name varchar (40), 
@offered bit
AS 
insert into course(major,semester,credit_hours,name,is_offered)
values(@major, @semester , @credit_hours ,@name , @offered)
GO

GO
CREATE PROCEDURE  Procedures_AdminLinkInstructor
@InstructorId int, @courseId int, @slotID int
AS
insert into slot(Instructor_Id, course_Id, slot_ID)
values(@InstructorId , @courseId , @slotID )
GO

GO
CREATE PROCEDURE  Procedures_AdminLinkStudent
@InstructorId int, 
@studentID int, 
@courseID int, 
@semestercode varchar (40)


AS
insert into Student_instructor_Course_Take(Instructor_Id, student_id, course_id, semester_code)
values(@InstructorId , @studentID, @courseId, @semestercode)
GO
CREATE PROCEDURE Procedures_AdminLinkStudentToAdvisor
    @studentID INT,
    @advisorID INT
AS
    UPDATE student
    SET advisor_id = @advisorID
    WHERE student_id = @studentID;
GO

GO