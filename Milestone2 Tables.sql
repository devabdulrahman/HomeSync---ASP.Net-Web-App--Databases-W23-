CREATE TABLE Room (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    type VARCHAR(30),
    floor INT,
    status VARCHAR(30)
 );


CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
	f_name VARCHAR(20) NOT NULL,
	l_name VARCHAR(20) NOT NULL,
	password VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL,
	room INT,
    type VARCHAR(6),
    birthdate DATETIME NOT NULL,
    age AS DATEDIFF(YEAR,birthdate,GETDATE()) ,
	FOREIGN KEY (room) REFERENCES Room(room_id)
  );

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
	no_of_guests_allowed INT,
	salary INT,
	FOREIGN KEY (admin_id) REFERENCES Users(id)
  );


CREATE TABLE Guest (
    guest_id INT PRIMARY KEY,
	guest_of INT ,
	address VARCHAR(200),
	arrival_date DATETIME,
	departure_date DATETIME,
	FOREIGN KEY (guest_id) REFERENCES Users(id),
	FOREIGN KEY (guest_of) REFERENCES Users(id)
  );

CREATE TABLE Task (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	creation_date DATETIME NOT NULL,
	due_date DATETIME NOT NULL,
	category VARCHAR(20) NOT NULL,
	creator INT NOT NULL,
	status VARCHAR(20) NOT NULL,
	reminder_date DATETIME ,
	priority INT NOT NULL,
	FOREIGN KEY (creator) REFERENCES Admin(admin_id)
);

CREATE TABLE Assigned_to (
	admin_id INT NOT NULL,
	task_id INT NOT NULL,
	user_id INT NOT NULL,
	FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
	FOREIGN KEY (task_id) REFERENCES Task(task_id),
	FOREIGN KEY (user_id) REFERENCES Users(id),
	CONSTRAINT assigned PRIMARY KEY (admin_id,task_id,user_id)
);

CREATE TABLE Calendar (
	event_id INT NOT NULL,
	user_assigned_to INT NOT NULL,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(200) NOT NULL,
	location VARCHAR(40) NOT NULL,
	reminder_date DATETIME NOT NULL,
	FOREIGN KEY (user_assigned_to) REFERENCES Users(id),
	CONSTRAINT event PRIMARY KEY (event_id,user_assigned_to)
);

CREATE TABLE Notes (
	id INT IDENTITY (1,1) PRIMARY KEY ,
	user_id INT NOT NULL,
	content VARCHAR(200) NOT NULL,
	creation_date DATETIME NOT NULL,
	title VARCHAR(50) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES Users(id),
);


CREATE TABLE Travel (
	trip_no INT IDENTITY (1,1) PRIMARY KEY ,
	hotel_name VARCHAR (30) NOT NULL,
	destination VARCHAR (30) NOT NULL,
	ingoing_flight_num INT NOT NULL,
	outgoing_flight_num INT NOT NULL,
	ingoing_flight_date DATETIME NOT NULL,
	outgoing_flight_date DATETIME NOT NULL,
	ingoing_flight_airport VARCHAR (30) NOT NULL,
	outgoing_flight_airport VARCHAR (30) NOT NULL,
	transport VARCHAR(30)
);

CREATE TABLE User_trip (
	trip_no INT NOT NULL,
	user_id INT NOT NULL,
	hotel_room_no INT,
	in_going_flight_seat_number INT ,
	out_going_flight_seat_number INT,
	FOREIGN KEY (trip_no) REFERENCES Travel(trip_no),
	FOREIGN KEY (user_id) REFERENCES Users(id),
	CONSTRAINT trip PRIMARY KEY (trip_no,user_id)	
);

