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

CREATE PROCEDURE ViewRooms @user_id INT
AS
BEGIN
	IF (@user_id IS NOT NULL )
	BEGIN
		SELECT Users.id,Users.f_name,Users.l_name,Room.* FROM Room INNER JOIN Users ON room_id = room WHERE id = @user_id 
	END 
	ELSE 
	BEGIN
		SELECT Users.id,Users.f_name,Users.l_name,Room.* FROM Room INNER JOIN Users ON room_id = room ORDER BY age DESC
	END
END

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

CREATE PROCEDURE ReceiveMoney @sender_id INT , @type VARCHAR(30), @amount DECIMAL(13,2), @status VARCHAR(10), @date DATETIME
AS
BEGIN
	INSERT INTO Finance (user_id,type,amount,status,date) 
	VALUES (@sender_id,@type,@amount,@status,@date)
END


--------------------------------------------

--2-18 ) PlanPayment : Crate a payment on a specific date

CREATE PROCEDURE PlanPayment @sender_id INT ,@receiver_id INT, @type VARCHAR(30), @amount DECIMAL(13,2), @status VARCHAR(10), @deadline DATETIME
AS
BEGIN
	INSERT INTO Finance (user_id,type,amount,status,receiver_id,deadline) 
	VALUES (@sender_id,@type,@amount,@status,@receiver_id,@deadline)
END

--------------------------------------------

--2-19 ) SendMessage : Send message to user

CREATE PROCEDURE SendMessage @sender_id INT ,@receiver_id INT, @title VARCHAR(30),@content VARCHAR(200), @timesent DATETIME ,@timereceived DATETIME
AS
BEGIN
	INSERT INTO Communication 
	VALUES (@sender_id,@receiver_id ,@content,@timesent,@timereceived,NULL,@title)
END

-------------------------------------------

--2-20 ) NoteTitle : Change note title for all notes user created

CREATE PROCEDURE NoteTitle @user_id INT, @note_title VARCHAR(50)
AS
BEGIN
	UPDATE Notes SET title = @note_title WHERE user_id = @user_id	
END

-------------------------------------------

--2-21 ) ShowMessages : Show all messages received from a specific user

CREATE PROCEDURE ShowMessages @user_id INT, @sender_id INT
AS
BEGIN
	SELECT * FROM Communication WHERE receiver_id = @user_id AND sender_id = @sender_id	
END

-------------------------------------------

--3-1 ) ViewUsers : See details of all users and filter them by @user_type

CREATE PROCEDURE ViewUsers @user_type VARCHAR(20)
AS
BEGIN
	SELECT * FROM Users WHERE  type = @user_type 
END

-------------------------------------------

--3-2 ) RemoveEvent : Remove an event from the system

CREATE PROCEDURE RemoveEvent @event_id INT , @user_id INT
AS
BEGIN
	DELETE FROM Calendar WHERE event_id = @event_id AND user_assigned_to = @user_id 
END

--------------------------------------------

--3-3 ) CreateSchedule : Create schedule for the rooms 

CREATE PROCEDURE CreateSchedule @creator_id INT, @room_id INT, @start_time DATETIME, @end_time DATETIME, @action VARCHAR(20)
AS
BEGIN
	INSERT INTO RoomSchedule VALUES (@creator_id,@action,@room_id,@start_time,@end_time)
END

-------------------------------------------

--3-4 ) GuestRemove : Remove a guest from the system

CREATE PROCEDURE GuestRemove @guest_id INT, @admin_id INT , @number_of_allowed_guests INT OUTPUT
AS
BEGIN
	DECLARE @n TABLE (updatedval INT);
	BEGIN TRANSACTION;
	BEGIN TRY
		DELETE FROM Guest WHERE guest_id = @guest_id AND guest_of = @admin_id
		UPDATE Admin SET no_of_guests_allowed = no_of_guests_allowed-1 
		OUTPUT INSERTED.no_of_guests_allowed INTO @n WHERE admin_id = @admin_id
		SELECT @number_of_allowed_guests = updatedval FROM @n 
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		PRINT ERROR_MESSAGE()
	END CATCH
END

--------------------------------------------

--3-5 ) RecommendTD :  Recommend travel destinations for guests under certain age



--------------------------------------------


--3-6 ) Survailance : Access cameras in the house



---------------------------------------------

--3-7 ) RoomAvailability : Change status of a room

CREATE PROCEDURE RoomAvailability @location INT, @status VARCHAR(40) 
AS
BEGIN
	UPDATE Room SET status = @status WHERE room_id = @location
END

---------------------------------------------

--3-8 ) AddInventory : Create an inventory gor a specific item

CREATE PROCEDURE AddInventory @item_id INT ,@name VARCHAR(30), @quantity INT, @expirydate DATETIME, @price DECIMAL(10,2),
@manufacturer VARCHAR(30),@category VARCHAR(20)
AS
BEGIN
	INSERT INTO Inventory VALUES (@item_id,@name, @quantity, @expirydate, @price,@manufacturer ,@category)
