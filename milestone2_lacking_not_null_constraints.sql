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
phone_number varchar(40), 
primary key ( student_id, phone_number)
);

create table course 
(
course_id int primary key identity(1,1),
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
instructor_id int primary key identity(1,1),
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
semester_code varchar(40),
exam_type varchar(40),
grade varchar(40) Default(NULL),
primary key ( course_id, student_id, semester_code),
foreign key(student_id) references student(student_id),
foreign key(instructor_id) references Instructor(instructor_id),
foreign key(course_id) references course(course_id)
);

create table semester
(
semester_code varchar(40) primary key identity(1,1),
Start_date date,
End_date date
); 

create table course_semester 
(
course_id int ,
semester_code varchar(40) ,
primary key ( course_id, semester_code)
);


create table slot
(
slot_id int primary key identity(1,1), 
day varchar(40),
time varchar(40),
location varchar(40),
course_id int,
instructor_id int,
foreign key(course_id) references course(course_id),
foreign key(instructor_id) references instructor(instructor_id)
);

create table graduation_plan
(
plan_id int identity(1,1),
semester_code varchar(40) ,
semester_credit_hours int,
expected_grad_date date,
expected_grad_semster varchar (40),
advisor_id int,
student_id int,
primary key ( plan_id, semester_code),
foreign key (advisor_id) references advisor(advisor_id),
foreign key (student_id) references student(student_id)
);

create table GradPlan_course
(
plan_id int,
semester_code varchar(40) ,
course_id int ,
primary key ( plan_id, semester_code, course_id),
foreign key (semester_code) references semester(semester_code),
foreign key (course_id) references course(course_id)
);

create table Request
(
request_id int primary key identity(1,1),
type_ varchar(40),
comment Varchar(40),
status_ varchar(40) Default('Pending') check(status_ IN('Pending','Accepted','Rejected')),
credit_hours int,
student_id int ,
advisor_id int,
course_id int,
foreign key (advisor_id) references advisor(advisor_id),
foreign key (student_id) references student(student_id),
foreign key (course_id)  references course(course_id)
);

create table MakeUp_Exam
(
exam_id int primary key identity(1,1),
date datetime,
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
payment_id int primary key identity(1,1),
amount int,
deadline datetime,
n_installments int,
status_ varchar(40) Default('notPaid') check(status_ IN('notPaid','Paid')),
start_date_ datetime,
fund_percentage decimal,
student_id int,
semester_code varchar(40),
foreign key (student_id) references student(student_id),
foreign key (semester_code) references semester(semester_code)
);

create table installments 
(
payment_id int,
deadline datetime,
amount int,
status_ varchar(40) Default('notPaid') check(status_ IN('notPaid','Paid')),
start_date datetime,
primary key (payment_id, deadline),
foreign key (payment_id) references payment(payment_id)
);
GO
EXEC CreateAllTables

GO



CREATE VIEW view_Students AS
SELECT *
FROM student

GO

CREATE VIEW view_Course_prerequisites AS
SELECT *
FROM course LEFT JOIN preqCourse ON course.course_id = preqCourse.course_id

GO
CREATE VIEW Instructors_AssignedCourses AS
SELECT i.*
FROM Instructor i LEFT OUTER JOIN Instructor_course ON Instructor.instructor_id = Instructor_course.instructor_id
GO

CREATE VIEW Student_Payment AS
SELECT *
FROM payment INNER JOIN student ON payment.student_id = student.student_id
GO

CREATE VIEW Courses_Slots_Instructor AS 
SELECT c.course_id,c.name,s.slot_id,s.day,s.time,s.location,Instructor.name
FROM (course c LEFT OUTER JOIN slot s ON course.course_id = slot.course_id) LEFT OUTER JOIN Instructor ON slot.instructor_id = Instructor.instructor_id
GO

CREATE VIEW Courses_MakeupExams AS
SELECT c.name,c.semester,m.*
FROM course c LEFT OUTER JOIN MakeUp_Exam m ON c.course_id = m.course_id
GO

