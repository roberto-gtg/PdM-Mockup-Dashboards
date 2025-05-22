/**
 * Asset Management Dashboard API Examples
 * 
 * This file contains example API endpoints for integrating the PostgreSQL database
 * with your dashboard system. Each endpoint corresponds to a specific dashboard
 * category and provides the data structure needed for the frontend.
 * 
 * Debug rule applied: Comprehensive logging and error handling for easier debugging
 */

const { Pool } = require('pg');
const express = require('express');
const app = express();

// Database connection pool - Debug: Using connection pooling for performance
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'asset_management',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Debug: Log database connection status
pool.on('connect', () => {
  console.log('Debug: Connected to PostgreSQL database');
});

pool.on('error', (err) => {
  console.error('Debug: Database connection error:', err);
});

// ==============================================
// REAL-TIME DASHBOARD ENDPOINTS
// ==============================================

/**
 * GET /api/fleet-health
 * Returns current health status for all equipment (Fleet Asset Health Dashboard)
 * 
 * Rule applied: Performance optimization with indexed queries
 */
app.get('/api/fleet-health', async (req, res) => {
  const { equipmentType = 'Haul Truck' } = req.query;
  
  try {
    console.log(`Debug: Fetching fleet health data for ${equipmentType}`);
    
    const query = `
      SELECT 
          e.unit_id,
          e.name,
          et.type_name as equipment_type,
          eh.health_index,
          eh.rul_hours,
          eh.confidence_score,
          eh.calculated_at as last_updated,
          COALESCE(
              string_agg(
                  CASE WHEN a.status = 'Active' 
                       THEN a.anomaly_type || ':' || a.severity 
                       ELSE NULL END, 
                  ', '
              ), 
              'No anomalies detected'
          ) as anomalies
      FROM equipment e
      JOIN equipment_types et ON e.equipment_type_id = et.id
      LEFT JOIN equipment_health eh ON e.id = eh.equipment_id
      LEFT JOIN anomalies a ON e.id = a.equipment_id
      WHERE et.type_name = $1 AND e.status = 'Active'
      GROUP BY e.unit_id, e.name, et.type_name, eh.health_index, eh.rul_hours, eh.confidence_score, eh.calculated_at
      ORDER BY eh.health_index ASC;
    `;
    
    const result = await pool.query(query, [equipmentType]);
    
    console.log(`Debug: Retrieved ${result.rows.length} ${equipmentType} records`);
    
    res.json({
      success: true,
      data: result.rows,
      timestamp: new Date().toISOString(),
      total_count: result.rows.length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching fleet health:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch fleet health data',
      debug_info: error.message
    });
  }
});

/**
 * GET /api/real-time-sensors/:equipmentId
 * Returns recent sensor readings for specific equipment
 */
app.get('/api/real-time-sensors/:equipmentId', async (req, res) => {
  const { equipmentId } = req.params;
  const { hours = 24 } = req.query;
  
  try {
    console.log(`Debug: Fetching sensor data for equipment ${equipmentId} (last ${hours} hours)`);
    
    const query = `
      SELECT 
          st.sensor_type,
          st.unit_of_measure,
          es.sensor_location,
          sr.value,
          sr.status,
          sr.timestamp,
          st.normal_range_min,
          st.normal_range_max,
          st.critical_threshold
      FROM sensor_readings sr
      JOIN equipment_sensors es ON sr.equipment_sensor_id = es.id
      JOIN sensor_types st ON es.sensor_type_id = st.id
      JOIN equipment e ON es.equipment_id = e.id
      WHERE e.unit_id = $1 
        AND sr.timestamp >= NOW() - INTERVAL '${hours} hours'
        AND es.is_active = true
      ORDER BY sr.timestamp DESC, st.sensor_type;
    `;
    
    const result = await pool.query(query, [equipmentId]);
    
    res.json({
      success: true,
      equipment_id: equipmentId,
      data: result.rows,
      time_range: `${hours} hours`,
      total_readings: result.rows.length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching sensor data:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch sensor data'
    });
  }
});

