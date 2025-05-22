-- Asset Management Dashboard Database Schema
-- Created for industrial asset monitoring and predictive maintenance

-- ==============================================
-- CORE EQUIPMENT AND ASSET TABLES
-- ==============================================

-- Equipment Types and Categories
CREATE TABLE equipment_types (
    id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE, -- 'Haul Truck', 'Excavator', 'Drill', etc.
    category VARCHAR(30) NOT NULL, -- 'Mobile', 'Fixed', 'Conveyor'
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main Equipment/Asset Registry
CREATE TABLE equipment (
    id SERIAL PRIMARY KEY,
    unit_id VARCHAR(20) NOT NULL UNIQUE, -- HT-101, EX-205, etc.
    equipment_type_id INTEGER REFERENCES equipment_types(id),
    name VARCHAR(100) NOT NULL,
    model VARCHAR(50),
    manufacturer VARCHAR(50),
    year_manufactured INTEGER,
    installation_date DATE,
    location VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Active', -- Active, Maintenance, Retired
    criticality_level VARCHAR(10) DEFAULT 'Medium', -- Critical, High, Medium, Low
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- SENSOR AND MONITORING DATA
-- ==============================================

-- Sensor Types and Specifications
CREATE TABLE sensor_types (
    id SERIAL PRIMARY KEY,
    sensor_type VARCHAR(50) NOT NULL, -- 'Temperature', 'Vibration', 'Pressure', etc.
    unit_of_measure VARCHAR(20), -- 'Celsius', 'Hz', 'PSI', 'RPM'
    normal_range_min DECIMAL(10,2),
    normal_range_max DECIMAL(10,2),
    critical_threshold DECIMAL(10,2),
    description TEXT
);

-- Equipment Sensors Mapping
CREATE TABLE equipment_sensors (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    sensor_type_id INTEGER REFERENCES sensor_types(id),
    sensor_location VARCHAR(100), -- 'Engine', 'Transmission', 'Hydraulic System'
    installation_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Real-time Sensor Readings
CREATE TABLE sensor_readings (
    id SERIAL PRIMARY KEY,
    equipment_sensor_id INTEGER REFERENCES equipment_sensors(id),
    timestamp TIMESTAMP NOT NULL,
    value DECIMAL(10,4) NOT NULL,
    status VARCHAR(20) DEFAULT 'Normal', -- Normal, Warning, Critical, Error
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- HEALTH AND RELIABILITY TRACKING
-- ==============================================

-- Health Index Calculations (for dashboards)
CREATE TABLE equipment_health (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    health_index DECIMAL(5,2) NOT NULL, -- 0-100%
    rul_hours INTEGER, -- Remaining Useful Life in hours
    confidence_score DECIMAL(5,2), -- ML model confidence
    calculated_at TIMESTAMP NOT NULL,
    model_version VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Anomaly Detection Results
CREATE TABLE anomalies (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    anomaly_type VARCHAR(50) NOT NULL, -- 'Engine Temp High', 'Vibration Excessive'
    severity VARCHAR(20) NOT NULL, -- 'Critical', 'High', 'Medium', 'Low'
    description TEXT,
    detected_at TIMESTAMP NOT NULL,
    resolved_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Active', -- Active, Acknowledged, Resolved
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Failure Predictions and Risk Assessment
CREATE TABLE failure_predictions (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    failure_probability DECIMAL(5,2) NOT NULL, -- 0-100%
    confidence_interval_low DECIMAL(5,2),
    confidence_interval_high DECIMAL(5,2),
    prediction_horizon_days INTEGER, -- 7, 30, 90 days
    ml_model VARCHAR(50), -- 'Gradient Boosting', 'LSTM', 'Random Forest'
    model_version VARCHAR(20),
    predicted_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- MAINTENANCE AND OPERATIONS
-- ==============================================

-- Maintenance Work Orders
CREATE TABLE work_orders (
    id SERIAL PRIMARY KEY,
    wo_number VARCHAR(20) NOT NULL UNIQUE,
    equipment_id INTEGER REFERENCES equipment(id),
    work_type VARCHAR(30) NOT NULL, -- 'Preventive', 'Predictive', 'Corrective', 'Emergency'
    priority VARCHAR(20) DEFAULT 'Medium', -- Critical, High, Medium, Low
    description TEXT,
    estimated_hours DECIMAL(6,2),
    actual_hours DECIMAL(6,2),
    estimated_cost DECIMAL(12,2),
    actual_cost DECIMAL(12,2),
    scheduled_date DATE,
    start_date TIMESTAMP,
    completion_date TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Planned', -- Planned, In Progress, Completed, Cancelled
    technician_assigned VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Maintenance History and Events
CREATE TABLE maintenance_events (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    work_order_id INTEGER REFERENCES work_orders(id),
    event_type VARCHAR(30) NOT NULL, -- 'Repair', 'Replacement', 'Inspection', 'Calibration'
    description TEXT,
    parts_used TEXT[], -- Array of part numbers
    labor_hours DECIMAL(6,2),
    cost DECIMAL(12,2),
    performed_by VARCHAR(100),
    performed_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MTBF/MTTR Tracking
CREATE TABLE reliability_metrics (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    metric_type VARCHAR(10) NOT NULL, -- 'MTBF', 'MTTR'
    value_hours DECIMAL(10,2) NOT NULL,
    calculation_period_start DATE,
    calculation_period_end DATE,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- FINANCIAL AND COST TRACKING
-- ==============================================

-- Cost Avoidance Tracking
CREATE TABLE cost_avoidance (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    work_order_id INTEGER REFERENCES work_orders(id),
    avoidance_type VARCHAR(50) NOT NULL, -- 'Avoided Failure', 'Early Detection', 'Optimized Maintenance'
    estimated_avoided_cost DECIMAL(12,2) NOT NULL,
    actual_avoided_cost DECIMAL(12,2),
    description TEXT,
    calculation_method VARCHAR(100),
    occurred_at DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Spare Parts Inventory and Demand
CREATE TABLE spare_parts (
    id SERIAL PRIMARY KEY,
    part_number VARCHAR(50) NOT NULL UNIQUE,
    part_name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50), -- 'Engine', 'Hydraulic', 'Electrical', etc.
    unit_cost DECIMAL(10,2),
    current_stock INTEGER DEFAULT 0,
    reorder_point INTEGER DEFAULT 0,
    lead_time_days INTEGER,
    supplier VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Spare Parts Demand Predictions
CREATE TABLE parts_demand_forecast (
    id SERIAL PRIMARY KEY,
    spare_part_id INTEGER REFERENCES spare_parts(id),
    equipment_id INTEGER REFERENCES equipment(id),
    predicted_demand INTEGER NOT NULL,
    forecast_period_start DATE,
    forecast_period_end DATE,
    confidence_level DECIMAL(5,2),
    ml_model VARCHAR(50),
    forecasted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Energy Consumption Tracking
CREATE TABLE energy_consumption (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    consumption_kwh DECIMAL(10,2) NOT NULL,
    cost_usd DECIMAL(10,2),
    recorded_date DATE NOT NULL,
    energy_type VARCHAR(20) DEFAULT 'Electricity', -- Electricity, Diesel, Gas
    efficiency_rating DECIMAL(5,2), -- kWh per unit of production
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- MODEL GOVERNANCE AND DATA QUALITY
-- ==============================================

-- ML Model Registry
CREATE TABLE ml_models (
    id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_type VARCHAR(50) NOT NULL, -- 'Gradient Boosting', 'LSTM', 'Random Forest'
    version VARCHAR(20) NOT NULL,
    purpose VARCHAR(100), -- 'Failure Prediction', 'Health Scoring', 'Anomaly Detection'
    accuracy_score DECIMAL(5,4),
    deployment_date DATE,
    last_retrained DATE,
    is_active BOOLEAN DEFAULT TRUE,
    configuration JSONB, -- Model hyperparameters and settings
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Model Performance Monitoring
CREATE TABLE model_performance (
    id SERIAL PRIMARY KEY,
    model_id INTEGER REFERENCES ml_models(id),
    metric_name VARCHAR(50) NOT NULL, -- 'Accuracy', 'Precision', 'Recall', 'Drift Score'
    metric_value DECIMAL(8,4) NOT NULL,
    evaluation_date DATE NOT NULL,
    data_window_start TIMESTAMP,
    data_window_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Data Pipeline Health Monitoring
CREATE TABLE pipeline_health (
    id SERIAL PRIMARY KEY,
    pipeline_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'Healthy', 'Warning', 'Critical', 'Failed'
    last_run_time TIMESTAMP,
    next_scheduled_run TIMESTAMP,
    records_processed INTEGER,
    error_count INTEGER DEFAULT 0,
    execution_time_seconds INTEGER,
    data_quality_score DECIMAL(5,2), -- 0-100%
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alert Quality and Effectiveness
CREATE TABLE alert_metrics (
    id SERIAL PRIMARY KEY,
    alert_type VARCHAR(50) NOT NULL,
    equipment_id INTEGER REFERENCES equipment(id),
    triggered_at TIMESTAMP NOT NULL,
    acknowledged_at TIMESTAMP,
    resolved_at TIMESTAMP,
    was_actionable BOOLEAN,
    false_positive BOOLEAN DEFAULT FALSE,
    severity VARCHAR(20),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- SAFETY AND COMPLIANCE
-- ==============================================

-- Safety Critical Assets
CREATE TABLE safety_critical_assets (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    safety_level VARCHAR(20) NOT NULL, -- 'Safety Critical', 'Safety Related', 'Non-Safety'
    inspection_frequency_days INTEGER,
    last_safety_inspection DATE,
    next_safety_inspection DATE,
    compliance_status VARCHAR(20) DEFAULT 'Compliant', -- Compliant, Non-Compliant, Under Review
    certifications TEXT[], -- Array of required certifications
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Compliance Tracking
CREATE TABLE compliance_records (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    regulation_name VARCHAR(100) NOT NULL,
    compliance_type VARCHAR(50), -- 'Environmental', 'Safety', 'Operational'
    status VARCHAR(20) NOT NULL, -- 'Compliant', 'Non-Compliant', 'Pending'
    assessment_date DATE,
    next_assessment_date DATE,
    findings TEXT,
    corrective_actions TEXT,
    responsible_party VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- OPERATIONAL DATA
-- ==============================================

-- Production Metrics
CREATE TABLE production_data (
    id SERIAL PRIMARY KEY,
    equipment_id INTEGER REFERENCES equipment(id),
    shift_date DATE NOT NULL,
    shift_type VARCHAR(20), -- 'Day', 'Night', 'Weekend'
    operating_hours DECIMAL(6,2),
    units_processed INTEGER,
    efficiency_percentage DECIMAL(5,2),
    downtime_minutes INTEGER DEFAULT 0,
    downtime_reason VARCHAR(100),
    operator_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- INDEXES FOR PERFORMANCE
-- ==============================================

-- Performance indexes for commonly queried columns
CREATE INDEX idx_equipment_unit_id ON equipment(unit_id);
CREATE INDEX idx_equipment_type ON equipment(equipment_type_id);
CREATE INDEX idx_sensor_readings_timestamp ON sensor_readings(timestamp);
CREATE INDEX idx_sensor_readings_equipment ON sensor_readings(equipment_sensor_id);
CREATE INDEX idx_equipment_health_timestamp ON equipment_health(calculated_at);
CREATE INDEX idx_anomalies_equipment_detected ON anomalies(equipment_id, detected_at);
CREATE INDEX idx_failure_predictions_equipment ON failure_predictions(equipment_id, predicted_at);
CREATE INDEX idx_work_orders_equipment ON work_orders(equipment_id);
CREATE INDEX idx_maintenance_events_equipment ON maintenance_events(equipment_id, performed_at);

-- ==============================================
-- COMMENTS AND DOCUMENTATION
-- ==============================================

COMMENT ON DATABASE asset_management IS 'Industrial Asset Management and Predictive Maintenance Database';
COMMENT ON TABLE equipment IS 'Master registry of all industrial equipment and assets';
COMMENT ON TABLE sensor_readings IS 'Time-series data from equipment sensors for real-time monitoring';
COMMENT ON TABLE equipment_health IS 'Calculated health indexes and RUL predictions for each asset';
COMMENT ON TABLE anomalies IS 'Detected anomalies and their resolution status';
COMMENT ON TABLE failure_predictions IS 'ML-generated failure probability forecasts';
COMMENT ON TABLE work_orders IS 'Maintenance work orders and scheduling';
COMMENT ON TABLE cost_avoidance IS 'Tracked cost savings from predictive maintenance activities';
COMMENT ON TABLE ml_models IS 'Registry of deployed machine learning models';
COMMENT ON TABLE model_performance IS 'Monitoring metrics for ML model performance and drift'; 