-- data cleaning

use layoffs;

select*from LAYOFFS;

CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `ROW_NUM` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*FROM LAYOFFS2;
INSERT INTO LAYOFFS2
SELECT *,
ROW_NUMBER() OVER( PARTITION BY COMPANY,INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF,'DATE') AS ROW_NUM FROM LAYOFFS;

#EXPLORATARY ANALYSIS 

-- 1. HOW MANY LAYOFFS HAPPENED PER COUNTRY?

SELECT country , sum(total_laid_off) 
as total_layoffs 
from layoffs2
group by country 
order by total_layoffs desc 
limit 10; 

-- 2. which industry faced the highest number of layoffs?

SELECT industry , sum(total_laid_off) 
as total_layoffs 
from layoffs2 
group by industry 
order by total_layoffs desc; 


-- 3 which companies laid off more than certain threshold of employees (e,g 5000) 

select company, total_laid_off 
from layoffs2 
where total_laid_off>5000
order by total_laid_off desc; 

-- 4 what is the average percentage of workforce 

select industry, avg(percentage_laid_off) as avg_percentage_laid_off 
from layoffs2 
group by industry 
order by avg_percentage_laid_off desc;

-- 5 what are the top 10 companies with the most layoffs?

select company, total_laid_off 
from layoffs2
order by total_laid_off desc 
limit 10; 

-- 6 what is the total number of layoffs across all compaines ?

select sum(total_laid_off) AS total_offs 
from layoffs2; 

-- 7 how many layoffs occured in each funding  stage (e.g, Post-IPO, Series B )?

select stage, COUNT(*) as num_layoffs 
from layoffs2 
group by stage 
order by num_layoffs desc; 

-- 8. which country raised the highest amount of funds ? 

select country, SUM(funds_raised_millions) 
as total_fund_raised
from layoffs2
group by country 
order by total_fund_raised desc 
limit 10; 


-- 9 which companies had layoffs with missing data for percentage laid off? 

select company, total_laid_off 
from layoffs2
where percentage_laid_off is null 
order by total_laid_off desc; 

-- 10 how many layoffs occurred in a specific time period (e.g. , 2023) ? 

select count(*) as layoffs_in_2023 
from layoffs2
where YEAR(date) = 2023; 

-- 11. which countries have the higest percentage of layoffs relative to their total workforce ? 

select country, round(avg(percentage_laid_off),2) as avg_percentage_laid_off 
from layoffs2
group by country
order by avg_percentage_laid_off desc
limit 10; 

-- 12. what is the distribution of layoffs accross different locations (cities)? 

select location,count(*) as num_offs 
from layoffs2 
group by location 
order by num_offs desc; 

-- 13. what are the top 5 industries that raised the most funds and had layoffs ? 

select industry,sum(funds_raised_millions) 
as total_funds_raised 
from layoffs2
where total_laid_off>0 
group by industry 
order by total_funds_raised desc 
limit 5; 


-- 14. maximum of total_laid_off and percentage_laid_off ? 

select max(total_laid_off), 
max(percentage_laid_off)
FROM layoffs2; 


-- 15. layoffs from start date to end date ? 

select min(date),max(date)
from layoffs2;

-- 16.  Sum of total_laid_off by year? 

select year(date),sum(total_laid_off) 
from layoffs2 
group by year(date) 
order by 1 desc;

SELECT INDUSTRY ,STAGE,SUM(TOTAL_LAID_OFF) AS TOTAL_LAYOFFS FROM LAYOFFS2 group by INDUSTRY,STAGE 
ORDER BY INDUSTRY;


------------------------ THE END -------------------------------


