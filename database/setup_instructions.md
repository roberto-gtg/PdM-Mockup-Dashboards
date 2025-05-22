# Asset Management PostgreSQL Database Setup

## Quick Setup Instructions

This database supports all dashboard categories in your asset management system:
- **Real-time dashboards** (Fleet Asset Health, Equipment Monitoring)
- **Reliability forecasting** (Failure predictions, MTBF/MTTR tracking)
- **Financial scorecards** (Cost avoidance, Energy consumption)
- **Model governance** (ML model performance, Data pipeline health)
- **Safety compliance** (Critical asset tracking, Regulatory compliance)

## Prerequisites

### 1. Install PostgreSQL
```bash
# macOS (using Homebrew)
brew install postgresql
brew services start postgresql

# Create a database user (optional)
createuser -s asset_admin
```

### 2. Create Database
```bash
# Create the database
createdb asset_management

# Or connect as postgres user first
psql postgres
CREATE DATABASE asset_management;
\q
```

## Database Setup

### 1. Create the Schema
```bash
cd database/
psql asset_management -f create_database.sql
```

### 2. Populate with Sample Data
```bash
psql asset_management -f populate_data.sql
```

### 3. Verify Installation
```bash
psql asset_management
\dt  -- List all tables
SELECT COUNT(*) FROM equipment;  -- Should return 26 equipment records
\q
```

## Database Structure Overview

### Core Tables
- **`equipment`** - Master equipment registry (26 industrial assets)
- **`equipment_types`** - Equipment categories (Haul Trucks, Excavators, etc.)
- **`sensor_readings`** - Real-time sensor data for monitoring
- **`equipment_health`** - Current health indexes and RUL predictions

### Monitoring & Reliability
- **`anomalies`** - Active equipment anomalies and alerts
- **`failure_predictions`** - ML-generated failure probability forecasts
- **`reliability_metrics`** - MTBF/MTTR tracking data
- **`work_orders`** - Maintenance scheduling and history

### Financial Tracking
- **`cost_avoidance`** - ROI tracking for predictive maintenance
- **`spare_parts`** - Inventory management
- **`energy_consumption`** - Equipment energy usage and costs

### Model Governance
- **`ml_models`** - ML model registry and versioning
- **`model_performance`** - Model accuracy and drift monitoring
- **`pipeline_health`** - Data pipeline status tracking

### Safety & Compliance
- **`safety_critical_assets`** - Safety classification and inspection tracking
- **`compliance_records`** - Regulatory compliance monitoring

## Sample Queries for Dashboard Integration

### 1. Fleet Asset Health (Real-time Dashboard)
```sql
-- Get current health status for all haul trucks
SELECT 
    e.unit_id,
    e.name,
    eh.health_index,
    eh.rul_hours,
    eh.calculated_at,
    string_agg(a.anomaly_type, ', ') as active_anomalies
FROM equipment e
JOIN equipment_types et ON e.equipment_type_id = et.id
LEFT JOIN equipment_health eh ON e.id = eh.equipment_id
LEFT JOIN anomalies a ON e.id = a.equipment_id AND a.status = 'Active'
WHERE et.type_name = 'Haul Truck'
GROUP BY e.unit_id, e.name, eh.health_index, eh.rul_hours, eh.calculated_at
ORDER BY eh.health_index ASC;
```

### 2. Failure Risk Forecast (Reliability Dashboard)
```sql
-- Get 7-day failure predictions with confidence intervals
SELECT 
    e.unit_id,
    e.name,
    fp.failure_probability,
    fp.confidence_interval_low,
    fp.confidence_interval_high,
    fp.ml_model,
    fp.predicted_at
FROM failure_predictions fp
JOIN equipment e ON fp.equipment_id = e.id
WHERE fp.prediction_horizon_days = 7
ORDER BY fp.failure_probability DESC;
```

### 3. Cost Avoidance Ledger (Financial Dashboard)
```sql
-- Get cost avoidance summary by month
SELECT 
    DATE_TRUNC('month', occurred_at) as month,
    COUNT(*) as avoidance_events,
    SUM(estimated_avoided_cost) as total_estimated_savings,
    SUM(actual_avoided_cost) as total_actual_savings,
    string_agg(DISTINCT avoidance_type, ', ') as avoidance_types
FROM cost_avoidance
WHERE occurred_at >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', occurred_at)
ORDER BY month DESC;
```

### 4. Model Performance Monitor (Governance Dashboard)
```sql
-- Get latest model performance metrics
SELECT 
    m.model_name,
    m.model_type,
    m.version,
    mp.metric_name,
    mp.metric_value,
    mp.evaluation_date
FROM ml_models m
JOIN model_performance mp ON m.id = mp.model_id
WHERE mp.evaluation_date = (
    SELECT MAX(evaluation_date) 
    FROM model_performance mp2 
    WHERE mp2.model_id = m.id
)
ORDER BY m.model_name, mp.metric_name;
```

