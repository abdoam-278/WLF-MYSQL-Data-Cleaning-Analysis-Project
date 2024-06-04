### 1. Removing Duplicates 

SELECT row_id, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM WLF 
group by row_id, country, year
HAVING COUNT(CONCAT(country, year)) > 1;

##  OR since we have unique row ids, we can partition by row number and find number 2, since we cant have a filter we create a subquery to be able to filter 

SELECT *
FROM ( 
SELECT row_id, CONCAT(country, year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) as Row_num
FROM WLF) as row_table 
WHERE row_num > 1; 

DELETE FROM WLF 
WHERE ROW_ID IN (
SELECT row_id
FROM ( 
SELECT row_id, CONCAT(country, year),
ROW_NUMBER() OVER( PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) as Row_num
FROM WLF) as row_table 
WHERE row_num > 1); 


## 2. Find blanks & NUlls 

SELECT * 
FROM WLF 
WHERE status = '';

SELECT DISTINCT status
FROM WLF 
WHERE status <> ''; ## investigating 

SELECT DISTINCT(Country) 
FROM WLF 
WHERE status = 'Developing';

UPDATE WLF 
SET status = 'Developing' 
WHERE country IN ( 
					SELECT DISTINCT(Country) 
					FROM WLF 
					WHERE status = 'Developing'); ## we cant specify target table or update in the FROM clause, we cant use the subquery 
                    
## WORKAROUND 

UPDATE WLF t1
JOIN WLF t2
	ON t1.country = t2.country ## where Afghanistan = Afghanistan 
SET t1.status = 'Developing' 
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing' ;

                    
UPDATE WLF t1
JOIN WLF t2
	ON t1.country = t2.country ## where Afghanistan = Afghanistan 
SET t1.status = 'Developed' 
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed' ;
                    
 ## updating blank values for lifeexpectancy
## thought process, since its steadily increasing across the years we can take the avg of the before/after year values 

SELECT * 
FROM WLF
WHERE Lifeexpectancy = ''; ## investigating 

SELECT t1.Country, t1.Year , t1.Lifeexpectancy,
t2.Country, t2.Year , t2.Lifeexpectancy,  
t3.Country, t3.Year , t3.Lifeexpectancy, 
ROUND((t2.lifeexpectancy + t3.lifeexpectancy)/ 2,1)
FROM WLF t1
JOIN WLF t2 
ON t1.country = t2.country AND t1.Year = t2.Year - 1
JOIN WLF t3
ON t1.country = t3.country AND t1.Year = t3.Year + 1 
Where t1.lifeexpectancy = '';


UPDATE WLF t1
JOIN WLF t2 
ON t1.country = t2.country AND t1.Year = t2.Year - 1
JOIN WLF t3
ON t1.country = t3.country AND t1.Year = t3.Year + 1 
SET t1.lifeexpectancy = ROUND((t2.lifeexpectancy + t3.lifeexpectancy)/ 2,1)
WHERE t1.lifeexpectancy = ''  ;                 
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    