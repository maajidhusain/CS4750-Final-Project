CREATE TABLE Athlete(
    athlete_id INT(50)  NOT NULL  AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    grad_year INT(4) NOT NULL,
    height INT(3) NOT NULL,
    ath_weight INT(3) NOT NULL,
    class VARCHAR(50) NOT NULL,
    boat_side VARCHAR(1) NOT NULL CHECK (boat_side="S" OR boat_side="P" OR boat_side="s" OR boat_side="p"),
    twoKPR INT(100) CHECK (twoKPR > 300),
    g8 INT(50) AS (twoKPR / ath_weight),
    age INT(50) AS (DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),DATE_OF_BIRTH)), '%Y')+0),
    PRIMARY KEY (athlete_id)
);

CREATE TABLE Coach(
    coach_id INT(50) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    PRIMARY KEY (coach_id) 
);

CREATE TABLE ExtraWork(
    athlete_id INT(50) NOT NULL,
    workout_id INT(50),
    mins INT(3) NOT NULL,
    dte DATE NOT NULL,
    workout_type VARCHAR(50) NOT NULL,
    descr VARCHAR(500) NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (athlete_id, workout_id)
);

CREATE TABLE Boats(
    boat_name VARCHAR(50) NOT NULL,
    num_seats INT(1) NOT NULL,
    PRIMARY KEY (boat_name)
);

CREATE TABLE Single(
    boat_name VARCHAR(50),
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    one_seat INT(50),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name),
    FOREIGN KEY (one_seat) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (boat_name)
);

CREATE TABLE TwoMan(
    boat_name VARCHAR(50) NOT NULL,
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    one_seat INT(50),
    two_seat INT(50),
    PRIMARY KEY (boat_name),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name),
    FOREIGN KEY (one_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(athlete_id)
);

