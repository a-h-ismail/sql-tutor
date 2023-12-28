CREATE DATABASE sql_tutor;
USE sql_tutor;

CREATE TABLE Players (PlayerID int, HP int, Name varchar(255), Strength int, Class varchar(255));
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (8927412, 20, 'steel56', 100, 'light');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-1635515, 50, 'cloudseeker11', 200, 'medium');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (2121575, 25, 'bastion73', 50, 'light');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (6598247, 110, 'ace1%', 1000, 'heavy');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-3764183, 15, 'delta732', 100, 'light');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-1243723, 20, 'epsilon32', 100, 'light');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (5321686, 125, 'chariot746', 1250, 'heavy');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (3178214, 40, 'shadow_flight832', 200, 'medium');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (-5464515, 20, 'anvil153', 100, 'light');
INSERT INTO Players(PlayerID, HP, Name, Strength, Class) VALUES (2843295, 20, 'sparks87', 1000, 'heavy');

CREATE USER 'sql_tutor'@'localhost' IDENTIFIED BY '';
GRANT SELECT ON sql_tutor.* TO 'sql_tutor'@'localhost';

