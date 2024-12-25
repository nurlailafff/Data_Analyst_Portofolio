-- CAR SALES DATA EXPLORATION

-- Selecting Data that we are going to start with
SELECT *
FROM car_sales_dataset;

-- Identify null values 
SELECT *
FROM car_sales_dataset
where name is null or " " 
or year is null or " " 
or selling_price is null or " " 
or km_driven is null or " " 
or fuel is null or " " 
or seller_type is null or " " 
or transmission is null or " " 
or owner is null or " " ;
-- There is no null or empty values 

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

-- overview of car dataset --
-- top selling car model by price --
SELECT Car_Model,
SUM(Selling_price) AS total_sales
FROM Car_sales_dataset
GROUP BY Car_Model
ORDER BY total_sales DESC
limit 1;

-- top selling car model by unit sold
SELECT car_model, 
    COUNT(car_model) AS unit_sold
FROM Car_sales_dataset
GROUP BY car_model
ORDER BY unit_sold DESC
limit 1;

-- Looking at the number of cars sold based on the year of manufacture
SELECT year, 
COUNT(year) AS car_sold
FROM car_sales_dataset 
GROUP BY year
ORDER BY car_sold DESC;

-- Looking at the total number of each car brand sold    
SELECT name, 
COUNT(name) AS car_sold
FROM car_sales_dataset 
GROUP BY name
ORDER BY car_sold DESC;
  
-- Looking at the total of each type of car owner sold
SELECT owner, 
COUNT(owner) AS car_sold
FROM car_sales_dataset 
GROUP BY owner
ORDER BY car_sold DESC;
    
-- Looking at the total of each type of car transmission sold
SELECT transmission, 
COUNT(transmission) AS car_sold
FROM car_sales_dataset 
GROUP BY transmission
ORDER BY car_sold DESC;

-- sales performance analysis --
SELECT
name, 
Car_model,
Year,
 COUNT(name) AS unit_sold
FROM car_sales_dataset
GROUP BY 
name,
Car_model,
Year
ORDER BY unit_sold DESC
Limit 10;


    
-- Customer preferencese --
SELECT
name,
Car_model,
fuel,
transmission,
COUNT(name) AS unit_sold
FROM car_sales_dataset
GROUP BY 
name,
car_model,
fuel,
transmission
ORDER BY unit_sold DESC
Limit 10;
    
-- Market trend analysis
SELECT 
name,
Car_model,
Transmission,
Fuel,
Year,
Count(name) AS unit_sold
FROM car_sales_dataset
GROUP BY
name,
Car_model,
Transmission,
Fuel,
Year
ORDER BY 
unit_sold DESC
Limit 10;
 