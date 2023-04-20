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
    boat_side VARCHAR(1) NOT NULL CHECK (boat_side="S" OR boat_side="P" OR boat_side="s" OR boat_side="p" boat_side="S/P" OR boat_side="s/p"),
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
    workout_num INT(50) NOT NULL,
    mins INT(3) NOT NULL,
    dte DATE NOT NULL,
    workout_type VARCHAR(50) NOT NULL,
    descr VARCHAR(500) NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (athlete_id, workout_num, dte)
);

CREATE TABLE Boats(
    boat_name VARCHAR(50) NOT NULL,
    num_seats INT(1) NOT NULL,
    PRIMARY KEY (boat_name)
);

CREATE TABLE Single(
    boat_name VARCHAR(50),
    oars VARCHAR(50),
    one_seat INT(50),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name),
    FOREIGN KEY (one_seat) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (boat_name)
);

CREATE TABLE TwoMan(
    boat_name VARCHAR(50) NOT NULL,
    oars VARCHAR(50),
    rigging VARCHAR(50),
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
    rigging VARCHAR(50),
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
    rigging VARCHAR(50),
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
    seat INT(1),
    UNIQUE INDEX(boat_name, seat),   
    PRIMARY KEY (athlete_id),
    FOREIGN KEY (boat_name) REFERENCES Boats(boat_name)
);

-- created new table for practices
CREATE TABLE Practices(
    practice_num INT(50) NOT NULL,
    dte DATE NOT NULL,
    workout_id INT(50) NOT NULL,
    FOREIGN KEY (workout_id) REFERENCES DailyWorkout(workout_id),
    PRIMARY KEY (practice_num, dte) 
);

-- table to track attendances
CREATE TABLE Attendance(
    athlete_id INT(50) NOT NULL,
    practice_num INT(50) NOT NULL,
    dte DATE NOT NULL,
    attended VARCHAR(1) DEFAULT 'Y' NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(athlete_id),
    FOREIGN KEY (practice_num, dte) REFERENCES Practices(practice_num, dte),
    PRIMARY KEY (athlete_id, practice_num, dte)
);

-- store hashed passwords for athletes
CREATE TABLE Passwords(
    athlete_id INT(50) NOT NULL,
    psswrd VARCHAR(255) NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(athlete_id),
    PRIMARY KEY (athlete_id)
);

-- store hashed passwords for coaches
CREATE TABLE CoachPasswords(
    coach_id INT(50) NOT NULL,
    psswrd VARCHAR(255) NOT NULL,
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id),
    PRIMARY KEY (coach_id)
);

-- automatically change a lineup when rows in is updated
DELIMITER $$
CREATE TRIGGER lineupTriggerUPDATE
AFTER UPDATE ON RowsIn
FOR EACH ROW
BEGIN

    DECLARE number_seats INT;
    DECLARE number_seatsOldBoat INT;
    
    IF ( (OLD.boat_name <> NEW.boat_name) OR (OLD.seat <> NEW.seat) ) THEN
        
        SELECT num_seats INTO number_seats FROM Boats WHERE boat_name = NEW.boat_name;
        SELECT num_seats INTO number_seatsOldBoat FROM Boats WHERE boat_name = OLD.boat_name;
        
        CASE
            WHEN number_seats = 8 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE EightMan SET one_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE EightMan SET two_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '3' THEN UPDATE EightMan SET three_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '4' THEN UPDATE EightMan SET four_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '5' THEN UPDATE EightMan SET five_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '6' THEN UPDATE EightMan SET six_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '7' THEN UPDATE EightMan SET seven_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '8' THEN UPDATE EightMan SET eight_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '0' THEN UPDATE EightMan SET coxswain = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;

             WHEN number_seats = 4 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE FourMan SET one_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE FourMan SET two_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '3' THEN UPDATE FourMan SET three_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '4' THEN UPDATE FourMan SET four_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '0' THEN UPDATE FourMan SET coxswain = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;
            
            WHEN number_seats = 2 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE TwoMan SET one_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE TwoMan SET two_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;

            WHEN number_seats = 1 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE Single SET one_seat = OLD.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;
        END CASE;
        CASE
            WHEN number_seatsOldBoat = 8 THEN
                CASE OLD.seat
                    WHEN '1' THEN UPDATE EightMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '2' THEN UPDATE EightMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '3' THEN UPDATE EightMan SET three_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '4' THEN UPDATE EightMan SET four_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '5' THEN UPDATE EightMan SET five_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '6' THEN UPDATE EightMan SET six_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '7' THEN UPDATE EightMan SET seven_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '8' THEN UPDATE EightMan SET eight_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '0' THEN UPDATE EightMan SET coxswain = NULL WHERE boat_name = OLD.boat_name;
                END CASE;

             WHEN number_seatsOldBoat = 4 THEN
                CASE OLD.seat
                    WHEN '1' THEN UPDATE FourMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '2' THEN UPDATE FourMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '3' THEN UPDATE FourMan SET three_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '4' THEN UPDATE FourMan SET four_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '0' THEN UPDATE FourMan SET coxswain = NULL WHERE boat_name = OLD.boat_name;
                END CASE;
            
            WHEN number_seatsOldBoat = 2 THEN
                CASE OLD.seat
                    WHEN '1' THEN UPDATE TwoMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                    WHEN '2' THEN UPDATE TwoMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
                END CASE;

            WHEN number_seatsOldBoat = 1 THEN
                CASE OLD.seat
                    WHEN '1' THEN UPDATE Single SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                END CASE;

        END CASE;
    END IF;

