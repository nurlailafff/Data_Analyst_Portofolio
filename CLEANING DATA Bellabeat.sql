-- CLEANING DATA
--check number of users
SELECT 
  COUNT( DISTINCT Id)
FROM
  `portofoliopj.Bellabeat.dailyactivity`; -- 33


SELECT 
  COUNT(DISTINCT Id)
FROM 
  `portofoliopj.Bellabeat.hourly_steps`; --33
  
  
SELECT 
  COUNT(DISTINCT Id)
FROM 
  `portofoliopj.Bellabeat.dailysleep`; -- 24

SELECT 
  COUNT(DISTINCT Id)
FROM 
  `portofoliopj.Bellabeat.hourly_calories`; -- 33

--check start-end date and id
SELECT 
  MIN(ActivityDate) as start_date,
  MAX(ActivityDate) as end_date
FROM 
  `portofoliopj.Bellabeat.dailyactivity`;

SELECT 
  MIN(SleepDay) as start_date,
  MAX(SleepDay) as end_date
FROM 
  `portofoliopj.Bellabeat.dailysleep`;

SELECT 
  MIN(ActivityHour) as start_date,
  MAX(ActivityHour) as end_date
FROM 
  `portofoliopj.Bellabeat.hourly_steps`;

SELECT 
  MIN(ActivityHour) as start_date,
  MAX(ActivityHour) as end_date
FROM 
  `portofoliopj.Bellabeat.hourly_calories`;

  -- daily activity, daily sleep, hourlysteps are same startdate: 2016-04-12, enddate: 2016-05-12. 31 days in total (bedaa)

--check all ids have the same length
SELECT 
LENGTH(CAST(Id as STRING)) AS length_Id
FROM `portofoliopj.Bellabeat.dailyactivity`;  
-- All Id have the same length (10)

SELECT 
LENGTH(CAST(Id as STRING)) AS length_Id
FROM `portofoliopj.Bellabeat.dailysleep`;  
-- All Id have the same length (10)

SELECT 
LENGTH(CAST(Id as STRING)) AS length_Id
FROM `portofoliopj.Bellabeat.hourly_steps`;  
-- All Id have the same length (10)

SELECT 
LENGTH(CAST(Id as STRING)) AS length_Id
FROM `portofoliopj.Bellabeat.hourly_calories`;  
-- All Id have the same length (10)

--Check the duplicate
SELECT 
  Id,
  ActivityDate,
  COUNT(*) as num_of_id
FROM 
  `portofoliopj.Bellabeat.dailyactivity`
GROUP BY
  Id, ActivityDate
HAVING 
  num_of_id > 1;

-- no data to display / no duplicates were found in daily_activity

SELECT 
  Id,
  SleepDay,
  COUNT(*) as num_of_id
FROM 
  `portofoliopj.Bellabeat.dailysleep`
GROUP BY
  Id, SleepDay
HAVING 
  num_of_id > 1;

--displays 3 duplicates

SELECT 
  Id,
  ActivityHour,
  COUNT(*) as num_of_id
FROM 
  `portofoliopj.Bellabeat.hourly_steps`
GROUP BY
  Id, ActivityHour
HAVING 
  num_of_id > 1;
-- no data to display / no duplicates were found in daily_activity


SELECT 
  Id,
  ActivityHour,
  COUNT(*) as num_of_id
FROM 
  `portofoliopj.Bellabeat.hourly_calories`
GROUP BY
  Id, ActivityHour
HAVING 
  num_of_id > 1;
-- no data to display / no duplicates were found in daily_activity

--Duplicate rows in dailysleep table need to be removed
CREATE table `portofoliopj.Bellabeat.dailysleep_new`
AS
SELECT DISTINCT * 
FROM `portofoliopj.Bellabeat.dailysleep`;

-- Check it again if it the new table had no duplicates
SELECT
  Id,
  SleepDay,
  COUNT(*) as num_of_id
FROM `portofoliopj.Bellabeat.dailysleep_new`
GROUP BY
  Id, SleepDay
HAVING 
  num_of_id > 1;

-- no data display/ no duplicates

--During the checking and cleaning process, I found that there were some zero data in TotalSteps column inside the daily_activity dataset. Therefore, I decided to check and remove those zero value. I created new table and named it daily_activity_new, so that the previous dataset still remained.

--Check if total steps = 0 in dailyactivity table
SELECT 
  Id, 
  Count(*) as num_of_zero_steps
FROM `portofoliopj.Bellabeat.dailyactivity`
WHERE 
  TotalSteps = 0
GROUP BY Id
ORDER BY num_of_zero_steps;

-- 15 ids with 0 total steps

-- Create new daily activity table 
CREATE TABLE `portofoliopj.Bellabeat.dailyactivity_new` AS
SELECT *
FROM `portofoliopj.Bellabeat.dailyactivity`
WHERE TotalSteps <> 0;
--new table is created and there are no Total Steps with 0 value

--Check it again if total steps = 0 in dailyactivity_new table
SELECT 
  Id, 
  Count(*) as num_of_zero_steps
FROM `portofoliopj.Bellabeat.dailyactivity_new`
WHERE 
  TotalSteps = 0
GROUP BY Id
ORDER BY num_of_zero_steps;
-- no data display/ no total steps = 0

--Check if total steps = 0 in Hourly_steps table
SELECT 
  Id, 
  Count(*) as num_of_zero_steps
FROM `portofoliopj.Bellabeat.hourly_steps`
WHERE 
  StepTotal = 0
GROUP BY Id
ORDER BY num_of_zero_steps;
-- 33 ids with 0 total steps

-- Create new hourly_steps table 
CREATE TABLE `portofoliopj.Bellabeat.hourly_steps_new` AS
SELECT *
FROM `portofoliopj.Bellabeat.hourly_steps`
WHERE StepTotal <> 0;
--new table is created and there are no Total Steps with a value of 0

--Check it again if total steps = 0 in hourly_steps_new table
SELECT 
  Id, 
  Count(*) as num_of_zero_steps
FROM `portofoliopj.Bellabeat.hourly_steps_new`
WHERE 
  StepTotal = 0
GROUP BY Id
ORDER BY num_of_zero_steps;
-- no data display/ no total steps = 0
-- 7535 data deleted

--Check if calories = 0 in Hourly_calories table
SELECT 
  Id, 
  Count(*) as num_of_zero_calories
FROM `portofoliopj.Bellabeat.hourly_calories`
WHERE 
  Calories=0
GROUP BY Id
ORDER BY num_of_zero_calories;
-- no data display/ no calloris = 0

--Check for null data
SELECT *
FROM `portofoliopj.Bellabeat.dailyactivity_new`
WHERE Id IS NULL;
-- no data display

SELECT *
FROM `portofoliopj.Bellabeat.dailysleep_new`
WHERE Id IS NULL;
-- no data display

SELECT *
FROM `portofoliopj.Bellabeat.hourly_steps_new`
WHERE Id IS NULL;
-- no data display

SELECT *
FROM `portofoliopj.Bellabeat.hourly_calories`
WHERE Id IS NULL;
-- no data display