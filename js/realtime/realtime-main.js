/**
 * Real-Time Dashboards common JavaScript functionality
 */

// Initialize real-time dashboard components
document.addEventListener('DOMContentLoaded', () => {
    console.log('Real-time dashboard initialized');
    initializeRealTimeUpdates();
    setupFilterHandlers();
});

/**
 * Set up real-time data updates for the dashboard
 */
function initializeRealTimeUpdates() {
    // Set up data refresh interval (every 30 seconds by default)
    const updateInterval = 30 * 1000; // 30 seconds
    console.log(`Setting up auto-refresh every ${updateInterval/1000} seconds`);
    
    // Update last refresh time
    updateLastRefreshTime();
    
    // Set interval for automatic data refresh
    window.realTimeUpdateInterval = setInterval(() => {
        console.log('Auto-refreshing real-time data');
        refreshDashboardData();
    }, updateInterval);
    
    // Setup manual refresh button handler
    const refreshButton = document.getElementById('refresh-data');
    if (refreshButton) {
        refreshButton.addEventListener('click', () => {
            console.log('Manual refresh triggered');
            refreshDashboardData();
        });
    }
}

/**
 * Update the last refresh time indicator
 */
function updateLastRefreshTime() {
    const now = new Date();
    const formattedTime = now.toLocaleTimeString();
    
    // If there's a last-refresh element, update it
    const lastRefreshElement = document.querySelector('.last-refresh-time');
    if (lastRefreshElement) {
        lastRefreshElement.textContent = formattedTime;
    }
    
    console.log(`Last refresh time updated: ${formattedTime}`);
}

/**
 * Set up event handlers for dashboard filters
 */
function setupFilterHandlers() {
    // Get all filter dropdowns
    const filterElements = document.querySelectorAll('select[id$="-type"], select[id$="status"], select[id="location"]');
    
    // Add change event listeners to each filter
    filterElements.forEach(filter => {
        filter.addEventListener('change', () => {
            console.log(`Filter changed: ${filter.id} = ${filter.value}`);
            applyFilters();
        });
    });
    
    // Add time period change handler
    const timePeriod = document.getElementById('time-period');
    if (timePeriod) {
        timePeriod.addEventListener('change', () => {
            console.log(`Time period changed: ${timePeriod.value}`);
            refreshDashboardData();
        });
    }
}

/**
 * Apply selected filters to the dashboard
 */
function applyFilters() {
    console.log('Applying filters to dashboard');
    
    // Get filter values
    const assetType = document.getElementById('asset-type')?.value || 'all';
    const location = document.getElementById('location')?.value || 'all';
    const healthStatus = document.getElementById('health-status')?.value || 'all';
    
    // Get all asset cards
    const assetCards = document.querySelectorAll('.asset-card');
    
    // Apply filters to each card
    assetCards.forEach(card => {
        let showCard = true;
        
        // Asset type filtering logic would go here
        // For demo, we're just using class names
        if (assetType !== 'all' && !card.classList.contains(assetType)) {
            showCard = false;
        }
        
        // Health status filtering
        if (healthStatus !== 'all' && !card.classList.contains(healthStatus)) {
            showCard = false;
        }
        
        // Location filtering would use data attributes in a real implementation
        
        // Show or hide the card
        card.style.display = showCard ? 'block' : 'none';
    });
    
    // Update summary counts after filtering
    updateSummaryCounts();
}

/**
 * Update the summary cards with current counts
 */
function updateSummaryCounts() {
    console.log('Updating summary counts');
    
    // Get visible cards by status
    const visibleHealthy = document.querySelectorAll('.asset-card.healthy:not([style*="display: none"])').length;
    const visibleWarning = document.querySelectorAll('.asset-card.warning:not([style*="display: none"])').length;
    const visibleCritical = document.querySelectorAll('.asset-card.critical:not([style*="display: none"])').length;
    const totalVisible = visibleHealthy + visibleWarning + visibleCritical;
    
    // Update count elements
    updateSummaryCard('healthy', visibleHealthy, totalVisible);
    updateSummaryCard('warning', visibleWarning, totalVisible);
    updateSummaryCard('critical', visibleCritical, totalVisible);
}

/**
 * Update a specific summary card
 * @param {string} type - The card type (healthy, warning, critical)
 * @param {number} count - The count to display
 * @param {number} total - The total for percentage calculation
 */
function updateSummaryCard(type, count, total) {
    const countElement = document.querySelector(`.summary-card.${type} .count`);
    const percentElement = document.querySelector(`.summary-card.${type} .percentage`);
    
    if (countElement) {
        countElement.textContent = count;
    }
    
    if (percentElement && total > 0) {
        const percentage = Math.round((count / total) * 100);
        percentElement.textContent = `${percentage}%`;
    } else if (percentElement) {
        percentElement.textContent = '0%';
    }
}

/**
 * Refresh all dashboard data
 */
function refreshDashboardData() {
    console.log('Refreshing dashboard data');
    
    // In a real application, this would fetch new data from the server
    // For the template, we just simulate a data refresh
    
    // Show loading indicator
    const dashboardContent = document.querySelector('.dashboard-content');
    if (dashboardContent) {
        dashboardContent.classList.add('loading');
    }
    
    // Simulate network delay
    setTimeout(() => {
        // In a real app, we would update with fresh data here
        
        // Update last refresh time
        updateLastRefreshTime();
        
        // Re-apply filters with the new data
        applyFilters();
        
        // Remove loading indicator
        if (dashboardContent) {
            dashboardContent.classList.remove('loading');
        }
        
        console.log('Dashboard data refresh complete');
    }, 500);
}

// Make utils available for specific dashboard pages
window.realTimeDashboardUtils = {
    refreshData: refreshDashboardData,
    applyFilters: applyFilters,
    updateSummary: updateSummaryCounts
}; 