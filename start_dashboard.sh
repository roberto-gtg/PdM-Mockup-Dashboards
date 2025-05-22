#!/bin/bash

# Asset Management Dashboard Startup Script
# Debug rule applied: Comprehensive logging for easier troubleshooting

echo "🚀 Starting Asset Management Dashboard System..."
echo "Debug: Checking prerequisites..."

# Check if PostgreSQL is running
if ! pgrep -x "postgres" > /dev/null; then
    echo "⚠️  Starting PostgreSQL service..."
    brew services start postgresql@14
    sleep 2
fi

# Check if database exists
if ! psql -lqt | cut -d \| -f 1 | grep -qw asset_management; then
    echo "❌ Database 'asset_management' not found. Please run setup first."
    echo "   Run: createdb asset_management && cd database && psql asset_management -f create_database.sql -f populate_data.sql"
    exit 1
fi

# Add PostgreSQL to PATH if not already there
export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

echo "✅ PostgreSQL running"
echo "✅ Database verified"

# Test database connectivity
echo "🔍 Testing database connection..."
if node test_database.js > /dev/null 2>&1; then
    echo "✅ Database connection successful"
else
    echo "❌ Database connection failed. Check logs:"
    node test_database.js
    exit 1
fi

echo ""
echo "📊 Dashboard System Ready!"
echo ""
echo "Available options:"
echo "1. Start API server:     node database/api_examples.js"
echo "2. Test database:        node test_database.js"
echo "3. Open dashboards:      open index.html"
echo ""
echo "API Endpoints (when server running):"
echo "- Fleet Health:          http://localhost:3001/api/fleet-health"
echo "- Failure Predictions:   http://localhost:3001/api/failure-predictions"
echo "- Cost Avoidance:        http://localhost:3001/api/cost-avoidance"
echo "- Model Performance:     http://localhost:3001/api/model-performance"
echo "- Dashboard Summary:     http://localhost:3001/api/dashboard-summary"
echo ""
echo "📁 Dashboard Files Location:"
echo "- Real-time dashboards:  ./dashboards/realtime/"
echo "- Reliability reports:   ./dashboards/reliability/"
echo "- Financial scorecards:  ./dashboards/financial/"
echo "- Governance dashboards: ./dashboards/governance/"
echo "- Specialty analytics:   ./dashboards/specialty/"
echo ""

# Optional: Start API server automatically
read -p "Start API server now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌐 Starting API server on http://localhost:3001..."
    node database/api_examples.js
fi 