CREATE DATABASE SMS_db;
USE SMS_db;

CREATE TABLE devices(
    device_id         VARCHAR(25) PRIMARY KEY,
    device_name       TEXT,
    location          TEXT,
    device_type       VARCHAR(50),
    status            VARCHAR(50),
    last_calibration  DATE
);

SELECT * FROM devices;

INSERT INTO devices VALUES
	('THM-101', 'Temperature/Humidity Sensor', 'Warehouse Zone A', 'Environmental', 'Active', '2023-05-15'),
	('AQI-205', 'Air Quality Monitor', 'Factory Floor - North', 'Pollution', 'Active', '2023-06-10'),
	('FLW-307', 'Water Flow Meter', 'Cooling System Pipe 12B', 'Hydraulic', 'Maintenance', '2023-04-22'),
	('PWR-409', 'Energy Monitor', 'Main Electrical Panel 3', 'Electrical', 'Active', '2023-07-01'),
	('VIB-503', 'Vibration Sensor', 'Conveyor Belt Motor', 'Mechanical', 'Active', '2023-05-30'),
	('GAS-612', 'Methane Detector', 'Storage Room 5', 'Safety', 'Faulty', '2023-03-18'),
	('PRS-704', 'Pressure Gauge', 'Boiler System', 'Hydraulic', 'Active', '2023-06-25'),
	('LGT-808', 'Light Intensity Sensor', 'Outdoor Parking', 'Environmental', 'Inactive', '2023-02-14'),
	('DRN-906', 'Door Contact Sensor', 'Main Entrance', 'Security', 'Active', '2023-07-12'),
	('CAM-017', 'Surveillance Camera', 'Loading Dock', 'Security', 'Active', '2023-06-05');

CREATE TABLE sensor_readings(
    reading_id      INT PRIMARY KEY,
    device_id       VARCHAR(25),
    timestamp       DATETIME,
    temperature     DECIMAL(6,2),
    humidity        DECIMAL(6,2),
    pm2_5           DECIMAL(6,2),
    water_flow_rate DECIMAL(6,2),
    current_amps    DECIMAL(6,2),
    vibration_g     DECIMAL(10,6)
);

SELECT * FROM sensor_readings;

INSERT INTO sensor_readings VALUES
	(1, 'DHT001', '2023-06-01 08:00:00', 23.5, 45.2, NULL, NULL, NULL, NULL),
	(2, 'PLC002', '2023-06-01 08:00:05', NULL, NULL, 12, NULL, NULL, NULL),
	(3, 'WTR003', '2023-06-01 08:00:10', NULL, NULL, NULL, 2.45, NULL, NULL),
	(4, 'ELC004', '2023-06-01 08:00:15', NULL, NULL, NULL, NULL, 15.3, NULL),
	(5, 'MOT005', '2023-06-01 08:00:20', NULL, NULL, NULL, NULL, NULL, 0.025),
	(6, 'DHT001', '2023-06-01 09:00:00', 24.1, 43.8, NULL, NULL, NULL, NULL),
	(7, 'PLC002', '2023-06-01 09:00:05', NULL, NULL, 18, NULL, NULL, NULL),
	(8, 'WTR003', '2023-06-01 09:00:10', NULL, NULL, NULL, 2.67, NULL, NULL),
	(9, 'ELC004', '2023-06-01 09:00:15', NULL, NULL, NULL, NULL, 22.7, NULL),
	(10, 'MOT005', '2023-06-01 09:00:20', NULL, NULL, NULL, NULL, NULL, 0.041),
	(11, 'DHT001', '2023-06-01 10:00:00', 25.7, 40.1, NULL, NULL, NULL, NULL),
	(12, 'PLC002', '2023-06-01 10:00:05', NULL, NULL, 25, NULL, NULL, NULL),
	(13, 'WTR003', '2023-06-01 10:00:10', NULL, NULL, NULL, 3.12, NULL, NULL),
	(14, 'ELC004', '2023-06-01 10:00:15', NULL, NULL, NULL, NULL, 18.9, NULL),
	(15, 'MOT005', '2023-06-01 10:00:20', NULL, NULL, NULL, NULL, NULL, 0.087),
	(16, 'DHT001', '2023-06-01 11:00:00', 26.3, 38.5, NULL, NULL, NULL, NULL),
	(17, 'PLC002', '2023-06-01 11:00:05', NULL, NULL, 32, NULL, NULL, NULL),
	(18, 'WTR003', '2023-06-01 11:00:10', NULL, NULL, NULL, 3.45, NULL, NULL),
	(19, 'ELC004', '2023-06-01 11:00:15', NULL, NULL, NULL, NULL, 25.1, NULL),
	(20, 'MOT005', '2023-06-01 11:00:20', NULL, NULL, NULL, NULL, NULL, 0.112);