// ==============================================
// RELIABILITY DASHBOARD ENDPOINTS
// ==============================================

/**
 * GET /api/failure-predictions
 * Returns failure probability forecasts (Failure Risk Forecast Dashboard)
 */
app.get('/api/failure-predictions', async (req, res) => {
  const { horizon = 7, minProbability = 0 } = req.query;
  
  try {
    console.log(`Debug: Fetching ${horizon}-day failure predictions (min probability: ${minProbability}%)`);
    
    const query = `
      SELECT 
          e.unit_id,
          e.name,
          et.type_name as equipment_type,
          fp.failure_probability,
          fp.confidence_interval_low,
          fp.confidence_interval_high,
          fp.ml_model,
          fp.model_version,
          fp.predicted_at,
          eh.health_index,
          eh.rul_hours
      FROM failure_predictions fp
      JOIN equipment e ON fp.equipment_id = e.id
      JOIN equipment_types et ON e.equipment_type_id = et.id
      LEFT JOIN equipment_health eh ON e.id = eh.equipment_id
      WHERE fp.prediction_horizon_days = $1 
        AND fp.failure_probability >= $2
        AND e.status = 'Active'
      ORDER BY fp.failure_probability DESC;
    `;
    
    const result = await pool.query(query, [horizon, minProbability]);
    
    res.json({
      success: true,
      prediction_horizon_days: parseInt(horizon),
      data: result.rows,
      high_risk_count: result.rows.filter(r => r.failure_probability >= 70).length,
      medium_risk_count: result.rows.filter(r => r.failure_probability >= 40 && r.failure_probability < 70).length,
      low_risk_count: result.rows.filter(r => r.failure_probability < 40).length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching failure predictions:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch failure predictions' });
  }
});

/**
 * GET /api/mtbf-mttr
 * Returns MTBF/MTTR reliability metrics
 */
app.get('/api/mtbf-mttr', async (req, res) => {
  try {
    console.log('Debug: Fetching MTBF/MTTR reliability metrics');
    
    const query = `
      SELECT 
          e.unit_id,
          e.name,
          et.type_name as equipment_type,
          MAX(CASE WHEN rm.metric_type = 'MTBF' THEN rm.value_hours END) as mtbf_hours,
          MAX(CASE WHEN rm.metric_type = 'MTTR' THEN rm.value_hours END) as mttr_hours,
          rm.calculation_period_start,
          rm.calculation_period_end
      FROM reliability_metrics rm
      JOIN equipment e ON rm.equipment_id = e.id
      JOIN equipment_types et ON e.equipment_type_id = et.id
      WHERE rm.calculated_at >= CURRENT_DATE - INTERVAL '1 year'
      GROUP BY e.unit_id, e.name, et.type_name, rm.calculation_period_start, rm.calculation_period_end
      ORDER BY equipment_type, e.unit_id;
    `;
    
    const result = await pool.query(query);
    
    // Calculate fleet averages by equipment type
    const fleetAverages = {};
    result.rows.forEach(row => {
      if (!fleetAverages[row.equipment_type]) {
        fleetAverages[row.equipment_type] = { mtbf: [], mttr: [] };
      }
      if (row.mtbf_hours) fleetAverages[row.equipment_type].mtbf.push(row.mtbf_hours);
      if (row.mttr_hours) fleetAverages[row.equipment_type].mttr.push(row.mttr_hours);
    });
    
    Object.keys(fleetAverages).forEach(type => {
      const mtbfValues = fleetAverages[type].mtbf;
      const mttrValues = fleetAverages[type].mttr;
      fleetAverages[type] = {
        avg_mtbf: mtbfValues.length ? mtbfValues.reduce((a, b) => a + b) / mtbfValues.length : 0,
        avg_mttr: mttrValues.length ? mttrValues.reduce((a, b) => a + b) / mttrValues.length : 0,
        equipment_count: mtbfValues.length
      };
    });
    
    res.json({
      success: true,
      individual_metrics: result.rows,
      fleet_averages: fleetAverages,
      calculation_period: '6 months'
    });
    
  } catch (error) {
    console.error('Debug: Error fetching MTBF/MTTR data:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch reliability metrics' });
  }
});

// ==============================================
// FINANCIAL DASHBOARD ENDPOINTS
// ==============================================

/**
 * GET /api/cost-avoidance
 * Returns cost avoidance tracking data (Cost Avoidance Ledger)
 */
app.get('/api/cost-avoidance', async (req, res) => {
  const { months = 6 } = req.query;
  
  try {
    console.log(`Debug: Fetching cost avoidance data for last ${months} months`);
    
    const query = `
      SELECT 
          ca.id,
          e.unit_id,
          e.name as equipment_name,
          et.type_name as equipment_type,
          ca.avoidance_type,
          ca.estimated_avoided_cost,
          ca.actual_avoided_cost,
          ca.description,
          ca.calculation_method,
          ca.occurred_at,
          wo.wo_number,
          wo.work_type
      FROM cost_avoidance ca
      JOIN equipment e ON ca.equipment_id = e.id
      JOIN equipment_types et ON e.equipment_type_id = et.id
      LEFT JOIN work_orders wo ON ca.work_order_id = wo.id
      WHERE ca.occurred_at >= CURRENT_DATE - INTERVAL '${months} months'
      ORDER BY ca.occurred_at DESC;
    `;
    
    const summaryQuery = `
      SELECT 
          DATE_TRUNC('month', occurred_at) as month,
          COUNT(*) as event_count,
          SUM(estimated_avoided_cost) as total_estimated,
          SUM(actual_avoided_cost) as total_actual,
          string_agg(DISTINCT avoidance_type, ', ') as avoidance_types
      FROM cost_avoidance
      WHERE occurred_at >= CURRENT_DATE - INTERVAL '${months} months'
      GROUP BY DATE_TRUNC('month', occurred_at)
      ORDER BY month DESC;
    `;
    
    const [detailResult, summaryResult] = await Promise.all([
      pool.query(query),
      pool.query(summaryQuery)
    ]);
    
    const totalEstimated = detailResult.rows.reduce((sum, row) => sum + parseFloat(row.estimated_avoided_cost || 0), 0);
    const totalActual = detailResult.rows.reduce((sum, row) => sum + parseFloat(row.actual_avoided_cost || 0), 0);
    
    res.json({
      success: true,
      summary: {
        total_estimated_savings: totalEstimated,
        total_actual_savings: totalActual,
        total_events: detailResult.rows.length,
        period_months: parseInt(months)
      },
      monthly_breakdown: summaryResult.rows,
      detailed_records: detailResult.rows
    });
    
  } catch (error) {
    console.error('Debug: Error fetching cost avoidance data:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch cost avoidance data' });
  }
});