END
$$
DELIMITER ;

-- create new attendance data for everyone once a practice is created
-- DELIMITER $$
-- CREATE TRIGGER practiceAttendanceTrigger
-- AFTER INSERT ON Practices
-- FOR EACH ROW
-- BEGIN
--     DECLARE athlete_id$ INT;
--     DECLARE practice_num$ INT;
--     DECLARE dte$ DATE;
--     DECLARE done INT DEFAULT FALSE;
--     DECLARE cur CURSOR FOR SELECT athlete_id FROM Athlete;
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

--     SET practice_num$ = NEW.practice_num;
--     SET dte$ = NEW.dte;

--     OPEN cur;

--     myloop: LOOP
--         FETCH cur INTO athlete_id$;
--         IF done THEN
--             LEAVE myloop;
--         END IF;

--         IF NEW.practice_num = 1 THEN
--             INSERT INTO Attendance VALUES (athlete_id$, practice_num$, dte$, "Y");
--         END IF;
--     END LOOP;

--     CLOSE cur;
-- END
-- $$
-- DELIMITER ;

-- automatically change a lineup when rows in is inserted
DELIMITER $$
CREATE TRIGGER lineupTriggerINSERT
AFTER INSERT ON RowsIn
FOR EACH ROW
BEGIN

    DECLARE number_seats INT;
    
        SELECT num_seats INTO number_seats FROM Boats WHERE boat_name = NEW.boat_name;
        
        CASE
            WHEN number_seats = 8 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE EightMan SET one_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE EightMan SET two_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '3' THEN UPDATE EightMan SET three_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '4' THEN UPDATE EightMan SET four_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '5' THEN UPDATE EightMan SET five_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '6' THEN UPDATE EightMan SET six_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '7' THEN UPDATE EightMan SET seven_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '8' THEN UPDATE EightMan SET eight_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '0' THEN UPDATE EightMan SET coxswain = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;

             WHEN number_seats = 4 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE FourMan SET one_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE FourMan SET two_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '3' THEN UPDATE FourMan SET three_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '4' THEN UPDATE FourMan SET four_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '0' THEN UPDATE FourMan SET coxswain = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;
            
            WHEN number_seats = 2 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE TwoMan SET one_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                    WHEN '2' THEN UPDATE TwoMan SET two_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;

            WHEN number_seats = 1 THEN
                CASE NEW.seat
                    WHEN '1' THEN UPDATE Single SET one_seat = NEW.athlete_id WHERE boat_name = NEW.boat_name;
                END CASE;

        END CASE;

END
$$
DELIMITER ;