CREATE TABLE device_alerts(
    alert_id    INT PRIMARY KEY,
    device_id   VARCHAR(25),
    timestamp   DATETIME,
    alert_type  TEXT,
    severity    VARCHAR(50),
    resolved    BOOLEAN,
    description TEXT
);

SELECT * FROM device_alerts;

INSERT INTO device_alerts VALUES
	(1, 'THM-101', '2023-08-01 14:30:45', 'High Temperature', 'Critical', FALSE, 'Temperature exceeded 40°C (Threshold: 38°C)'),
	(2, 'AQI-205', '2023-08-01 15:12:33', 'PM2.5 Spike', 'High', TRUE, 'PM2.5 levels reached 120 µg/m³ (Normal: <50)'),
	(3, 'FLW-307', '2023-08-02 08:45:22', 'Zero Flow Detected', 'Medium', FALSE, 'No water flow for 2+ hours'),
	(4, 'PWR-409', '2023-08-02 11:03:17', 'Power Surge', 'Critical', TRUE, 'Voltage spike to 250V (Normal: 220V±5%)'),
	(5, 'VIB-503', '2023-08-03 09:30:55', 'Abnormal Vibration', 'High', FALSE, 'Vibration reached 0.15g (Normal: <0.05g)'),
	(6, 'GAS-612', '2023-08-03 13:22:10', 'Methane Leak', 'Critical', FALSE, 'CH4 concentration at 2.5% LEL'),
	(7, 'PRS-704', '2023-08-04 10:15:38', 'Low Pressure', 'Medium', TRUE, 'Pressure dropped to 2.3 bar (Min: 2.5 bar)'),
	(8, 'LGT-808', '2023-08-04 18:45:29', 'Sensor Offline', 'Low', FALSE, 'No data received for 24+ hours'),
	(9, 'DRN-906', '2023-08-05 02:30:44', 'Door Forced Open', 'High', TRUE, 'Unauthorized access during non-working hours'),
	(10, 'CAM-017', '2023-08-05 07:22:16', 'Motion Detected', 'Low', FALSE, 'Continuous motion in restricted area');

SELECT * FROM devices
WHERE status='Active'
ORDER BY last_calibration;

SELECT *,TIMESTAMPDIFF(MONTH,last_calibration,CURDATE()) AS Duration FROM devices 
WHERE TIMESTAMPDIFF(MONTH,last_calibration,CURDATE())>6
ORDER BY Duration DESC;

SELECT * FROM devices 
WHERE LOWER(location) LIKE '%Warehouse%'
	OR LOWER(location) LIKE '%Storage%';
    
SELECT * FROM device_alerts
WHERE resolved=FALSE 
	AND severity='Critical';

SELECT * FROM device_alerts
WHERE DATE(timestamp) IN ('2023-08-03','2023-08-04','2023-08-05');

SELECT d.* , COUNT(da.alert_id) AS Total_alerts
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
GROUP BY d.device_id
HAVING Total_alerts>2;

SELECT d.* ,da.*
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
WHERE d.status IN ('Faulty','Inactive')
	AND da.timestamp=(
		SELECT MAX(sub.timestamp)
        FROM device_alerts sub
        WHERE sub.device_id=d.device_id);

SELECT d.* ,da.*
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
WHERE d.status='Maintenance'
	AND da.resolved=FALSE;

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY,d.last_calibration,a.first_alert_time)),2) AS Average_time_between_calibrations
FROM devices d
JOIN (
	SELECT device_id,MIN(timestamp) AS first_alert_time
    FROM device_alerts
    GROUP BY device_id 
) a
ON d.device_id=a.device_id;
    
SELECT * FROM device_alerts
WHERE LOWER(description) LIKE '%threshold%' 
	OR LOWER(description) LIKE '%spike%';
    
SELECT d.* 
FROM devices d
WHERE d.device_id IN (
	SELECT device_id
    FROM device_alerts
    WHERE severity='High')
AND d.device_id IN (
	SELECT device_id
    FROM device_alerts
    WHERE severity='Critical');
    
SELECT device_type,alert_type,alert_count
FROM(
	SELECT 
		d.device_type,
        da.alert_type,
        COUNT(*) AS Alert_count,
        RANK() OVER(PARTITION BY d.device_type ORDER BY COUNT(*) DESC) AS ranking
	FROM devices d 
    JOIN device_alerts da 
    ON d.device_id=da.device_id
	GROUP BY d.device_type,da.alert_type) ranked_alerts
WHERE ranking=1;