-- 1-1 ) UserRegister : Register on the website with a unique email along with the needed information. 
--		 Choose which type of user you will be using @usertype (Admin).

CREATE PROCEDURE UserRegister @usertype varchar(20), @userName varchar(20) , @email varchar(50), @first_name varchar(20),
@last_name varchar(20), @birth_date datetime, @password varchar(10) , @user_id INT OUTPUT
AS
BEGIN
	DECLARE @vexists BIT;
	SELECT @vexists = CASE WHEN EXISTS (SELECT * FROM Users WHERE Users.email=@email) THEN 1 ELSE 0 END ;
	IF @vexists = 1 
	BEGIN
		SET @user_id  = -2 ;
	END
	ELSE
	BEGIN
		INSERT INTO Users (f_name,l_name,password,email,type,birthdate) VALUES (@first_name,@last_name,@password,@email,@usertype, @birth_date) ;
		SET @user_id = SCOPE_IDENTITY();
		IF @usertype = 'Admin'
		BEGIN
			INSERT INTO Admin (admin_id) VALUES (@user_id)
		END
		IF @usertype = 'Guest'
		BEGIN
			INSERT INTO Guest (guest_id) VALUES (@user_id)
		END
	END
END;
GO

---------------------------------------------

-- 2-1 ) UserLogin : Login using my email and password. In the event that the user is not registered, the @user_id value will be (-1).

CREATE PROCEDURE UserLogin @email varchar(50), @password varchar(10) ,@success BIT OUTPUT , @user_id INT OUTPUT
AS
BEGIN
	SELECT TOP 1 @user_id = Users.id FROM Users WHERE (email =@email AND password = @password);
	IF @user_id IS NULL
	BEGIN
		SET @success = 0;
	END
	ELSE
	BEGIN
		SET @success = 1;
	END
END;
GO

---------------------------------------------

-- 2-2 ) ViewProfile : View all the details of my profile.

CREATE PROCEDURE ViewProfile @user_id INT 
AS
BEGIN
	SELECT * FROM Users WHERE Users.id = @user_id
END;
GO

---------------------------------------------

--2-3 ) ViewRooms : View the assigned room of each user according to their @user_id ordered according to @age (if there is no value 
--		given for @age then show details of the room that is assigned to @user_id, if @user_id is also empty then show 
--		all the details of the room)



---------------------------------------------

--2-4 )  ViewMyTask : View their task. (You should check if the deadline has passed or not if it passed set the status to done) .

CREATE PROCEDURE ViewMyTask @user_id INT 
AS
BEGIN
	SELECT * FROM Task INNER JOIN Assigned_to ON Task.task_id = Assigned_to.task_id WHERE user_id = @user_id 
	UPDATE Task SET  status = 'done' FROM Task INNER JOIN Assigned_to ON Task.task_id = Assigned_to.task_id WHERE Task.status <> 'done' 
	AND Task.due_date < GETDATE() AND Assigned_to.user_id = @user_id 
END
GO

---------------------------------------------

--2-5 ) FinishMyTask : Finish their task.

CREATE PROCEDURE FinishMyTask @user_id INT, @title VARCHAR(50) 
AS
BEGIN
	UPDATE Task SET  status = 'done' FROM Task INNER JOIN Assigned_to ON Task.creator= Assigned_to.admin_id WHERE Assigned_to.user_id=@user_id 
	AND Task.name = @title
END
GO

---------------------------------------------

--2-6 )  ViewTask : View task status given the @user_id and the @creator of the task. (The recently created reports should be shown first)

CREATE PROCEDURE ViewTask @user_id INT, @creator INT 
AS
BEGIN
	SELECT Task.task_id,creator,priority,name,category,status,creation_date,due_date,reminder_date FROM Task INNER JOIN Assigned_to ON Task.creator = Assigned_to.admin_id 
	WHERE Task.creator = @creator AND Assigned_to.user_id=@user_id  
	ORDER BY Task.creation_date DESC
END
GO

---------------------------------------------

--2-7 ) ViewMyDeviceCharge : View device charge

CREATE PROCEDURE ViewMyDeviceCharge @device_id INT , @charge INT OUTPUT , @location INT OUTPUT
AS
BEGIN
	SELECT @charge = charge FROM Device WHERE device_id = @device_id
	SELECT @location = room FROM Device WHERE device_id = @device_id
END
GO

---------------------------------------------

--2-8 ) BookRoom : Book a room with other users