CREATE TABLE FourMan(
    boat_name VARCHAR(50) NOT NULL,
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    coxswain INT(50),
    one_seat INT(50),
    two_seat INT(50),
    three_seat INT(50),
    four_seat INT(50),
    PRIMARY KEY (boat_name),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name),
    FOREIGN KEY (coxswain) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (one_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (three_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (four_seat) REFERENCES Athlete(athlete_id)
);

CREATE TABLE EightMan(
    boat_name VARCHAR(50),
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    coxswain INT(50),
    one_seat INT(50),
    two_seat INT(50),
    three_seat INT(50),
    four_seat INT(50),
    five_seat INT(50),
    six_seat INT(50),
    seven_seat INT(50),
    eight_seat INT(50),
    PRIMARY KEY (boat_name),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name),
    FOREIGN KEY (coxswain) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (one_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (three_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (four_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (five_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (six_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (seven_seat) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (eight_seat) REFERENCES Athlete(athlete_id)
);

CREATE TABLE DailyWorkout(
    workout_id INT(50) NOT NULL AUTO_INCREMENT,
    descr VARCHAR(500) NOT NULL,
    PRIMARY KEY (workout_id) 
);

CREATE TABLE RowsIn(
    athlete_id VARCHAR(50) NOT NULL,
    boat_name VARCHAR(50),
    PRIMARY KEY (athlete_id),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name)
);

-- created new table for practices
CREATE TABLE Practices(
    practice_id INT(50) NOT NULL AUTO_INCREMENT,
    workout_id INT(50) NOT NULL,
    dte DATE NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES DailyWorkout(workout_id),
    PRIMARY KEY (practice_id) 
);

-- renamed "practices" to this, changed workout_id to practice_id and delted date, also added "attended"
CREATE TABLE Attendance(
    athlete_id INT(50) NOT NULL,
    practice_id INT(50) NOT NULL,
    attended VARCHAR(1) DEFAULT 'Y' NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (athlete_id, practice_id)
);




INSERT INTO Athlete
(athlete_id, first_name, last_name, email, phone_number, date_of_birth, grad_year, height, ath_weight, class, boat_side, twoKPR)
VALUES 
(1, 'Grace', 'Nguyen', 'gracenguyen@yahoo.com', 2345678901, '2002-06-25', 2023, 67, 155, 'Sophomore', 'S', '320'),
(2, 'Ryan', 'Miller', 'ryanmiller@gmail.com', 3456789012, '2001-09-18', 2023, 73, 195, 'Junior', 'P', '420'),
(3, 'Lila', 'Patel', 'lilapatel@hotmail.com', 7890123456, '1999-02-14', 2023, 64, 165, 'Senior', 'S', '360'),
(4, 'Tyler', 'Jones', 'tylerjones@gmail.com', 5678901234, '2000-11-01', 2023, 70, 180, 'Freshman', 'P', '330'),
(5, 'Sophie', 'Kim', 'sophiekim@yahoo.com', 4567890123, '2003-04-08', 2023, 66, 170, 'Sophomore', 'S', '340'),
(6, 'Andrew', 'Martinez', 'andrewmartinez@hotmail.com', 9012345678, '1998-07-09', 2023, 74, 200, 'Junior', 'P', '350'),
(7, 'Isabella', 'Garcia', 'isabellagarcia@gmail.com', 3456789012, '2002-01-01', 2023, 68, 175, 'Freshman', 'S', '310'),
(8, 'Jacob', 'Wilson', 'jacobwilson@yahoo.com', 7890123456, '2001-05-25', 2023, 71, 185, 'Senior', 'P', '460'),
(9, 'Avery', 'Brown', 'averybrown@gmail.com', 5678901234, '2000-08-12', 2023, 65, 170, 'Sophomore', 'S', '450'),
(10,'Ethan', 'Lee', 'ethanlee@hotmail.com', 9012345678, '1999-11-05', 2023, 69, 180, 'Junior', 'P', '330'),
(11, 'Olivia', 'Johnson', 'oliviajohnson@gmail.com', 2345678901, '2002-03-03', 2023, 72, 190, 'Freshman', 'S', '320'),
(12, 'Mason', 'Garcia', 'masongarcia@hotmail.com', 7890123456, '2001-07-22', 2023, 68, 175, 'Senior', 'P', '430'),
(13, 'Sophia', 'Kim', 'sophiakim@yahoo.com', 5678901234, '2003-02-14', 2023, 67, 165, 'Sophomore', 'S', '330'),
(14, 'William', 'Nguyen', 'williamnguyen@gmail.com', 9012345678, '2000-06-07', 2023, 73, 195, 'Junior', 'P', '420'),
(15, 'Katie', 'Smith', 'katie_smith@yahoo.com', 2345678901, '2002-05-11', 2023, 65, 150, 'Sophomore', 'S', '330'),
(16, 'Matthew', 'Garcia', 'matthewgarcia@gmail.com', 3456789012, '2001-08-14', 2023, 72, 190, 'Junior', 'P', '450'),
(17, 'Lauren', 'Nguyen', 'lauren.nguyen@hotmail.com', 7890123456, '1999-03-21', 2023, 67, 165, 'Senior', 'S', '370'),
(18, 'David', 'Kim', 'davidkim@gmail.com', 5678901234, '2000-10-17', 2023, 69, 180, 'Freshman', 'P', '320'),
(19, 'Emily', 'Martinez', 'emilymartinez@yahoo.com', 4567890123, '2003-05-23', 2023, 66, 170, 'Sophomore', 'S', '340'),
(20, 'Daniel', 'Brown', 'daniel_brown@hotmail.com', 9012345678, '1998-08-12', 2023, 73, 195, 'Junior', 'P', '460'),
(21, 'Chloe', 'Wilson', 'chloewilson@gmail.com', 3456789012, '2002-01-01', 2023, 68, 175, 'Freshman', 'S', '310'),
(22, 'Ryan', 'Lee', 'ryanlee@hotmail.com', 7890123456, '2001-04-14', 2023, 71, 185, 'Senior', 'P', '440'),
(23, 'Samantha', 'Johnson', 'samanthajohnson@gmail.com', 5678901234, '2000-09-23', 2023, 65, 170, 'Sophomore', 'S', '420'),
(24, 'Joseph', 'Miller', 'josephmiller@hotmail.com', 9012345678, '1999-12-17', 2023, 69, 180, 'Junior', 'P', '310'),
(25, 'Natalie', 'Garcia', 'nataliegarcia@yahoo.com', 2345678901, '2002-02-08', 2023, 72, 190, 'Freshman', 'S', '350'),
(26, 'Nicholas', 'Nguyen', 'nicholas_nguyen@gmail.com', 7890123456, '2001-06-15', 2023, 68, 175, 'Senior', 'P', '420'),
(27, 'Ava', 'Kim', 'ava_kim@yahoo.com', 5678901234, '2003-01-10', 2023, 67, 165, 'Sophomore', 'S', '340'),
(28, 'Benjamin', 'Smith', 'benjam_smith@gmail.com', 9012345678, '2000-05-07', 2023, 73, 195, 'Junior', 'P', '430')
    ;

INSERT INTO Coach
(coach_id, first_name, last_name, email, phone_number, position)
VALUES
(1, 'Frank', 'Biller', 'frank@virginiarowing.org', 1234567876, 'Head Coach');


INSERT INTO Boats
VALUES
    ('Peoples Eight', 8),
    ('White Rocket II', 8),
    ('Jefferson', 8),
    ('Panda', 4),
    ('Myers', 4),
    ('Kadravits', 4),
    ('Orange Swift', 1),
    ('Blue Swift', 1),
    ('Green Swift', 1),
    ('Orange Swift D', 2),
    ('Blue Swift D', 2),
    ('Green Swift D', 2),
;

INSERT INTO EightMan
VALUES
    ('Peoples Eight', 'red', 'P', 1, 2, 3, 4, 5, 6, 7, 8, 9),
    ('White Rocket II', 'blue', 'p', 6, 7, 8, 9, 10, 11, 12, 13, 14),
    ('Jefferson', NULL, 'P', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
    ;

INSERT INTO FourMan
VALUES
    ('Panda', 'orange', 'S', 15, 16, 17, 18, 19),
    ('Myers', 'orange', 'p', 10, 11, 12, 13, 14),
    ('Kadravits', 'gray', 'S', 19, 20, 21, 22, 23),
;

INSERT INTO TwoMan
VALUES
    ('Orange Swift D', 'skinnys', 'S', 24, 25),
    ('Blue Swift D', NULL, 'S', NULL, NULL),
    ('Green Swift D', NULL, 'S', NULL, NULL),
;

INSERT INTO Single
VALUES
    ('Orange Swift', 'skinnys', 'S', 26),
    ('Blue Swift', NULL, 'S', NULL),
    ('Green Swift', NULL, 'S', NULL),
;

INSERT INTO DailyWorkout
VALUES
(1, "4x20' Z2L with 4' rest"),
(1, "2x30' Z1L with 5' rest")
(2, "5x10' Z4L with 2' rest")
(3, "3x15' Z3L with 3' rest")
(4, "6x5' Z5L with 1' rest")
(5, "4x25' Z2L with 4' rest")
(6, "2x40' Z1L with 6' rest")
(7, "8x3' Z6L with 1' rest")
(8, "5x20' Z3L with 3' rest")
(9, "6x10' Z4L with 2' rest")
(10, "3x30' Z2L with 5' rest")
;

INSERT INTO Practices
VALUES
(1, 1, '2022-03-15'),
(1, 2, '2022-03-16')
(2, 3, '2022-03-17')
(3, 4, '2022-03-18')
(4, 5, '2022-03-19')
(5, 6, '2022-03-20')
(6, 7, '2022-03-21')
(7, 8, '2022-03-22')
(8, 9, '2022-03-23')
(9, 10, '2022-03-24')
(10, 1, '2022-03-25')
;