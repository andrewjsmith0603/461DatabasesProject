-- Uncomment select statements as needed for testing

-- 1.
-- SELECT DISTINCT f_name, l_name, city, email_add FROM Folk NATURAL JOIN Email NATURAL JOIN Resides NATURAL JOIN place;

-- 2.
/*
SELECT DISTINCT city, state, NumberOfResidents FROM 
(SELECT city, count(*) as NumberOfResidents FROM Folk NATURAL JOIN Resides NATURAL JOIN Place GROUP BY city) AS counts
NATURAL JOIN Place
ORDER BY NumberOfResidents DESC;
*/

-- 3
/*
SELECT state, count(*) as numOfInhabCities FROM
(SELECT DISTINCT city, state FROM Folk NATURAL JOIN Resides NATURAL JOIN Place) as inhabs group by state
UNION
(SELECT allPlaces.state, 0 as numOfInhabCities FROM
((SELECT DISTINCT city, state FROM Folk NATURAL JOIN Resides NATURAL JOIN Place) as inhabs
RIGHT JOIN
(SELECT DISTINCT city, state FROM Place) as allPlaces on inhabs.city = allPlaces.city)
WHERE inhabs.city is NULL
EXCEPT
(SELECT state, 0 as numOfInhabCities FROM
(SELECT DISTINCT city, state FROM Folk NATURAL JOIN Resides NATURAL JOIN Place) as inhabs group by state))
ORDER BY state ASC;
*/

-- 4
-- Dates can be adjusted for time interval needed and voting_ac can be adjusted for voting center needed
/*
SELECT DISTINCT folk_ID FROM REGISTERED
WHERE reg_date >= '1000-01-01' AND reg_date <= '1000-02-03'
AND voting_ac = 'aaaa'
*/

-- 5
-- Dates can be adjusted for month(s) needed and voting_ac(s) can be added or removed to exclude certain voting centers
/*
SELECT COUNT(*) FROM
(SELECT * FROM Registered NATURAL JOIN Voting_Center
WHERE reg_date >= '1000-01-01' AND reg_date <= '1000-02-01'
and (X_coord * X_coord) +  (Y_coord * Y_coord) < (5*5) -- Distance < 5 miles
EXCEPT 
SELECT * FROM Registered NATURAL JOIN Voting_Center
WHERE voting_ac = 'aaaa' or voting_ac = 'eeee') as regs
*/

-- 6
-- Dates can be adjusted for given time fram and city can be adjusted for target city
/*
SELECT voting_ac, count FROM
(SELECT count(*) as count, voting_ac From Registered NATURAL JOIN Voting_Center NATURAL JOIN PLACE
Where city = 'onesville' and reg_date >= '1000-01-01' AND reg_date <= '1000-02-01'
GROUP BY voting_ac) as y
WHERE count = 
	(SELECT MAX(count) FROM
	(SELECT count(*) as count, voting_ac From Registered NATURAL JOIN Voting_Center NATURAL JOIN PLACE
	Where city = 'onesville' and reg_date >= '1000-01-01' AND reg_date <= '1000-02-01'
	GROUP BY voting_ac) as x)
*/

-- 7 
-- all state checks can be adjusted for target state
/*
SELECT folk_ID FROM 
(
SELECT COUNT(*) as counts, folk_ID FROM Registered NATURAL JOIN Voting_Center NATURAL JOIN PLACE
WHERE state = 'oneland'
GROUP BY folk_ID
) as x
WHERE counts = 
	(SELECT COUNT(*) as counts FROM Voting_Center NATURAL JOIN PLACE
	WHERE state = 'oneland'
	GROUP BY state)
*/

-- 8
/*
SELECT DISTINCT Registered.folk_ID FROM REGISTERED 
JOIN
(
	SELECT folk_ID, Min(closestCenter) as closestCenter FROM
	(
		SELECT DISTINCT Folk_ID, Voting_Center.voting_ac as closestCenter FROM Resides NATURAL JOIN Registered NATURAL JOIN
		(SELECT MIN( SQRT( POW(Resides.X_coord - Voting_Center.X_coord, 2) + POW(Resides.X_coord - Voting_Center.X_coord, 2) ) ) as dist, folk_ID FROM Resides JOIN Voting_Center
		GROUP BY folk_ID) as Distances
		JOIN Voting_Center on Distances.dist = SQRT( POW(Resides.X_coord - Voting_Center.X_coord, 2) + POW(Resides.X_coord - Voting_Center.X_coord, 2) )
		ORDER BY Voting_Center.voting_ac ASC
    ) as closeCenters
	GROUP BY folk_ID
) as MinClosest
on MinClosest.folk_ID = Registered.folk_ID
WHERE Registered.voting_ac != closestCenter
ORDER BY Registered.folk_ID ASC
*/

-- 9
-- Change date and folk_ID checks as needed 

/*
SELECT folk_ID, Min(closestCenter) as closestCenter FROM
	(
		SELECT DISTINCT Folk_ID, availCenters.voting_ac as closestCenter FROM Resides NATURAL JOIN Registered NATURAL JOIN
		(SELECT MIN( SQRT( POW(Resides.X_coord - Voting_Center.X_coord, 2) + POW(Resides.X_coord - Voting_Center.X_coord, 2) ) ) as dist, folk_ID FROM Resides JOIN (Voting_Center NATURAL JOIN Operates)
		WHERE DATEDIFF(endDT, startDT) >= ABS(DATEDIFF(endDT, '1000-01-01')) and folk_ID = '0000000000000001'
		GROUP BY folk_ID) as Distances
		JOIN (SELECT * FROM Voting_Center NATURAL JOIN OPERATES
        WHERE DATEDIFF(endDT, startDT) >= ABS(DATEDIFF(endDT, '1000-01-01'))) as availCenters
        on Distances.dist = SQRT( POW(Resides.X_coord - availCenters.X_coord, 2) + POW(Resides.X_coord - availCenters.X_coord, 2) )
		ORDER BY availCenters.voting_ac ASC
    ) as closeCenters
GROUP BY folk_ID
ORDER BY folk_ID
*/

-- 10
-- UNCOMMENT AND RUN ALL CAST INSERTS IN LOADALL TO SEE DATA FROM THIS
-- bal_ID can be changed as needed

/*
SELECT  voting_ac, 
		COUNT(CASE WHEN bal_answer = 'YES' THEN 1 END) AS YES,
		COUNT(CASE WHEN bal_answer = 'NO' THEN 1 END) AS NO,
		COUNT(CASE WHEN bal_answer = 'ABSTAIN' THEN 1 END) AS ABSTAIN
FROM
(	SELECT * FROM CAST NATURAL JOIN BALLOT
	WHERE bal_ID = 'balA'
) as x
GROUP BY voting_ac
*/