-- automatically change a lineup when rows in is deleted
DELIMITER $$
CREATE TRIGGER lineupTriggerDELETE
AFTER DELETE ON RowsIn
FOR EACH ROW
BEGIN

    DECLARE number_seatsOldBoat INT;
        
    SELECT num_seats INTO number_seatsOldBoat FROM Boats WHERE boat_name = OLD.boat_name;
        
    CASE
        WHEN number_seatsOldBoat = 8 THEN
            CASE OLD.seat
                WHEN '1' THEN UPDATE EightMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '2' THEN UPDATE EightMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '3' THEN UPDATE EightMan SET three_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '4' THEN UPDATE EightMan SET four_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '5' THEN UPDATE EightMan SET five_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '6' THEN UPDATE EightMan SET six_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '7' THEN UPDATE EightMan SET seven_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '8' THEN UPDATE EightMan SET eight_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '0' THEN UPDATE EightMan SET coxswain = NULL WHERE boat_name = OLD.boat_name;
            END CASE;

        WHEN number_seatsOldBoat = 4 THEN
            CASE OLD.seat
                WHEN '1' THEN UPDATE FourMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '2' THEN UPDATE FourMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '3' THEN UPDATE FourMan SET three_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '4' THEN UPDATE FourMan SET four_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '0' THEN UPDATE FourMan SET coxswain = NULL WHERE boat_name = OLD.boat_name;
            END CASE;
            
        WHEN number_seatsOldBoat = 2 THEN
            CASE OLD.seat
                 WHEN '1' THEN UPDATE TwoMan SET one_seat = NULL WHERE boat_name = OLD.boat_name;
                WHEN '2' THEN UPDATE TwoMan SET two_seat = NULL WHERE boat_name = OLD.boat_name;
            END CASE;

        WHEN number_seatsOldBoat = 1 THEN
            CASE OLD.seat
                WHEN '1' THEN UPDATE Single SET one_seat = NULL WHERE boat_name = OLD.boat_name;
            END CASE;

    END CASE;

END
$$
DELIMITER ;

