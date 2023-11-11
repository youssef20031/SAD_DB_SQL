CREATE DATABASE uni;
use uni;

create table advisor 
(
advisor_id int primary key,
name varchar(40),
email varchar(40),
office varchar(40),
password Varchar(40)
);

create table student 
(
student_id int primary key,
f_name varchar(40),
l_name varchar(40),
gpa decimal,
faculty varchar(40),
email varchar(40),
major varchar(40),
password varchar(40),
financial_status varchar(40),
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
grade decimal,
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
type varchar(40),
comment Varchar(40),
status_ varchar Default('Pending'),
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
type varchar(40),
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
status_ varchar Default('Pending'),
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
status_ varchar Default('Pending'),
start_date date,
primary key (payment_id, deadline),
foreign key (payment_id) references payment(payment_id)
);