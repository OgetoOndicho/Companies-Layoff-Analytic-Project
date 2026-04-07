-- Create A Database to host our data --
CREATE DATABASE NBO_TECH_LTD;

-- Authorise the database for use --
USE nbo_tech_ltd;

-- Using the Table import wizard, import data into the DB in the table named employees_layoffs
-- Have a brief overview of our data  by using the SELECT Statement  --
SELECT * FROM employees_layoffs;

-- Create a duplicate copy of our data in a duplicate table --
CREATE TABLE employees_layoffs_copy
LIKE employees_layoffs;

-- Copy data from the original table to the new table --
INSERT INTO employees_layoffs_copy
SELECT * FROM employees_layoffs;

-- View our data in the new table created --
SELECT * FROM employees_layoffs_copy;

-- Find the total count of data --
SELECT COUNT(*) as Total_entries
FROM employees_layoffs_copy;


-- PART A: DATA CLEANING --
-- Inspect for NULL Values inside our data --employees_layoffs
SELECT * FROM employees_layoffs_copy
WHERE company IS NULL
	OR location IS NULL
    OR industry IS NULL
    OR total_laid_off IS NULL
    OR percentage_laid_off IS NULL
    OR date IS NULL
    OR stage IS NULL
    OR country IS NULL
    OR funds_raised_millions IS NULL;
    
-- To make changes to the database lets authorize the database to allow changes to be made --
SET sql_safe_updates = 0;

-- Now that we have identified NULLS, Get rid of the NULLS --

DELETE FROM employees_layoffs_copy
WHERE company IS NULL
	OR location IS NULL
    OR industry IS NULL
    OR total_laid_off IS NULL
    OR percentage_laid_off IS NULL
    OR date IS NULL
    OR stage IS NULL
    OR country IS NULL
    OR funds_raised_millions IS NULL;
    
    
-- What is the Total Count after NULLS Have been eliminated --
SELECT COUNT(*) AS Total_entries
FROM employees_layoffs_copy;

SELECT * FROM employees_layoffs_copy;

-- Let us add Column_ID for unique data identification --
ALTER TABLE employees_layoffs_copy
MODIFY employee_ID INT AFTER company;

SELECT * FROM employees_layoffs_copy;

-- SET the employee_ID AS the first_column --
ALTER TABLE employees_layoffs_copy
MODIFY COLUMN company VARCHAR(255) AFTER employee_ID;

-- Rename the 'Date' column to 'Layoff_date' --
ALTER TABLE employees_layoffs_copy
RENAME COLUMN date TO Layoff_date;

-- Have a glance at Columns data types and Make modifications --
DESCRIBE employees_layoffs_copy;

-- Change data types for some of the columns --
UPDATE employees_layoffs_copy
SET Layoff_date = 
	CASE
		WHEN Layoff_date LIKE '%/%' THEN date_format(STR_TO_DATE( Layoff_date, '%m/%d/%Y'), '%Y/%m/%d')
        ELSE NULL 
        END;
-- Adjust Layoff Column to date data type --
ALTER TABLE employees_layoffs_copy
MODIFY COLUMN Layoff_date DATE;


-- Check and Remove Duplicates if any --
SELECT *, 
	ROW_NUMBER() OVER 
		( PARTITION BY employee_ID,company, location, industry, total_laid_off, percentage_laid_off, Layoff_date, stage, country, funds_raised_millions) 
AS row_num
FROM employees_layoffs_copy;

-- USE CTES to identify any duplicates --
WITH Duplicates_cte AS
(
    SELECT *, 
	ROW_NUMBER() OVER 
		( PARTITION BY employee_ID,company, location, industry, total_laid_off, percentage_laid_off, Layoff_date, stage, country, funds_raised_millions) 
AS row_num
FROM employees_layoffs_copy
)
SELECT * FROM Duplicates_cte
WHERE row_num > 1;

SELECT * FROM employees_layoffs_copy;
    

 