CREATE PROCEDURE BookRoom @user_id INT , @room_id INT
AS
BEGIN
	DECLARE @prevroom INT;
	DECLARE @residents INT;
	SELECT @prevroom = room FROM Users WHERE id = @user_id
	UPDATE Users SET room = @room_id WHERE id = @user_id
	IF EXISTS (SELECT 1 FROM Room WHERE room_id = @room_id AND status = 'empty')
	BEGIN
		UPDATE Room SET status = 'occupied' WHERE room_id = @room_id
	END
	SELECT @residents = COUNT(room) FROM Users WHERE room=@prevroom 
	IF @prevroom IS NOT NULL AND @residents = 0
	BEGIN
		UPDATE Room SET status = 'empty' WHERE room_id = @prevroom
	END
   
END
GO

---------------------------------------------

--2-9 ) CreateEvent :  Create events on the system

CREATE PROCEDURE CreateEvent @event_id INT, @user_id INT, @name VARCHAR(50), @description VARCHAR(200), @location VARCHAR(40),@reminder_date DATETIME ,@other_user_id INT
AS
BEGIN
	IF @other_user_id IS NULL
	BEGIN
		INSERT INTO Calendar VALUES (@event_id, @user_id, @name, @description, @location,@reminder_date)
	END
	ELSE
	BEGIN
		INSERT INTO Calendar VALUES (@event_id, @user_id, @name, @description, @location,@reminder_date) ,
		(@event_id, @other_user_id, @name, @description, @location,@reminder_date)
	END
END
GO

---------------------------------------------

--2-10 ) AssignUser

CREATE PROCEDURE AssignUser @user_id INT , @event_id INT , @user_assigned INT OUTPUT
AS
BEGIN
	IF EXISTS (
        SELECT *
        FROM Calendar
        WHERE event_id = @event_id 
    )
    BEGIN
    DECLARE @n VARCHAR(50);
    DECLARE @d VARCHAR(200);
    DECLARE @l VARCHAR(40);
    DECLARE @r DATETIME;
    IF NOT EXISTS (SELECT * FROM Calendar WHERE event_id =@event_id AND user_assigned_to = @user_id)
    BEGIN
		SELECT  @n=name, @d=description, @l=location, @r=reminder_date FROM Calendar WHERE event_id = @event_id 
		AND user_assigned_to <> @user_id;
		INSERT INTO Calendar VALUES (@event_id , @user_id,@n,@d,@l,@r);
		SET @user_assigned=@user_id
		SELECT user_assigned_to,name,description,location,reminder_date FROM Calendar WHERE event_id = @event_id AND user_assigned_to =@user_id
	END  
	END    
END
GO

-----------------------------------------------

--2-11 )  AddReminder : Add a reminder to a task

CREATE PROCEDURE AddReminder @task_id INT , @reminder DATETIME 
AS
BEGIN
	UPDATE Task SET reminder_date = @reminder WHERE task_id = @task_id
END
GO

-----------------------------------------------

--2-12 ) Uninvited :  Uninvite a specific user to an event.

CREATE PROCEDURE Uninvited @event_id INT , @user_id INT
AS
BEGIN
	DELETE FROM Calendar  WHERE event_id = @event_id AND user_assigned_to = @user_id 
END
GO

-----------------------------------------------

--2-13 ) UpdateTaskDeadline : Update the deadline of a specific task.

CREATE PROCEDURE UpdateTaskDeadline @deadline DATETIME,@task_id INT
AS
BEGIN
	UPDATE Task SET due_date = @deadline WHERE task_id = @task_id
END
GO

-----------------------------------------------

--2-14 ) ViewEvent :  View their event given the @event_id and if the @event_id is empty then view all events that 
--belong to the user order by their date

CREATE PROCEDURE ViewEvent @user_id INT, @event_id INT
AS
BEGIN
	IF (@event_id IS NULL)
	BEGIN
		SELECT * FROM Calendar WHERE user_assigned_to = @user_id ORDER BY reminder_date ASC
	END
	ELSE
	BEGIN
		SELECT * FROM Calendar WHERE user_assigned_to = @user_id AND event_id = @event_id ORDER BY reminder_date ASC
	END
END
GO

----------------------------------------------

--2-15 ) ViewRecommendation : View users that have no recommendations.

CREATE PROCEDURE ViewRecommendation 
AS
BEGIN
	SELECT name FROM Users WHERE NOT EXISTS (SELECT user_id FROM Recommendation WHERE user_id = Users.id )
END
GO

----------------------------------------------

--2-16 ) CreateNote : Create new note

CREATE PROCEDURE CreateNote @user_id INT , @title VARCHAR(50),@content VARCHAR(200), @creation_date DATETIME 
AS
BEGIN
	INSERT INTO Notes VALUES (@user_id,@content,@creation_date,@title)
END
GO

---------------------------------------------

--2-17 ) RecieveMoney : Receive a transaction

