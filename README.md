# Asset Management Dashboard System

This project contains the structure and templates for an HTML web application used to display asset management dashboards for industrial operations. The dashboards display data from databases for each graph/visualization.

## Recent Updates

### Enhanced Dropdown Navigation (Latest)
- **Added**: Dropdown menus for each dashboard category (Financial, Governance, Reliability, Real-time, Specialty)
- **Enhanced**: Direct navigation to individual reports from toolbar
- **Implemented**: Hover-based dropdown interactions with smooth animations
- **Added**: Active page highlighting in dropdown menus
- **Created**: Visual indicators for current section and active reports
- **Improved**: Navigation UX with chevron animations and hover effects

### Toolbar Navigation Fixes ✅ RESOLVED
- **Fixed**: Network error when loading toolbar across different dashboard pages
- **Enhanced**: Robust path resolution for nested directory structures  
- **Added**: Comprehensive debug logging for easier troubleshooting
- **Created**: SVG logo for consistent branding
- **Improved**: Error handling with detailed error messages
- **Updated**: CSS classes to match HTML structure
- **Latest Fix**: Corrected root-level path calculation for index.html

**Recommended Usage**: Open dashboards via HTTP server (`python3 -m http.server 8080`) to avoid CORS issues.
The toolbar now provides seamless navigation to any report from any page in the application.

## Project Structure

The project is organized into the following directories:

```
├── assets/               # Static assets
│   ├── images/           # Image files
│   ├── fonts/            # Custom fonts
│   └── icons/            # Icon files
├── css/                  # CSS stylesheets
│   ├── main.css          # Main stylesheet
│   ├── realtime/         # Real-time dashboard styles
│   ├── reliability/      # Reliability report styles
│   ├── financial/        # Financial scorecard styles
│   ├── governance/       # Governance dashboard styles
│   └── specialty/        # Specialty pack styles
├── js/                   # JavaScript files
│   ├── main.js           # Main JavaScript file
│   ├── realtime/         # Real-time dashboard scripts
│   ├── reliability/      # Reliability report scripts
│   ├── financial/        # Financial scorecard scripts
│   ├── governance/       # Governance dashboard scripts
│   └── specialty/        # Specialty pack scripts
├── data/                 # Data files and mock data
├── lib/                  # Third-party libraries
├── components/           # Reusable components
├── config/               # Configuration files
└── dashboards/           # Dashboard HTML files
    ├── realtime/         # Real-time dashboards
    ├── reliability/      # Reliability reports
    ├── financial/        # Financial scorecards
    ├── governance/       # Governance dashboards
    └── specialty/        # Specialty analytic packs
```

## Dashboard Categories

The system includes the following dashboard categories:

### 1. Real-Time "Control-Room" Dashboards
- Fleet Asset-Health Wallboard (`dashboards/realtime/fleet-asset-health.html`)
- Conveyor Condition Heatmap (`dashboards/realtime/conveyor-condition-heatmap.html`)
- Crusher & Mill Protection Dashboard (`dashboards/realtime/crusher-mill-protection.html`)
- Rail & Port Equipment Health Panel (`dashboards/realtime/rail-port-equipment.html`)

### 2. Reliability Engineer "Week-Ahead" Reports
- Failure-Risk Forecast (7/30/90 days) (`dashboards/reliability/failure-risk-forecast.html`)
- Maintenance Prioritisation Matrix (`dashboards/reliability/maintenance-prioritization-matrix-ref.html`)
- MTBF / MTTR Trend Pack (`dashboards/reliability/mtbf-mttr-trend-pack.html`)
- RUL Ensemble Report (`dashboards/reliability/rul-ensemble-report.html`)
- Root-Cause Explorer (`dashboards/reliability/root-cause-explorer.html`)

### 3. Financial & Executive Scorecards
- Reliability Scorecard (`dashboards/financial/reliability-scorecard.html`)
- Cost-Avoidance Ledger (`dashboards/financial/cost-avoidance-ledger.html`)
- Spares Demand Predictor (`dashboards/financial/spares-demand-predictor.html`)
- Energy-to-Health Correlation (`dashboards/financial/energy-to-health-correlation.html`)

### 4. Model-Governance & Ops Dashboards
- Model Drift Monitor (`dashboards/governance/model-drift-monitor.html`)
- Alert Quality Panel (`dashboards/governance/alert-quality-panel.html`)
- Data-Pipeline Health (`dashboards/governance/data-pipeline-health.html`)

### 5. Specialty Analytic Packs
- AI-Assisted Compliance (`dashboards/specialty/ai-assisted-compliance.html`)
- Cycle-Counting & Fatigue Life Dashboard (`dashboards/specialty/cycle-counting-fatigue-life-dashboard.html`)
- Lubrication-AI Report (`dashboards/specialty/lubrication-ai-report.html`)
- Safety-Critical Asset Heat-Map (`dashboards/specialty/safety-critical-asset-heat-map.html`)

## Development

Each dashboard has its own HTML file with corresponding CSS and JavaScript files. The structure is designed to make it easy to maintain and extend the application:

- Each dashboard category has its own index file
- Dashboard-specific CSS is in the corresponding folders
- Common functionality is in main.js and main.css
- Dashboard-specific JavaScript is in separate files

## Getting Started

1. Open `index.html` in your browser to view the main dashboard navigation
2. Navigate to specific dashboard categories to see available dashboards
3. Each dashboard has its own page with specific visualizations and controls

## Notes

- The current implementation includes a fully functional example of the Fleet Asset-Health Wallboard and the Rail & Port Equipment Health Panel.
- The Reliability Engineer Week-Ahead Reports have been integrated with their respective HTML content.
- The Financial & Executive Scorecards have been integrated with their respective HTML content.
- The Model Governance & Ops Dashboards have been integrated with their respective HTML content.
- The Specialty Analytic Packs have been integrated with their respective HTML content.
- A persistent toolbar has been implemented across all dashboard pages for consistent navigation.

## Database Integration

### PostgreSQL Database Setup ✅ COMPLETED

A comprehensive PostgreSQL database has been successfully installed and configured with real industrial asset data:

#### Installation Status
- ✅ PostgreSQL 14 installed via Homebrew
- ✅ Database service started and running
- ✅ `asset_management` database created
- ✅ Schema deployed (22 tables, 9 indexes)
- ✅ Sample data populated (26 equipment records)
- ✅ API connectivity verified

#### Quick Verification
```bash
# Database is ready - test with:
node test_database.js

# Start API server:
node database/api_examples.js

# Test endpoints:
curl http://localhost:3001/api/dashboard-summary
curl http://localhost:3001/api/fleet-health
```

#### Database Features
- **26 Industrial Assets**: Haul trucks, excavators, drills, crushers, conveyors
- **Real-time Monitoring**: Sensor readings, health indexes, anomaly detection
- **Predictive Analytics**: Failure forecasts, RUL calculations, ML model tracking
- **Financial Tracking**: Cost avoidance, energy consumption, ROI analysis
- **Model Governance**: ML performance monitoring, data pipeline health
- **Safety Compliance**: Critical asset tracking, regulatory compliance

#### API Integration
Sample Node.js API endpoints are provided in `database/api_examples.js`:
- `/api/fleet-health` - Equipment health status
- `/api/failure-predictions` - Risk forecasts
- `/api/cost-avoidance` - Financial savings tracking
- `/api/model-performance` - ML model monitoring
- `/api/dashboard-summary` - High-level KPIs

See `database/setup_instructions.md` for complete documentation.

## Contributing

This project is open for contributions. If you'd like to contribute, please follow these steps:

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Commit your changes
5. Push your branch
6. Open a pull request 