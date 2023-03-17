
-- Retrieve the daily workout, extra workouts, lineups, and user information

-- Retrieve today's daily workout
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE date IN (CURDATE());

-- Retrieve tomorrow's daily workout
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE date IN (CURDATE() + INTERVAL 1 DAY);

-- Retrieve a daily workout from any date
SELECT description 
FROM DailyWorkout NATURAL JOIN Practices 
WHERE DAY(date) = $num AND MONTH(date) = 
4month AND YEAR(date) = $year;

-- Retrieve how many practices an athlete missed

-- retrieve the athletes attending tomorrow's practice

-- retrieve an athletes extra workouts (all of them)

-- retrieve some athlete user information

-- retrieve all of the lineups

-- retieve a given user's lineups (use "Rows in")





-- Add new user to database
-- Add extra work
-- Add daily workout


-- Users will be able to update their profile information
-- Coaches will be able to change boat lineups, riggings, and workouts
-- Athletes can update if they are attending a practice or not


-- The ‘Superuser’ will be able to delete, or remove inactive or archived athletes
-- Coach will be able to delete invalid extra workouts
-- Search/Filter Data
-- Each user will be allowed to filter through the athlete directory to see the different attributes assigned to the results from the search