CREATE VIEW Students_Courses_transcript AS
SELECT st.student_id,s.name,c.course_id,c.name,st.exam_type,st.grade,st.semester_code,i.name
FROM ((Student_instructor_Course_Take st INNER JOIN student s ON st.student_id = s.student_id) INNER JOIN course c ON st.course_id = c.course_id) INNER JOIN Instructor i ON st.instructor_id = i.instructor_id
GO

CREATE VIEW Semster_offered_Courses AS
SELECT c.course_id,c.course_id,c.semester
FROM cource c
GO

CREATE VIEW Advisors_Graduation_Plan AS
SELECT g.*,a.advisor_id,a.name
FROM graduation_plan g LEFT OUTER JOIN advisor a ON g.advisor_id = a.advisor_id


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
Set identity_insert semester OFF;
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
Set identity_insert semester ON;
insert into slot(Instructor_Id, course_Id, slot_ID)
values(@InstructorId , @courseId , @slotID )
Set identity_insert semester OFF;
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

CREATE VIEW all_Pending_Requests AS
SELECT r.*,s.name,a.name
FROM (Request r LEFT OUTER JOIN student s ON r.student_id = s.student_id) LEFT OUTER JOIN advisor a ON r.advisor_id = a.advisor_id
GO

GO
CREATE PROCEDURE Procedures_AdvisorCreateGP
@semester_code varchar(40),
@expected_graduation_date date,
@sem_credit_hours int,
@advisor_id int,
@student_id int
AS
insert into graduation_plan(semester_code,semester_credit_hours,expected_grad_date,advisor_id,student_id)
VALUES(@semester_code,@sem_credit_hours,@expected_graduation_date,@advisor_id,@student_id)
GO

GO
CREATE PROCEDURE Procedures_AdvisorAddCourseGP
 @student_id int, 
 @Semester_code varchar (40), 
 @course_name varchar (40)
 AS
 DECLARE @p_id int
 DECLARE @c_id int
 SELECT @p_id = plan_id 
 FROM graduation_plan
 WHERE (student_id = @student_id) AND (semester_code = @Semester_code);
 SELECT @c_id = course_id
 FROM course
 WHERE name = @course_name;
 INSERT INTO GradPlan_course
 VALUES(@p_id,@Semester_code,@c_id)
 GO

GO
CREATE PROCEDURE Procedures_AdvisorUpdateGP
@expected_grad_semster varchar(40),
@studentID int
AS
    UPDATE graduation_plan
    SET expected_grad_semster = @expected_grad_semster
    WHERE student_id = @studentID;
GO

GO
CREATE PROCEDURE Procedures_AdvisorDeleteFromGP
@studentID int, 
@semester_code varchar(40),
@course_ID int
AS
DECLARE @p_id int
SELECT @p_id = plan_id 
FROM graduation_plan
WHERE (student_id = @student_id) AND (semester_code = @Semester_code);

DELETE FROM GradPlan_course
WHERE (plan_id = @p_id) AND (semester_code = @semester_code) AND (course_id = @course_ID)
GO


GO
CREATE PROCEDURE Procedures_AdvisorViewAssignedStudents
@AdvisorID int,
@major varchar(40)
AS
SELECT s.*
FROM advisor a INNER JOIN student s ON a.advisor_id = s.advisor_id
WHERE (a.advisor_id = @AdvisorID) AND (s.major = @major)
GO


GO
CREATE PROCEDURE Procedures_AdvisorViewPendingRequests
@AdvisorID int
AS
SELECT R.*
FROM Request R
WHERE R.advisor_id = @AdvisorID
GO

GO
CREATE PROCEDURE Procedures_StudentaddMobile
 @StudentID int, 
 @mobile_number varchar (40)
 AS
 INSERT INTO student_phone
 values(@StudentID,@mobile_number)
GO


