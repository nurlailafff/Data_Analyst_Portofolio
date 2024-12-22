-- CAR SALES DATA EXPLORATION

-- Selecting Data that we are going to start with
SELECT *
FROM car_sales_dataset;

SELECT *
FROM car_sales_dataset
where name is null 
or year is null
or selling_price is null
or km_driven is null 
or fuel is null
or seller_type is null
or transmission is null
or owner is null;

-- Looking at Total Cars sold  each year
SELECT 
    year, 
    COUNT(year) AS car_sold
FROM 
    car_sales_dataset 
GROUP BY
    year
ORDER BY 
    car_sold DESC;
    
-- Looking at the total number of each car brand sold    
    SELECT 
    name, 
    COUNT(name) AS car_sold
FROM 
    car_sales_dataset 
GROUP BY
    name
ORDER BY 
    car_sold DESC;
  
-- Looking at the total of each type of car owner sold
SELECT 
    owner, 
    COUNT(owner) AS car_sold
FROM 
    car_sales_dataset 
GROUP BY
    owner
ORDER BY 
    car_sold DESC;
    
-- Looking at the total of each type of car transmission sold
SELECT 
    transmission, 
    COUNT(transmission) AS car_sold
FROM 
    car_sales_dataset 
GROUP BY
    transmission
ORDER BY 
    car_sold DESC;
 
-- Grouping car names by car model with adding a new column called 'car model' next to the car names
SELECT 
    name,
    SUBSTRING_INDEX(name, ' ', 1) AS car_model
FROM 
    car_sales_dataset;
    
ALTER TABLE car_sales_dataset
ADD COLUMN car_model VARCHAR(100);

UPDATE car_sales_dataset
SET car_model = SUBSTRING_INDEX(name, ' ', 1);

ALTER TABLE car_sales_dataset
MODIFY car_model VARCHAR(100) AFTER name;

select distinct year from car_sales_dataset order by year DESC ;