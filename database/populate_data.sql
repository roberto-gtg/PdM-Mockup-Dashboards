-- Sample Data Population Script for Asset Management Database
-- This script populates all tables with realistic industrial equipment data

-- ==============================================
-- EQUIPMENT TYPES AND BASIC SETUP
-- ==============================================

-- Insert Equipment Types
INSERT INTO equipment_types (type_name, category, description) VALUES
('Haul Truck', 'Mobile', 'Large mining haul trucks for material transport'),
('Excavator', 'Mobile', 'Hydraulic excavators for digging and loading'),
('Drill', 'Mobile', 'Rotary blast hole drills for mining operations'),
('Crusher', 'Fixed', 'Primary and secondary crushing equipment'),
('Conveyor Belt', 'Fixed', 'Material transport conveyor systems'),
('Loader', 'Mobile', 'Front-end loaders for material handling'),
('Grader', 'Mobile', 'Motor graders for road maintenance'),
('Bulldozer', 'Mobile', 'Track-type tractors for earthmoving'),
('Mill', 'Fixed', 'Ball mills and SAG mills for ore processing'),
('Rail Car', 'Mobile', 'Rail transport cars for bulk materials');

-- Insert Equipment/Assets
INSERT INTO equipment (unit_id, equipment_type_id, name, model, manufacturer, year_manufactured, installation_date, location, status, criticality_level) VALUES
-- Haul Trucks
('HT-101', 1, 'Haul Truck 101', '793F', 'Caterpillar', 2018, '2018-03-15', 'Mine Site A', 'Active', 'High'),
('HT-102', 1, 'Haul Truck 102', '793F', 'Caterpillar', 2018, '2018-04-20', 'Mine Site A', 'Active', 'High'),
('HT-103', 1, 'Haul Truck 103', '793F', 'Caterpillar', 2019, '2019-02-10', 'Mine Site A', 'Active', 'High'),
('HT-104', 1, 'Haul Truck 104', '777G', 'Caterpillar', 2020, '2020-01-15', 'Mine Site B', 'Active', 'High'),
('HT-105', 1, 'Haul Truck 105', '777G', 'Caterpillar', 2020, '2020-03-22', 'Mine Site B', 'Active', 'High'),
('HT-106', 1, 'Haul Truck 106', '793F', 'Caterpillar', 2017, '2017-11-08', 'Mine Site A', 'Active', 'Critical'),

-- Excavators
('EX-201', 2, 'Excavator 201', '6060FS', 'Caterpillar', 2019, '2019-06-12', 'Mine Site A', 'Active', 'Critical'),
('EX-202', 2, 'Excavator 202', '992K', 'Caterpillar', 2018, '2018-08-30', 'Mine Site B', 'Active', 'High'),
('EX-203', 2, 'Excavator 203', 'EX8000-6', 'Hitachi', 2020, '2020-05-18', 'Mine Site A', 'Active', 'Critical'),
('EX-204', 2, 'Excavator 204', '6060FS', 'Caterpillar', 2021, '2021-02-25', 'Mine Site B', 'Active', 'High'),
('EX-205', 2, 'Excavator 205', 'EX5600-6', 'Hitachi', 2019, '2019-09-14', 'Mine Site A', 'Active', 'High'),

-- Drills
('DR-301', 3, 'Drill 301', 'MD6420', 'Caterpillar', 2020, '2020-07-10', 'Mine Site A', 'Active', 'Medium'),
('DR-302', 3, 'Drill 302', 'MD6420', 'Caterpillar', 2019, '2019-11-22', 'Mine Site B', 'Active', 'Medium'),
('DR-303', 3, 'Drill 303', 'FlexiROC T45', 'Epiroc', 2021, '2021-01-15', 'Mine Site A', 'Active', 'Medium'),
('DR-304', 3, 'Drill 304', 'MD6420', 'Caterpillar', 2018, '2018-12-05', 'Mine Site B', 'Active', 'Medium'),
('DR-305', 3, 'Drill 305', 'FlexiROC T45', 'Epiroc', 2020, '2020-09-08', 'Mine Site A', 'Active', 'Medium'),

