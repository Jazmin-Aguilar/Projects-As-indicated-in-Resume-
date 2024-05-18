/* Name:Jazmin Aguilar
    DTSC660: Data and Database Managment with SQL
    Module 8
    Assignment 7

	Netflix data set
	I enjoy watching my shows on Netflix so I figuired it would be cool to analyze the data from Netflix*/

/* PART 1
Created a table for the Netflix csv file*/

CREATE TABLE netflix (
show_id varchar(40),
type text,
title text,
director text,
country text,
date_added date,
release_year int,
rating varchar(40),
duration varchar(40),
listed_in text
);	

/*COPY COMMAND*/

COPY netflix
FROM 'C:\Users\Public\netflix.csv'
WITH (FORMAT CSV, HEADER);

SELECT * FROM netflix;
SELECT COUNT(show_id) FROM netflix;
SELECT COUNT(director) FROM netflix;

/*Question 1*/

CREATE TABLE netflix_backup AS SELECT * FROM netflix;

/*Question 2 */

ALTER TABLE netflix ADD genre text;
UPDATE netflix SET genre = listed_in;

/*Question 3 */
/*Updating Null values in director column, as 'Not Given' is a Null value*/

SELECT director FROM netflix;
UPDATE netflix
SET director = NULL
WHERE director = 'Not Given';

/*Question 4  */
/*Updating the Null value in country column as 'Not Given' is a Null value, then deleting the rows that have the null in country*/

SELECT country FROM netflix;

UPDATE netflix
SET country = NULL
WHERE country = 'Not Given';

DELETE FROM netflix
WHERE country IS NULL;
SELECT * FROM netflix;

/*Question 5
I noticed that the listed_in columns have multiple genres for the ones that have 'Action & Adventure' I will 
be cutting down the genre to the first one listed, so anything that starts with 'Action & Adventure' will 
only be Action & Adventure*/

SELECT listed_in,count(listed_in) FROM netflix
GROUP BY listed_in
ORDER BY listed_in;

/*Actual command */
UPDATE netflix
SET listed_in = 'Action & Adventure'
WHERE listed_in ILIKE ('Action & Adventure%_%');



/*Question 6,  I looked at the ratings and saw that there is TV-Y7 and TV-Y7-FV, which is essentially the same rating as 
TV-Y7 as both are intended for kids of age 7 and above, SO I will be making TV-Y7-FV to be TV-Y7 */

UPDATE netflix
SET rating = 'TV-Y7'
WHERE rating ILIKE ('TV-Y7-FV');

/*Question 7-
I will be sorting the min and season in the duration column and will be making two seperate columns, one as 'movie_times' and
the other as 'seasons' this would help differentiate movie times versus shows and their seasons. We would then be able to analyze
each category as their own and even sort it further by time(30 min vs 1 hour vs. 1 hour and 3 min etc.)and 
see each show by how many seasons they had and many compare shows run time among each other */

SELECT * FROM netflix;
/*First create the two new columns then move appropiate data to each column*/
ALTER TABLE netflix ADD COLUMN movie_times text;
ALTER TABLE netflix ADD COLUMN seasons text;

UPDATE netflix
SET movie_times = duration
WHERE duration ILIKE ('%_%min');
UPDATE netflix
SET seasons = duration
WHERE duration ILIKE ('%_%season%_%') OR duration = '1 Season';