## how each country did in the past 15 years regarding Life expectancy?

SELECT Country, MIN(Lifeexpectancy), MAX(lifeexpectancy), ROUND(MAX(lifeexpectancy) - MIN(Lifeexpectancy),1) AS life_increase_15_years
FROM WLF 
GROUP BY country 
HAVING  MIN(Lifeexpectancy) <> 0 AND MAX(lifeexpectancy)<> 0 ## looks like we have a data quality issue where some countries have 0s
ORDER BY life_increase_15_years DESC;


## looking at the world overall, what is the average life time expectancy over the years?

SELECT year, ROUND(AVG(lifeexpectancy),1) as avg_life_expectancy
FROM WLF 
WHERE  Lifeexpectancy <> 0 
GROUP BY year 
ORDER BY Year; 


## Correlation - Does the GDP have an effect on the life expectancy?
## We can add the results in different buckets ( categorize them) using a case statement 

SELECT Country, ROUND(AVG(lifeexpectancy),1) as avg_life_expectancy , ROUND(AVG(GDP),1) AS AVG_GDP 
FROM WLF
GROUP BY country 
HAVING AVG_GDP <> 0 AND avg_life_expectancy <> 0 
ORDER BY AVG_GDP;

-- pretty positive correlation as life expectancy dramatically increases when GDP increases 
-- can also see it much easier if we were to import it to Tableau for example 

## We can add the results in different buckets ( categorize them at approx halfpoint) using a case statement 
SELECT 
SUM(CASE WHEN GDP >=1500 THEN 1  ELSE 0 END) High_GDP_Count,
AVG( CASE WHEN GDP >= 1500 THEN lifeexpectancy ELSE NULL END) High_GDP_life_Expectancy,
SUM(CASE WHEN GDP <=1500 THEN 1  ELSE 0 END) Low_GDP_Count,
AVG( CASE WHEN GDP <= 1500 THEN lifeexpectancy ELSE NULL END) Low_GDP_life_Expectancy
FROM WLF;
-- we can do this with all the columns and analyze the correlation 


## What is the average life expectancies between the statuses we have?

SELECT status, ROUND(AVG(lifeexpectancy),1) as avg_life_exp
FROM WLF 
GROUP BY status;

-- this does not really show the real difference because we do not know how many countries are in each( developed, & developing) 

SELECT status, COUNT( DISTINCT Country) as country_count , ROUND(AVG(lifeexpectancy),1) as avg_life_exp
FROM WLF 
GROUP BY status; 

-- since there are fewer countries that are developed; numbers are skewed in favor for the developed countries since we can keep this high avg

## BMI based on each country? is there any correlation?

SELECT Country, ROUND(AVG(lifeexpectancy),1) as avg_life_expectancy , ROUND(AVG(BMI),1) AS BMI
FROM WLF
GROUP BY country 
HAVING BMI <> 0 AND avg_life_expectancy <> 0 
ORDER BY BMI DESC;


### How many people are dying each year in a country compared to their lifeexpectancy? using the rolling total

SELECT Country, Year, Lifeexpectancy, adultmortality,
SUM(AdultMortality) OVER (PARTITION BY Country ORDER BY Year) AS rolling_total ## the order by year makes sure they are added sequentially and not randomly 
FROM WLF 






