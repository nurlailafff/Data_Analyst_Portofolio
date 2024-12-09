
-- Data Cleaning

SELECT *
FROM top_200_instagrammers;

-- first thing to do is create a staging table. This is the one I will work in and clean the data. I want a table with the raw data in case something happens
create table top_200_instagrammers_staging
like top_200_instagrammers;

insert top_200_instagrammers_staging
select*
from top_200_instagrammers;
 
select* 
from top_200_instagrammers_staging;

-- let's check for duplicates

SELECT*,
		ROW_NUMBER() OVER (
			PARTITION BY username, "Channel name", country, url, 'main topic', 'main video category', likes, followers) AS row_num
	FROM 
		top_200_instagrammers_staging;
        
-- there is no duplicates, no need to delete anything


-- Standardize Data

SELECT * 
FROM top_200_instagrammers_staging;

SELECT DISTINCT country
FROM top_200_instagrammers_staging
ORDER BY country;

-- if we look at country it looks like we need to change the abbreviation into the realcountry name

SELECT top_insta_influencers_data.Country, top_200_instagrammers.Country
FROM top_insta_influencers_data
JOIN top_200_instagrammers
	ON top_insta_influencers_data.channel_info = top_200_instagrammers.Username;
    
-- update country name
UPDATE top_200_instagrammers_staging tp
JOIN topintasgramusercountry tk ON tp.username = tk.channel_info
SET tp.country = tk.country;

-- Check the country again to make sure everything is all set
select distinct country
from top_200_instagrammers_staging;

-- It seems that there are still some country names that are in abbreviated form
-- update the country name
select *
from top_200_instagrammers_staging 
where country='CO';

update top_200_instagrammers_staging
set country = 'Colombia'
where country like 'CO';

select *
from top_200_instagrammers_staging 
where country='US';

update top_200_instagrammers_staging
set country = 'United States'
where country like 'US';

select *
from top_200_instagrammers_staging 
where country='BR';

update top_200_instagrammers_staging
set country = 'Brazil'
where country like 'BR';


-- if we look at main topic it looks like we have some null and empty rows, let's take a look at these

SELECT *
FROM top_200_instagrammers_staging
WHERE `Main topic` IS NULL 
OR `Main topic` = "";

SELECT*
FROM top_200_instagrammers_staging;

-- update the empty main topic with the help of topictabel
UPDATE top_200_instagrammers_staging tp
JOIN topictabel tt ON tp.username = tt.username
SET tp.`Main topic`= tt.`Main topic`;

----------------------------------------------------------------
-- Delete Unused Columns

SELECT *
FROM top_200_instagrammers_staging;

ALTER TABLE top_200_instagrammers_staging 
DROP COLUMN `Main video category`, 
DROP COLUMN`Avg. 1 Day`, 
DROP COLUMN`Avg. 3 Day`, 
DROP COLUMN`Avg. 7 Day`, 
DROP COLUMN`Avg. 14 Day`, 
DROP COLUMN`Avg. 30 Day`;

ALTER TABLE top_200_instagrammers_staging 
DROP COLUMN `Channel Name`;