-- Fixed Equipment
('CR-401', 4, 'Primary Crusher', 'C160', 'Metso', 2017, '2017-05-20', 'Processing Plant', 'Active', 'Critical'),
('CR-402', 4, 'Secondary Crusher', 'HP500', 'Metso', 2018, '2018-01-12', 'Processing Plant', 'Active', 'Critical'),
('CV-501', 5, 'Conveyor Belt 1', 'CV-1200', 'Continental', 2018, '2018-03-25', 'Processing Plant', 'Active', 'High'),
('CV-502', 5, 'Conveyor Belt 2', 'CV-1200', 'Continental', 2018, '2018-04-10', 'Processing Plant', 'Active', 'High'),
('CV-503', 5, 'Conveyor Belt 3', 'CV-1500', 'Continental', 2019, '2019-02-28', 'Mine Site A', 'Active', 'High'),

-- Additional Mobile Equipment
('LD-601', 6, 'Loader 601', '992K', 'Caterpillar', 2019, '2019-08-15', 'Mine Site A', 'Active', 'Medium'),
('LD-602', 6, 'Loader 602', '992K', 'Caterpillar', 2020, '2020-04-20', 'Mine Site B', 'Active', 'Medium'),
('GR-701', 7, 'Grader 701', '16M3', 'Caterpillar', 2018, '2018-07-08', 'Mine Site A', 'Active', 'Low'),
('GR-702', 7, 'Grader 702', '16M3', 'Caterpillar', 2019, '2019-03-12', 'Mine Site B', 'Active', 'Low'),
('BD-801', 8, 'Bulldozer 801', 'D11T', 'Caterpillar', 2020, '2020-06-18', 'Mine Site A', 'Active', 'Medium');

-- ==============================================
-- SENSOR TYPES AND EQUIPMENT SENSORS
-- ==============================================

-- Insert Sensor Types
INSERT INTO sensor_types (sensor_type, unit_of_measure, normal_range_min, normal_range_max, critical_threshold, description) VALUES
('Engine Temperature', 'Celsius', 80.00, 105.00, 120.00, 'Engine coolant temperature monitoring'),
('Oil Pressure', 'PSI', 45.00, 75.00, 30.00, 'Engine oil pressure sensor'),
('Vibration', 'Hz', 0.00, 2.50, 5.00, 'Equipment vibration monitoring'),
('Hydraulic Pressure', 'PSI', 2000.00, 3500.00, 4000.00, 'Hydraulic system pressure'),
('Transmission Temperature', 'Celsius', 70.00, 95.00, 110.00, 'Transmission fluid temperature'),
('Tire Pressure', 'PSI', 80.00, 120.00, 60.00, 'Tire pressure monitoring'),
('Fuel Level', 'Percentage', 10.00, 100.00, 5.00, 'Fuel tank level sensor'),
('Brake Pressure', 'PSI', 50.00, 150.00, 30.00, 'Brake system pressure'),
('Coolant Level', 'Percentage', 80.00, 100.00, 60.00, 'Coolant reservoir level'),
('RPM', 'RPM', 800.00, 2200.00, 2500.00, 'Engine revolutions per minute'),
('Hydraulic Flow', 'GPM', 50.00, 200.00, 250.00, 'Hydraulic fluid flow rate'),
('Belt Speed', 'FPM', 400.00, 800.00, 900.00, 'Conveyor belt speed'),
('Load Weight', 'Tons', 0.00, 400.00, 450.00, 'Equipment load weight sensor'),
('Steering Fluid', 'Percentage', 70.00, 100.00, 50.00, 'Power steering fluid level');

-- Insert Equipment Sensors (sample for first few pieces of equipment)
INSERT INTO equipment_sensors (equipment_id, sensor_type_id, sensor_location, installation_date, is_active) VALUES
-- HT-101 sensors
(1, 1, 'Engine Block', '2018-03-15', TRUE),
(1, 2, 'Engine Block', '2018-03-15', TRUE),
(1, 3, 'Engine Mount', '2018-03-15', TRUE),
(1, 4, 'Hydraulic System', '2018-03-15', TRUE),
(1, 5, 'Transmission', '2018-03-15', TRUE),
(1, 6, 'Front Axle', '2018-03-15', TRUE),
(1, 7, 'Fuel Tank', '2018-03-15', TRUE),
(1, 8, 'Brake System', '2018-03-15', TRUE),
(1, 9, 'Radiator', '2018-03-15', TRUE),
(1, 10, 'Engine', '2018-03-15', TRUE),

