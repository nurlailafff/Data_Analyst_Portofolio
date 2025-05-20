##Classifying users based on their average daily steps
--Creating temp table for the mean of daily steps
WITH
  daily_average AS (
  SELECT
    Id,
    AVG(TotalSteps) AS totalsteps_mean,
  FROM
    `portofoliopj.Bellabeat.dailyactivity_new`
  GROUP BY
    Id
  ORDER BY
    totalsteps_mean  
  
),
--After getting all the total mean, we will now categorize each user base on User Level 
 users AS (
SELECT 
  Id, 
  AVG(totalsteps_mean) as avg_total_steps,
  CASE
  WHEN AVG(totalsteps_mean) < 5000 THEN 'Sedentary'
  WHEN AVG(totalsteps_mean) BETWEEN 5001 AND 7500 THEN 'Lightly Active'
  WHEN AVG(totalsteps_mean) BETWEEN 7501 AND 10000 THEN 'Fairly Active'
  WHEN AVG(totalsteps_mean) > 10000 THEN 'Very Active'
  END AS user_type
FROM daily_average
GROUP BY
  Id
ORDER BY avg_total_steps

),
 user_level_counts AS (
    SELECT user_type, COUNT(*) AS total
    FROM users
    GROUP BY user_type
  ),
  total_user_level_counts AS (
    SELECT SUM(total) AS total_user_level
    FROM user_level_counts
  ),
  user_level_percentages AS (
    SELECT user_type, CAST(total AS FLOAT64) / total_user_level_counts.total_user_level AS user_percentage
    FROM user_level_counts, total_user_level_counts
    WHERE 1 = 1
  )
SELECT user_type,
user_percentage,
FROM user_level_percentages;

##USER ACTIVITY BY HOURS AND DAYS
--Check the total steps for each hour
SELECT 
    EXTRACT(HOUR FROM PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour)) AS hour,
    SUM(StepTotal) AS total_steps_by_hour
FROM 
    `portofoliopj.Bellabeat.hourly_steps_new`
GROUP BY 
    hour
ORDER BY 
    hour;

--Check the average total steps and average minutes asleep for each day.
WITH
-- Merging two tables
daily_activity_sleep AS (
  SELECT
    TotalSteps,
    TotalMinutesAsleep,

    dailyactivity_new.Id AS id,
    dailyactivity_new.ActivityDate AS date
  FROM 
    `portofoliopj.Bellabeat.dailyactivity_new` AS dailyactivity_new
  INNER JOIN 
    `portofoliopj.Bellabeat.dailysleep_new` AS dailysleep_new
  ON
    dailyactivity_new.Id = dailysleep_new.Id AND
    dailyactivity_new.ActivityDate = DATE(PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', dailysleep_new.SleepDay))
)

-- Find the average of Total steps and Total minutes asleep per week
SELECT 
  day_of_week, 
  ROUND(AVG(TotalSteps), 2) AS ave_totalsteps_perday,
  ROUND(AVG(TotalMinutesAsleep), 2) AS ave_minutesasleep_perday
FROM (
  SELECT *,
    CASE
      WHEN EXTRACT(DAYOFWEEK FROM date) = 1 THEN 'Mon'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 2 THEN 'Tue'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 3 THEN 'Wed'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 4 THEN 'Thu'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 5 THEN 'Fri'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 6 THEN 'Sat'
      WHEN EXTRACT(DAYOFWEEK FROM date) = 7 THEN 'Sun'
    END AS day_of_week,
    EXTRACT(DAYOFWEEK FROM date) AS day_order
  FROM daily_activity_sleep
)
GROUP BY day_of_week,day_order
ORDER BY day_order;

##DEVICE USAGE
--Categorization of users by usage (in days)
(SELECT Id,
COUNT(Id) AS Total_Logged_Uses,
CASE
WHEN COUNT(Id) BETWEEN 20 AND 31 THEN 'Active User'
WHEN COUNT(Id) BETWEEN 11 and 20 THEN 'Moderate User'
WHEN COUNT(Id) BETWEEN 0 and 10 THEN 'Light User'
END Fitbit_Usage_Type
FROM `portofoliopj.Bellabeat.dailyactivity_new`
GROUP BY Id);

--check the percentage of users who achieved full 1 month usage (all day wear)
WITH User_Usage AS (
    SELECT 
        Id,
        COUNT(Id) AS Total_Logged_Uses
    FROM 
        `portofoliopj.Bellabeat.dailyactivity_new`
    GROUP BY 
        Id
)

SELECT 
    COUNT(CASE WHEN Total_Logged_Uses = 31 THEN 1 END) * 100.0 / COUNT(*) AS Percentage_All_Day_Wearers
FROM 
    User_Usage;