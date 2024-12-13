-- Stored Procedure to calculate the Euclidean distance between user's coordinates and the stations' 

DELIMITER //
CREATE PROCEDURE FindClosestStation(
	IN userLat DECIMAL(10,8),
    IN userLong DECIMAL(11,8)
)
BEGIN 
	SELECT 
		Name AS StationName,
        Latitude,
        Longitude,
        SQRT(POW(Latitude-userLat, 2) + POW(Longitude - userLong, 2)) AS Distance
	FROM 
		Station
	ORDER BY 
		Distance ASC
	LIMIT 1;
END;
//

-- Sample calls of stored procedure 
CALL FindClosestStation(42.223792, -71.102391);
CALL FindClosestStation(42.223792, -71.152391);

-- When a new alert is added, below triggers updates corresponding Station

DELIMITER //
CREATE TRIGGER StationAlertTrigger
AFTER INSERT ON Alert
FOR EACH ROW
BEGIN
	IF NEW.AlertType = 'Parking' THEN
		UPDATE Station
		SET Parking = FALSE
        WHERE StationID = NEW.StationID;
	ELSEIF NEW.AlertType = 'Bike Rack' THEN
		UPDATE Station
		SET BikeStorage = FALSE
        WHERE StationID = NEW.StationID;
	ELSEIF NEW.AlertType = 'Access' THEN 
		UPDATE Station
		SET Accessibility = FALSE
        WHERE StationID = NEW.StationID;
	END IF;
END;
//

-- Same alert is added to activate the trigger

INSERT INTO Alert (AlertType, StationID, AlertMessage)
VALUES ('Parking', 86, 'North Quincy Newport Avenue Parking Lot closed beginning Wed Oct 16 due to construction');


-- All stations with their lines and sublines (if exists subline)
CREATE VIEW StationByLineAndSubline AS
SELECT 
    sw.Name AS 'Subway Name',
    'Main Line' AS 'Subline Name',
    st.Name AS 'Station Name'
FROM
    SubwayLine sw
JOIN LineStation ls ON ls.SubwayLineID = sw.LineID AND ls.SublineID IS NULL
JOIN Station st ON st.StationID = ls.StationID

UNION

SELECT 
    sw.Name AS 'Subway Name',
    sb.Name AS 'Subline Name',
    st.Name AS 'Station Name'
FROM
    SubwayLine sw
JOIN Subline sb ON sb.SubwayLineID = sw.LineID
JOIN LineStation ls ON ls.SublineID = sb.SublineID
JOIN Station st ON st.StationID = ls.StationID;

-- Analytics View for aggregated data for analytical insights
CREATE VIEW Ridership_Analytics AS 
SELECT 
	ServiceDate,
    l.Name,
    TotalMonthlyWeekdayRidership / CountOfWeekdays AS 'Average Weekday Ridership',
    TotalMonthlyRidership / CountOfDays AS 'Average Monthly Ridership'
FROM 
	MonthlyLineRidership mlr
JOIN SubwayLine l ON l.LineID = mlr.LineID;
