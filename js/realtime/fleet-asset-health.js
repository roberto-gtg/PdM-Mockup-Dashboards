/**
 * Fleet Asset-Health Wallboard JavaScript
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Fleet Asset-Health dashboard initialized');
    initializeFleetDashboard();
});

/**
 * Initialize the fleet health dashboard
 */
function initializeFleetDashboard() {
    // Initialize dashboard-specific components
    setupAssetDetailsLinks();
    setupCharts();
    
    // Generate demo data for testing
    if (document.querySelectorAll('.asset-card').length < 10) {
        console.log('Generating additional demo assets');
        generateDemoAssets();
    }
}

/**
 * Set up event handlers for asset detail links
 */
function setupAssetDetailsLinks() {
    const detailLinks = document.querySelectorAll('.asset-details-link');
    
    detailLinks.forEach(link => {
        link.addEventListener('click', (event) => {
            event.preventDefault();
            const assetCard = link.closest('.asset-card');
            const assetName = assetCard.querySelector('h3').textContent;
            
            console.log(`Asset details requested for: ${assetName}`);
            showAssetDetails(assetName, assetCard);
        });
    });
}

/**
 * Show detailed information for a selected asset
 * @param {string} assetName - The name of the asset
 * @param {Element} assetCard - The asset card element
 */
function showAssetDetails(assetName, assetCard) {
    // In a real application, this would open a detailed view or modal
    // For demo purposes, we'll just log the information
    
    const assetStatus = assetCard.querySelector('.asset-data p:nth-child(2)').textContent;
    const assetLocation = assetCard.querySelector('.asset-data p:nth-child(1)').textContent;
    
    console.log('Asset Details:');
    console.log(`- Name: ${assetName}`);
    console.log(`- Status: ${assetStatus}`);
    console.log(`- Location: ${assetLocation}`);
    
    // If we had a modal, we would show it here
    alert(`Asset Details: ${assetName}\n${assetStatus}\n${assetLocation}`);
}

/**
 * Set up chart visualizations
 */
function setupCharts() {
    console.log('Setting up fleet health trend charts');
    
    // In a real application, this would initialize Chart.js or another
    // charting library to display asset health trends
    
    // For the template, we'll just add a placeholder message
    const chartPlaceholder = document.querySelector('.chart-placeholder');
    if (chartPlaceholder) {
        chartPlaceholder.innerHTML = `
            <p>Asset Health Trend (24h)</p>
            <div class="chart-mockup">
                <div class="chart-bar" style="height: 70%;" title="Healthy: 70%"></div>
                <div class="chart-bar" style="height: 20%;" title="Warning: 20%"></div>
                <div class="chart-bar" style="height: 10%;" title="Critical: 10%"></div>
            </div>
            <div class="chart-legend">
                <span class="legend-item"><span class="legend-color healthy"></span> Healthy</span>
                <span class="legend-item"><span class="legend-color warning"></span> Warning</span>
                <span class="legend-item"><span class="legend-color critical"></span> Critical</span>
            </div>
        `;
    }
}

/**
 * Generate additional demo assets for testing
 */
