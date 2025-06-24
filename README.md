# Siemens-MindSphere
## Overview 
The SMS_db is designed to manage and monitor various types of industrial and environmental devices, capturing real-time sensor data, logging alerts, and tracking device status and calibration. It includes three key tables:
#### devices: 
Contains metadata about each monitoring device, including type, location, calibration history, and operational status.
#### sensor_readings:
 Stores time-stamped measurements from devices such as temperature, humidity, air quality, water flow, and vibration.
#### device_alerts: 
Logs alerts triggered by abnormal conditions, including the severity, resolution status, and detailed descriptions.
## Objectives 
To enable real-time monitoring, predictive maintenance, and operational efficiency through IoT device data and alert analytics.
## Database Creation
``` sql
CREATE DATABASE SMS_db;
USE SMS_db;
```
## Table Creation
### Table:devices
``` sql
CREATE TABLE devices(
    device_id         VARCHAR(25) PRIMARY KEY,
    device_name       TEXT,
    location          TEXT,
    device_type       VARCHAR(50),
    status            VARCHAR(50),
    last_calibration  DATE
);

SELECT * FROM devices;
```
### Table:sensor_readings
``` sql
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
```
### Table:device_alerts
``` sql
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
```
### Key Queries

#### 1. List all active devices with their last calibration dates, sorted by calibration age (oldest first).
``` sql 
SELECT * FROM devices
WHERE status='Active'
ORDER BY last_calibration;
```
#### 2. Show devices that haven't been calibrated in over 6 months.
``` sql
SELECT *,TIMESTAMPDIFF(MONTH,last_calibration,CURDATE()) AS Duration FROM devices 
WHERE TIMESTAMPDIFF(MONTH,last_calibration,CURDATE())>6
ORDER BY Duration DESC;
```
#### 3. Find devices located in 'Warehouse' or 'Storage' areas.
``` sql
SELECT * FROM devices 
WHERE LOWER(location) LIKE '%warehouse%'
        OR LOWER(location) LIKE '%storage%';
```
#### 4. Display all unresolved critical alerts with their timestamps.
``` sql
SELECT * FROM device_alerts
WHERE resolved=FALSE 
        AND severity='Critical';
```
#### 5. List alerts triggered between August 3-5, 2023.
``` sql
SELECT * FROM device_alerts
WHERE DATE(timestamp) IN ('2023-08-03','2023-08-04','2023-08-05');
```
#### 6. Find devices that have generated more than 2 alerts.
``` sql
SELECT d.* , COUNT(da.alert_id) AS Total_alerts
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
GROUP BY d.device_id
HAVING Total_alerts>2;
```
#### 7. Show inactive/faulty devices and their last alert types (if any).
``` sql
SELECT d.* ,da.*
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
WHERE d.status IN ('Faulty','Inactive')
        AND da.timestamp=(
                SELECT MAX(sub.timestamp)
        FROM device_alerts sub
        WHERE sub.device_id=d.device_id);
```
#### 8. Identify devices currently under maintenance but with active alerts.
``` sql
SELECT d.* ,da.*
FROM devices d 
JOIN device_alerts da 
ON d.device_id=da.device_id
WHERE d.status='Maintenance'
        AND da.resolved=FALSE;
```
#### 9. Calculate the average time between device calibration and first alert.
``` sql
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY,d.last_calibration,a.first_alert_time)),2) AS Average_time_between_calibrations
FROM devices d
JOIN (
        SELECT device_id,MIN(timestamp) AS first_alert_time
    FROM device_alerts
    GROUP BY device_id 
) a
ON d.device_id=a.device_id;
```
#### 10. Find alerts where the description contains 'threshold' or 'spike'.
``` sql
SELECT * FROM device_alerts
WHERE LOWER(description) LIKE '%threshold%' 
        OR LOWER(description) LIKE '%spike%';
```
#### 11. List devices that have both high and critical severity alerts.
``` sql
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
```
#### 12. Show the most common alert type per device category (Environmental/Safety/etc
``` sql
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
```
## Conclusion 
The database design and SQL queries for SMS_db provide a solid foundation for proactive monitoring and analysis of smart devices. Through the use of filtering, aggregation, date functions, and analytical SQL techniques (like RANK() and subqueries), the system offers insights into device reliability, operational risks, and environmental compliance. 

