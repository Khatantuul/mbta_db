-- Initializing the database

CREATE DATABASE mbta_project;

USE mbta_project;

-- Creation of main tables

CREATE TABLE SubwayLine (
	LineID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(40) NOT NULL,
    Color VARCHAR(20) NOT NULL,
    OperationalStatus VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE SubLine (
	SubLineID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    SubwayLineID INT NOT NULL,
    Name VARCHAR(40) NOT NULL,
	FOREIGN KEY (SubwayLineID) REFERENCES SubwayLine(LineID)
) ENGINE=INNODB;

CREATE TABLE Station (
	StationID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Latitude DECIMAL(10, 8) NOT NULL,
    Longitude DECIMAL(11, 8) NOT NULL,
    Accessibility BOOLEAN DEFAULT TRUE,
    BikeStorage BOOLEAN DEFAULT TRUE,
    Parking BOOLEAN DEFAULT TRUE
);

-- Bridge/junction table to connect Line/Subline to Station
CREATE TABLE LineStation (
	LineStationID INT PRIMARY KEY AUTO_INCREMENT,
	SubwayLineID INT NOT NULL,
    SubLineID INT, 
    StationID INT NOT NULL,
    FOREIGN KEY (SubwayLineID) REFERENCES SubwayLine(LineID),
    FOREIGN KEY (SubLineID) REFERENCES SubLine(SubLineID),
    FOREIGN KEY (StationID) REFERENCES Station(StationID)
) ENGINE=INNODB;

CREATE TABLE Alert (
	AlertID INT PRIMARY KEY AUTO_INCREMENT,
    AlertType ENUM("Parking", "Bike Rack", "Access") NOT NULL,
    StationID INT NOT NULL,
    AlertMessage VARCHAR(255),
    AlertDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StationID) REFERENCES Station(StationID)
)ENGINE=INNODB;

-- Base table for Ridership_analytics view 

CREATE TABLE MonthlyLineRidership(
	RidershipID INT PRIMARY KEY AUTO_INCREMENT,
    ServiceDate DATE NOT NULL,
    LineID INT NOT NULL,
    TotalMonthlyWeekdayRidership DECIMAL(15,2) NOT NULL,
    TotalMonthlyRidership DECIMAL(15,2) NOT NULL,
    CountOfWeekdays INT NOT NULL,
    CountOfDays INT NOT NULL,
    FOREIGN KEY (LineID) REFERENCES SubwayLine(LineID)
)ENGINE=INNODB;