function generateDemoAssets() {
    const assetGrid = document.getElementById('asset-grid');
    if (!assetGrid) return;
    
    const assetTypes = ['Haul Truck', 'Loader', 'Excavator', 'Dozer', 'Grader'];
    const locations = ['Pit 1', 'Pit 2', 'Processing Plant', 'Stockpile'];
    const statuses = ['healthy', 'healthy', 'healthy', 'warning', 'critical']; // Weighted distribution
    
    // Generate 7 additional assets
    for (let i = 1; i <= 7; i++) {
        const assetType = assetTypes[Math.floor(Math.random() * assetTypes.length)];
        const assetId = `${assetType.substring(0, 1)}T-${400 + i}`;
        const location = locations[Math.floor(Math.random() * locations.length)];
        const status = statuses[Math.floor(Math.random() * statuses.length)];
        
        const assetCard = document.createElement('div');
        assetCard.className = `asset-card ${status}`;
        assetCard.setAttribute('data-location', location.toLowerCase().replace(' ', '-'));
        assetCard.setAttribute('data-type', assetType.toLowerCase().replace(' ', '-'));
        
        // Generate asset card content based on status
        assetCard.innerHTML = generateAssetCardHtml(assetType, assetId, location, status);
        
        // Add to grid
        assetGrid.appendChild(assetCard);
        
        // Add event listener to the new detail link
        const detailLink = assetCard.querySelector('.asset-details-link');
        detailLink.addEventListener('click', (event) => {
            event.preventDefault();
            const assetName = assetCard.querySelector('h3').textContent;
            showAssetDetails(assetName, assetCard);
        });
    }
    
    // Update summary counts after adding new assets
    if (window.realTimeDashboardUtils) {
        window.realTimeDashboardUtils.updateSummary();
    }
}

/**
 * Generate HTML for an asset card
 * @param {string} type - Asset type
 * @param {string} id - Asset ID
 * @param {string} location - Asset location
 * @param {string} status - Asset health status
 * @returns {string} HTML for asset card
 */
function generateAssetCardHtml(type, id, location, status) {
    let metrics = '';
    
    // Generate different metrics based on asset type and status
    if (type === 'Haul Truck') {
        const engineTemp = status === 'critical' ? '118°C' : status === 'warning' ? '105°C' : '92°C';
        const oilPressure = status === 'critical' ? '40 psi' : status === 'warning' ? '55 psi' : '65 psi';
        
        metrics = `
            <p><strong>Engine Temp:</strong> ${status !== 'healthy' ? `<span class="highlight-${status}">` : ''}${engineTemp}${status !== 'healthy' ? '</span>' : ''}</p>
            <p><strong>Oil Pressure:</strong> ${status === 'critical' ? '<span class="highlight-critical">40 psi</span>' : oilPressure}</p>
        `;
    } else if (type === 'Loader' || type === 'Excavator') {
        const hydraulicPressure = status === 'critical' ? '2200 psi' : status === 'warning' ? '1950 psi' : '1800 psi';
        const bearingTemp = status === 'critical' ? '92°C' : status === 'warning' ? '83°C' : '75°C';
        
        metrics = `
            <p><strong>Hydraulic Pressure:</strong> ${status !== 'healthy' ? `<span class="highlight-${status}">` : ''}${hydraulicPressure}${status !== 'healthy' ? '</span>' : ''}</p>
            <p><strong>Bearing Temp:</strong> ${status === 'critical' ? `<span class="highlight-${status}">` : ''}${bearingTemp}${status === 'critical' ? '</span>' : ''}</p>
        `;
    } else {
        const fuelLevel = status === 'critical' ? '15%' : status === 'warning' ? '28%' : '65%';
        const engineRPM = status === 'critical' ? '2950 RPM' : status === 'warning' ? '2200 RPM' : '1800 RPM';
        
        metrics = `
            <p><strong>Fuel Level:</strong> ${status === 'critical' ? `<span class="highlight-${status}">` : ''}${fuelLevel}${status === 'critical' ? '</span>' : ''}</p>
            <p><strong>Engine RPM:</strong> ${status === 'critical' ? `<span class="highlight-${status}">` : ''}${engineRPM}${status === 'critical' ? '</span>' : ''}</p>
        `;
    }
    
    // Calculate random update time (1-10 minutes ago)
    const updateTime = Math.floor(Math.random() * 10) + 1;
    
    return `
        <h3>${type} ${id}</h3>
        <div class="asset-data">
            <p><strong>Location:</strong> ${location}</p>
            <p><strong>Status:</strong> <span class="status-${status}">${status.charAt(0).toUpperCase() + status.slice(1)}</span></p>
            ${metrics}
            <p><strong>Last Updated:</strong> ${updateTime} min ago</p>
        </div>
        <a href="#" class="asset-details-link">View Details</a>
    `;
} 