END

---------------------------------------------

--3-9 ) Shopping : Calculate price of purchasing a certain item 

CREATE PROCEDURE Shopping @id INT , @quantity INT,@total_price DECIMAL(10,2) OUTPUT
AS
BEGIN
	SELECT @total_price = @quantity*price FROM Inventory WHERE supply_id = @id 
END

---------------------------------------------

--3-10 ) LogActivityDuration : set duration of a current user activity

CREATE PROCEDURE LogActivityDuration @room_id INT, @device_id INT , @user_id INT , @date DATETIME
AS
BEGIN
	UPDATE Log SET duration = 1.0 WHERE room_id=@room_id AND device_id=@device_id AND user_id=@user_id AND date = @date AND activity IS NOT NULL
END

---------------------------------------------

--3-11 ) TabletConsumption :  Set device consumption for all tablets

CREATE PROCEDURE TabletConsumption @consumption INT
AS
BEGIN
	UPDATE Consumption SET consumption = @consumption FROM Consumption INNER JOIN Device ON Device.device_id = Consumption.device_id WHERE Device.type= 'Tablet' OR Device.type = 'tablet'
END

--------------------------------------------

--3-12 ) MakeRoomPreferencesTemp : Make preferences for Room temperature to be 30 if a user is older then 40

CREATE PROCEDURE MakePreferncesRoomTemp @user_id INT , @category VARCHAR(20) , @preferences_number INT
AS
BEGIN
	INSERT INTO Preferences (user_id,category,preference_no,content) 
	SELECT id,@category,@preferences_number,'Set room temp = 30 if user is older than 40 years old' FROM Users WHERE age > 40 AND id = @user_id
END

--------------------------------------------

--3-13 ) ViewMyLogEntry = View Log entries involving the user

CREATE PROCEDURE ViewMyLogEntry @user_id INT 
AS
BEGIN
	SELECT * FROM Log WHERE user_id = @user_id
END

--------------------------------------------

--3-14 ) UpdateMyLogEntry = Update Log entries involving the user

CREATE PROCEDURE UpdateMyLogEntry @user_id INT , @room_id INT, @device_id INT,@activity VARCHAR(30)
AS
BEGIN
	UPDATE Log SET room_id=@room_id,device_id=@device_id,activity= @activity WHERE user_id = @user_id
END

--------------------------------------------

--3-15 ) ViewRoom : View rooms that are not being used 

CREATE PROCEDURE ViewRoom 
AS
BEGIN
	SELECT * FROM Room WHERE status = 'empty'
END

--------------------------------------------

--3-16 ) ViewMeeting :  View the details of the booked rooms given @user_id and @room_id . (If @room_id is not booked
--then show all rooms that are booked by this user).

CREATE PROCEDURE ViewMeeting @room_id INT,@user_id INT 
AS
BEGIN
	IF EXISTS (
        SELECT * 
        FROM RoomSchedule 
        WHERE creator_id = @user_id AND room = @room_id 
    )
    BEGIN
        SELECT * FROM RoomSchedule WHERE creator_id = @user_id AND room = @room_id 
    END
    ELSE
    BEGIN
        SELECT * FROM RoomSchedule WHERE creator_id = @user_id
    END
END

---------------------------------------------

--3-17 ) AdminAddTask : Add to the tasks

CREATE PROCEDURE AdminAddTask @user_id INT , @creator INT ,@name VARCHAR(30), @category VARCHAR(20), @priority INT,
@status VARCHAR(20), @reminder DATETIME , @deadline DATETIME , @other_user VARCHAR(20)
AS
BEGIN
	DECLARE @task INT;
	BEGIN TRANSACTION;
	BEGIN TRY
		INSERT INTO Task VALUES (@name,GETDATE(),@deadline,@category,@creator,@status,@reminder,@priority)
		SET @task = SCOPE_IDENTITY();
		INSERT INTO Assigned_to VALUES (@creator,@task,@user_id)
		IF (@other_user IS NOT NULL)
		BEGIN 
			INSERT INTO Assigned_to VALUES (@creator,@task,@other_user)
		END
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	END CATCH
END

----------------------------------------------

--3-18 ) AddGuest : Add Guests to the system , generate passwords for them and reserve rooms under their name

CREATE PROCEDURE AddGuest @email VARCHAR(30),@first_name VARCHAR(10),@address VARCHAR(30),@password VARCHAR(30),@guest_of INT , @room_id INT
AS
BEGIN
	DECLARE @lastguest INT;
	BEGIN TRANSACTION;
	BEGIN TRY
		INSERT INTO Users (f_name,password,email,room,type) VALUES (@first_name,@password,@email,@room_id,'guest')
		SET @lastguest = SCOPE_IDENTITY();
		INSERT INTO Guest VALUES (@lastguest,@guest_of,@address,NULL,NULL)
		UPDATE Admin SET no_of_guests_allowed = no_of_guests_allowed+1 WHERE admin_id=@guest_of
		UPDATE Room SET status = 'occupied' WHERE room_id = @room_id
		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
	END CATCH
