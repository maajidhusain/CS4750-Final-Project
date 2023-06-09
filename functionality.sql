
-- Retrieve the daily workout, extra workouts, lineups, and user information

-- Retrieve today's daily workout
SELECT practice_num, dte, descr 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE dte IN (CURDATE());

-- Retrieve tomorrow's daily workout
SELECT practice_num, dte, descr 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE dte = (CURDATE() + INTERVAL 1 DAY);

-- Retrieve a daily workout from any date
SELECT practice_num, dte, descr 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE DAY(dte) = $num AND MONTH(dte) = 
$month AND YEAR(dte) = $year;

-- Retrieve how many practices an athlete missed
SELECT count(attended) AS missed
FROM Attendance
WHERE attended <> 'Y' AND athlete_id = $athlete_id;

-- retrieve the athletes attending tomorrow's practice
SELECT CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete NATURAL JOIN Attendance
WHERE attended = 'Y' AND dte = (CURDATE() + INTERVAL 1 DAY);

-- retrieve an athletes extra workouts (all of them)
SELECT mins, dte, workout_type, descr
FROM ExtraWork
WHERE athlete_id = $athlete_id;

-- retrieve athletes total extra workouts minutes
SELECT CONCAT(first_name, ' ', last_name) AS Name, SUM(mins) AS Total_Minutes
FROM ExtraWork NATURAL JOIN Athlete
GROUP BY athlete_id;

-- retrieve some athlete user information (Ex: g8)
SELECT CONCAT(first_name, ' ', last_name) AS Name, g8
FROM Athlete
WHERE athlete_id = $athlete_id;

-- retrieve all of the 8's lineups
SELECT *
FROM EightMan;

-- retrieve all of the 4's lineups
SELECT *
FROM FourMan;

-- retrieve all of the 2's lineups
SELECT *
FROM TwoMan;

-- retrieve all of the 1's lineups
SELECT *
FROM Single;

-- retieve a given user's lineups (use "Rows in")
SELECT boat_name
FROM RowsIn
WHERE athlete_id = $athlete_id;

-- retrieve the name of an eights lineup coxswain
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.coxswain = Athlete.athlete_id;

-- retrieve the name of an eights lineup 1 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.one_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 2 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.two_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 3 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.three_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 4 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.four_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 5 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.five_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 6 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.six_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 7 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.seven_seat = Athlete.athlete_id;


-- retrieve the name of an eights lineup 8 seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN EightMan ON EightMan.eight_seat = Athlete.athlete_id;


-- retrieve the name of an four lineup coxswain seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN FourMan ON FourMan.coxswain = Athlete.athlete_id;


-- retrieve the name of an four lineup one seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN FourMan ON FourMan.one_seat = Athlete.athlete_id;


-- retrieve the name of an four lineup two seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN FourMan ON FourMan.two_seat = Athlete.athlete_id;


-- retrieve the name of an four lineup three seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN FourMan ON FourMan.three_seat = Athlete.athlete_id;


-- retrieve the name of an four lineup four seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN FourMan ON FourMan.four_seat = Athlete.athlete_id;


-- retrieve the name of an TwoMan lineup one seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN TwoMan ON TwoMan.one_seat = Athlete.athlete_id;


-- retrieve the name of an TwoMan lineup two seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN TwoMan ON TwoMan.two_seat = Athlete.athlete_id;


-- retrieve the name of an Single lineup one seat
SELECT boat_name AS Boat, CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete JOIN Single ON Single.one_seat = Athlete.athlete_id;


-- Add athlete
INSERT INTO Athlete 
(first_name, last_name, email, phone_number, date_of_birth, grad_year, height, ath_weight, class, boat_side, twoKPR)
VALUES 
($first_name, $last_name, $email, $phone_number, $date_of_birth, $grad_year, $height, $ath_weight, $class, $boat_side, $twoKPR);

-- Add Coach
INSERT INTO Coach 
(first_name, last_name, email, phone_number, position)
VALUES 
($first_name, $last_name, $email, $phone_number, $position);