CREATE TABLE Finance (
	payment_id INT IDENTITY(1,1) PRIMARY KEY ,
	user_id INT NOT NULL,
	type VARCHAR(30) NOT NULL,
	amount DECIMAL(13,2) NOT NULL,
	currency VARCHAR(10) ,
	method VARCHAR(15) ,
	status VARCHAR(15) NOT NULL,
	date DATETIME ,
	receiver_id INT ,
	deadline DATETIME ,
	penalty DECIMAL(13,2) ,
	FOREIGN KEY (user_id) REFERENCES Users(id),
	FOREIGN KEY (receiver_id) REFERENCES Users(id)
);

CREATE TABLE Health (
	date DATETIME NOT NULL,
	activity VARCHAR(30),
	user_id INT NOT NULL,
	hours_slept DECIMAL(13,2),
	food VARCHAR(100),
	FOREIGN KEY (user_id) REFERENCES Users(id),
	CONSTRAINT healthstate PRIMARY KEY (date,activity)
);

CREATE TABLE Communication (
	message_id INT IDENTITY(1,1) PRIMARY KEY,
	sender_id INT NOT NULL,
	receiver_id INT NOT NULL,
	content VARCHAR(200) NOT NULL,
	time_sent DATETIME NOT NULL,
	time_received DATETIME NOT NULL,
	time_read DATETIME ,
	title VARCHAR(20),
	FOREIGN KEY (sender_id) REFERENCES Users(id),
	FOREIGN KEY (receiver_id) REFERENCES Users(id)
);

CREATE TABLE Device (
	device_id INT IDENTITY(1,1) PRIMARY KEY,
	room INT,
	type VARCHAR(30),
	status VARCHAR(15),
	battery_status VARCHAR(15),
	charge INT,
	FOREIGN KEY (room) REFERENCES Room(room_id)
);

CREATE TABLE RoomSchedule (
	creator_id INT NOT NULL,
	action VARCHAR(30) NOT NULL,
	room INT NOT NULL,
	start_time DATETIME NOT NULL,
	end_time DATETIME NOT NULL,
	FOREIGN KEY (creator_id) REFERENCES Users(id),
	FOREIGN KEY (room) REFERENCES Room(room_id),
	Constraint r_sched PRIMARY KEY (creator_id,start_time)
);

CREATE TABLE Log (
	room_id INT NOT NULL,
	device_id INT NOT NULL,
	user_id INT NOT NULL,
	activity VARCHAR(30) NOT NULL,
	date DATETIME NOT NULL,
	duration DECIMAL (13,2),
	FOREIGN KEY (room_id) REFERENCES Room(room_id),
	FOREIGN KEY (device_id) REFERENCES Device(device_id),
	FOREIGN KEY (user_id) REFERENCES Users(id),
	Constraint roomlog PRIMARY KEY (room_id,device_id,user_id,date)
);

CREATE TABLE Consumption (
	device_id INT NOT NULL,
	consumption INT NOT NULL,
	date DATETIME NOT NULL,
	FOREIGN KEY (device_id) REFERENCES Device(device_id),
	Constraint consumed PRIMARY KEY (device_id,date)
);

CREATE TABLE Preferences (
	user_id INT NOT NULL,
	category VARCHAR(10),
	preference_no INT NOT NULL,
	content VARCHAR(100) NOT NULL,
	FOREIGN KEY (user_id) REFERENCES Users(id),
	Constraint preference PRIMARY KEY (user_id,preference_no)
);

CREATE TABLE Recommendation (
	recommendation_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	category VARCHAR(15),
	preference_no INT ,
	content VARCHAR(100) NOT NULL,
	FOREIGN KEY (user_id,preference_no) REFERENCES Preferences(user_id,preference_no)
);

CREATE TABLE Inventory (
	supply_id INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	quantity INT,
	expiry_date DATETIME ,
	price DECIMAL(13,2),
	manufacturer VARCHAR(20) ,
	category VARCHAR(20) ,
);

CREATE TABLE Camera (
	monitor_id INT PRIMARY KEY,
	camera_id INT IDENTITY(1,1),
	room_id INT ,
	FOREIGN KEY (monitor_id) REFERENCES Users(id),
	FOREIGN KEY (room_id) REFERENCES Room(room_id)
);