/* CRUD TO REQUESTS TYPE COMPARATION:

CREATE -> POST REQUEST
READ -> GET REQUEST
UPDATE -> UPDATE/PATCH REQUEST
DELETE -> DELETE REQUEST
*/

/* TEST DATA FOR TODAY
CHARLOTTE 2145 POINTS
MAX 2135 POINTS
JOHN 1875 POINTS
SLEEPY BUNNY 1900
NOACH 1780

We'll create a table with this information
name, sketchful_id, student_id, points, rank, email
*/

/* CREATE A DATABASE*/
CREATE DATABASE sketchful;

/* DROP/ DELETE DATABASE */
DROP DATABASE sketchful;

/* CREATE A TABLE INSIDE OF THE DATABASE */

CREATE TABLE sketchful.game_december(
student_id INT,
student_name VARCHAR(120),
sketchful_name VARCHAR(120),
points INT,
student_rank INT,
email VARCHAR(80)
);

/* LET'S POPULATE THE TABLE */
INSERT INTO sketchful.game_december(
student_id, student_name, sketchful_name, points, student_rank, email
) VALUES
( 2345, "CHARLOTTE", "Charlotte", 2145, 1, "charlotte@gmail.com"), 
( 2346, "MAX", "Max", 2135, 2, "max@gmail.com");

/* Let's take a look at our populated data*/

SELECT *
FROM sketchful.game_december;

/* What happens if we add new entries that are repeating 
our primary key that should be unique? */
INSERT INTO sketchful.game_december(
student_id, student_name, sketchful_name, points, student_rank, email
) VALUES
( 2345, "John Doe", "Johnny Doe", 1000, 100, "johndoe@gmail.com"), 
( 2346, "Bonnie", "Bonnie", 1200, 110, "bonnie@gmail.com");

SELECT *
FROM sketchful.game_december;
/* Double values as we didn't precise student_id is 
the primary one and should be unique
*/

/* DROP OUR TABLE AND REBUILD WITH THE PROPER STRUCTURE */

DROP TABLE sketchful.game_december;
CREATE TABLE sketchful.game_december(
student_id INT PRIMARY KEY,
student_name VARCHAR(120) NOT NULL,
sketchful_name VARCHAR(120) UNIQUE,
points INT DEFAULT 0,
student_rank INT,
email VARCHAR(80)
);
SELECT *
FROM sketchful.game_december;

INSERT INTO sketchful.game_december(
student_id, student_name, sketchful_name, points, student_rank, email
) VALUES
( 2345, "CHARLOTTE", "Charlotte", 2145, 1, "charlotte@gmail.com"), 
( 2346, "MAX", "Max", 2135, 2, "max@gmail.com");

/* What happens if we add new entries that are repeating 
our primary key that should be unique? */
INSERT INTO sketchful.game_december(
student_id, student_name, sketchful_name, points, student_rank, email
) VALUES
( 2345, "John Doe", "Johnny Doe", 1000, 100, "johndoe@gmail.com"), 
( 2346, "Bonnie", "Bonnie", 1200, 110, "bonnie@gmail.com");

/* Not possible anymore to have double student id*/
SELECT *
FROM sketchful.game_december;

/*How to fail properly in case this table exists */
CREATE TABLE IF NOT EXISTS sketchful.game_december(
student_id INT PRIMARY KEY,
student_name VARCHAR(120) NOT NULL
);

/*Same for dropping a table*/
DROP TABLE IF EXISTS skecthful.game_november;

/*HOW TO  UPDATE A VALUE IN OUR TABLE USING THE PRIMARY KEY*/

UPDATE sketchful.game_december
SET student_name = "JOHN"
WHERE student_id = 2345;
 /*LETS LOOK AT THE UPDATE */
SELECT *
FROM sketchful.game_december;

/* LETS TRY TO UPDATE THE POINT BASED ON THE SKETCHFUL NAME VALUE */
UPDATE sketchful.game_december
SET points = 1875
WHERE student_name = 'JOHN';
/* NOT POSSIBLE AS STUDENT NAME NOT PRIMARY */

/* if we want to allow SQL to update not based on primary key */
set sql_safe_updates = 1;

/*DELETE ENTRY IN OUR TABLE */
DELETE FROM sketchful.game_december
WHERE student_id = 2345;
