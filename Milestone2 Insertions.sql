INSERT INTO Room VALUES ('bedroom',2,'empty');
INSERT INTO Room VALUES ('bedroom',3,'occupied');
INSERT INTO Room VALUES ('bedroom',1,'occupied');
INSERT INTO Room VALUES ('bedroom',3,'empty');
INSERT INTO Room VALUES ('bedroom',2,'occupied');
INSERT INTO Room VALUES ('living room',0,'empty');
INSERT INTO Room VALUES ('kitchen',1,'occupied');
INSERT INTO Room VALUES ('garden',0,'empty');

INSERT INTO Users VALUES ('Magda','Sleem','12E_rT=JK','sleemmag124@gmail.com',3,'Admin','07-14-2001');
INSERT INTO Users VALUES ('Noha','Fawzy','Um/nnud189','nfawzy1992@gmail.com',7,'Admin','09-08-1992');
INSERT INTO Users VALUES ('Sleem','Shafeey','reT09=im23','shafeey.sleem192@gmail.com',2,'Admin','01-30-1986');
INSERT INTO Users VALUES ('Rasha','Adham','te4Un77-Fx','r_adham12@gmail.com',5,'Admin','04-17-2001');
INSERT INTO Users VALUES ('Mahmoud','Ezzat','1iop._23Rt','mahmodezt22@gmail.com',2,'Admin','02-08-1992');
INSERT INTO Admin (admin_id) VALUES (1);
INSERT INTO Admin (admin_id) VALUES (2);
INSERT INTO Admin (admin_id) VALUES (3);
INSERT INTO Admin (admin_id) VALUES (4);
INSERT INTO Admin (admin_id) VALUES (5);

INSERT INTO Users VALUES ('Salma','Ayman','oPP0~gm22','salma_ayaman15@gmail.com',3,'Guest','11-24-1998');
INSERT INTO Users VALUES ('Magdy','Elsayed','mUb)dd_21','magdymls@gmail.com',7,'Guest','04-08-2000');
INSERT INTO Users VALUES ('Marwa','Roshdy','reT*g/im23','m.roshdii124@gmail.com',2,'Guest','01-19-1995');
INSERT INTO Users VALUES ('Ahmed','Fathy','tg8&dl_x','afathy2000@gmail.com',5,'Guest','07-12-2000');
INSERT INTO Users VALUES ('Ashraf','ElMeligy','3_rttY&i*_P','ashrafmeligy97@gmail.com',2,'Guest','02-08-1997');
INSERT INTO Guest (guest_id) VALUES (6);
INSERT INTO Guest (guest_id) VALUES (7);
INSERT INTO Guest (guest_id) VALUES (8);
INSERT INTO Guest(guest_id) VALUES (9);
INSERT INTO Guest (guest_id) VALUES (10);

INSERT INTO Device VALUES (7,'microwave','off','no battery');
INSERT INTO Device VALUES (7,'fridge','on','AC');
INSERT INTO Device VALUES (2,'Emergency Light','off','charging');
INSERT INTO Device VALUES (3,'Television','on','AC');
INSERT INTO Device VALUES (6,'Virtual Assistant','off','full');

INSERT INTO Calendar VALUES (1,5,'birthday','Noha Birthday 24-10','Calypso Café','11-24-2023');
INSERT INTO Calendar VALUES (2,8,'meeting','New Project meeting','Meeting Room 124','09-15-2023');

INSERT INTO Task VALUES ('data entry','11-14-2023','11-16-2023','work',4,'pending',NULL,1);
INSERT INTO Task VALUES ('start campaign','09-21-2023','10-02-2023','work',2,'in progress',NULL,3);
INSERT INTO Task VALUES ('paint rooms','12-19-2023','12-24-2023','diy',5,'pending',NULL,1);

INSERT INTO Notes (user_id, content, creation_date, title) VALUES
( 10, 'Discuss plans for the team vacation.', '2024-01-04 05:49:28.210', 'Vacation Planning'),
( 9, 'Set personal goals for the month.', '2024-01-04 05:49:28.210', 'Personal Goals'),
( 8, 'Analyze feedback from recent customer interactions.', '2024-01-04 05:49:28.210', 'Customer Feedback'),
( 7, 'Check and review the recent code changes.', '2024-01-04 05:49:28.210', 'Code Review'),
( 6, 'Prepare materials for the upcoming training session.', '2024-01-04 05:49:28.210', 'Training Session'),
( 5, 'Overview of project milestones.', '2024-01-04 05:49:28.210', 'Project Update'),
( 4, 'Discuss marketing strategies for the new product.', '2024-01-04 05:49:28.210', 'Product Launch'),
( 3, 'Complete the task by EOD.', '2024-01-04 05:49:28.210', 'Daily Reminder'),
( 3, 'lorem ipsum dolor set amit', '2018-03-25 00:00:00.000', 'study physics'),
( 2, 'Plan team-building activities.', '2024-01-04 05:49:28.210', 'Team Building'),
( 1, 'Provide updates on the ongoing project.', '2024-01-04 05:49:28.210', 'Project Status'),
( 1, 'Discussion about upcoming projects.', '2024-01-04 05:49:28.210', 'Meeting Notes');

INSERT INTO Communication VALUES
(3, 6, 'Hey Alice, hows it going?', '2024-02-18 10:30:15.000', '2024-02-18 10:31:20.000', NULL, 'Casual Greeting'),
(7, 4, 'Hi Bob, any updates on the project?', '2024-02-18 12:45:30.000', '2024-02-18 12:46:22.000', NULL, 'Project Inquiry'),
(1, 9, 'Good morning Emily! Ready for the meeting?', '2024-02-18 08:00:00.000', '2024-02-18 08:01:05.000', NULL, 'Meeting Reminder'),
(2, 8, 'Hello David, just wanted to say hi!', '2024-02-18 15:20:45.000', '2024-02-18 15:21:30.000', NULL, 'Friendly Message'),
(5, 10, 'Greetings Samantha! Hows your day so far?', '2024-02-18 18:12:10.000', '2024-02-18 18:13:05.000', NULL, 'Daily Check-in'),
(6, 1, 'Hey Michael, got any weekend plans?', '2024-02-18 09:40:00.000', '2024-02-18 09:41:15.000', NULL, 'Weekend Discussion'),
(4, 3, 'Hi Olivia, quick question about the upcoming event.', '2024-02-18 14:05:20.000', '2024-02-18 14:06:10.000', NULL, 'Event Inquiry'),
(8, 5, 'Morning James! Dont forget the deadline is approaching.', '2024-02-18 11:55:00.000', '2024-02-18 11:56:30.000', NULL, 'Deadline Reminder'),
(10, 7, 'Hello Chloe, need your input on the latest report.', '2024-02-18 16:30:45.000', '2024-02-18 16:31:40.000', NULL, 'Report Feedback'),
(9, 2, 'Hi John, received your message. Lets catch up later.', '2024-02-18 22:10:08.000', '2024-02-18 22:10:10.000', NULL, 'Acknowledgment');