-- HT-102 sensors
(2, 1, 'Engine Block', '2018-04-20', TRUE),
(2, 2, 'Engine Block', '2018-04-20', TRUE),
(2, 3, 'Engine Mount', '2018-04-20', TRUE),
(2, 4, 'Hydraulic System', '2018-04-20', TRUE),
(2, 5, 'Transmission', '2018-04-20', TRUE),
(2, 6, 'Front Axle', '2018-04-20', TRUE),
(2, 7, 'Fuel Tank', '2018-04-20', TRUE),
(2, 9, 'Radiator', '2018-04-20', TRUE),
(2, 10, 'Engine', '2018-04-20', TRUE),
(2, 14, 'Steering System', '2018-04-20', TRUE),

-- HT-103 sensors
(3, 1, 'Engine Block', '2019-02-10', TRUE),
(3, 2, 'Engine Block', '2019-02-10', TRUE),
(3, 3, 'Engine Mount', '2019-02-10', TRUE),
(3, 5, 'Transmission', '2019-02-10', TRUE),
(3, 8, 'Brake System', '2019-02-10', TRUE),
(3, 10, 'Engine', '2019-02-10', TRUE),
(3, 14, 'Steering System', '2019-02-10', TRUE);

-- ==============================================
-- CURRENT EQUIPMENT HEALTH STATUS
-- ==============================================

-- Insert Current Health Status (matching dashboard data)
INSERT INTO equipment_health (equipment_id, health_index, rul_hours, confidence_score, calculated_at, model_version) VALUES
(1, 85.00, 1200, 87.5, '2024-01-26 10:30:00', 'v2.1.3'), -- HT-101
(2, 92.00, 1500, 91.2, '2024-01-26 10:30:00', 'v2.1.3'), -- HT-102
(3, 78.00, 900, 84.8, '2024-01-26 10:30:00', 'v2.1.3'),  -- HT-103
(4, 95.00, 1800, 93.7, '2024-01-26 10:30:00', 'v2.1.3'), -- HT-104
(5, 88.00, 1350, 89.1, '2024-01-26 10:30:00', 'v2.1.3'), -- HT-105
(6, 62.00, 450, 78.3, '2024-01-26 10:28:15', 'v2.1.3'),  -- HT-106
(7, 89.50, 1650, 92.1, '2024-01-26 10:30:00', 'v2.1.3'), -- EX-201
(8, 93.20, 1420, 90.8, '2024-01-26 10:30:00', 'v2.1.3'), -- EX-202
(9, 86.70, 1280, 88.4, '2024-01-26 10:30:00', 'v2.1.3'), -- EX-203
(10, 91.80, 1520, 91.9, '2024-01-26 10:30:00', 'v2.1.3'), -- EX-204
(11, 87.40, 1380, 89.6, '2024-01-26 10:30:00', 'v2.1.3'), -- EX-205
(12, 94.20, 2100, 93.8, '2024-01-26 10:30:00', 'v2.1.3'), -- DR-301
(13, 89.60, 1890, 91.2, '2024-01-26 10:30:00', 'v2.1.3'), -- DR-302
(14, 92.30, 2050, 92.7, '2024-01-26 10:30:00', 'v2.1.3'), -- DR-303
(15, 88.90, 1750, 90.1, '2024-01-26 10:30:00', 'v2.1.3'), -- DR-304
(16, 90.80, 1980, 91.8, '2024-01-26 10:30:00', 'v2.1.3'), -- DR-305
(17, 76.50, 850, 83.2, '2024-01-26 10:30:00', 'v2.1.3'),  -- CR-401
(18, 82.30, 1100, 86.7, '2024-01-26 10:30:00', 'v2.1.3'), -- CR-402
(19, 85.60, 1300, 88.9, '2024-01-26 10:30:00', 'v2.1.3'), -- CV-501
(20, 88.20, 1450, 90.3, '2024-01-26 10:30:00', 'v2.1.3'), -- CV-502
(21, 91.40, 1620, 92.1, '2024-01-26 10:30:00', 'v2.1.3'), -- CV-503
(22, 93.70, 2200, 94.2, '2024-01-26 10:30:00', 'v2.1.3'), -- LD-601
(23, 89.80, 1870, 91.5, '2024-01-26 10:30:00', 'v2.1.3'), -- LD-602
(24, 96.20, 2400, 95.8, '2024-01-26 10:30:00', 'v2.1.3'), -- GR-701
(25, 94.80, 2350, 94.9, '2024-01-26 10:30:00', 'v2.1.3'), -- GR-702
(26, 87.60, 1590, 89.7, '2024-01-26 10:30:00', 'v2.1.3'); -- BD-801

