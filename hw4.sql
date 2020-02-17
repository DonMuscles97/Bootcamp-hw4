--1. Write a query to return users who have admin roles

SELECT ownerName, roleName FROM owners JOIN roles ON owners.roleID = roles.roleID WHERE roleName = 'admin';


-- 2. Write a query to return users who have admin roles and information about their taverns

SELECT ownerName, roleName, tavernName FROM owners JOIN roles ON owners.roleID = roles.roleID 
JOIN taverns ON owners.ownerID = taverns.ownerID WHERE roleName = 'admin';


-- 3. Write a query that returns all guests ordered by name (ascending) and their classes and corresponding levels

SELECT names, levelNumber, className FROM guests JOIN classLevel on guests.guestID = classLevel.guestID
 JOIN class ON classLevel.classID = class.classID ORDER BY names ASC;

--  4. Write a query that returns the top 10 sales in terms of sales price and what the services were

SELECT servPrice, serviceName FROM servSales 
JOIN services ON servSales.serviceID = services.serviceID 
ORDER BY servPrice DESC;

-- 5. Write a query that returns guests with 2 or more classes

SELECT * FROM guests JOIN classLevel ON classLevel.guestID = guests.guestID
WHERE guests.guestID IN (SELECT guestID FROM classLevel GROUP BY guestID
HAVING COUNT(*) >1)

-- 6. Write a query that returns guests with 2 or more classes with levels higher than 5
SELECT * FROM guests JOIN classLevel ON classLevel.guestID = guests.guestID
WHERE levelNumber > 5 and guests.guestID IN (SELECT guestID FROM classLevel GROUP BY guestID
HAVING COUNT(*) >1)

-- 7. Write a query that returns guests with ONLY their highest level class

Select names,  MAX(levelNumber) FROM classLevel
JOIN guests ON guests.guestID = classLevel.guestID
Join class ON classLevel.classID = class.classID
GROUP BY names

-- 8. Write a query that returns guests that stay within a date range. Please remember that guests can stay for more than one night AND not all of the dates they stay have to be in that range (just some of them)

SELECT * FROM roomSales WHERE dateStayed BETWEEN '2020-01-01' AND '2020-01-16';

--  9. Using the additional queries provided, take the lab’s SELECT ‘CREATE query’ and add any IDENTITY and PRIMARY KEY constraints to it.

SELECT 
CONCAT('CREATE TABLE ',TABLE_NAME, ' (') as queryPiece 
FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_NAME = 'Taverns'
UNION ALL
SELECT CONCAT(cols.COLUMN_NAME, ' ', cols.DATA_TYPE, 
(
	CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
	Then CONCAT
		('(', CAST(CHARACTER_MAXIMUM_LENGTH as varchar(100)), ')') 
	Else '' 
	END)
, 
	CASE WHEN refConst.CONSTRAINT_NAME iS NOT NULL
	Then 
		(CONCAT(' FOREIGN KEY REFERENCES ', constKeys.TABLE_NAME, '(', constKeys.COLUMN_NAME, ')')) 
	Else '' 
	END
, 

	CASE WHEN keys.CONSTRAINT_NAME LIKE 'PK%' Then	' PRIMARY KEY IDENTITY(1,1) 'Else '' 
	END
, 
',') as queryPiece From
INFORMATION_SCHEMA.COLUMNS as cols
LEFT JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as keys ON 
(keys.TABLE_NAME = cols.TABLE_NAME and keys.COLUMN_NAME = cols.COLUMN_NAME)
LEFT JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as refConst ON 
(refConst.CONSTRAINT_NAME = keys.CONSTRAINT_NAME)
LEFT JOIN 
(SELECT DISTINCT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE) as constKeys 
ON (constKeys.CONSTRAINT_NAME = refConst.UNIQUE_CONSTRAINT_NAME)
 WHERE cols.TABLE_NAME = 'Taverns'
UNION ALL
SELECT ')'; 




