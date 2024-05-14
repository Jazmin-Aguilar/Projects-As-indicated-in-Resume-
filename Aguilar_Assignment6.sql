/*
    Name: Jazmin Aguilar
    DTSC660: Data and Database Managment with SQL
    Module 7
    Assignment 6


*/

--------------------------------------------------------------------------------
/*				                 Table Creation		  		          */
--------------------------------------------------------------------------------
CREATE TABLE customer_spending
(	date DATE,
	year INT,
	month varchar(40),
	customer_age INT,
	customer_gender varchar(1),
	country varchar(40),
	state varchar(40),
	product_category varchar(40),
	sub_category varchar(40),
	quantity INT,
	unit_cost decimal(10,2),
	unit_price decimal (10,6),
	cost INT,
	revenue INT
);

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
/*				                 Import Data           		  		          */
--------------------------------------------------------------------------------

COPY customer_spending
FROM 'C:\Users\Public\customer_spending.csv'
WITH (FORMAT CSV, HEADER);

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
/*				                 Question 1: 		  		          */
--------------------------------------------------------------------------------

SELECT product_category,SUM(revenue) AS total_revenue FROM customer_spending
GROUP BY product_category,year
HAVING year = 2016
ORDER BY product_category ASC;

--------------------------------------------------------------------------------
/*				                  Question 2           		  		          */
--------------------------------------------------------------------------------

SELECT sub_category,AVG(unit_price) AS avg_unit_price,AVG(unit_cost) AS avg_unit_cost, AVG(unit_price)-AVG(unit_cost) AS margin FROM customer_spending
GROUP BY sub_category,year
HAVING year = 2015
ORDER BY sub_category ASC;

--------------------------------------------------------------------------------
/*				                  Question 3           		  		          */
--------------------------------------------------------------------------------

SELECT customer_gender,COUNT(customer_gender) AS tot_num_female_buyers FROM customer_spending
WHERE product_category = 'Clothing'
GROUP BY customer_gender
HAVING customer_gender = 'F';

--------------------------------------------------------------------------------
/*				                  Question 4           		  		          */
--------------------------------------------------------------------------------

SELECT customer_age,sub_category,AVG(quantity) AS avg_quantity,AVG(cost) AS avg_cost FROM customer_spending
GROUP BY customer_age,sub_category
ORDER BY customer_age DESC, sub_category ASC;
--------------------------------------------------------------------------------
/*				                  Question 5           		  		          */
-------------------------------------------------------------------------------

SELECT country FROM
(SELECT country, COUNT(DISTINCT date) AS num_trans FROM customer_spending
WHERE customer_age >= 18 AND customer_age <= 25
GROUP BY country) AS trans
WHERE num_trans > 30;

--------------------------------------------------------------------------------
/*				                  Question 6           		  		          */
--------------------------------------------------------------------------------

SELECT sub_category, round(AVG(quantity),2) AS avg_quantity, round(AVG(unit_cost),2) AS avg_cost FROM customer_spending
GROUP BY sub_category
HAVING COUNT(*) >= 10
ORDER BY sub_category ASC;