-- ==============================================
-- CURRENT ANOMALIES
-- ==============================================

-- Insert Current Anomalies (matching dashboard data)
INSERT INTO anomalies (equipment_id, anomaly_type, severity, description, detected_at, status) VALUES
-- HT-101 anomalies
(1, 'Engine Temp High', 'High', 'Engine temperature reading 118°C, approaching critical threshold', '2024-01-26 08:45:00', 'Active'),
(1, 'Oil Pressure Low', 'Medium', 'Oil pressure at 38 PSI, below normal operating range', '2024-01-26 09:15:00', 'Active'),
(1, 'Vibration Excessive', 'Medium', 'Unusual vibration pattern detected in engine mount sensors', '2024-01-26 09:30:00', 'Active'),

-- HT-102 anomalies
(2, 'Coolant Level Low', 'Medium', 'Coolant reservoir at 65%, below optimal level', '2024-01-26 07:30:00', 'Active'),
(2, 'Tire Pressure Low', 'Medium', 'Front left tire pressure at 75 PSI', '2024-01-26 08:00:00', 'Active'),
(2, 'Fuel Consumption High', 'Low', 'Fuel consumption 15% above expected rate', '2024-01-26 09:00:00', 'Active'),

-- HT-103 anomalies  
(3, 'Transmission Temp High', 'High', 'Transmission temperature at 108°C', '2024-01-26 08:20:00', 'Active'),
(3, 'Brake Pressure Low', 'High', 'Brake system pressure at 42 PSI', '2024-01-26 09:45:00', 'Active'),
(3, 'Steering Fluid Low', 'Medium', 'Power steering fluid at 55%', '2024-01-26 10:00:00', 'Active'),

-- HT-105 anomalies
(5, 'Engine Temp High', 'Medium', 'Engine temperature trending upward, currently at 112°C', '2024-01-26 09:20:00', 'Active'),
(5, 'Oil Pressure Low', 'Medium', 'Oil pressure fluctuating, current reading 41 PSI', '2024-01-26 09:35:00', 'Active'),
(5, 'Vibration Excessive', 'Medium', 'Increased vibration levels in drivetrain', '2024-01-26 09:50:00', 'Active'),

-- HT-106 critical anomalies
(6, 'Critical: Engine Overheat', 'Critical', 'Engine temperature at 125°C, immediate attention required', '2024-01-26 10:15:00', 'Active'),
(6, 'Hydraulic Leak', 'High', 'Hydraulic fluid pressure drop indicating potential leak', '2024-01-26 10:20:00', 'Active'),
(6, 'Brake System Malfunction', 'Critical', 'Brake pressure sensor showing irregular readings', '2024-01-26 10:25:00', 'Active');

-- ==============================================
-- FAILURE PREDICTIONS
-- ==============================================

-- Insert Failure Predictions (matching dashboard data)
INSERT INTO failure_predictions (equipment_id, failure_probability, confidence_interval_low, confidence_interval_high, 
                                prediction_horizon_days, ml_model, model_version, predicted_at) VALUES
-- 7-day predictions
(7, 85.00, 78.00, 92.00, 7, 'Gradient Boosting', 'v3.2.1', '2024-03-15 00:00:00'), -- Excavator 7 (A123)
(20, 72.00, 65.00, 79.00, 7, 'LSTM', 'v2.8.4', '2024-03-15 00:00:00'), -- Conveyor Belt 3 (B456)
(17, 68.00, 60.00, 76.00, 7, 'Gradient Boosting', 'v3.2.1', '2024-03-15 00:00:00'), -- Crusher 1 (C789)
(4, 55.00, 48.00, 62.00, 7, 'LSTM', 'v2.8.4', '2024-03-15 00:00:00'), -- Truck 12 (D012)
(16, 42.00, 35.00, 49.00, 7, 'Gradient Boosting', 'v3.2.1', '2024-03-15 00:00:00'), -- Drill 5 (E345)
(22, 38.00, 31.00, 45.00, 7, 'LSTM', 'v2.8.4', '2024-03-15 00:00:00'), -- Loader 9 (F678)
(24, 25.00, 18.00, 32.00, 7, 'Gradient Boosting', 'v3.2.1', '2024-03-15 00:00:00'), -- Grader 2 (G901)
(26, 15.00, 8.00, 22.00, 7, 'LSTM', 'v2.8.4', '2024-03-15 00:00:00'), -- Bulldozer 4 (H234)