GO
CREATE FUNCTION FN_AdvisorLogin
(
    @ID INT,
    @password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT = 0; 
    IF EXISTS (SELECT 1 FROM advisor WHERE advisor_id = @ID AND password_ = @password)
    BEGIN
        SET @Success = 1;
    END
    RETURN @Success;
END;

GO
CREATE FUNCTION FN_Advisors_Requests
(
    @advisorID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        RequestID,
        Type_ AS RequestType,
        Comment,
        Status_,
        Credit_Hours,
        Student_ID,
        Advisor_ID,
        Course_ID
    FROM
        Request
    WHERE
        Advisor_ID = @advisorID
);



GO
CREATE PROCEDURE Procedures_AdvisorApproveRejectCourseRequest
(
    @RequestID INT,
    @StudentID INT,
    @AdvisorID INT
)
AS
    DECLARE @Status VARCHAR(10);
    DECLARE @AssignedHours INT;
    DECLARE @PrerequisitesTaken BIT;

    IF NOT EXISTS (SELECT 1 FROM student WHERE student_id = @StudentID AND advisor_id = @AdvisorID)
    BEGIN
       
        RETURN;
    END


    SELECT
        @Status = Status_,
        @AssignedHours = Assigned_Hours
    FROM
        Request
    WHERE
        RequestID = @RequestID;

 
    IF @Status <> 'Pending'
    BEGIN
  
        RETURN;
    END

    SET @PrerequisitesTaken = dbo.CheckPrerequisitesTaken(@RequestID);

    IF @AssignedHours < dbo.GetCourseCreditHours(@RequestID)
    BEGIN
        
        RETURN;
    END


    IF @PrerequisitesTaken = 1
    BEGIN
        UPDATE Request
        SET Status_ = 'Accepted'
        WHERE RequestID = @RequestID;
    END
    ELSE
    BEGIN
        UPDATE Request
        SET Status_ = 'Rejected'
        WHERE RequestID = @RequestID;
    END
GO



CREATE FUNCTION FN_StudentLogin
(
    @StudentID INT,
    @Password VARCHAR(40)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Success BIT = 0;

   
    IF EXISTS (SELECT 1 FROM student WHERE student_id = @StudentID AND password_ = @Password)
    BEGIN
        SET @Success = 1; 
    END

    RETURN @Success;
END;



GO
CREATE FUNCTION FN_SemsterAvailableCourses
(
    @semester_code VARCHAR(40)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        C.course_id,
        C.name AS course_name,
        C.major,
        C.credit_hours,
        I.name AS instructor_name,
        S.slot_id,
        S.day,
        S.time,
        S.location
    FROM
        course C
    INNER JOIN
        course_semester CS ON C.course_id = CS.course_id
    INNER JOIN
        slot S ON C.course_id = S.course_id
    LEFT JOIN
        Instructor_course IC ON C.course_id = IC.course_id
    LEFT JOIN
        Instructor I ON IC.instructor_id = I.instructor_id
    WHERE
        CS.semester_code = @semester_code
        AND C.is_offered = 1
);


GO
CREATE PROCEDURE Procedures_StudentSendingCourseRequest
(
    @StudentID INT,
    @CourseID INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
)
AS
    DECLARE @AdvisorID INT;
    SELECT @AdvisorID = advisor_id
    FROM student
    WHERE student_id = @StudentID;
    INSERT INTO Request (type_, comment, status_, credit_hours, student_id, advisor_id, course_id)
    VALUES (@Type, @Comment, 'Pending', dbo.GetCourseCreditHours(@CourseID), @StudentID, @AdvisorID, @CourseID);
GO


CREATE PROCEDURE Procedures_StudentSendingCHRequest
(
    @StudentID INT,
    @CreditHours INT,
    @Type VARCHAR(40),
    @Comment VARCHAR(40)
)
AS
    DECLARE @AdvisorID INT;
    SELECT @AdvisorID = advisor_id
    FROM student
    WHERE student_id = @StudentID;
    INSERT INTO Request (type_, comment, status_, credit_hours, student_id, advisor_id)
    VALUES (@Type, @Comment, 'Pending', @CreditHours, @StudentID, @AdvisorID);
GO

CREATE FUNCTION FN_StudentViewGP
(
    @StudentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.student_id AS Student_ID,
        S.f_name + ' ' + S.l_name AS Student_Name,
        GP.plan_id AS Graduation_Plan_ID,
        GC.course_id AS Course_ID,
        C.name AS Course_Name,
        GC.semester_code AS Semester_Code,
        GP.expected_grad_smester AS Expected_Graduation_Date,
        GP.semester_credit_hours AS Semester_Credit_Hours,
        GP.advisor_id AS Advisor_ID
    FROM
        student S
    INNER JOIN
        graduation_plan GP ON S.student_id = GP.student_id
    INNER JOIN
        GradPlan_course GC ON GP.plan_id = GC.plan_id
    INNER JOIN
        course C ON GC.course_id = C.course_id
    WHERE
        S.student_id = @StudentID
);


GO
CREATE FUNCTION FN_StudentUpcomingInstallment
(
    @StudentID INT
)
RETURNS DATE
AS
BEGIN
    DECLARE @UpcomingInstallmentDeadline DATE;

    -- Find the first not paid installment deadline for the student
    SELECT TOP 1
        @UpcomingInstallmentDeadline = I.deadline
    FROM
        payment P
    INNER JOIN
        installments I ON P.payment_id = I.payment_id
    WHERE
        P.student_id = @StudentID
        AND I.status_ = 'notPaid'
    ORDER BY
        I.deadline;

    RETURN @UpcomingInstallmentDeadline;
END;


GO
CREATE FUNCTION FN_StudentViewSlot
(
    @CourseID INT,
    @InstructorID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        S.slot_id AS Slot_ID,
        S.location,
        S.time,
        S.day,
        C.name AS Course_Name,
        I.name AS Instructor_Name
    FROM
        slot S
    INNER JOIN
        course C ON S.course_id = C.course_id
    INNER JOIN
        Instructor_course IC ON S.course_id = IC.course_id
    INNER JOIN
        Instructor I ON IC.instructor_id = I.instructor_id
    WHERE
        S.course_id = @CourseID
        AND I.instructor_id = @InstructorID
);



GO
CREATE PROCEDURE Procedures_ViewRequiredCourses
    @StudentID INT,
    @CurrentSemesterCode VARCHAR(40)
AS
SELECT C.*
FROM (GradPlan_course L INNER JOIN graduation_plan G ON L.plan_id = G.plan_id) INNER JOIN course C ON C.course_id = L.course_id
WHERE G.student_id = @StudentID
GO


GO
CREATE PROCEDURE Procedures_StudentRegisterFirstMakeup @StudentID INT, @CourseID INT, @studentCurrentSemester VARCHAR(40)
AS
BEGIN
--    IF NOT EXISTS (SELECT * FROM MakeUp_Exam me INNER JOIN exam_student es ON me.exam_id = es.exam_id WHERE es.student_id = @StudentID AND es.student_id = @courseID)
    IF NOT EXISTS (SELECT * FROM MakeUp_Exam me INNER JOIN exam_student es ON me.exam_id = es.exam_id WHERE me.TYPE = 'First_Makeup' AND me.student_id = @StudentID AND me.course_id = @CourseID)
    BEGIN
	    DECLARE @makeup_id INT;
	    SELECT @makeup_id = me.exam_id FROM MakeUP_Exam me INNER JOIN exam_student es ON me.exam_id = es.exam_id;

	   	INSERT INTO exam_student (exam_id, student_id, course_id)
	   	VALUES(@makeup_id, @StudentID, @CourseID);
    END
END

-- GO
-- CREATE FUNCTION FN_StudentCheckSMEligiability
-- (
-- 	@CourseID INT,
-- 	@StudentID INT
-- )
-- RETURN BIT
-- AS
-- 	BEGIN
		
-- 	END
GO

GO
CREATE PROCEDURE Procedures_ViewMS
@Student_ID int
AS
SELECT c.*
FROM course c
WHERE S.student_id = @Student_ID AND NOT EXISTS(
SELECT c.*
FROM
Student_instructor_Course_Take S INNER JOIN course C1 ON S.course_id = C1.course_id)
GO

GO
CREATE PROCEDURE Procedures_ChooseInstructor
@Student_ID int, 
@Instructor_ID int, 
@Course_ID int
AS
UPDATE Instructor_course
SET instructor_id = @Instructor_ID
WHERE @Course_ID = course_id;
UPDATE Student_instructor_Course_Take
SET instructor_id = @Instructor_ID
WHERE @Course_ID = course_id AND @Student_ID = student_id; 
GO
