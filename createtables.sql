CREATE TABLE Athlete(
    user_id INT(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number INT(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    grad_year INT(4) NOT NULL,
    height INT(3) NOT NULL,
    weight INT(3) NOT NULL,
    class VARCHAR(50) NOT NULL,
    boat_side VARCHAR(50) NOT NULL,
    twoKPR INTEGER(100) NOT NULL,
    g8 INTEGER(100) NOT NULL,
    age AS DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(),DATE_OF_BIRTH)), '%Y') 
 + 0 NOT NULL,
    PRIMARY KEY (user_id) AUTO_INCREMENT
);

CREATE TABLE Coach(
    user_id INT(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number INT(10) NOT NULL,
    position VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id) AUTO_INCREMENT
);

CREATE TABLE ExtraWork(
    user_id INT(50) NOT NULL,
    workout_id INT(50),
    minutes INT(3) NOT NULL,
    date DATE NOT NULL,
    workout_type VARCHAR(50) NOT NULL,
    description VARCHAR(500) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Athlete(user_id),
    PRIMARY KEY (user_id, workout_id)
);

CREATE TABLE Single(
    name VARCHAR(50),
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    one_seat INT(50),
    FOREIGN KEY (name) REFERENCES Boats(name),
    FOREIGN KEY (one_seat) REFERENCES Athlete(user_id),
    PRIMARY KEY (name)
);

