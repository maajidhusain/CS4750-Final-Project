CREATE TABLE Athlete(
    user_id = INT PRIMARY KEY AUTOINCREMENT,
    first_name = VARCHAR(50) NOT NULL,
    last_name = VARCHAR(50) NOT NULL,
    email = VARCHAR(50) NOT NULL,
    phone_number = INT(10) NOT NULL,
    date_of_birth = DATE NOT NULL,
    grad_year = INT(4) NOT NULL,
    height = INT(3) NOT NULL,
    weight = INT(3) NOT NULL,
    class = VARCHAR(50) NOT NULL,
    boat_side = VARCHAR(50) NOT NULL,
    twoKPR = INTEGER(100) NOT NULL,
    g8 = INTEGER(100) NOT NULL,
    age = INT(2) NOT NULL
);

CREATE TABLE Coach(
    user_id = INT PRIMARY KEY AUTOINCREMENT,
    first_name = VARCHAR(50) NOT NULL,
    last_name = VARCHAR(50) NOT NULL,
    email = VARCHAR(50) NOT NULL,
    phone_number = INT(10) NOT NULL,
    position = VARCHAR(50) NOT NULL
);

CREATE TABLE ExtraWork(
    -- athlete user_id as foriegn key
    workout_id = INT PRIMARY KEY AUTOINCREMENT,
    minutes = INT(3) NOT NULL,
    date = DATE NOT NULL,
    workout_type = VARCHAR(50) NOT NULL,
    description = VARCHAR(500) NOT NULL
);

CREATE TABLE Single(
    name = VARCHAR(50) PRIMARY KEY,
    oars = VARCHAR(50) NOT NULL,
    rigging = VARCHAR(50) NOT NULL,
    one_seat = Athlete.user_id AS FOREIGN KEY
);

CREATE TABLE TwoMan(
    name = VARCHAR(50) PRIMARY KEY,
    oars = VARCHAR(50) NOT NULL,
    rigging = VARCHAR(50) NOT NULL,
    one_seat = Athlete.user_id AS FOREIGN KEY,
    two_seat = Athlete.user_id AS FOREIGN KEY
);

CREATE TABLE FourMan(
    name = VARCHAR(50) PRIMARY KEY,
    oars = VARCHAR(50) NOT NULL,
    rigging = VARCHAR(50) NOT NULL,
    coxswain = Athlete.user_id AS FOREIGN KEY,
    one_seat = Athlete.user_id AS FOREIGN KEY,
    two_seat = Athlete.user_id AS FOREIGN KEY,
    three_seat = Athlete.user_id AS FOREIGN KEY,
    four_seat = Athlete.user_id AS FOREIGN KEY
);

CREATE TABLE EightMan(
    name = VARCHAR(50) PRIMARY KEY,
    oars = VARCHAR(50) NOT NULL,
    rigging = VARCHAR(50) NOT NULL,
    coxswain = Athlete.user_id AS FOREIGN KEY,
    one_seat = Athlete.user_id AS FOREIGN KEY,
    two_seat = Athlete.user_id AS FOREIGN KEY,
    three_seat = Athlete.user_id AS FOREIGN KEY,
    four_seat = Athlete.user_id AS FOREIGN KEY,
    five_seat = Athlete.user_id AS FOREIGN KEY,
    six_seat = Athlete.user_id AS FOREIGN KEY,
    seven_seat = Athlete.user_id AS FOREIGN KEY,
    eight_seat = Athlete.user_id AS FOREIGN KEY
);

CREATE TABLE DailyWorkout(
    workout_id = INT PRIMARY KEY AUTOINCREMENT,
    description = VARCHAR(500) NOT NULL
);

CREATE TABLE RowsIn(
    Athlete.user_id AS FOREIGN KEY,
    Boats.name AS FOREIGN KEY -- need to find a way to get the name of the boat. I think we should have a table of boat names since there are four classes of boats and we cant foreign key to each one
);

CREATE TABLE Practices(
    Athlete.user_id AS FOREIGN KEY,
    DailyWorkout.workout_id AS FOREIGN KEY,
    date = DATE NOT NULL
);

CREATE TABLE Boats(
    name = VARCHAR(50) PRIMARY KEY,
    num_seats = INT(1) NOT NULL,
)