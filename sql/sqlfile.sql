create database linkedin_job_market;
use linkedin_job_market;

CREATE TABLE postings (
    job_id BIGINT,
    company_id BIGINT,
    title VARCHAR(255),
    location VARCHAR(255),
    work_type VARCHAR(50),
    formatted_experience_level VARCHAR(50),
    max_salary DECIMAL(12,2),
    min_salary DECIMAL(12,2),
    med_salary DECIMAL(12,2),
    pay_period VARCHAR(20),
    city VARCHAR(100),
    annual_salary DECIMAL(12,2),
    industry VARCHAR(255)
);

ALTER TABLE postings ADD COLUMN name VARCHAR(255) AFTER annual_salary;

SHOW VARIABLES LIKE 'secure_file_priv';

select * from postings;

TRUNCATE TABLE postings;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_postings.csv'
INTO TABLE postings
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@job_id, @company_id, title, location, work_type, formatted_experience_level,
 @max_salary, @min_salary, @med_salary, pay_period, city, @annual_salary, @name, @industry)
SET
  job_id = IF(@job_id='', NULL, @job_id),
  company_id = IF(@company_id='', NULL, @company_id),
  max_salary = IF(@max_salary='', NULL, @max_salary),
  min_salary = IF(@min_salary='', NULL, @min_salary),
  med_salary = IF(@med_salary='', NULL, @med_salary),
  annual_salary = IF(@annual_salary='', NULL, @annual_salary),
  name = IF(@name='', NULL, @name),
  industry = IF(@industry='', NULL, @industry);

select count(*) from postings;

select * from postings limit 10;


select title , count(*) as total_postings
from postings
group by title
order by total_postings desc
limit 15;

CREATE TABLE job_skills (
    job_id BIGINT,
    skill_abr VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_skills.csv'
INTO TABLE job_skills
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select skill_abr,count(*) as top_skills
from job_skills
group by skill_abr
order by top_skills desc
limit 15;

select city,count(title) as data_analyst
from postings
where title like '%analyst%'
group by city
order by data_analyst desc
limit 15;

select work_type,count(*) as jobs_count,ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM postings), 2) AS percentage # round is to get percentage
from postings
group by work_type
order by jobs_count desc
limit 15;

select formatted_experience_level,avg(annual_salary) as annual_salary
from postings 
group by formatted_experience_level
order by annual_salary  desc
limit 15;

select industry,count(title) as no_analyst
from postings
where title like '%analyst%' and title is not null
group by industry
order by no_analyst desc
limit 15;