-- 30-day predictions
(1, 45.00, 38.00, 52.00, 30, 'Random Forest', 'v1.9.2', '2024-03-15 00:00:00'),
(2, 32.00, 25.00, 39.00, 30, 'Random Forest', 'v1.9.2', '2024-03-15 00:00:00'),
(3, 58.00, 51.00, 65.00, 30, 'Random Forest', 'v1.9.2', '2024-03-15 00:00:00'),
(6, 78.00, 71.00, 85.00, 30, 'Random Forest', 'v1.9.2', '2024-03-15 00:00:00');

-- ==============================================
-- ML MODELS REGISTRY
-- ==============================================

-- Insert ML Models
INSERT INTO ml_models (model_name, model_type, version, purpose, accuracy_score, deployment_date, last_retrained, is_active, configuration) VALUES
('Equipment Health Predictor', 'Gradient Boosting', 'v3.2.1', 'Health Index Calculation', 0.9240, '2024-01-15', '2024-03-10', TRUE, 
 '{"n_estimators": 200, "max_depth": 8, "learning_rate": 0.1, "features": ["temperature", "vibration", "pressure", "rpm"]}'),
('Failure Risk LSTM', 'LSTM', 'v2.8.4', 'Failure Prediction', 0.8870, '2024-02-01', '2024-03-08', TRUE,
 '{"sequence_length": 168, "hidden_units": 128, "dropout": 0.2, "epochs": 100}'),
('Anomaly Detection RF', 'Random Forest', 'v1.9.2', 'Anomaly Detection', 0.9150, '2024-01-20', '2024-03-05', TRUE,
 '{"n_estimators": 300, "max_features": "sqrt", "min_samples_split": 5}'),
('RUL Ensemble Model', 'Ensemble', 'v4.1.0', 'Remaining Useful Life', 0.9050, '2024-02-15', '2024-03-12', TRUE,
 '{"base_models": ["xgboost", "lstm", "svm"], "meta_learner": "linear_regression"}');

-- ==============================================
-- SPARE PARTS AND INVENTORY
-- ==============================================

-- Insert Spare Parts
INSERT INTO spare_parts (part_number, part_name, description, category, unit_cost, current_stock, reorder_point, lead_time_days, supplier) VALUES
('ENG-001-CAT', 'Engine Oil Filter', 'Heavy duty engine oil filter for CAT engines', 'Engine', 125.50, 25, 10, 7, 'Caterpillar Parts'),
('HYD-002-CAT', 'Hydraulic Pump', 'Main hydraulic pump assembly', 'Hydraulic', 8950.00, 3, 2, 14, 'Caterpillar Parts'),
('TIR-003-GEN', 'Tire 37.00R57', 'Radial tire for haul trucks', 'Tires', 12500.00, 8, 4, 21, 'Michelin'),
('BRK-004-CAT', 'Brake Disc', 'Brake disc assembly for heavy equipment', 'Brake', 2100.00, 12, 6, 10, 'Caterpillar Parts'),
('ENG-005-CAT', 'Air Filter', 'Primary air filter element', 'Engine', 85.75, 45, 15, 5, 'Donaldson'),
('HYD-006-CAT', 'Hydraulic Cylinder', 'Boom hydraulic cylinder', 'Hydraulic', 5200.00, 4, 2, 18, 'Caterpillar Parts'),
('ELE-007-GEN', 'Alternator', '24V 150A alternator', 'Electrical', 850.00, 8, 3, 12, 'Delco Remy'),
('TRA-008-CAT', 'Transmission Filter', 'Automatic transmission filter kit', 'Transmission', 165.00, 20, 8, 7, 'Caterpillar Parts'),
('COO-009-CAT', 'Radiator', 'Engine cooling radiator assembly', 'Cooling', 3200.00, 2, 1, 20, 'Caterpillar Parts'),
('BEL-010-CON', 'Conveyor Belt', '1200mm steel cord conveyor belt', 'Conveyor', 450.00, 1500, 500, 30, 'Continental');

-- ==============================================
-- WORK ORDERS AND MAINTENANCE
-- ==============================================

-- Insert Recent Work Orders
INSERT INTO work_orders (wo_number, equipment_id, work_type, priority, description, estimated_hours, estimated_cost, 
                        scheduled_date, status, technician_assigned) VALUES
