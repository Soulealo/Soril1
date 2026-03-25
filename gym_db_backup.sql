DROP DATABASE IF EXISTS gym_db;
CREATE DATABASE gym_db;
USE gym_db;

CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL
);

CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    trainer_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type VARCHAR(50),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    check_in DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

INSERT INTO trainers (name, specialization, phone) VALUES
('Bat-Erdene', 'Fitness', '99112233'),
('Saraa', 'Yoga', '99113344');

INSERT INTO members (name, email, phone, join_date) VALUES
('Anu', 'anu@mail.com', '88112233', '2024-01-10'),
('Bold', 'bold@mail.com', '88113344', '2024-02-15'),
('Temuulen', 'temuulen@mail.com', '88114455', '2024-03-01');

INSERT INTO subscriptions (member_id, trainer_id, start_date, end_date, type) VALUES
(1, 1, '2024-01-10', '2024-04-10', 'Monthly'),
(2, 1, '2024-02-15', '2024-05-15', 'Monthly'),
(3, 2, '2024-03-01', '2024-06-01', 'Yoga');

INSERT INTO attendance (member_id, check_in) VALUES
(1, '2024-03-01'),
(1, '2024-03-02'),
(2, '2024-03-01'),
(3, '2024-03-01'),
(3, '2024-03-02'),
(3, '2024-03-03');

SELECT m.name AS member_name,
       t.name AS trainer_name,
       s.type,
       s.start_date,
       s.end_date
FROM subscriptions s
JOIN members m ON s.member_id = m.member_id
JOIN trainers t ON s.trainer_id = t.trainer_id;

SELECT t.name AS trainer_name,
       COUNT(s.member_id) AS total_members
FROM trainers t
LEFT JOIN subscriptions s ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.name;

SELECT t.name, COUNT(s.member_id) AS total_members
FROM trainers t
JOIN subscriptions s ON t.trainer_id = s.trainer_id
GROUP BY t.trainer_id, t.name
ORDER BY total_members DESC
LIMIT 1;

SELECT m.name, COUNT(a.attendance_id) AS visits
FROM members m
JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(a.attendance_id) >= 2;

DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'report_user'@'localhost';

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'password123';
CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'password123';

GRANT ALL PRIVILEGES ON gym_db.* TO 'admin_user'@'localhost';
GRANT SELECT ON gym_db.* TO 'report_user'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'report_user'@'localhost';