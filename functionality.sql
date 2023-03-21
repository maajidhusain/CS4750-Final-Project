
-- Retrieve the daily workout, extra workouts, lineups, and user information

-- Retrieve today's daily workout
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE dte IN (CURDATE());

-- Retrieve tomorrow's daily workout
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE dte = (CURDATE() + INTERVAL 1 DAY);

-- Retrieve a daily workout from any date
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE DAY(dte) = $num AND MONTH(dte) = 
$month AND YEAR(dte) = $year;

-- Retrieve how many practices an athlete missed
SELECT count(attended)
FROM Practices
WHERE attended <> 'Y' AND athlete_id = $athlete_id;

-- retrieve the athletes attending tomorrow's practice
SELECT first_name + ' ' + last_name AS Name
FROM Athlete NATURAL JOIN Practices
WHERE attended = 'Y' AND dte = (CURDATE() + INTERVAL 1 DAY);

-- retrieve an athletes extra workouts (all of them)
SELECT mins, dte, workout_type, descr
FROM ExtraWork
WHERE athlete_id = $athlete_id;

-- retrieve athletes total extra workouts minutes
SELECT SUM(mins)
FROM ExtraWork
GROUP BY athlete_id;

-- retrieve some athlete user information (Ex: g8)
SELECT first_name + ' ' + last_name AS Name, g8
FROM Athlete
WHERE athlete_id = $athlete_id;

-- retrieve all of the 8's lineups
SELECT boat_name, oars, coxswain, one_seat, two_seat, three_seat, four_seat, five_seat, six_seat, seven_seat, eight_seat
FROM EightMan;

-- retrieve all of the 4's lineups
SELECT boat_name, oars, coxswain, one_seat, two_seat, three_seat, four_seat
FROM FourMan;

-- retrieve all of the 2's lineups
SELECT boat_name, oars, coxswain, one_seat, two_seat
FROM TwoMan;

-- retrieve all of the 1's lineups
SELECT boat_name, oars, coxswain, one_seat
FROM Single;

-- retieve a given user's lineups (use "Rows in")
SELECT boat_name
FROM RowsIn
WHERE athlete_id = $athlete_id;






-- Add new user to database
INSERT INTO Athlete 
(first_name, last_name, email, phone_number, date_of_birth, year, height, weight, class, boat_side, twoKPR)
VALUES 
($first_name, $last_name, $email, $phone_number, $date_of_birth, $year, $height, $weight, $class, $boat_side, $twoKPR);

-- Add Coach
-- Add extra work
-- Add Single
-- Add two man
-- Add FourMan
-- Add EightMan
-- Add RowsIn
-- Add Practices
-- Add daily workout
-- Add Boats


-- Users will be able to update their profile information
-- Coaches will be able to change boat lineups, riggings, and workouts
-- Athletes can update if they are attending a practice or not


-- The ‘Superuser’ will be able to delete, or remove inactive or archived athletes
-- Coach will be able to delete invalid extra workouts
-- Search/Filter Data
-- Each user will be allowed to filter through the athlete directory to see the different attributes assigned to the results from the search