('WO-2024-001', 6, 'Emergency', 'Critical', 'Engine overheating investigation and repair', 16.0, 8500.00, 
 '2024-01-26', 'In Progress', 'Mike Johnson'),
('WO-2024-002', 3, 'Predictive', 'High', 'Transmission service due to high temperature readings', 8.0, 2500.00, 
 '2024-01-27', 'Planned', 'Sarah Martinez'),
('WO-2024-003', 1, 'Preventive', 'Medium', 'Scheduled 2000-hour service', 12.0, 1800.00, 
 '2024-01-28', 'Planned', 'Robert Chen'),
('WO-2024-004', 17, 'Predictive', 'High', 'Crusher bearing replacement - vibration analysis indicates wear', 20.0, 15000.00, 
 '2024-01-29', 'Planned', 'David Wilson'),
('WO-2024-005', 2, 'Preventive', 'Medium', 'Oil change and filter replacement', 4.0, 850.00, 
 '2024-01-30', 'Planned', 'Lisa Thompson');

-- Insert Maintenance Events (Historical)
INSERT INTO maintenance_events (equipment_id, work_order_id, event_type, description, parts_used, labor_hours, cost, 
                               performed_by, performed_at) VALUES
(1, NULL, 'Inspection', 'Monthly safety inspection completed', '{}', 2.0, 150.00, 'Mike Johnson', '2024-01-15 14:00:00'),
(2, NULL, 'Repair', 'Coolant leak repair', '{"COO-009-CAT"}', 6.0, 1200.00, 'Sarah Martinez', '2024-01-18 10:30:00'),
(4, NULL, 'Replacement', 'Air filter replacement', '{"ENG-005-CAT"}', 1.0, 125.75, 'Robert Chen', '2024-01-20 08:15:00'),
(7, NULL, 'Calibration', 'Hydraulic system pressure calibration', '{}', 3.0, 350.00, 'David Wilson', '2024-01-22 13:45:00'),
(12, NULL, 'Inspection', 'Drill bit inspection and replacement', '{"DRL-011-EPI"}', 4.0, 2500.00, 'Lisa Thompson', '2024-01-24 11:20:00');

-- ==============================================
-- FINANCIAL DATA
-- ==============================================

-- Insert Cost Avoidance Records
INSERT INTO cost_avoidance (equipment_id, work_order_id, avoidance_type, estimated_avoided_cost, actual_avoided_cost, 
                           description, calculation_method, occurred_at) VALUES
(3, 2, 'Early Detection', 25000.00, 25000.00, 'Prevented major transmission failure through predictive maintenance', 
 'Cost of transmission replacement vs. preventive service', '2024-01-27'),
(17, 4, 'Avoided Failure', 150000.00, NULL, 'Crusher bearing replacement before catastrophic failure', 
 'Production loss + equipment damage vs. planned maintenance', '2024-01-29'),
(6, 1, 'Emergency Response', 50000.00, NULL, 'Quick response prevented engine seizure', 
 'Engine replacement cost vs. repair cost', '2024-01-26'),
(2, NULL, 'Optimized Maintenance', 5000.00, 5000.00, 'Extended service interval based on condition monitoring', 
 'Additional service cycles avoided', '2024-01-18');

-- Insert Energy Consumption Data
INSERT INTO energy_consumption (equipment_id, consumption_kwh, cost_usd, recorded_date, energy_type, efficiency_rating) VALUES
-- Daily consumption for past week
(1, 480.5, 72.08, '2024-01-25', 'Diesel', 2.4),
(2, 445.2, 66.78, '2024-01-25', 'Diesel', 2.2),
(3, 510.8, 76.62, '2024-01-25', 'Diesel', 2.6),
(4, 420.3, 63.05, '2024-01-25', 'Diesel', 2.1),
(5, 465.7, 69.86, '2024-01-25', 'Diesel', 2.3),
(6, 550.2, 82.53, '2024-01-25', 'Diesel', 2.8),
(17, 2200.0, 220.00, '2024-01-25', 'Electricity', 5.5),
(18, 1850.0, 185.00, '2024-01-25', 'Electricity', 4.6),
(19, 45.5, 4.55, '2024-01-25', 'Electricity', 0.1),
(20, 48.2, 4.82, '2024-01-25', 'Electricity', 0.1);

