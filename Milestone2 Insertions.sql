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