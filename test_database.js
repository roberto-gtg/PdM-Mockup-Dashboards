// Test script for Asset Management Database
// Debug rule applied: Comprehensive logging for database testing

require('dotenv').config();
const { Pool } = require('pg');

// Database connection pool
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'asset_management',
  user: process.env.DB_USER || process.env.USER, // Use system username as default
  password: process.env.DB_PASSWORD,
});

async function testDatabase() {
  try {
    console.log('Debug: Testing database connection...');
    
    // Test 1: Basic connection
    const client = await pool.connect();
    console.log('✅ Database connection successful');
    
    // Test 2: Equipment count
    const equipmentResult = await client.query('SELECT COUNT(*) as count FROM equipment');
    console.log(`✅ Equipment records: ${equipmentResult.rows[0].count}`);
    
    // Test 3: Fleet health data (matching dashboard)
    const healthQuery = `
      SELECT 
        e.unit_id,
        e.name,
        eh.health_index,
        eh.rul_hours,
        string_agg(a.anomaly_type, ', ') as anomalies
      FROM equipment e
      JOIN equipment_health eh ON e.id = eh.equipment_id
      LEFT JOIN anomalies a ON e.id = a.equipment_id AND a.status = 'Active'
      WHERE e.unit_id LIKE 'HT-%'
      GROUP BY e.unit_id, e.name, eh.health_index, eh.rul_hours
      ORDER BY eh.health_index ASC
      LIMIT 5
    `;
    
    const healthResult = await client.query(healthQuery);
    console.log('✅ Fleet health data sample:');
    healthResult.rows.forEach(row => {
      console.log(`   ${row.unit_id}: ${row.health_index}% health, ${row.rul_hours}h RUL`);
      if (row.anomalies) {
        console.log(`     Anomalies: ${row.anomalies}`);
      }
    });
    
    // Test 4: Failure predictions
    const predictionsQuery = `
      SELECT 
        e.unit_id,
        fp.failure_probability,
        fp.prediction_horizon_days,
        fp.ml_model
      FROM failure_predictions fp
      JOIN equipment e ON fp.equipment_id = e.id
      WHERE fp.prediction_horizon_days = 7
      ORDER BY fp.failure_probability DESC
      LIMIT 3
    `;
    
    const predictionsResult = await client.query(predictionsQuery);
    console.log('✅ Failure predictions (7-day horizon):');
    predictionsResult.rows.forEach(row => {
      console.log(`   ${row.unit_id}: ${row.failure_probability}% risk (${row.ml_model})`);
    });
    
    // Test 5: Cost avoidance summary
    const costQuery = `
      SELECT 
        COUNT(*) as events,
        SUM(estimated_avoided_cost) as total_savings
      FROM cost_avoidance
      WHERE occurred_at >= CURRENT_DATE - INTERVAL '30 days'
    `;
    
    const costResult = await client.query(costQuery);
    console.log(`✅ Cost avoidance (last 30 days): ${costResult.rows[0].events} events, $${parseFloat(costResult.rows[0].total_savings || 0).toLocaleString()} savings`);
    
    client.release();
    console.log('\n🚀 Database setup complete and ready for dashboard integration!');
    
  } catch (error) {
    console.error('❌ Database test failed:', error.message);
    console.error('Debug info:', error);
  } finally {
    await pool.end();
  }
}

// Run the test
testDatabase(); 