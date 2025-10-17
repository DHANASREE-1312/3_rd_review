# Monitoring & Observability Setup Guide

## Quick Setup (15 Minutes)

### Prerequisites
- Azure account with active subscription
- Backend application running
- Access to Azure Portal

---

## Step-by-Step Setup

### 1. Create Application Insights Resource (5 minutes)

#### 1.1 Navigate to Azure Portal
1. Go to [https://portal.azure.com](https://portal.azure.com)
2. Sign in with your Azure account

#### 1.2 Create Resource
1. Click **Create a resource** (top left)
2. Search for **"Application Insights"**
3. Click **Create**

#### 1.3 Configure Settings
Fill in the following:

| Field | Value |
|-------|-------|
| **Subscription** | Your Azure subscription |
| **Resource Group** | `mess_fb` (or create new) |
| **Name** | `mess-feedback-insights` |
| **Region** | Same as your backend (e.g., East US) |
| **Workspace** | Create new or use existing Log Analytics workspace |

4. Click **Review + Create**
5. Click **Create**
6. Wait for deployment (1-2 minutes)

#### 1.4 Get Connection String
1. Go to the created resource
2. Click **Overview** (left menu)
3. Find **Connection String** (right side)
4. Click **Copy to clipboard** 📋

Example format:
```
InstrumentationKey=12345678-1234-1234-1234-123456789abc;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/
```

### 2. Configure Backend Application (3 minutes)

#### 2.1 Add Environment Variable
1. Open `backend/.env` file
2. Add this line:
   ```env
   APPLICATIONINSIGHTS_CONNECTION_STRING=<paste-your-connection-string-here>
   ```

#### 2.2 Install Dependencies
```bash
cd backend
npm install applicationinsights
```

#### 2.3 Restart Application
```bash
# Build the application
npm run build

# Start the server
npm start
```

You should see:
```
✅ Application Insights monitoring enabled
🚀 Daily Mess Feedback System Backend running on port 5000
```

### 3. Verify Monitoring is Working (2 minutes)

#### 3.1 Test Monitoring Endpoints
```bash
# Check monitoring status
curl http://localhost:5000/api/monitoring/status

# Expected response:
{
  "monitoring": {
    "enabled": true,
    "provider": "Azure Application Insights",
    "features": [...]
  }
}
```

#### 3.2 Generate Test Data
```bash
# Make some API calls to generate metrics
curl http://localhost:5000/api/monitoring/health
curl http://localhost:5000/api/monitoring/metrics

# Submit test feedback (if you have the script)
node submit-diverse-feedback.js
```

#### 3.3 Check Azure Portal
1. Go back to Application Insights resource
2. Click **Live Metrics** (left menu)
3. You should see:
   - ✅ Server online
   - ✅ Incoming requests
   - ✅ Request duration
   - ✅ Request rate

**Note**: It may take 2-3 minutes for data to appear initially.

---

## Setting Up Dashboard (5 minutes)

### Option 1: Use Azure Portal (Recommended)

#### 1. Navigate to Dashboards
1. In Application Insights, click **Overview**
2. Click **Application Dashboard** (top)
3. This creates a default dashboard

#### 2. Customize Dashboard
1. Click **Edit** (top right)
2. Add tiles by clicking **+ Add tile**
3. Recommended tiles:
   - **Requests** - Line chart
   - **Failed requests** - Metric
   - **Server response time** - Line chart
   - **Exceptions** - Count

#### 3. Add Custom Queries

Click **+ Add tile** → **Logs**

**Query 1: Request Performance**
```kusto
requests
| where timestamp > ago(1h)
| summarize 
    Count = count(),
    AvgDuration = avg(duration),
    P95Duration = percentile(duration, 95)
    by bin(timestamp, 5m)
| render timechart
```

**Query 2: Error Rate**
```kusto
exceptions
| where timestamp > ago(24h)
| summarize ErrorCount = count() by type, bin(timestamp, 1h)
| render columnchart
```

**Query 3: Feedback Submissions**
```kusto
customEvents
| where name == "FeedbackSubmitted"
| where timestamp > ago(7d)
| summarize Count = count() by bin(timestamp, 1d)
| render barchart
```

### Option 2: Import Pre-configured Dashboard

1. Download `azure-monitoring/dashboard-config.json`
2. In Azure Portal, click **Dashboard** (top left)
3. Click **Upload** → Select the JSON file
4. Update resource IDs in the configuration
5. Click **Save**

---

## Configuring Alerts (5 minutes)

### 1. Create Action Group

#### 1.1 Navigate to Alerts
1. Azure Portal → **Monitor** (search in top bar)
2. Click **Alerts** → **Action groups**
3. Click **+ Create**

#### 1.2 Configure Action Group
| Field | Value |
|-------|-------|
| **Subscription** | Your subscription |
| **Resource Group** | `mess_fb` |
| **Name** | `AdminAlerts` |
| **Display name** | `Admin Alerts` |

#### 1.3 Add Notification
1. Click **Notifications** tab
2. Click **+ Add**
3. Select **Email/SMS message/Push/Voice**
4. Enter your email address
5. Click **OK**

#### 1.4 Review and Create
1. Click **Review + create**
2. Click **Create**

### 2. Create Alert Rules

#### Alert 1: High Error Rate

1. Go to Application Insights resource
2. Click **Alerts** → **+ Create** → **Alert rule**
3. **Condition**:
   - Signal: **Exceptions**
   - Threshold: **Greater than 50**
   - Evaluation period: **5 minutes**
4. **Actions**:
   - Select action group: `AdminAlerts`
5. **Details**:
   - Name: `High Error Rate`
   - Severity: **2 - Warning**
6. Click **Create alert rule**

#### Alert 2: Slow Response Time

1. Create new alert rule
2. **Condition**:
   - Signal: **Server response time**
   - Threshold: **Greater than 2000 ms**
   - Evaluation period: **10 minutes**
3. **Actions**: `AdminAlerts`
4. **Details**:
   - Name: `Slow Response Time`
   - Severity: **3 - Informational**
5. Click **Create alert rule**

#### Alert 3: High CPU Usage

1. Create new alert rule
2. **Condition**:
   - Signal: **Percentage CPU** (if using App Service)
   - Threshold: **Greater than 80%**
   - Evaluation period: **15 minutes**
3. **Actions**: `AdminAlerts`
4. **Details**:
   - Name: `High CPU Usage`
   - Severity: **2 - Warning**
5. Click **Create alert rule**

---

## Key Metrics to Monitor

### 1. Request Metrics

**Total Requests (Last Hour)**
```kusto
requests
| where timestamp > ago(1h)
| summarize TotalRequests = count()
```

**Average Response Time**
```kusto
requests
| where timestamp > ago(1h)
| summarize AvgResponseTime = avg(duration)
```

**Success Rate**
```kusto
requests
| where timestamp > ago(1h)
| summarize 
    Total = count(),
    Successful = countif(success == true),
    SuccessRate = round(100.0 * countif(success == true) / count(), 2)
```

### 2. Error Metrics

**Total Errors**
```kusto
exceptions
| where timestamp > ago(1h)
| summarize ErrorCount = count()
```

**Errors by Type**
```kusto
exceptions
| where timestamp > ago(24h)
| summarize Count = count() by type
| order by Count desc
```

**Error Trend**
```kusto
exceptions
| where timestamp > ago(7d)
| summarize Count = count() by bin(timestamp, 1d)
| render timechart
```

### 3. Performance Metrics

**CPU Usage** (if available)
```kusto
performanceCounters
| where name == "% Processor Time"
| where timestamp > ago(1h)
| summarize AvgCPU = avg(value) by bin(timestamp, 5m)
| render timechart
```

**Memory Usage**
```kusto
performanceCounters
| where name == "Available Bytes"
| where timestamp > ago(1h)
| summarize AvgMemory = avg(value) by bin(timestamp, 5m)
| render timechart
```

**Database Query Performance**
```kusto
dependencies
| where type == "SQL"
| where timestamp > ago(1h)
| summarize 
    Count = count(),
    AvgDuration = avg(duration),
    P95Duration = percentile(duration, 95)
    by name
| order by AvgDuration desc
```

### 4. Custom Business Metrics

**Feedback Submissions by Meal Type**
```kusto
customEvents
| where name == "FeedbackSubmitted"
| where timestamp > ago(7d)
| extend mealType = tostring(customDimensions.mealType)
| summarize Count = count() by mealType
| render piechart
```

**AI Analysis Performance**
```kusto
customEvents
| where name == "AIAnalysisCompleted"
| where timestamp > ago(24h)
| extend duration = todouble(customMeasurements.duration)
| summarize 
    Count = count(),
    AvgDuration = avg(duration),
    MaxDuration = max(duration)
```

**User Activity Heatmap**
```kusto
requests
| where timestamp > ago(7d)
| extend hour = datetime_part("hour", timestamp)
| summarize RequestCount = count() by hour
| render columnchart
```

---

## Testing Your Monitoring

### 1. Generate Test Traffic

```bash
# Install Apache Bench (if not installed)
# Windows: Download from Apache website
# Linux: sudo apt-get install apache2-utils
# Mac: brew install ab

# Generate 100 requests
ab -n 100 -c 10 http://localhost:5000/api/monitoring/health
```

### 2. Simulate Errors

Create a test endpoint in `backend/src/server.ts`:
```typescript
app.get('/api/test-error', (req, res) => {
  monitoring.trackError('Test error', 'TestError', { source: 'manual-test' });
  throw new Error('This is a test error');
});
```

Then trigger it:
```bash
for i in {1..10}; do
  curl http://localhost:5000/api/test-error
done
```

### 3. Track Custom Events

```bash
# Track custom event via API
curl -X POST http://localhost:5000/api/monitoring/event \
  -H "Content-Type: application/json" \
  -d '{
    "name": "TestEvent",
    "properties": {
      "testType": "manual",
      "user": "admin"
    },
    "measurements": {
      "value": 42
    }
  }'
```

### 4. Verify in Azure Portal

1. Go to Application Insights
2. Click **Live Metrics** - See real-time data
3. Click **Logs** - Run queries to verify data
4. Click **Alerts** - Check if alerts triggered (if thresholds met)

---

## Creating Your Monitoring Report

### Required Screenshots

#### 1. Overview Dashboard
- Navigate to Application Insights → Overview
- Show key metrics: Requests, Response time, Failures
- Screenshot the main dashboard

#### 2. Live Metrics
- Click **Live Metrics**
- Generate some traffic
- Screenshot showing:
  - Incoming requests
  - Request duration
  - Request rate
  - Server status

#### 3. Custom Metrics
- Go to **Logs**
- Run the "Feedback Submissions" query
- Screenshot the chart

#### 4. Alert Configuration
- Navigate to **Alerts**
- Screenshot the list of alert rules
- Click on one alert to show details
- Screenshot the configuration

#### 5. Performance Analysis
- Run the "Request Performance" query
- Screenshot the time chart
- Show P95 response times

### 3-Slide Presentation Structure

**Slide 1: Monitoring Overview**
- Title: "Application Monitoring with Azure Insights"
- Screenshot: Overview dashboard
- Key metrics highlighted:
  - Total requests: X
  - Avg response time: Xms
  - Error rate: X%

**Slide 2: Key Metrics Tracked**
- 3 metric categories:
  1. **Request Metrics**: Count, duration, success rate
  2. **Error Tracking**: Exception count, types, trends
  3. **Performance**: CPU, memory, database queries
- Include 1-2 charts showing trends

**Slide 3: Alert Configuration**
- Screenshot of alert rules
- List of configured alerts:
  - High Error Rate (>50 errors/5min)
  - Slow Response Time (>2s)
  - High CPU Usage (>80%)
- Show action group (email notifications)

---

## Advanced Features

### 1. Application Map

View dependencies and performance:
1. Click **Application Map** (left menu)
2. See visual representation of:
   - Your application
   - Database connections
   - External APIs
   - Performance metrics per component

### 2. Performance Investigation

Analyze slow requests:
1. Click **Performance** (left menu)
2. Select **Operations** tab
3. Click on slow operations
4. View detailed timeline and dependencies

### 3. Failure Analysis

Investigate errors:
1. Click **Failures** (left menu)
2. View top 3 exception types
3. Click on exception to see:
   - Stack trace
   - Affected operations
   - Timeline of occurrences

### 4. User Analytics

Track user behavior:
1. Click **Users** (left menu)
2. View:
   - Active users
   - User sessions
   - User flows
   - Retention analysis

---

## Monitoring Best Practices

### 1. Set Appropriate Thresholds
- Start conservative, adjust based on actual traffic
- Use percentiles (P95, P99) instead of averages
- Consider business hours vs off-hours

### 2. Create Meaningful Alerts
- Alert on symptoms, not causes
- Reduce alert fatigue - only critical issues
- Include context in alert messages
- Test alerts regularly

### 3. Regular Review
- Check dashboard daily
- Review weekly trends
- Analyze monthly patterns
- Adjust thresholds as needed

### 4. Document Baselines
- Record normal performance metrics
- Document expected traffic patterns
- Note seasonal variations
- Track improvement over time

---

## Troubleshooting

### No Data Appearing

**Problem**: Dashboard shows no data  
**Solutions**:
- Wait 2-3 minutes for initial data
- Verify connection string is correct
- Check backend logs for initialization errors
- Ensure backend is actually running
- Generate test traffic

### Connection String Error

**Problem**: "Invalid connection string"  
**Solutions**:
- Verify format includes InstrumentationKey
- Check for extra spaces or line breaks
- Regenerate connection string in Azure Portal
- Ensure .env file is loaded correctly

### Alerts Not Triggering

**Problem**: No alert emails received  
**Solutions**:
- Check spam/junk folder
- Verify email in action group is correct
- Ensure alert rule is enabled
- Check if threshold is actually exceeded
- Review alert history in Azure Portal

### High Data Volume Costs

**Problem**: Unexpected Azure costs  
**Solutions**:
- Review sampling settings
- Adjust data retention period
- Filter unnecessary telemetry
- Use daily cap feature
- Monitor ingestion volume

---

## Cost Optimization

### Free Tier Limits
- **Data ingestion**: 5 GB/month free
- **Data retention**: 90 days
- **Additional**: $2.30/GB beyond free tier

### Tips to Stay Within Free Tier
1. Enable sampling for high-traffic apps
2. Filter out unnecessary telemetry
3. Use appropriate log levels
4. Monitor usage in Azure Portal
5. Set up billing alerts

### Check Current Usage
```kusto
// Data ingestion by type (last 30 days)
union *
| where timestamp > ago(30d)
| summarize GB = sum(_BilledSize) / 1000000000 by _ResourceType
| order by GB desc
```

---

## Next Steps

After setup:

1. ✅ Verify monitoring is working
2. ✅ Create custom dashboard
3. ✅ Configure 3+ alert rules
4. ✅ Generate test data
5. ✅ Take screenshots for report
6. ✅ Create 3-slide presentation
7. ✅ Record demo video

---

## Support Resources

- **Azure Monitor Docs**: [https://docs.microsoft.com/azure/azure-monitor/](https://docs.microsoft.com/azure/azure-monitor/)
- **KQL Tutorial**: [https://docs.microsoft.com/azure/data-explorer/kusto/query/tutorial](https://docs.microsoft.com/azure/data-explorer/kusto/query/tutorial)
- **Best Practices**: [https://docs.microsoft.com/azure/azure-monitor/best-practices](https://docs.microsoft.com/azure/azure-monitor/best-practices)

---

**Setup Time**: ~15 minutes  
**Difficulty**: Beginner-friendly  
**Cost**: Free tier available