END

---------------------------------------------

--3-19 ) AssignTask : Assign Task to a specific User

CREATE PROCEDURE AssignTask @user_id INT , @task_id INT , @creator_id INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM Task WHERE task_id = @task_id AND creator = @creator_id )
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM Assigned_to WHERE user_id = @user_id AND task_id = @task_id AND admin_id = @creator_id)
		BEGIN
			INSERT INTO Assigned_to VALUES (@creator_id,@task_id,@user_id)
		END		
	END
END

-----------------------------------------------

--3-20 ) DeleteMsg : Delete Last message sent

CREATE PROCEDURE DeleteMsg
AS
BEGIN
	DELETE FROM Communication WHERE time_sent=(SELECT MAX(time_sent) FROM Communication )
END

-----------------------------------------------

--3-21 ) AddItinerary : Add outgoing flight itinerary for a specific flight.

CREATE PROCEDURE AddItinerary @trip_no INT,@flight_num INT ,@flight_date DATETIME ,@destination VARCHAR(40)
AS
BEGIN
	UPDATE Travel SET outgoing_flight_num=@flight_num , outgoing_flight_date = @flight_date , destination = @destination WHERE trip_no = @trip_no
END

-----------------------------------------------

--3-22 ) ChangeFlight : Change flight date to next year for all flights in current year 

CREATE PROCEDURE ChangeFlight
AS
BEGIN
	UPDATE Travel SET ingoing_flight_date = DATEADD(YEAR,1,ingoing_flight_date) WHERE YEAR(ingoing_flight_date) = YEAR(GETDATE())
	UPDATE Travel SET outgoing_flight_date = DATEADD(YEAR,1,outgoing_flight_date) WHERE YEAR(outgoing_flight_date) = YEAR(GETDATE())
END

----------------------------------------------

--3-23 ) UpdateFlight : Update incoming flights

CREATE PROCEDURE UpdateFlight @date DATETIME ,@destination VARCHAR(15)
AS
BEGIN
	UPDATE Travel SET ingoing_flight_date = @date  WHERE destination = @destination
END

-----------------------------------------------

--3-24 ) AddDevice : Add a new device

CREATE PROCEDURE AddDevice @device_id INT, @status VARCHAR(20), @battery INT,@location INT, @type VARCHAR(20)
AS
BEGIN
	INSERT INTO Device (device_id,room,type,status,charge) VALUES (@device_id,@location,@type,@status,@battery)
END

-----------------------------------------------

--3-25 ) OutOfBattery : Find the location of all devices out of battery

CREATE PROCEDURE OutOfBattery
AS
BEGIN
	SELECT room FROM Device WHERE battery_status = 'empty'
END

------------------------------------------------

--3-26 ) Charging : Set the status of all device out of battery to charging

CREATE PROCEDURE Charging
AS
BEGIN
	UPDATE Device SET status = 'charging' WHERE battery_status = 'empty'
END

------------------------------------------------

--3-27 ) GuestsAllowed : Set the number of allowed guests for an admin

CREATE PROCEDURE GuestsAllowed @admin_id INT , @number_of_guests INT
AS
BEGIN
	UPDATE Admin SET no_of_guests_allowed = @number_of_guests WHERE admin_id = @admin_id
END

-------------------------------------------------

--3-28 ) Penalize : Add a penalty for all unpaid transactions where the deadline has passed

CREATE PROCEDURE Penalize @penalty_amount DECIMAL(13,2)
AS
BEGIN
	UPDATE Finance SET penalty = @penalty_amount WHERE status <> 'done' AND deadline < GETDATE() 
END

------------------------------------------------

--3-29 ) GuestNumber : Get the number of all guests currently present for a certain admin 

CREATE PROCEDURE GuestNumber @admin_id INT
AS
BEGIN
	SELECT COUNT(*) FROM Guest WHERE guest_of = @admin_id
END

------------------------------------------------

--3-30 ) Youngest : Get the youngest user in the system 

CREATE PROCEDURE Youngest
AS
BEGIN
	SELECT TOP 1 * FROM Users ORDER BY birthdate DESC
END

------------------------------------------------

--3-31 AveragePayment : Get the users whose average income per month is greater then a specific amount.

CREATE PROCEDURE AveragePayment @amount DECIMAL(10,2)
AS
BEGIN
	SELECT f_name, l_name FROM Users INNER JOIN Admin ON id = admin_id WHERE salary > @amount
END

-----------------------------------------------

--3-32 ) Purchase : Get the sum of all purchases needed in the home inventory 

CREATE PROCEDURE Purchase
AS
BEGIN
	SELECT SUM(price) FROM Inventory WHERE quantity < 1 
END

-----------------------------------------------

--3-33 ) NeedCharge : Get the location where more than two devices have a dead battery