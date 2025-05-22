document.addEventListener('DOMContentLoaded', () => {
    console.log('🔧 DEBUG: Toolbar loader started'); // Debug log
    
    const toolbarContainer = document.getElementById('toolbar-container');
    if (!toolbarContainer) {
        console.error('❌ ERROR: Toolbar container not found. Make sure you have a <div id="toolbar-container"></div> in your HTML.');
        return;
    }

    // **Fixed path determination logic** (Applied rule: debugging improvement)
    const currentPath = window.location.pathname;
    console.log(`🔧 DEBUG: Current path: ${currentPath}`); // Debug log
    
    // Simplified and more reliable path calculation
    let depth = 0;
    let basePath = '';
    
    // Check if we're at the root directory (Dashboard Test 2 folder)
    const isRootLevel = currentPath === '/' || 
                       currentPath.endsWith('/index.html') || 
                       currentPath.endsWith('/') ||
                       !currentPath.includes('/dashboards/');
    
    if (isRootLevel) {
        // At root level - components folder is in same directory
        depth = 0;
        basePath = '';
        console.log(`🔧 DEBUG: Detected root level`); // Debug log
    } else {
        // In a subdirectory - count how many levels deep
        const pathParts = currentPath.split('/').filter(part => part !== '');
        
        // Remove filename if present
        if (pathParts.length > 0 && pathParts[pathParts.length - 1].includes('.html')) {
            pathParts.pop();
        }
        
        // Find how many directories we need to go up to reach root
        const dashboardIndex = pathParts.findIndex(part => part === 'dashboards');
        if (dashboardIndex >= 0) {
            // We're in dashboards/category/ so need to go up 2 levels
            depth = pathParts.length - dashboardIndex + 1;
        } else {
            depth = pathParts.length;
        }
        
        for (let i = 0; i < depth; i++) {
            basePath += '../';
        }
    }
    
    console.log(`🔧 DEBUG: Calculated depth: ${depth}, basePath: "${basePath}"`); // Debug log
    
    const toolbarUrl = basePath + 'components/toolbar.html';
    console.log(`🔧 DEBUG: Attempting to fetch toolbar from: ${toolbarUrl}`); // Debug log

    fetch(toolbarUrl)
        .then(response => {
            console.log(`🔧 DEBUG: Fetch response status: ${response.status}`); // Debug log
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status} when trying to fetch ${toolbarUrl}`);
            }
            return response.text();
        })
        .then(data => {
            console.log('✅ SUCCESS: Toolbar HTML loaded successfully'); // Debug log
            toolbarContainer.innerHTML = data;

            // **Enhanced path adjustment logic** (Applied rule: debugging improvement)
            const logo = toolbarContainer.querySelector('.toolbar-logo');
            if (logo && logo.dataset.srcRootRelative) {
                const logoSrc = basePath + logo.dataset.srcRootRelative;
                logo.src = logoSrc;
                console.log(`🔧 DEBUG: Logo src set to: ${logoSrc}`); // Debug log
            }

            // **Enhanced dropdown link processing** (Applied rule: debugging improvement)
            const navLinks = toolbarContainer.querySelectorAll('.nav-link');
            const dropdownItems = toolbarContainer.querySelectorAll('.dropdown-item');
            console.log(`🔧 DEBUG: Found ${navLinks.length} navigation links and ${dropdownItems.length} dropdown items`); // Debug log
            
            // Process main navigation links
            navLinks.forEach((link, index) => {
                if (link.dataset.hrefRootRelative) {
                    const newHref = basePath + link.dataset.hrefRootRelative;
                    link.href = newHref;
                    console.log(`🔧 DEBUG: Nav link ${index} href set to: ${newHref}`); // Debug log
                }
            });

            // Process dropdown menu items
            dropdownItems.forEach((item, index) => {
                if (item.dataset.hrefRootRelative) {
                    const newHref = basePath + item.dataset.hrefRootRelative;
                    item.href = newHref;
                    console.log(`🔧 DEBUG: Dropdown item ${index} href set to: ${newHref}`); // Debug log
                }
            });

            // **Enhanced active link management with dropdown support** (Applied rule: debugging improvement)
            const currentPagePath = window.location.pathname;
            const currentHash = window.location.hash;
            console.log(`🔧 DEBUG: Setting active links - Path: ${currentPagePath}, Hash: ${currentHash}`); // Debug log

            // Check main navigation links
            document.querySelectorAll('.toolbar-center .nav-link:not(.dropdown-toggle)').forEach(link => {
                const linkHref = link.getAttribute('href');
                if (!linkHref) return;

                let linkPath = linkHref.split('#')[0];
                const linkHash = linkHref.split('#')[1];

                // Normalize paths to be absolute for comparison
                const absoluteLinkPath = new URL(linkPath, window.location.origin + window.location.pathname).pathname;

                let isActive = false;

                if (absoluteLinkPath === currentPagePath) {
                    if (linkHash && '#' + linkHash === currentHash) {
                        isActive = true;
                    } else if (!linkHash && !currentHash) {
                        isActive = true;
                    }
                }

                // Special case for the main "Overview" link on the root index.html
                if (link.dataset.hrefRootRelative === 'index.html' && currentPagePath.endsWith('/index.html') && !currentHash && depth === 0) {
                     if (!linkHash && !currentHash) isActive = true;
                     else isActive = false; // Ensure if hash is present, it doesn't activate overview wrongly
                }

                if (isActive) {
                    link.classList.add('active');
                    console.log(`🔧 DEBUG: Set active link: ${link.textContent}`); // Debug log
                } else {
                    link.classList.remove('active');
                }
            });

            // **Check dropdown items and highlight parent dropdown** (Applied rule: enhanced navigation)
            let activeDropdown = null;
            document.querySelectorAll('.dropdown-item').forEach(item => {
                const itemHref = item.getAttribute('href');
                if (!itemHref) return;

                const itemPath = itemHref.split('#')[0];
                const absoluteItemPath = new URL(itemPath, window.location.origin + window.location.pathname).pathname;

                if (absoluteItemPath === currentPagePath) {
                    item.classList.add('active');
                    // Find the parent dropdown and mark it as active
                    const parentDropdown = item.closest('.nav-dropdown');
                    if (parentDropdown) {
                        const dropdownToggle = parentDropdown.querySelector('.dropdown-toggle');
                        if (dropdownToggle) {
                            dropdownToggle.classList.add('active');
                            activeDropdown = dropdownToggle.textContent.trim().split(' ')[0]; // Get first word
                            console.log(`🔧 DEBUG: Set active dropdown: ${activeDropdown} for item: ${item.textContent}`); // Debug log
                        }
                    }
                } else {
                    item.classList.remove('active');
                }
            });
            
            console.log('✅ SUCCESS: Toolbar initialization completed'); // Debug log
        })
        .catch(error => {
            console.error('❌ ERROR: Error loading or processing toolbar:', error); // Debug log
            
            // **Enhanced error display** (Applied rule: better error handling)
            toolbarContainer.innerHTML = `
                <div style="background-color: #ff4444; color: white; padding: 10px; text-align: center; font-family: Arial, sans-serif;">
                    <strong>⚠️ Toolbar Loading Error</strong><br>
                    ${error.message}<br>
                    <small>Attempted to load: ${toolbarUrl}</small>
                </div>
            `;
        });
}); 