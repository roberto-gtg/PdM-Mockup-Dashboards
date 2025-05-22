// Dashboard Pages Testing Script
// Debug rule applied: Comprehensive logging for page testing

const fs = require('fs');
const path = require('path');

function testDashboardPages() {
    console.log('🧪 Testing Dashboard Pages...\n');

    // Define key dashboard files to test
    const testFiles = [
        'index.html',
        'components/toolbar.html',
        'dashboards/realtime/fleet-asset-health.html',
        'dashboards/reliability/failure-risk-forecast.html',
        'dashboards/financial/cost-avoidance-ledger.html',
        'dashboards/governance/model-drift-monitor.html',
        'dashboards/specialty/ai-assisted-compliance.html'
    ];

    const results = [];

    testFiles.forEach(filePath => {
        try {
            if (fs.existsSync(filePath)) {
                const content = fs.readFileSync(filePath, 'utf8');
                
                // Basic content checks
                const hasHtml = content.includes('<html');
                const hasTitle = content.includes('<title');
                const hasBody = content.includes('<body');
                const hasToolbarContainer = content.includes('toolbar-container') || 
                                          content.includes('toolbar') ||
                                          filePath.includes('toolbar.html');
                
                const status = hasHtml && hasTitle && hasBody ? '✅ PASS' : '⚠️  WARN';
                
                results.push({
                    file: filePath,
                    status: status,
                    size: (content.length / 1024).toFixed(1) + 'KB',
                    hasToolbar: hasToolbarContainer
                });
                
                console.log(`${status} ${filePath}`);
                console.log(`   Size: ${(content.length / 1024).toFixed(1)}KB`);
                console.log(`   Toolbar integration: ${hasToolbarContainer ? '✅' : '❌'}`);
                console.log('');
                
            } else {
                results.push({
                    file: filePath,
                    status: '❌ MISSING',
                    size: '0KB',
                    hasToolbar: false
                });
                console.log(`❌ MISSING ${filePath}\n`);
            }
        } catch (error) {
            results.push({
                file: filePath,
                status: '❌ ERROR',
                size: '0KB',
                hasToolbar: false
            });
            console.log(`❌ ERROR ${filePath}: ${error.message}\n`);
        }
    });

    // Summary
    const passed = results.filter(r => r.status === '✅ PASS').length;
    const total = results.length;
    
    console.log('📊 Test Summary:');
    console.log(`   Total files tested: ${total}`);
    console.log(`   Passed: ${passed}`);
    console.log(`   Issues: ${total - passed}`);
    console.log('');
    
    if (passed === total) {
        console.log('🎉 All dashboard pages are ready!');
        console.log('');
        console.log('🚀 Quick Start Options:');
        console.log('1. HTTP Server: python3 -m http.server 8080');
        console.log('2. Direct access: open index.html');
        console.log('3. API Server: node database/api_examples.js');
    } else {
        console.log('⚠️  Some issues detected. Check the files above.');
    }
}

// Run the test
testDashboardPages(); 