-- ==============================================
-- RELIABILITY METRICS
-- ==============================================

-- Insert MTBF/MTTR Data
INSERT INTO reliability_metrics (equipment_id, metric_type, value_hours, calculation_period_start, calculation_period_end) VALUES
-- MTBF (Mean Time Between Failures) - last 6 months
(1, 'MTBF', 720.5, '2023-07-01', '2024-01-01'),
(2, 'MTBF', 1200.8, '2023-07-01', '2024-01-01'),
(3, 'MTBF', 480.2, '2023-07-01', '2024-01-01'),
(4, 'MTBF', 1850.6, '2023-07-01', '2024-01-01'),
(5, 'MTBF', 950.3, '2023-07-01', '2024-01-01'),
(6, 'MTBF', 320.8, '2023-07-01', '2024-01-01'),

-- MTTR (Mean Time To Repair) - last 6 months
(1, 'MTTR', 8.5, '2023-07-01', '2024-01-01'),
(2, 'MTTR', 6.2, '2023-07-01', '2024-01-01'),
(3, 'MTTR', 12.8, '2023-07-01', '2024-01-01'),
(4, 'MTTR', 4.5, '2023-07-01', '2024-01-01'),
(5, 'MTTR', 9.7, '2023-07-01', '2024-01-01'),
(6, 'MTTR', 18.3, '2023-07-01', '2024-01-01');

-- ==============================================
-- MODEL GOVERNANCE DATA
-- ==============================================

