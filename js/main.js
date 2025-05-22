/**
 * Main JavaScript file for Asset Management Dashboard System
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log('Dashboard system initialized');
    
    // Update copyright year automatically
    const footerYear = document.querySelector('footer p');
    if (footerYear) {
        footerYear.textContent = footerYear.textContent.replace('2023', new Date().getFullYear());
    }
    
    // Add navigation active state
    const currentLocation = window.location.pathname;
    const navLinks = document.querySelectorAll('nav a');
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') && currentLocation.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
});

// Utility functions for dashboard system
const dashboardUtils = {
    /**
     * Format date for display
     * @param {Date} date - Date to format
     * @returns {string} Formatted date string
     */
    formatDate: (date) => {
        return new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        }).format(date);
    },
    
    /**
     * Load dashboard data with error handling
     * @param {string} url - URL to fetch data from
     * @returns {Promise} Promise with data response
     */
    loadDashboardData: async (url) => {
        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error(`Failed to load data: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error('Error loading dashboard data:', error);
            // Display user-friendly error message
            return { error: 'Unable to load dashboard data. Please try again later.' };
        }
    }
};

// Make utilities available globally
window.dashboardUtils = dashboardUtils; 