CREATE TABLE TwoMan(
    name VARCHAR(50) NOT NULL,
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    one_seat INT(50),
    two_seat INT(50),
    PRIMARY KEY (name),
    FOREIGN KEY (name) REFERENCES Boats(name),
    FOREIGN KEY (one_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(user_id)
);

CREATE TABLE FourMan(
    name VARCHAR(50) NOT NULL,
    oars VARCHAR(50),
    rigging VARCHAR(50) NOT NULL,
    coxswain INT(50),
    one_seat INT(50),
    two_seat INT(50),
    three_seat INT(50),
    four_seat INT(50),
    PRIMARY KEY (name),
    FOREIGN KEY (name) REFERENCES Boats(name),
    FOREIGN KEY (coxswain) REFERENCES Athlete(user_id),
    FOREIGN KEY (one_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (three_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (four_seat) REFERENCES Athlete(user_id)
);

CREATE TABLE EightMan(
    name VARCHAR(50),
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
    PRIMARY KEY (name),
    FOREIGN KEY (name) REFERENCES Boats(name),
    FOREIGN KEY (coxswain) REFERENCES Athlete(user_id),
    FOREIGN KEY (one_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (two_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (three_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (four_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (five_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (six_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (seven_seat) REFERENCES Athlete(user_id),
    FOREIGN KEY (eight_seat) REFERENCES Athlete(user_id)
);

CREATE TABLE DailyWorkout(
    workout_id INT(50) NOT NULL,
    description VARCHAR(500) NOT NULL
    PRIMARY KEY (workout_id) AUTO_INCREMENT
);

CREATE TABLE RowsIn(
    athlete_id VARCHAR(50) NOT NULL,
    boat_name VARCHAR(50),
    PRIMARY KEY (athlete_id),
    FOREIGN KEY (boat_name) REFERENCES Boats(name),
);

CREATE TABLE Practices(
    athlete_id INT(50) NOT NULL,
    workout_id INT(50) NOT NULL,
    attended VARCHAR(1) DEFAULT 'Y',
    date DATE NOT NULL,
    FOREIGN KEY (athlete_id) REFERENCES Athlete(user_id),
    PRIMARY KEY (athlete_id, workout_id)
);

CREATE TABLE Boats(
    name VARCHAR(50) NOT NULL,
    num_seats INT(1) NOT NULL,
    PRIMARY KEY (name)
)


INSERT INTO Athlete 
VALUES 
    ('John', 'Smith', 'johnsmith@gmail.com', 1234567890, '1999-01-01', 2023, 70, 180, 'Freshman', 'Port', '07:00', '06:00'),
    ('Jane', 'Doe', 'janedoe@gmail.com', 0987654321, '2000-05-15', 2022, 65, 170, 'Sophomore', 'Starboard', '06:30', '05:45'),
    ('Michael', 'Jordan', 'mj23@gmail.com', 5551234567, '1984-02-17', 2024, 80, 200, 'Senior', 'Coxswain', '06:15', '05:30'),
    ('Serena', 'Williams', 'serenawilliams@gmail.com', 8885551234, '1981-09-26', 2023, 72, 155, 'Junior', 'Starboard', '06:45', '06:15'),
    ('Tom', 'Brady', 'tombrady@gmail.com', 3335551234, '1977-08-03', 2025, 75, 225, 'Senior', 'Port', '06:00', '05:15'),
    ('LeBron', 'James', 'lebronjames@gmail.com', 6664441234, '1984-12-30', 2022, 82, 250, 'Junior', 'Coxswain', '06:30', '05:45'),
    ('Lionel', 'Messi', 'lionelmessi@gmail.com', 7771111234, '1987-06-24', 2024, 68, 160, 'Sophomore', 'Starboard', '06:15', '05:30'),
    ('Simone', 'Biles', 'simonebiles@gmail.com', 5557771234, '1997-03-14', 2023, 58, 120, 'Freshman', 'Port', '07:00', '06:00'),
    ('Katie', 'Ledecky', 'katieledecky@gmail.com', 4442221234, '1997-03-17', 2025, 70, 150, 'Senior', 'Starboard', '06:45', '06:15'),
    ('Usain', 'Bolt', 'usainbolt@gmail.com', 9991111234, '1986-08-21', 2023, 80, 200, 'Junior', 'Port', '06:30', '05:45'),
    ('Michael', 'Phelps', 'michaelphelps@gmail.com', 7778881234, '1985-06-30', 2022, 80, 185, 'Sophomore', 'Coxswain', '06:15', '05:30'),
    ('Serena', 'Guthrie', 'serenaguthrie@gmail.com', 3336661234, '1993-05-19', 2024, 67, 145, 'Freshman', 'Starboard', '07:00', '06:00'),
    ('Megan', 'Rapinoe', 'meganrapinoe@gmail.com', 1117771234, '1985-07-05', 2023, 65, 135, 'Junior', 'Port', '06:45', '06:15')
    ;

INSERT INTO Boats
VALUES
    ('Eight', 8),
    ('Four', 4),
    ('Pair', 2),
    ('Single', 1)
    ;

INSERT INTO EightMan
VALUES
    ('JohnnyIve', 'red', 'starboard', 1, 2, 3, 4, 5, 6, 7, 8, 9),
    ('Apple', 'blue', 'port', 10, 11, 12, 13, 14, 15, 16, 17, 18),
    ('Google', 'green', 'starboard', 19, 20, 21, 22, 23, 24, 25, 26, 27),
    ('Microsoft', 'yellow', 'port', 28, 29, 30, 31, 32, 33, 34, 35, 36),
    ('Amazon', 'orange', 'starboard', 37, 38, 39, 40, 41, 42, 43, 44, 45),
    ('Facebook', 'purple', 'port', 46, 47, 48, 49, 50, 51, 52, 53, 54),
    ('Twitter', 'black', 'starboard', 55, 56, 57, 58, 59, 60, 61, 62, 63),
    ('Instagram', 'white', 'port', 64, 65, 66, 67, 68, 69, 70, 71, 72),
    ('Snapchat', 'pink', 'starboard', 73, 74, 75, 76, 77, 78, 79, 80, 81),
    ('TikTok', 'grey', 'port', 82, 83, 84, 85, 86, 87, 88, 89, 90),
    ('Twitch', 'brown', 'starboard', 91, 92, 93, 94, 95, 96, 97, 98, 99),
    ('Discord', 'silver', 'port', 100, 101, 102, 103, 104, 105, 106, 107, 108),
    ('Spotify', 'gold', 'starboard', 109, 110, 111, 112, 113, 114, 115, 116, 117)
    ;

INSERT INTO FourMan
VALUES
    ('JohnnyIve', 'red', 'starboard', 1, 2, 3, 4, 5),
    ('Apple', 'blue', 'port', 10, 11, 12, 13, 14),
    ('Google', 'green', 'starboard', 19, 20, 21, 22, 23),
    ('Microsoft', 'yellow', 'port', 28, 29, 30, 31, 32),
    ('Amazon', 'orange', 'starboard', 37, 38, 39, 40, 41),
    ('Facebook', 'purple', 'port', 46, 47, 48, 49, 50),
    ('Twitter', 'black', 'starboard', 55, 56, 57, 58, 59),
    ('Instagram', 'white', 'port', 64, 65, 66, 67, 68),
    ('Snapchat', 'pink', 'starboard', 73, 74, 75, 76, 77),
    ('TikTok', 'grey', 'port', 82, 83, 84, 85, 86),
    ('Twitch', 'brown', 'starboard', 91, 92, 93, 94, 95),
    ('Discord', 'silver', 'port', 100, 101, 102, 103, 104),
    ('Spotify', 'gold', 'starboard', 109, 110, 111, 112, 113)

INSERT INTO Pair
VALUES
    