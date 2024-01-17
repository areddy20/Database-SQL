--1) Select the promotion id, promotion action, and promotion period provided to a particular flight id. (2.5%)

SELECT P.Prom_ID, P.Prom_Action, P.Prom_Period
FROM Promotions P
JOIN Promotions_Flights PF ON P.Prom_ID = PF.promotion_id
WHERE PF.flight_id = [flight_id];

--2) Display all the flight ids, flight points, and the flight arrival dates for a particular passenger name. (2.5%)

SELECT F.flight_id, F.flight_miles, F.arrival_datetime
FROM Flights F
JOIN Passenger_Flights PF ON F.flight_id = PF.flight_id
JOIN Passengers P ON PF.passenger_id = P.passid
WHERE P.pname = '[passenger_name]';



--3) Find the Flight ids and the number of promotions provided to each flight id. (2.5%)

SELECT PF.flight_id, COUNT(PF.promotion_id)  
FROM Promotions_Flights PF
GROUP BY PF.flight_id;


--4) Find the passengers ids and names who arrived to Berlin between March 1st and March 15th 2023. (2.5%)

SELECT P.passid, P.pname
FROM Passengers P
JOIN Passenger_Flights PF ON P.passid = PF.passenger_id
JOIN Flights F ON PF.flight_id = F.flight_id
WHERE F.destination = 'Berlin'
  AND F.arrival_datetime BETWEEN TO_DATE('2023-03-01', 'YYYY-MM-DD') AND TO_DATE('2023-03-15', 'YYYY-MM-DD');


--5) Display for a particular flight id, the flight id, source, destination, the number of miles collected, and the trip ids and arrival dates included in the flight. (2.5%)

SELECT F.flight_id, F.source, F.destination, F.flight_miles, T.trip_id, F.arrival_datetime
FROM Flights F
JOIN Trips T ON F.flight_id = T.flight_id
WHERE F.flight_id = [flight_id];

--6) Find the number of expired cards available in the database. (2.5%)

SELECT COUNT(*)  
FROM Cards
WHERE expiry_date < SYSDATE;



--7) Find the passenger with the maximum number of expired cards. (2.5%)

SELECT P.passid, P.pname
FROM Passengers P
JOIN Cards C ON P.passid = C.passid
WHERE C.expiry_date < SYSDATE
ORDER BY (SELECT COUNT(*) FROM Cards WHERE passid = P.passid) DESC
FETCH FIRST 1 ROW ONLY;


--8) Find the redemption history of a particular passenger name. You should display the award ID, award description, passenger name,center id, and number of points redeemed. (3%)

SELECT R.AwardID, A.a_description, P.pname, R.CenterID, R.quantity
FROM Redeem_History R
JOIN Passengers P ON R.PassID = P.passid
JOIN Awards A ON R.AwardID = A.award_id
WHERE P.pname = '[passenger_name]';

--9) Display the name and occupation of the passengers living in Fairfax. (3%)

SELECT P.pname, P.occupation
FROM Passengers P
JOIN Passengers_address PA ON P.passid = PA.passid
WHERE PA.city = 'Fairfax';

--10) Display the sum of points of the passengers living in Fairfax. (3%)

SELECT SUM(PT.total_points) AS total_points
FROM Point_Accounts PT
JOIN Passengers P ON PT.passid = P.passid
JOIN Passengers_address PA ON P.passid = PA.passid
WHERE PA.city = 'Fairfax';


--11) Display the passenger name with the maximum number of collected points. (3%)

SELECT Passengers.pname
FROM Passengers 
JOIN Point_Accounts  ON Passengers.passid = Point_Accounts.passid
WHERE Point_Accounts.total_points = (SELECT MAX(total_points) FROM Point_Accounts);

--12) Find the total number of points redeemed on a particular date. (3%)

SELECT SUM(quantity)  
FROM Redeem_History
WHERE redemption_date = TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD');


--13) Find the number of awards redeemed by a particular passenger id. (3%)
SELECT COUNT(*)  
FROM Redeem_History
WHERE PassID = [passenger_id];

--14) Find the number of passengers who redeemed awards from a particular center id. (3%)

SELECT COUNT(*)  
FROM Redeem_History
WHERE CenterID = [center_id];

--15) Find the total number of awards in the database. (3%)

SELECT COUNT(*) FROM Awards;


--16) Display a list of passenger names living in Fairfax and whose occupation is Engineer. (2.5%)

SELECT P.pname
FROM Passengers P
JOIN Passengers_address PA ON P.passid = PA.passid
WHERE PA.city = 'Fairfax' AND P.occupation = 'Engineer';


--17) Find the list of trips not included in any flight. (3%)

SELECT T.trip_id
FROM Trips T
LEFT JOIN Flights F ON T.flight_id = F.flight_id
WHERE F.flight_id IS NULL;

--18) Find the trip booked the most by passengers (3%)

SELECT T.trip_id
FROM Trips T
JOIN Passenger_Flights PF ON T.flight_id = PF.flight_id
GROUP BY T.trip_id
ORDER BY COUNT(PF.passenger_id) DESC
FETCH FIRST 1 ROW ONLY;