/**
 * GET /api/energy-consumption
 * Returns energy consumption and efficiency data
 */
app.get('/api/energy-consumption', async (req, res) => {
  const { equipmentType, days = 30 } = req.query;
  
  try {
    console.log(`Debug: Fetching energy consumption data for ${days} days`);
    
    let whereClause = '';
    let queryParams = [days];
    
    if (equipmentType) {
      whereClause = 'AND et.type_name = $2';
      queryParams.push(equipmentType);
    }
    
    const query = `
      SELECT 
          e.unit_id,
          e.name,
          et.type_name as equipment_type,
          ec.consumption_kwh,
          ec.cost_usd,
          ec.recorded_date,
          ec.energy_type,
          ec.efficiency_rating,
          eh.health_index
      FROM energy_consumption ec
      JOIN equipment e ON ec.equipment_id = e.id
      JOIN equipment_types et ON e.equipment_type_id = et.id
      LEFT JOIN equipment_health eh ON e.id = eh.equipment_id
      WHERE ec.recorded_date >= CURRENT_DATE - INTERVAL '${days} days' ${whereClause}
      ORDER BY ec.recorded_date DESC, e.unit_id;
    `;
    
    const result = await pool.query(query, queryParams);
    
    // Calculate efficiency correlations
    const efficiencyData = result.rows.map(row => ({
      unit_id: row.unit_id,
      health_index: row.health_index,
      efficiency_rating: row.efficiency_rating,
      cost_per_kwh: row.consumption_kwh > 0 ? row.cost_usd / row.consumption_kwh : 0
    }));
    
    res.json({
      success: true,
      data: result.rows,
      efficiency_analysis: efficiencyData,
      period_days: parseInt(days),
      total_records: result.rows.length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching energy consumption:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch energy consumption data' });
  }
});

// ==============================================
// MODEL GOVERNANCE ENDPOINTS
// ==============================================

/**
 * GET /api/model-performance
 * Returns ML model performance metrics (Model Governance Dashboard)
 */
app.get('/api/model-performance', async (req, res) => {
  try {
    console.log('Debug: Fetching ML model performance metrics');
    
    const query = `
      SELECT 
          m.id as model_id,
          m.model_name,
          m.model_type,
          m.version,
          m.purpose,
          m.accuracy_score,
          m.deployment_date,
          m.last_retrained,
          m.is_active,
          json_agg(
              json_build_object(
                  'metric_name', mp.metric_name,
                  'metric_value', mp.metric_value,
                  'evaluation_date', mp.evaluation_date
              ) ORDER BY mp.evaluation_date DESC
          ) as recent_metrics
      FROM ml_models m
      LEFT JOIN model_performance mp ON m.id = mp.model_id
      WHERE mp.evaluation_date >= CURRENT_DATE - INTERVAL '30 days' OR mp.evaluation_date IS NULL
      GROUP BY m.id, m.model_name, m.model_type, m.version, m.purpose, m.accuracy_score, m.deployment_date, m.last_retrained, m.is_active
      ORDER BY m.is_active DESC, m.model_name;
    `;
    
    const result = await pool.query(query);
    
    res.json({
      success: true,
      models: result.rows,
      active_model_count: result.rows.filter(m => m.is_active).length,
      total_model_count: result.rows.length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching model performance:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch model performance data' });
  }
});

/**
 * GET /api/pipeline-health
 * Returns data pipeline health status
 */
app.get('/api/pipeline-health', async (req, res) => {
  try {
    console.log('Debug: Fetching data pipeline health status');
    
    const query = `
      SELECT 
          pipeline_name,
          status,
          last_run_time,
          next_scheduled_run,
          records_processed,
          error_count,
          execution_time_seconds,
          data_quality_score,
          CASE 
              WHEN next_scheduled_run < NOW() AND status != 'Failed' THEN 'OVERDUE'
              WHEN error_count > 0 THEN 'WARNING'
              WHEN status = 'Failed' THEN 'FAILED'
              ELSE status
          END as computed_status
      FROM pipeline_health
      ORDER BY 
          CASE status 
              WHEN 'Failed' THEN 1 
              WHEN 'Critical' THEN 2
              WHEN 'Warning' THEN 3
              WHEN 'Healthy' THEN 4
              ELSE 5
          END,
          pipeline_name;
    `;
    
    const result = await pool.query(query);
    
    const statusCounts = result.rows.reduce((acc, row) => {
      acc[row.computed_status] = (acc[row.computed_status] || 0) + 1;
      return acc;
    }, {});
    
    res.json({
      success: true,
      pipelines: result.rows,
      status_summary: statusCounts,
      total_pipelines: result.rows.length
    });
    
  } catch (error) {
    console.error('Debug: Error fetching pipeline health:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch pipeline health data' });
  }
});

// ==============================================
// MAINTENANCE & WORK ORDERS
// ==============================================

/**
 * GET /api/work-orders
 * Returns current work orders and maintenance schedule
 */
app.get('/api/work-orders', async (req, res) => {
  const { status, priority } = req.query;
  
  try {
    console.log('Debug: Fetching work orders');
    
    let whereConditions = [];
    let queryParams = [];
    
    if (status) {
      whereConditions.push(`wo.status = $${queryParams.length + 1}`);
      queryParams.push(status);
    }
    
    if (priority) {
      whereConditions.push(`wo.priority = $${queryParams.length + 1}`);
      queryParams.push(priority);
    }
    
    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';
    
    const query = `
      SELECT 
          wo.wo_number,
          wo.work_type,
          wo.priority,
          wo.description,
          wo.estimated_hours,
          wo.actual_hours,
          wo.estimated_cost,
          wo.actual_cost,
          wo.scheduled_date,
          wo.start_date,
          wo.completion_date,
          wo.status,
          wo.technician_assigned,
          e.unit_id,
          e.name as equipment_name,
          et.type_name as equipment_type,
          eh.health_index
      FROM work_orders wo
      JOIN equipment e ON wo.equipment_id = e.id
      JOIN equipment_types et ON e.equipment_type_id = et.id
      LEFT JOIN equipment_health eh ON e.id = eh.equipment_id
      ${whereClause}
      ORDER BY 
          CASE wo.priority 
              WHEN 'Critical' THEN 1 
              WHEN 'High' THEN 2 
              WHEN 'Medium' THEN 3 
              WHEN 'Low' THEN 4 
          END,
          wo.scheduled_date ASC;
    `;
    
    const result = await pool.query(query, queryParams);
    
    res.json({
      success: true,
      work_orders: result.rows,
      total_count: result.rows.length,
      filters_applied: { status, priority }
    });
    
  } catch (error) {
    console.error('Debug: Error fetching work orders:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch work orders' });
  }
});

// ==============================================
// UTILITY ENDPOINTS
// ==============================================

/**
 * GET /api/dashboard-summary
 * Returns high-level summary for main dashboard
 */
app.get('/api/dashboard-summary', async (req, res) => {
  try {
    console.log('Debug: Fetching dashboard summary');
    
    const queries = {
      equipment: 'SELECT COUNT(*) as count FROM equipment WHERE status = \'Active\'',
      critical_health: 'SELECT COUNT(*) as count FROM equipment_health WHERE health_index < 70',
      active_anomalies: 'SELECT COUNT(*) as count FROM anomalies WHERE status = \'Active\'',
      pending_work_orders: 'SELECT COUNT(*) as count FROM work_orders WHERE status IN (\'Planned\', \'In Progress\')',
      cost_savings_mtd: `
        SELECT COALESCE(SUM(actual_avoided_cost), 0) as total 
        FROM cost_avoidance 
        WHERE occurred_at >= DATE_TRUNC('month', CURRENT_DATE)
      `,
      high_risk_predictions: `
        SELECT COUNT(*) as count 
        FROM failure_predictions 
        WHERE failure_probability >= 70 AND prediction_horizon_days = 7
      `
    };
    
    const results = {};
    for (const [key, query] of Object.entries(queries)) {
      const result = await pool.query(query);
      results[key] = result.rows[0].count || result.rows[0].total || 0;
    }
    
    res.json({
      success: true,
      summary: results,
      generated_at: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Debug: Error fetching dashboard summary:', error);
    res.status(500).json({ success: false, error: 'Failed to fetch dashboard summary' });
  }
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Debug: Unhandled error:', error);
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    debug_info: process.env.NODE_ENV === 'development' ? error.message : undefined
  });
});

// Start server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Debug: Asset Management API server running on port ${PORT}`);
  console.log(`Debug: Available endpoints:`);
  console.log(`  - GET /api/fleet-health`);
  console.log(`  - GET /api/failure-predictions`);
  console.log(`  - GET /api/cost-avoidance`);
  console.log(`  - GET /api/model-performance`);
  console.log(`  - GET /api/dashboard-summary`);
});

module.exports = app; 