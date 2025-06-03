CREATE TABLE IF NOT EXISTS location (
    id_location SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    coordinates POINT NOT NULL,
    is_active   BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS trajectory (
    id_trajectory SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    arrival_location_id INT NOT NULL,
    place_of_departure_id INT NOT NULL,
    FOREIGN KEY (arrival_location_id) REFERENCES location(id_location) ON DELETE CASCADE,
    FOREIGN KEY (place_of_departure_id) REFERENCES location(id_location) ON DELETE CASCADE,

    CHECK (start_time < end_time)
);


CREATE TABLE IF NOT EXISTS groups (
    id_group SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    association VARCHAR(255),
    quantity INT NOT NULL,
    trajectory_id INT NOT NULL,
    FOREIGN KEY (trajectory_id) REFERENCES trajectory(id_trajectory) ON DELETE CASCADE,

    CHECK (quantity >= 0)
);

CREATE TABLE IF NOT EXISTS fish (
    id_fish SERIAL PRIMARY KEY,
    weight FLOAT NOT NULL,
    size VARCHAR(255) NOT NULL,
    location_id INT NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES location(id_location) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES groups(id_group) ON DELETE CASCADE,

    CHECK (weight >= 0)
);

CREATE TABLE IF NOT EXISTS interaction (
    id_interaction SERIAL PRIMARY KEY,
    time TIMESTAMP NOT NULL,
    description VARCHAR(255),
    fish_1_id INT NOT NULL,
    fish_2_id INT NOT NULL,
    FOREIGN KEY (fish_1_id) REFERENCES fish(id_fish) ON DELETE CASCADE,
    FOREIGN KEY (fish_2_id) REFERENCES fish(id_fish) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS state (
    id_tate SERIAL PRIMARY KEY,
    brightness INT NOT NULL,
    speed INT NOT NULL,
    state_time TIMESTAMP NOT NULL,
    temperature FLOAT NOT NULL,
    fish_id INT NOT NULL,
    FOREIGN KEY (fish_id) REFERENCES fish(id_fish) ON DELETE CASCADE,

    CHECK (brightness >= 0),
    CHECK (speed >= 0)
);

CREATE TABLE IF NOT EXISTS cycle (
    id_cycle SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    frequency INT NOT NULL ,
    duration INT NOT NULL,

    CHECK (frequency >= 0),
    CHECK (duration >= 0)
);

CREATE TABLE IF NOT EXISTS cycle_group (
    id_group INT NOT NULL,
    id_cycle INT NOT NULL,
    PRIMARY KEY (id_cycle, id_group),
    FOREIGN KEY (id_group) REFERENCES groups(id_group) ON DELETE CASCADE,
    FOREIGN KEY (id_cycle) REFERENCES cycle(id_cycle) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cycle_fish (
    id_fish INT NOT NULL,
    id_cycle INT NOT NULL,
    PRIMARY KEY (id_fish, id_cycle),
    FOREIGN KEY (id_fish) REFERENCES fish(id_fish) ON DELETE CASCADE,
    FOREIGN KEY (id_cycle) REFERENCES cycle(id_cycle) ON DELETE CASCADE
);

--test data

INSERT INTO location (name, coordinates, is_active)
VALUES
    ('Central Park', POINT(40.785091, -73), TRUE),
    ('Times Square', POINT(22.3424, -7.3), TRUE),
    ('Brooklyn Bridge', POINT(1.232, 35.56456), TRUE),
    ('Empire State Building', POINT(-31.666, 228.337), FALSE);

INSERT INTO trajectory (start_time, end_time, arrival_location_id, place_of_departure_id)
VALUES
    ('1998-02-25 08:12:52', '2022-02-24 4:00:00', 1, 2),
    ('2001-09-11 12:45:01', '2025-02-26 11:00:00', 3, 1),
    ('2025-02-27 4:20:00', '2025-02-27 16:00:00', 3, 2);

INSERT INTO groups (name, association, quantity, trajectory_id)
VALUES
    ('Explorers', 'Tourist', 10, 1),
    ('Photographers', NULL, 5, 2),
    ('Historians', 'Research', 8, 3);


INSERT INTO fish (weight, size, location_id, group_id)
VALUES
    (5.5, 'Small', 1, 1),
    (12.0, 'Medium', 2, 1),
    (8.3, 'Large', 3, 2),
    (4.0, 'Small', 2, 3);

INSERT INTO interaction (time, description, fish_1_id, fish_2_id)
VALUES
    ('2024-02-25 09:30:00', 'fish 1 and 2 interacted near Central Park', 1, 2),
    ('2025-02-26 10:15:00', 'fish 3 observed fish 4 near Brooklyn Bridge', 3, 4);

INSERT INTO state (brightness, speed, state_time, temperature, fish_id)
VALUES
    (80, 10, '2005-05-5 14:38:018', 22.5, 1),
    (90, 15, '2019-07-12 12:37:32', 21.0, 2),
    (70, 8, '2015-08-13 15:30:07', -19.0, 3);

INSERT INTO cycle (type, frequency, duration)
VALUES
    ('flashing', 24, 60),
    ('torsion', 7, 420),
    ('sound', 30, 1800);

INSERT INTO cycle_group (id_group, id_cycle)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

INSERT INTO cycle_fish (id_fish, id_cycle)
VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 3);

--SELECT * FROM fish ORDER BY size DESC LIMIT 2;