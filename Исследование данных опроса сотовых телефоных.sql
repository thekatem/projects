SELECT *
FROM cellphones_data

UPDATE cellphones_data
SET cellphone_id = cast (cellphone_id as int)
-- update íå êîíâåðòèðóåò äàííûå, ïîýòîìó äëÿ óäîáñòâà, äàííûå áóäóò êîíâåðòèðîâàòüñÿ â çàïðîñå. 
 
-- òîï 5 ñàìûõ äîðîãèõ è äåøåâûõ óñòðîéñòâ è ñðåäíèé ðåéòèíã óñòðîéñòâà
SELECT TOP 5 brand, model, convert (int, price) as price, AVG (cast (rating as int)) rating
FROM cellphones_data data
JOIN cellphones_ratings ratings
	ON data.cellphone_id = ratings.cellphone_id
GROUP BY brand, model, price
ORDER BY 3 DESC

SELECT TOP 5 brand, model, convert (int, price) as price, AVG ( cast (rating as int)) rating
FROM cellphones_data data
JOIN cellphones_ratings ratings
	ON data.cellphone_id = ratings.cellphone_id
GROUP BY brand, model, price
ORDER BY price ASC


-- ñðåäíÿÿ öåíà òîâàðà è êîëè÷åñòâî ãîëîñîâ çà óñòðîéñòâà
SELECT brand, AVG( convert (int, price)) as avg_price, COUNT (*) number_votes
FROM cellphones_data data
JOIN cellphones_ratings ratings
	ON data.cellphone_id = ratings.cellphone_id
GROUP BY brand
ORDER BY avg_price DESC


-- êîëè÷åñòâî ãîëîñîâ çà óñòðîéñòâà áðåíäà è ñðåäíÿÿ îöåíêà
SELECT brand, AVG (cast (rating as int)) avg_rating, COUNT (*) number_votes
FROM cellphones_ratings as ratings
JOIN cellphones_data as data
	ON ratings.cellphone_id = data.cellphone_id
GROUP BY brand
ORDER BY 2 DESC

-- ìîäåëü óñòðîéñòâà ñ ìàêñèìàëüíûì ðåéòèíãîì
SELECT brand, model, rating
FROM cellphones_ratings as ratings
JOIN cellphones_data as data
	ON ratings.cellphone_id = data.cellphone_id
WHERE rating = (SELECT MAX (cast (rating as int)) FROM cellphones_ratings)
ORDER BY 2 DESC


-- ìîäåëü óñòðîéñòâà ñ ñàìûì ëó÷øèì îáùèì ïîëó÷åííûì ðåéòèíãîì
WITH max_cte as (
SELECT brand, model, SUM( convert (int, rating)) popular_model
FROM cellphones_ratings as ratings
JOIN cellphones_data as data
	ON ratings.cellphone_id = data.cellphone_id
GROUP BY model, brand)

SELECT brand, model, popular_model
FROM max_cte
WHERE popular_model = (SELECT MAX (popular_model) FROM max_cte)


-- îáùèé ðåéòèíã áðåíäà è ñðåäíÿÿ öåíà íà òîâàðû
Select brand, SUM( convert (int, rating))  popular_brand,
 AVG ( convert (int,price)) price
From cellphones_data  as data
JOIN cellphones_ratings as ratings
	ON ratings.cellphone_id = data.cellphone_id
	GROUP BY  brand
	ORDER BY popular_brand DESC


-- êîë-âî óñòðîéñòâ ó áðåíäîâ ñ ìàêñèìàëüíûì ðåéòèíãîì 
SELECT brand, COUNT (*) as max_count
From cellphones_data data
JOIN cellphones_ratings as ratings
	ON data.cellphone_id = ratings.cellphone_id
WHERE rating = '10' or rating = '18'
GROUP BY brand 
ORDER BY 2 DESC

-- êòî ïîêóïàåò óñòðîéñòâà ÷àùå âñåãî, ñ ðàçáèâêîé ïî ïîëó è áðåíäó
SELECT brand, COUNT (model) as gender_count, gender
From cellphones_data data
JOIN cellphones_ratings as ratings
	ON data.cellphone_id = ratings.cellphone_id
JOIN cellphones_users users 
	ON users.user_id = ratings.user_id
WHERE gender is NOT NULL
GROUP BY brand, gender
ORDER BY 1 

-- êîë-âî îöåíåííûõ óñòðîéñòâ êàæäûì ïîëîì, âêëþ÷àÿ òåõ, êòî åãî íå óêàçàë. è ñðåäíÿÿ öåíà è ðåéòèíã ïî ïîëó. 
SELECT gender, COUNT (model) as gender_count, AVG (cast (price as int)) avg_price, AVG (cast (rating as int)) avg_rating
From cellphones_data data
JOIN cellphones_ratings as ratings
	ON data.cellphone_id = ratings.cellphone_id
JOIN cellphones_users users 
	ON users.user_id = ratings.user_id
GROUP BY gender
ORDER BY 1 

-- ñðåäíèé ðåéòèíã óñòðîéñòâ ïî âîçðàñòíûì ãðóïïàì. 
WITH age_cte as (
SELECT brand, age, rating,
CASE 
    WHEN age BETWEEN '20' AND '29' THEN 20
	WHEN age BETWEEN '30' AND '39' THEN 30
	WHEN age BETWEEN '40' AND '49' THEN 40
	WHEN age BETWEEN '50' AND '59' THEN 50
	WHEN age BETWEEN '60' AND '69' THEN 60
END AS Age_group
From cellphones_users users 
JOIN cellphones_ratings as ratings
	ON users.user_id = ratings.user_id
JOIN cellphones_data data 
	ON data.cellphone_id = ratings. cellphone_id)
	
SELECT AVG (convert(int,rating)) avg_rate, Age_group
FROM age_cte
GROUP BY Age_group
ORDER BY avg_rate DESC, Age_group ASC
	




SELECT *
FROM cellphones_users
ORDER BY occupation

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'it' ,'IT'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'team worker in it' ,'IT'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'Information Technology' ,'IT'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'ADMINISTRATIVE OFFICER' ,'Administrative officer'))

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'HEALTHCARE' ,'Healthcare')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'Purchase Manager' ,'Manager')

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'accountant' ,'Accountant'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'EDUCATION' ,'Education'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'Executive Manager' ,'executive'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'FINANCE' ,'Finance'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'MANAGER' ,'Manager'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'Ops Manager' ,'Manager'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'nurse' ,'Healthcare'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'sales' ,'Sales'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'retail' ,'Sales'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'Sales Manager' ,'Sales'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'SecurITy' ,'Security'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'software developer' ,'IT'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'QA Software Manager' ,'IT'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'wrITer' ,'Writer'))

UPDATE cellphones_users 
SET occupation = (SELECT REPLACE(occupation,'president transportation company' ,'executive'))

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'ICT Officer' ,'IT')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'banking' ,'business')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'Computer technician' ,'IT')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'System Administrator' ,'IT')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'Technical Engineer' ,'IT')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'WEB DESIGN' ,'IT')

UPDATE cellphones_users 
SET occupation = REPLACE(occupation,'teacher' ,'Education')

Update cellphones_users 
set gender = NULL where gender LIKE '%Select gender%'
