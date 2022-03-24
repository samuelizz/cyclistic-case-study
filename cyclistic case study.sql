-- Creating a database for the project called capstone.
CREATE DATABASE Capstone;

-- Using the database created 
USE capstone;

-- Creating the table for the cyclistic data

CREATE TABLE cyclistic(
ride_id TEXT NULL,
rideable_type VARCHAR(50) NULL,
started_at DATETIME NULL,
ended_at DATETIME NULL,
start_station_name TEXT NULL,
start_station_id VARCHAR(50) NULL,
end_station_name TEXT NULL,
end_station_id VARCHAR(50) NULL,
start_lat TEXT NULL,
start_lng TEXT NULL,
end_lat TEXT NULL,
end_lng TEXT NULL,
member_casual VARCHAR(20) NULL
);

-- example of the code used to import the csv data into the table created i.e the cyclistic table.
-- this was used to import the twelve months for the project i.e from march 2021 to feb 2022

LOAD DATA INFILE  '((file path)' 
INTO TABLE cyclistic FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- getting familiar with the data.
SELECT * FROM cyclistic LIMIT 100;
SELECT COUNT(DISTINCT ride_id) FROM cyclistic;

/* leaning the data 
 Deleting irrelevant columns
 columns to be dropped : ride_id, start_lat, start_lng, end_lat, end_lng
start_station_name, end_station_name, start_station_id, end_station_id
*/

ALTER TABLE cyclistic
DROP COLUMN ride_id;

ALTER TABLE cyclistic
DROP COLUMN start_lat;

ALTER TABLE cyclistic
DROP COLUMN start_lng;

ALTER TABLE cyclistic
DROP COLUMN end_lat; 

ALTER TABLE cyclistic
DROP COLUMN end_lng;

ALTER TABLE cyclistic
DROP COLUMN start_station_name;

ALTER TABLE cyclistic
DROP COLUMN end_station_name;

ALTER TABLE cyclistic
DROP COLUMN start_station_id;

ALTER TABLE cyclistic
DROP COLUMN end_station_id;

ALTER TABLE cyclistic
ADD COLUMN weekday INT AFTER ended_at;

-- Making the length of the member_casual columnn to be 6
UPDATE cylistic
SET member_casual = LEFT(member_casual, 6);

-- Checking for nulls in each column

SELECT * FROM cyclistic WHERE rideable_type IS NULL;
SELECT * FROM cyclistic WHERE started_at IS NULL;
SELECT * FROM cyclistic WHERE ended_at IS NULL;
SELECT * FROM cyclistic WHERE member_casual IS NULL;

-- The counts of the customer type
SELECT
	member_casual AS customer_type,
    COUNT(member_casual) AS counts
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1;

-- The counts of the rideable type
SELECT 
	rideable_type,
    COUNT(rideable_type) AS counts
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1;
    

-- Which rideable type is mostly used by the customer type?

SELECT
	member_casual AS customer_type,
    COUNT(CASE WHEN rideable_type = "classic_bike" THEN 1 ELSE NULL END) AS classic_bike,
    COUNT(CASE WHEN rideable_type = "electric_bike" THEN 1 ELSE NULL END) AS electric_bike,
    COUNT(CASE WHEN rideable_type = "docked_bike" THEN 1 ELSE NULL END) AS docked_bike    
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1;

-- What is the average ride length by customer type 
SELECT
	member_casual,
    ROUND(AVG(time_to_sec(TIMEDIFF(ended_at, started_at))),2) AS avg_ride_length_in_sec
FROM cyclistic
 WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0 
GROUP BY 1;


-- Number of rides taken per months in the last twelve months

SELECT
	YEAR(started_at) AS yr,
    MONTHNAME(started_at) AS month,
    COUNT(CASE WHEN member_casual = "member" THEN 1 ELSE NULL END) AS member,
    COUNT(CASE WHEN member_casual = "casual" THEN 1 ELSE NULL END) AS casual
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1,2;

-- Number of rides taken in different weekday for the last twelve months

SELECT
	-- YEAR(started_at) AS yr,
	-- MONTHNAME(started_at) AS month,
	CASE
		WHEN WEEKDAY(started_at) = 0 THEN 'Monday'
        WHEN WEEKDAY(started_at) = 1 THEN 'Tuesday'
        WHEN WEEKDAY(started_at) = 2 THEN 'Wednesday'
        WHEN WEEKDAY(started_at) = 3 THEN 'Thursday'
        WHEN WEEKDAY(started_at) = 4 THEN 'Friday'
        WHEN WEEKDAY(started_at) = 5 THEN 'Saturday'
        WHEN WEEKDAY(started_at) = 6 THEN 'Sunday'
        ELSE NULL 
	END AS dayname,
    COUNT(CASE WHEN member_casual = 'member' THEN member_casual ELSE NULL END) AS member,
    COUNT(CASE WHEN member_casual = 'casual' THEN member_casual ELSE NULL END) AS casual
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1;

 -- Number of the average ride length taken for different weekday for the last twelve months
 SELECT
	-- YEAR(started_at) AS yr,
	-- MONTHNAME(started_at) AS month,
	CASE
		WHEN WEEKDAY(started_at) = 0 THEN 'Monday'
        WHEN WEEKDAY(started_at) = 1 THEN 'Tuesday'
        WHEN WEEKDAY(started_at) = 2 THEN 'Wednesday'
        WHEN WEEKDAY(started_at) = 3 THEN 'Thursday'
        WHEN WEEKDAY(started_at) = 4 THEN 'Friday'
        WHEN WEEKDAY(started_at) = 5 THEN 'Saturday'
        WHEN WEEKDAY(started_at) = 6 THEN 'Sunday'
        ELSE NULL 
	END AS dayname,
    ROUND(AVG(CASE WHEN member_casual = 'member' THEN time_to_sec(TIMEDIFF(ended_at, started_at)) ELSE NULL END),2) AS member,
    ROUND(AVG(CASE WHEN member_casual = 'casual' THEN time_to_sec(TIMEDIFF(ended_at, started_at)) ELSE NULL END),2) AS casual
FROM cyclistic
WHERE time_to_sec(TIMEDIFF(ended_at, started_at)) > 0
GROUP BY 1;
    

 

