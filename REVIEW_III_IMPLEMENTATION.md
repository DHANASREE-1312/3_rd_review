# Cloud Computing Review III - Implementation Guide

## Overview
This document describes the implementation of **CI/CD Security Scanning** and **Monitoring & Observability** features for the Daily Mess Feedback System.

---

## 🔒 Priority #1: CI/CD Security & Code Scanning

### Implementation Summary
We've integrated three security scanning tools into the CI/CD pipeline:

#### 1. **CodeQL (SAST - Static Application Security Testing)**
- **Purpose**: Analyzes source code for security vulnerabilities
- **Languages**: JavaScript, TypeScript
- **Configuration**: `.github/workflows/security-scan.yml`
- **Queries**: Security-extended + Quality rules

**What it detects:**
- SQL Injection vulnerabilities
- Cross-Site Scripting (XSS)
- Path traversal issues
- Insecure cryptography
- Authentication/Authorization flaws

#### 2. **SonarCloud (Code Quality & Security)**
- **Purpose**: Comprehensive code quality and security analysis
- **Configuration**: `sonar-project.properties`
- **Features**:
  - Code smells detection
  - Security hotspots
  - Code coverage analysis
  - Technical debt tracking
  - Duplicate code detection

#### 3. **OWASP ZAP (DAST - Dynamic Application Security Testing)**
- **Purpose**: Tests running application for vulnerabilities
- **Configuration**: `.zap/rules.tsv`
- **Scan Type**: Baseline scan

**What it detects:**
- Runtime security vulnerabilities
- Missing security headers
- Cookie security issues
- SSL/TLS configuration problems
- Authentication weaknesses

### Setup Instructions

#### Step 1: Enable GitHub Actions
1. Push your code to GitHub repository
2. Navigate to **Settings** → **Actions** → **General**
3. Enable "Allow all actions and reusable workflows"

#### Step 2: Configure CodeQL
CodeQL is automatically enabled in the workflow. No additional setup required!