-- Add extra work
INSERT INTO ExtraWork
(athlete_id, workout_num, mins, dte, workout_type, descr)
VALUES
($athlete_id, $workout_num, $mins, $dte, $workout_type, $descr);

-- Add Single
INSERT INTO Single
(boat_name, oars, one_seat)
VALUES
($boat_name, $oars, $one_seat);

-- Add two man
INSERT INTO TwoMan
(boat_name, oars, rigging, one_seat, two_seat)
VALUES
($boat_name, $oars, $rigging, $one_seat, $two_seat);

-- Add FourMan
INSERT INTO FourMan
(boat_name, oars, rigging, coxswain, one_seat, two_seat, three_seat, four_seat)
VALUES
($boat_name, $oars, $rigging, $coxswain, $one_seat, $two_seat, $three_seat, $four_seat);

-- Add EightMan
INSERT INTO EightMan
(boat_name, oars, rigging, coxswain, one_seat, two_seat, three_seat, four_seat, five_seat, six_seat, seven_seat, eight_seat)
VALUES
($boat_name, $oars, $rigging, $coxswain, $one_seat, $two_seat, $three_seat, $four_seat, $five_seat, $six_seat, $seven_seat, $eight_seat);

-- Add RowsIn
INSERT INTO RowsIn
(athlete_id, boat_name, seat)
VALUES
($athlete_id, $boat_name, $seat);

-- Add Practices
INSERT INTO Practices
(practice_num, dte, workout_id)
VALUES
($practice_num, $dte, $workout_id);

-- Add daily workout
INSERT INTO DailyWorkout
(workout_id, descr)
VALUES
($workout_id, $descr);

-- Add Boats
INSERT INTO Boats
(boat_name, num_seats)
VALUES
($boat_name, $num_seats);


-- Users will be able to update their profile information
UPDATE Athlete
SET first_name=$first_name, last_name=$last_name, email=$email, phone_number=$phone_number, date_of_birth=$date_of_birth, grad_year=$grad_year, height=$height, ath_weight=$ath_weight, class=$class, boat_side=$boat_side, twoKPR=$twoKPR
WHERE athlete_id=$athlete_id;

-- coach updates lineup
UPDATE RowsIn
SET boat_name=$boat_name, seat=$seat
WHERE athlete_id=$athlete_id;

-- coach updates rigging / oars
UPDATE EightMan
SET rigging=$rigging
WHERE boat_name=$boat_name;

UPDATE EightMan
SET oars=$oars
WHERE boat_name=$boat_name;

UPDATE FourMan
SET rigging=$rigging
WHERE boat_name=$boat_name;

UPDATE FourMan
SET oars=$oars
WHERE boat_name=$boat_name;

UPDATE TwoMan
SET rigging=$rigging
WHERE boat_name=$boat_name;

UPDATE TwoMan
SET oars=$oars
WHERE boat_name=$boat_name;

UPDATE Single
SET oars=$oars
WHERE boat_name=$boat_name;

-- coach changes practice's workout
UPDATE practices
SET workout_id=$workout_id
WHERE practice_num=$practice_num AND dte=$dte;


-- Athletes can update if they are attending a practice or not
UPDATE Attendance
SET attended = "N"
WHERE athlete_id=$athlete_id AND practice_num=$practice_num AND dte=$dte;

UPDATE Attendance
SET attended = "Y"
WHERE athlete_id=$athlete_id AND practice_num=$practice_num AND dte=$dte;


-- Coach will be able to delete invalid extra workouts
DELETE FROM ExtraWork
WHERE workout_num=$workout_num AND athlete_id=$athlete_id;

-- Search/Filter Data
-- search by 2kscore 
SELECT CONCAT(first_name, ' ', last_name) AS Name, twoKPR
FROM Athlete
WHERE twoKPR <= $twoKPR;
-- search by name
SELECT CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete
WHERE first_name <> NULL AND last_name <> NULL;
-- search by boat side
SELECT CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete
WHERE boat_side = $boat_side;
-- search by class
SELECT CONCAT(first_name, ' ', last_name) AS Name
FROM Athlete
WHERE class = $class;