### 5. Safety Critical Asset Status (Safety Dashboard)
```sql
-- Get safety critical assets requiring inspection
SELECT 
    e.unit_id,
    e.name,
    sca.safety_level,
    sca.last_safety_inspection,
    sca.next_safety_inspection,
    sca.compliance_status,
    CASE 
        WHEN sca.next_safety_inspection < CURRENT_DATE THEN 'OVERDUE'
        WHEN sca.next_safety_inspection < CURRENT_DATE + INTERVAL '7 days' THEN 'DUE_SOON'
        ELSE 'CURRENT'
    END as inspection_status
FROM safety_critical_assets sca
JOIN equipment e ON sca.equipment_id = e.id
WHERE sca.safety_level IN ('Safety Critical', 'Safety Related')
ORDER BY sca.next_safety_inspection ASC;
```

## Connection Configuration

### Environment Variables
Create a `.env` file in your project root:
```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=asset_management
DB_USER=your_username
DB_PASSWORD=your_password

# For local development
DATABASE_URL=postgresql://your_username:your_password@localhost:5432/asset_management
```

### Node.js Connection Example
```javascript
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'asset_management',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Example query function
async function getEquipmentHealth() {
  const query = `
    SELECT unit_id, health_index, rul_hours 
    FROM equipment e 
    JOIN equipment_health eh ON e.id = eh.equipment_id 
    ORDER BY health_index ASC
  `;
  const result = await pool.query(query);
  return result.rows;
}
```

### Python Connection Example
```python
import psycopg2
import pandas as pd
from sqlalchemy import create_engine

# Database connection
engine = create_engine('postgresql://username:password@localhost:5432/asset_management')

# Example query function
def get_failure_predictions():
    query = """
    SELECT e.unit_id, fp.failure_probability, fp.ml_model 
    FROM failure_predictions fp
    JOIN equipment e ON fp.equipment_id = e.id
    WHERE fp.prediction_horizon_days = 7
    ORDER BY fp.failure_probability DESC
    """
    return pd.read_sql(query, engine)
```

## Data Refresh and Maintenance

### Update Health Calculations
```sql
-- Update equipment health with new ML model results
UPDATE equipment_health 
SET health_index = ?, rul_hours = ?, confidence_score = ?, calculated_at = NOW()
WHERE equipment_id = ?;
```

### Add New Sensor Readings
```sql
-- Insert new sensor readings (typically from automated data pipeline)
INSERT INTO sensor_readings (equipment_sensor_id, timestamp, value, status)
VALUES (?, NOW(), ?, ?);
```

### Archive Old Data (Monthly Maintenance)
```sql
-- Archive sensor readings older than 1 year
DELETE FROM sensor_readings 
WHERE timestamp < NOW() - INTERVAL '1 year';

-- Archive old model performance metrics
DELETE FROM model_performance 
WHERE evaluation_date < NOW() - INTERVAL '6 months';
```

## Troubleshooting

### Common Issues

1. **Connection Refused**: Ensure PostgreSQL is running
   ```bash
   brew services restart postgresql
   ```

2. **Permission Denied**: Grant proper permissions
   ```sql
   GRANT ALL PRIVILEGES ON DATABASE asset_management TO your_username;
   ```

3. **Table Not Found**: Verify schema creation
   ```bash
   psql asset_management -c "\dt"
   ```

### Performance Optimization

1. **Index Usage**: The schema includes performance indexes for common queries
2. **Query Optimization**: Use EXPLAIN ANALYZE to optimize slow queries
3. **Connection Pooling**: Use connection pooling in production applications

## Debug Logging

To enable debug logging for database operations, add these comments to your queries:
```sql
-- Debug: Querying equipment health for dashboard refresh
-- Rule applied: Performance optimization with indexed columns
SELECT /* Debug: Fleet health query */ 
    unit_id, health_index 
FROM equipment e 
JOIN equipment_health eh ON e.id = eh.equipment_id;
```

## Success Verification

After setup, verify with this test:
```sql
-- Should return summary of all dashboard data
SELECT 
    'Equipment' as category, COUNT(*) as count FROM equipment
UNION ALL
SELECT 
    'Health Records' as category, COUNT(*) as count FROM equipment_health
UNION ALL
SELECT 
    'Active Anomalies' as category, COUNT(*) as count FROM anomalies WHERE status = 'Active'
UNION ALL
SELECT 
    'Failure Predictions' as category, COUNT(*) as count FROM failure_predictions
UNION ALL
SELECT 
    'ML Models' as category, COUNT(*) as count FROM ml_models WHERE is_active = TRUE;
```

Expected results:
- Equipment: 26
- Health Records: 26  
- Active Anomalies: 15
- Failure Predictions: 12
- ML Models: 4

The database is now ready for your dashboard system! 🚀 