#### Step 3: Set up SonarCloud
1. Go to [SonarCloud.io](https://sonarcloud.io)
2. Sign in with GitHub
3. Click "+" → "Analyze new project"
4. Select your repository
5. Copy the **Organization Key** and **Project Key**
6. Update `sonar-project.properties`:
   ```properties
   sonar.organization=your-org-key
   sonar.projectKey=your-project-key
   ```
7. In GitHub, go to **Settings** → **Secrets and variables** → **Actions**
8. Add secret: `SONAR_TOKEN` (get from SonarCloud → My Account → Security)

#### Step 4: Run Security Scan
```bash
# Push to trigger the workflow
git add .
git commit -m "Add security scanning"
git push origin main
```

The workflow runs automatically on:
- Push to `main` or `develop` branches
- Pull requests
- Every Monday at 9 AM (scheduled)

### Viewing Results

#### CodeQL Results
1. Go to repository → **Security** tab → **Code scanning**
2. View detected vulnerabilities with severity levels
3. Click on alerts for detailed remediation guidance

#### SonarCloud Results
1. Visit [SonarCloud Dashboard](https://sonarcloud.io)
2. Select your project
3. View:
   - **Issues**: Bugs, vulnerabilities, code smells
   - **Security Hotspots**: Areas requiring security review
   - **Measures**: Code coverage, duplications, complexity

#### OWASP ZAP Results
1. Go to GitHub Actions → Select workflow run
2. Download **zap-scan-results** artifact
3. Open `report_html.html` in browser
4. Review vulnerabilities and recommendations

### Vulnerability Fixes Demonstrated

#### Example 1: Missing Security Headers
**Issue Found**: X-Content-Type-Options header missing  
**Fix Applied**: Added helmet middleware in `server.ts`
```typescript
// Install helmet
npm install helmet

// Add to server.ts
const helmet = require('helmet');
app.use(helmet());
```

#### Example 2: SQL Injection Prevention
**Issue Found**: Potential SQL injection in user queries  
**Fix Applied**: Using parameterized queries with mssql
```typescript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE username = '${username}'`;

// ✅ Secure
const result = await pool.request()
  .input('username', sql.VarChar, username)
  .query('SELECT * FROM users WHERE username = @username');
```

---

## 📊 Priority #2: Monitoring & Observability

### Implementation Summary
Integrated **Azure Application Insights** for comprehensive monitoring and observability.

### Key Metrics Tracked

#### 1. **Request Metrics**
- Total request count
- Average response time
- Success/failure rate
- Request distribution by endpoint

#### 2. **Error Tracking**
- Exception count and types
- Error rate over time
- Stack traces for debugging
- Custom error properties

#### 3. **Performance Metrics**
- CPU usage percentage
- Memory consumption
- Database query performance
- API response times

#### 4. **Custom Business Metrics**
- Feedback submissions count
- AI analysis completion rate
- User activity patterns
- Meal rating trends

### Setup Instructions

#### Step 1: Create Application Insights Resource
1. Go to [Azure Portal](https://portal.azure.com)
2. Click "Create a resource" → Search "Application Insights"
3. Fill in details:
   - **Name**: `mess-feedback-insights`
   - **Resource Group**: `mess_fb`
   - **Region**: Same as your app
4. Click "Review + Create"
5. Copy the **Connection String**

#### Step 2: Configure Backend
1. Add to `backend/.env`:
   ```env
   APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx;IngestionEndpoint=https://xxx
   ```

2. Install dependencies:
   ```bash
   cd backend
   npm install applicationinsights
   ```

3. Build and restart:
   ```bash
   npm run build
   npm start
   ```

#### Step 3: Verify Monitoring
Test the monitoring endpoints:
```bash
# Check monitoring status
curl http://localhost:5000/api/monitoring/status

# View current metrics
curl http://localhost:5000/api/monitoring/metrics

# Health check
curl http://localhost:5000/api/monitoring/health
```

### Dashboard Configuration

#### Option 1: Azure Portal Dashboard
1. Go to Azure Portal → Application Insights resource
2. Click "Dashboard" → "New dashboard"
3. Import `azure-monitoring/dashboard-config.json`
4. Customize tiles as needed

#### Option 2: Use Pre-configured Queries
In Application Insights → **Logs**, run these queries:

**Request Performance:**
```kusto
requests
| where timestamp > ago(1h)
| summarize 
    RequestCount = count(),
    AvgDuration = avg(duration),
    P95Duration = percentile(duration, 95)
    by bin(timestamp, 5m)
| render timechart
```

**Error Rate:**
```kusto
exceptions
| where timestamp > ago(24h)
| summarize ErrorCount = count() by type, bin(timestamp, 1h)
| render columnchart
```

**Feedback Submissions:**
```kusto
customEvents
| where name == "FeedbackSubmitted"
| where timestamp > ago(7d)
| summarize Count = count() by bin(timestamp, 1d)
| render barchart
```

### Alert Rules Configuration

#### Step 1: Create Action Group
1. Azure Portal → **Monitor** → **Alerts** → **Action groups**
2. Click "+ Create"
3. Configure:
   - **Name**: `AdminAlerts`
   - **Short name**: `AdminAlert`
   - **Email**: Your admin email
4. Save

#### Step 2: Create Alert Rules
Use the configurations in `azure-monitoring/alert-rules.json`:

**High Error Rate Alert:**
- Condition: More than 50 errors in 5 minutes
- Severity: Warning
- Action: Email admin

**Slow Response Time Alert:**
- Condition: Avg response time > 2 seconds
- Severity: Warning
- Action: Email DevOps team

**High CPU Usage Alert:**
- Condition: CPU > 80% for 15 minutes
- Severity: Warning
- Action: Email admin

#### Step 3: Test Alerts
```bash
# Generate test errors
for i in {1..60}; do
  curl http://localhost:5000/api/test-error
  sleep 1
done
```

### Monitoring Dashboard Screenshots

Create these screenshots for your report:

1. **Overview Dashboard** - Request count, error rate, response time
2. **Performance Metrics** - CPU, memory, database queries
3. **Custom Events** - Feedback submissions, AI analysis
4. **Alert Configuration** - Show configured alert rules
5. **Live Metrics** - Real-time monitoring view

---

## 📋 Deliverables Checklist

### Priority #1: Security Scanning

- [x] GitHub Actions workflow with CodeQL
- [x] SonarCloud integration
- [x] OWASP ZAP baseline scan
- [x] Security scan results (artifacts)
- [ ] **Security_Report.pdf** - Screenshots of scan results
- [ ] **Vulnerability_Fixes.md** - Document 2+ fixes
- [ ] **1-minute demo video** - Show pipeline run with security step

### Priority #2: Monitoring & Observability

- [x] Azure Application Insights integration
- [x] Custom metrics tracking
- [x] Dashboard configuration
- [x] Alert rules setup
- [ ] **Monitoring_Dashboard.pdf** - Screenshots of dashboard
- [ ] **3-slide presentation** - Metrics & alert demo
- [ ] **Demo video** - Show live metrics and alerts

---

## 🎥 Demo Script

### Security Scanning Demo (1 minute)
1. **[0:00-0:15]** Show GitHub Actions workflow file
2. **[0:15-0:30]** Navigate to Actions tab, show running workflow
3. **[0:30-0:45]** Show CodeQL security alerts in Security tab
4. **[0:45-1:00]** Show SonarCloud dashboard with findings

### Monitoring Demo (2 minutes)
1. **[0:00-0:30]** Show Application Insights overview dashboard
2. **[0:30-1:00]** Demonstrate live metrics while making API calls
3. **[1:00-1:30]** Show custom events (feedback submissions)
4. **[1:30-2:00]** Show configured alert rules and test alert

---

## 🚀 Quick Start Commands

### Run Security Scan Locally
```bash
# Install dependencies
cd backend && npm install
cd ../frontend && npm install

# Run linting
cd backend && npm run lint
cd ../frontend && npm run lint

# Build projects
cd backend && npm run build
cd ../frontend && npm run build
```

### Start with Monitoring
```bash
# Set environment variable
export APPLICATIONINSIGHTS_CONNECTION_STRING="your-connection-string"

# Start backend
cd backend
npm run dev

# In another terminal, test endpoints
curl http://localhost:5000/api/monitoring/metrics
curl http://localhost:5000/api/monitoring/health
```

### Generate Test Data
```bash
# Submit test feedback (generates metrics)
node submit-diverse-feedback.js

# Check metrics
curl http://localhost:5000/api/monitoring/metrics
```

---

## 📚 Additional Resources

### Security Scanning
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [SonarCloud Best Practices](https://docs.sonarcloud.io/)
- [OWASP ZAP User Guide](https://www.zaproxy.org/docs/)

### Monitoring
- [Application Insights Overview](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Kusto Query Language](https://docs.microsoft.com/azure/data-explorer/kusto/query/)
- [Azure Monitor Alerts](https://docs.microsoft.com/azure/azure-monitor/alerts/alerts-overview)

---

## 🎓 Learning Outcomes

### Security Skills Gained
✅ Understanding of SAST vs DAST  
✅ Implementing automated security scanning  
✅ Identifying and fixing common vulnerabilities  
✅ Secure coding practices  

### Monitoring Skills Gained
✅ Application performance monitoring  
✅ Custom metrics and events tracking  
✅ Alert configuration and incident response  
✅ Dashboard creation and visualization  

---

## 📝 Notes for Review

- All security scans run automatically on push
- Monitoring is production-ready with connection string
- Alert rules can be customized per requirements
- Dashboard is importable to Azure Portal
- All code follows existing project structure
- No breaking changes to existing functionality

---

**Implementation Date**: October 2024  
**Team**: Daily Mess Feedback System  
**Review**: Cloud Computing Review III