-- automatically add a new boat when the boats table is updated
DELIMITER $$
CREATE TRIGGER boatTriggerINSERT
AFTER INSERT ON Boats
FOR EACH ROW
BEGIN

    DECLARE number_seats INT;
        
        SELECT num_seats INTO number_seats FROM Boats WHERE boat_name = NEW.boat_name;
        
        IF (number_seats = 8) THEN
            -- create a new 8
            INSERT INTO EightMan VALUES (NEW.boat_name, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
        ELSEIF (number_seats = 4) THEN
            -- create a new 4
            INSERT INTO FourMan VALUES (NEW.boat_name, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
        ELSEIF (number_seats = 2) THEN
            -- create a new 2
            INSERT INTO TwoMan VALUES (NEW.boat_name, NULL, NULL, NULL, NULL);
        ELSE
            -- create a new 1
            INSERT INTO Single VALUES (NEW.boat_name, NULL, NULL);
        END IF;
END
$$
DELIMITER ;




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
(28, 'Benjamin', 'Smith', 'benjam_smith@gmail.com', 9012345678, '2000-05-07', 2023, 73, 195, 'Junior', 'P', '430'),
(29, 'Avery', 'Williams', 'averyw@example.com', 9012345679, '2001-08-23', 2023, 68, 170, 'Sophomore', 'S', '365'),
(30, 'Cameron', 'Davis', 'camerondavis@example.com', 9012345680, '2000-12-01', 2023, 75, 190, 'Junior', 'P', '395'),
(31, 'Ethan', 'Johnson', 'ethanj@example.com', 9012345681, '2001-04-17', 2024, 71, 180, 'Sophomore', 'S', '415'),
(32, 'Sophia', 'Martinez', 'sophiamartinez@example.com', 9012345682, '2000-07-11', 2023, 66, 160, 'Junior', 'S', '480'),
(33, 'William', 'Garcia', 'williamgarcia@example.com', 9012345683, '1999-11-29', 2024, 72, 195, 'Senior', 'P', '345'),
(34, 'Madison', 'Hernandez', 'madisonh@example.com', 9012345684, '2000-02-09', 2023, 69, 175, 'Junior', 'S', '510'),
(35, 'Noah', 'Lopez', 'noahlopez@example.com', 9012345685, '2001-01-13', 2023, 76, 200, 'Sophomore', 'P', '340'),
(36, 'Isabella', 'Gonzalez', 'isabellag@example.com', 9012345686, '2000-09-03', 2024, 70, 165, 'Junior', 'S', '420'),
(37, 'Michael', 'Rodriguez', 'michaelr@example.com', 9012345687, '2001-03-05', 2023, 74, 185, 'Sophomore', 'P', '335'),
(38, 'Mia', 'Perez', 'miaperez@example.com', 9012345688, '2000-11-27', 2023, 67, 160, 'Junior', 'S', '390'),
(39, 'James', 'Turner', 'jamesturner@example.com', 9012345689, '1999-12-12', 2024, 73, 195, 'Senior', 'P', '315'),
(40, 'Charlotte', 'Phillips', 'charlottep@example.com', 9012345690, '2001-05-29', 2023, 68, 170, 'Sophomore', 'S', '350'),
(41, 'David', 'Campbell', 'davidc@example.com', 9012345691, '2000-08-19', 2024, 77, 205, 'Junior', 'P', '425'),
(42, 'David', 'Campbell', 'davidc@example.com', 9012345691, '2000-08-19', 2024, 77, 205, 'Junior', 'P', '425'),
(43, 'Amelia', 'Parker', 'ameliaparker@example.com', 9012345692, '2001-02-23', 2023, 71, 175, 'Sophomore', 'S', '485'),
(44, 'Olivia', 'Harris', 'oliviaharris@example.com', 9012345694, '2000-01-04', 2023, 66, 160, 'Junior', 'S', '365'),
(45, 'Daniel', 'Clark', 'danielc@example.com', 9012345695, '2001-07-27', 2024, 72, 180, 'Sophomore', 'P', '420'),
(46, 'Emily', 'Lewis', 'emilylewis@example.com', 9012345696, '2000-12-15', 2023, 68, 170, 'Junior', 'S', '470'),
(47, 'Alexander', 'Lee', 'alexlee@example.com', 9012345697, '2001-02-14', 2023, 76, 200, 'Sophomore', 'P', '485'),
(48, 'Abigail', 'Green', 'abigailgreen@example.com', 9012345698, '2000-09-01', 2023, 69, 175, 'Junior', 'S', '500'),
(49, 'David', 'Baker', 'davidbaker@example.com', 9012345699, '1999-10-27', 2024, 74, 185, 'Senior', 'P', '365'),
(50, 'Sofia', 'Gomez', 'sofiagomez@example.com', 9012345700, '2001-01-09', 2023, 70, 165, 'Sophomore', 'S', '415'),
(51, 'Elijah', 'Kelly', 'elijahkelly@example.com', 9012345701, '2000-06-19', 2023, 77, 205, 'Junior', 'P', '395'),
(52, 'Victoria', 'Howard', 'victoriahoward@example.com', 9012345702, '2001-04-25', 2024, 71, 175, 'Sophomore', 'S', '470'),
(53, 'Matthew', 'Nguyen', 'matthewnguyen@example.com', 9012345703, '2000-08-13', 2023, 73, 195, 'Junior', 'P', '510'),
(54, 'Chloe', 'Allen', 'chloeallen@example.com', 9012345704, '2001-03-17', 2023, 67, 160, 'Sophomore', 'S', '475'),
(55, 'Ryan', 'Wright', 'ryanwright@example.com', 9012345705, '2000-11-03', 2024, 75, 190, 'Junior', 'P', '420'),
(56, 'Natalie', 'King', 'natalieking@example.com', 9012345706, '1999-12-22', 2023, 72, 195, 'Senior', 'S', '395'),
(57, 'Christopher', 'Scott', 'chrisscott@example.com', 9012345707, '2001-06-05', 2023, 74, 185, 'Sophomore', 'P', '335')
;

INSERT INTO Coach
(coach_id, first_name, last_name, email, phone_number, position)
VALUES
(1, 'Frank', 'Biller', 'frank@virginiarowing.org', 1234567876, 'Head Coach'),
(2, 'Walker', 'Haptman', 'walker@virginiarowing.org', 14567898776, 'Head Novice Coach'),
(3, 'Frank', 'Vasquez', 'frankV@virginiarowing.org', 14565664534, 'Assistant Coach'),
(4, 'Ellie', 'Coles', 'ellie@virginiarowing.org', 1223567976, 'Assistant Coach'),
(5, 'Matt', 'Connor', 'matt@virginiarowing.org', 1234235876, 'Physical Therapist'),
(6, 'Bailey', 'Hughs', 'bailey@virginiarowing.org', 1234561234, 'Assistant Coach')
;

INSERT INTO DailyWorkout
VALUES
(1, "4x20' Z2L with 4' rest"),
(2, "2x30' Z2L with 5' rest"),
(3, "8x10' Z2U with 2' rest"),
(4, "3x15' Z2U with 3' rest"),
(5, "6x5' Z5L with 1' rest"),
(6, "4x25' Z2L with 4' rest"),
(7, "2x40' Z1L with 6' rest"),
(8, "8x3' Z6L with 1' rest"),
(9, "5x20' Z3L with 3' rest"),
(10, "6x10' Z4L with 2' rest"),
(11, "3x30' Z2L with 5' rest"),
(12, "3x2k' @22 Z4 with 5' rest"),
(13, "6x700m @36 2k pace with 2:30 rest"),
(14, "Ledecky Special"),
(15, "12x8x6x 40 on 20 off @2k pace"),
(16, "4x9' z3 w/ 4' rest"),
(17, "3x10' + 1x7' 7' rest"),
(18, "Rugby test"),
(19, "6x20' w/ 4' rest"),
(20, "Heavy Metal"),
(21, "SEAL"),
(22, "Trophy"),
(23, "PEL"),
(24, "60' Z2")
;

INSERT INTO ExtraWork
VALUES
    (1, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (2, 1, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (3, 1, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (4, 1, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (5, 1, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (6, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (7, 1, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (8, 1, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (9, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (10, 1, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (11, 1, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (12, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (13, 1, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (14, 1, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (15, 1, 15, '2023-05-14', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (16, 1, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (17, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (18, 1, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (19, 1, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (20, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (21, 1, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (22, 1, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (23, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (24, 1, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (25, 1, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (26, 1, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (27, 1, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (28, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (29, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (30, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (31, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (32, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (33, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (34, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (35, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (36, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (37, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (38, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (39, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (40, 1, 25, '2023-04-01', 'water', '4x10 pushups 4x10 Z2l'),
    (41, 1, 25, '2023-04-01', 'water', '4x10 pushups 4x10 Z2l'),
    (42, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (43, 1, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (44, 1, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (45, 1, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (46, 1, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (47, 1, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (48, 1, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (49, 1, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (50, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (51, 1, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (52, 1, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (53, 1, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (54, 1, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (55, 1, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (56, 1, 15, '2023-05-14', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (57, 1, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (1, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (2, 2, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (3, 2, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (4, 2, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (5, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (6, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (7, 2, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (8, 2, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (9, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (10, 2, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (11, 2, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (12, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (13, 2, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (14, 2, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (15, 2, 15, '2023-05-14', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (16, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (17, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (18, 2, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (19, 2, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (20, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (21, 2, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (22, 2, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (23, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (24, 2, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (25, 2, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (26, 2, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (27, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (28, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (29, 2, 25, '2023-04-01', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (30, 2, 30, '2022-03-15', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (31, 2, 20, '2023-04-01', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (32, 2, 15, '2023-05-14', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (33, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (34, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (35, 2, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (36, 2, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (37, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (38, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (39, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (40, 2, 25, '2023-04-01', 'water', '4x10 pushups 4x10 Z2l'),
    (41, 2, 25, '2023-04-01', 'water', '4x10 pushups 4x10 Z2l'),
    (42, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (43, 2, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (44, 2, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (45, 2, 15, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (46, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (47, 2, 25, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (48, 2, 40, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (49, 2, 3, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (50, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (51, 2, 10, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (52, 2, 30, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (53, 2, 20, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (54, 2, 30, '2023-04-01', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (55, 2, 10, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press'),
    (56, 2, 15, '2023-05-14', 'water', '4x10 pushups, 3x12 squats, 20 min rows'),
    (57, 2, 5, '2022-03-15', 'land', '4x10 pushups, 3x8 sit ups, 3x12 bench press')
    ;

INSERT INTO Boats
(boat_name, num_seats)
VALUES
    ("People's Eight", 8),
    ('White Rocket II', 8),
    ('Jefferson', 8),
    ('Critchfield', 8),
    ("O'Connor", 8),
    ("1960", 8),
    ('Panda', 4),
    ('Myers', 4),
    ('Kudravits', 4),
    ('Rampage', 4),
    ('Orange Swift', 1),
    ('Blue Swift', 1),
    ('Green Swift', 1),
    ('Orange Swift D', 2),
    ('Blue Swift D', 2),
    ('Green Swift D', 2)
;

INSERT INTO RowsIn
VALUES
(1, "People's Eight", 0),
(2, "People's Eight", 1),
(3, "People's Eight", 2),
(4, "People's Eight", 3),
(5, "People's Eight", 4),
(6, "People's Eight", 5),
(7, "People's Eight", 6),
(8, "People's Eight", 7),
(9, "People's Eight", 8),

(10, "White Rocket II", 0),
(11, "White Rocket II", 1),
(12, "White Rocket II", 2),
(13, "White Rocket II", 3),
(14, "White Rocket II", 4),
(15, "White Rocket II", 5),
(16, "White Rocket II", 6),
(17, "White Rocket II", 7),
(18, "White Rocket II", 8),

(19, "Jefferson", 0),
(20, "Jefferson", 1),
(21, "Jefferson", 2),
(22, "Jefferson", 3),
(23, "Jefferson", 4),
(24, "Jefferson", 5),
(25, "Jefferson", 6),
(26, "Jefferson", 7),
(27, "Jefferson", 8),

(28, "Critchfield", 0),
(29, "Critchfield", 1),
(30, "Critchfield", 2),
(31, "Critchfield", 3),
(32, "Critchfield", 4),
(33, "Critchfield", 5),
(34, "Critchfield", 6),
(35, "Critchfield", 7),
(36, "Critchfield", 8),

(37, "O'Connor", 0),
(38, "O'Connor", 1),
(39, "O'Connor", 2),
(40, "O'Connor", 3),
(41, "O'Connor", 4),
(42, "O'Connor", 5),
(43, "O'Connor", 6),
(44, "O'Connor", 7),
(45, "O'Connor", 8),

(46, "Panda", 0),
(47, "Panda", 1),
(48, "Panda", 2),
(49, "Panda", 3),
(50, "Panda", 4),

(51, "Orange Swift D", 1),
(52, "Orange Swift D", 2),

(53, "Blue Swift D", 1),
(54, "Blue Swift D", 2),

(55, "Blue Swift", 1),

(56, "Green Swift", 1),

(57, "Orange Swift", 1)

;

INSERT INTO Practices
VALUES
(1, '2022-03-15', 1),
(2, '2022-03-15', 2),
(1, '2022-03-16', 3),
(2, '2022-03-16', 4),
(1, '2022-03-17', 5),
(2, '2022-03-17', 6),
(1, '2022-03-18', 7),
(2, '2022-03-18', 8),
(1, '2022-03-19', 9),
(2, '2022-03-19', 10),
(1, '2022-03-20', 11),
(2, '2022-03-20', 12),
(1, '2022-03-21', 13),
(2, '2022-03-21', 14),
(1, '2022-03-22', 15),
(2, '2022-03-22', 16),
(1, '2022-03-23', 17),
(2, '2022-03-23', 18),
(1, '2022-03-24', 19),
(2, '2022-03-24', 20),
(1, '2022-03-25', 21),
(2, '2022-03-25', 22),
(1, '2022-03-26', 23),
(2, '2022-03-26', 24),
(1, '2022-03-27', 1),
(2, '2022-03-27', 2),
(1, '2022-03-28', 3),
(2, '2022-03-28', 4),
(1, '2022-03-29', 5),
(2, '2022-03-29', 6),
(1, '2022-03-30', 7),
(2, '2022-03-30', 8),
(1, '2022-03-31', 9),
(2, '2022-03-31', 10),
(1, '2022-04-01', 11),
(2, '2022-04-01', 12),
(1, '2022-04-02', 13),
(2, '2022-04-02', 14),
(1, '2022-04-03', 15),
(2, '2022-04-03', 16),
(1, '2022-04-04', 17),
(2, '2022-04-04', 18),
(1, '2022-04-05', 19),
(2, '2022-04-05', 20),
(1, '2022-04-06', 21),
(2, '2022-04-06', 22),
(1, '2022-04-07', 23),
(2, '2022-04-07', 24),
(1, '2023-04-02', 10), 
(2, '2023-04-02', 11), 
(1, '2023-04-03', 12), 
(2, '2023-04-03', 13)
;