-- Insert Model Performance Metrics
INSERT INTO model_performance (model_id, metric_name, metric_value, evaluation_date, data_window_start, data_window_end) VALUES
-- Performance tracking for the last month
(1, 'Accuracy', 0.9240, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(1, 'Precision', 0.9180, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(1, 'Recall', 0.9050, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(1, 'Drift Score', 0.0450, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),

(2, 'Accuracy', 0.8870, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(2, 'Precision', 0.8920, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(2, 'Recall', 0.8650, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(2, 'Drift Score', 0.0320, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),

(3, 'Accuracy', 0.9150, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(3, 'Precision', 0.9080, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(3, 'Recall', 0.9200, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59'),
(3, 'Drift Score', 0.0280, '2024-01-25', '2024-01-01 00:00:00', '2024-01-25 23:59:59');

-- Insert Pipeline Health Data
INSERT INTO pipeline_health (pipeline_name, status, last_run_time, next_scheduled_run, records_processed, 
                            error_count, execution_time_seconds, data_quality_score) VALUES
('Sensor Data Ingestion', 'Healthy', '2024-01-26 10:30:00', '2024-01-26 11:30:00', 45280, 0, 45, 98.5),
('Health Index Calculation', 'Healthy', '2024-01-26 10:25:00', '2024-01-26 10:55:00', 26, 0, 180, 99.2),
('Anomaly Detection', 'Warning', '2024-01-26 10:20:00', '2024-01-26 10:50:00', 150, 2, 95, 97.8),
('Failure Prediction', 'Healthy', '2024-01-26 06:00:00', '2024-01-27 06:00:00', 26, 0, 320, 99.5),
('Model Training', 'Healthy', '2024-01-25 02:00:00', '2024-01-28 02:00:00', 125000, 0, 7200, 98.9);

-- Insert Alert Quality Metrics
INSERT INTO alert_metrics (alert_type, equipment_id, triggered_at, acknowledged_at, resolved_at, 
                          was_actionable, false_positive, severity, description) VALUES
('Engine Temperature Critical', 6, '2024-01-26 10:15:00', '2024-01-26 10:18:00', NULL, TRUE, FALSE, 'Critical', 
 'Engine temperature exceeded critical threshold'),
('Hydraulic Pressure Low', 6, '2024-01-26 10:20:00', '2024-01-26 10:22:00', NULL, TRUE, FALSE, 'High', 
 'Hydraulic system pressure drop detected'),
('Vibration Anomaly', 1, '2024-01-26 09:30:00', '2024-01-26 09:35:00', '2024-01-26 10:15:00', TRUE, FALSE, 'Medium', 
 'Unusual vibration pattern detected and investigated'),
('Oil Pressure Warning', 3, '2024-01-26 09:45:00', '2024-01-26 09:48:00', NULL, TRUE, FALSE, 'High', 
 'Oil pressure below normal operating range'),
('Sensor Calibration', 12, '2024-01-25 14:20:00', '2024-01-25 14:25:00', '2024-01-25 15:30:00', TRUE, FALSE, 'Low', 
 'Sensor calibration drift detected and corrected');

-- ==============================================
-- SAFETY AND COMPLIANCE
-- ==============================================

-- Insert Safety Critical Assets
INSERT INTO safety_critical_assets (equipment_id, safety_level, inspection_frequency_days, last_safety_inspection, 
                                   next_safety_inspection, compliance_status, certifications) VALUES
(17, 'Safety Critical', 30, '2024-01-10', '2024-02-09', 'Compliant', '{"MSHA", "ISO 45001", "ANSI B20.1"}'),
(18, 'Safety Critical', 30, '2024-01-15', '2024-02-14', 'Compliant', '{"MSHA", "ISO 45001", "ANSI B20.1"}'),
(6, 'Safety Related', 60, '2024-01-05', '2024-03-05', 'Under Review', '{"MSHA", "DOT"}'),
(1, 'Safety Related', 90, '2023-12-20', '2024-03-19', 'Compliant', '{"MSHA", "DOT"}'),
(7, 'Safety Critical', 45, '2024-01-08', '2024-02-22', 'Compliant', '{"MSHA", "ISO 45001"}');

-- Insert Compliance Records
INSERT INTO compliance_records (equipment_id, regulation_name, compliance_type, status, assessment_date, 
                               next_assessment_date, findings, corrective_actions, responsible_party) VALUES
(17, 'MSHA Part 56', 'Safety', 'Compliant', '2024-01-10', '2024-07-10', 
 'All safety systems operational', 'None required', 'Safety Manager'),
(6, 'DOT Vehicle Standards', 'Operational', 'Non-Compliant', '2024-01-20', '2024-02-20', 
 'Brake system requires immediate attention', 'Emergency brake repair scheduled', 'Maintenance Supervisor'),
(19, 'EPA Emissions', 'Environmental', 'Compliant', '2024-01-12', '2024-01-12', 
 'Emissions within acceptable limits', 'Continue monitoring', 'Environmental Coordinator'),
(1, 'OSHA Machine Guarding', 'Safety', 'Compliant', '2024-01-18', '2024-07-18', 
 'All guards in place and functional', 'None required', 'Safety Manager');

-- ==============================================
-- PRODUCTION DATA
-- ==============================================

-- Insert Production Data (last 7 days)
INSERT INTO production_data (equipment_id, shift_date, shift_type, operating_hours, units_processed, 
                            efficiency_percentage, downtime_minutes, downtime_reason, operator_id) VALUES
-- Recent production data for haul trucks
(1, '2024-01-25', 'Day', 10.5, 42, 87.5, 30, 'Fuel break', 'OP001'),
(1, '2024-01-25', 'Night', 8.0, 32, 85.0, 45, 'Tire inspection', 'OP002'),
(2, '2024-01-25', 'Day', 11.0, 44, 91.7, 15, 'Operator break', 'OP003'),
(2, '2024-01-25', 'Night', 9.5, 38, 89.2, 0, NULL, 'OP004'),
(3, '2024-01-25', 'Day', 9.0, 36, 78.0, 90, 'Brake inspection', 'OP005'),
(4, '2024-01-25', 'Day', 12.0, 48, 95.0, 0, NULL, 'OP006'),
(4, '2024-01-25', 'Night', 10.5, 42, 92.5, 30, 'Routine check', 'OP007'),
(5, '2024-01-25', 'Day', 11.5, 46, 90.0, 20, 'Refueling', 'OP008'),
-- Equipment out of service
(6, '2024-01-25', 'Day', 0.0, 0, 0.0, 720, 'Engine overheating - out of service', NULL);

-- ==============================================
-- DEBUG COMMENTS
-- ==============================================

-- Debug: Data population completed successfully
-- Total equipment records: 26 (covering all dashboard categories)
-- Health data: Current status for all equipment matching dashboard displays
-- Anomalies: Active anomalies matching dashboard examples
-- Failure predictions: 7-day and 30-day forecasts with confidence intervals
-- Work orders: Active and planned maintenance activities
-- Cost avoidance: Financial tracking for predictive maintenance ROI
-- Model governance: ML model registry and performance monitoring
-- Safety compliance: Critical asset tracking and regulatory compliance
-- Production data: Operational metrics for efficiency tracking

SELECT 'Database population completed successfully!' as status; 