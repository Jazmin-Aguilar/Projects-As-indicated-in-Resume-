-- Data Cleaning--

--Create Table--

CREATE TABLE layoffs
(
company text,
location text,
industry text,
total_laid_off text,
percentage_laid_off text,
date Date,
stage text,
country text,
funds_raised_millions text
);


--Import csv file-- 

COPY layoffs 
FROM 'C:\Users\Public\layoffs.csv'
WITH (FORMAT CSV, HEADER);


SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns or rows



CREATE TABLE layoffs_staging
AS TABLE layoffs;




SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, date) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)

SELECT * 
FROM duplicate_cte
WHERE row_num >1;



SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


CREATE TABLE layoffs_staging2
(
company text,
location text,
industry text,
total_laid_off text,
percentage_laid_off text,
date date,
stage text,
country text,
funds_raised_millions text,
row_num INT
);

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

INSERT  INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


DELETE  
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;


--Standardzing data

SELECT company, TRIM(company)
FROM layoffs_staging2


UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


--update 'NULL' AS NULL values

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = 'NULL';

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL';
 

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';



SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


--update values that are null in industry by 'joining' columns with same company
UPDATE layoffs_staging2 t1
SET industry = t2.industry
FROM layoffs_staging2 t2
WHERE 
	t1.company = t2.company AND
	t1.industry IS NULL AND
	t2.industry IS NOT NULL;

	
	
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL;



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
