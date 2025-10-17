# Azure Monitoring - Quick Setup Commands

## Prerequisites
- Azure CLI installed
- Azure subscription active
- Logged in to Azure CLI

## 1. Login to Azure
```bash
az login
```

## 2. Set Your Subscription
```bash
# List subscriptions
az account list --output table

# Set active subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

## 3. Create Application Insights Resource

### Option A: Using Azure CLI
```bash
# Set variables
RESOURCE_GROUP="mess_fb"
LOCATION="eastus"
APP_INSIGHTS_NAME="mess-feedback-insights"
WORKSPACE_NAME="mess-feedback-workspace"

# Create Log Analytics Workspace (required for App Insights)
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --location $LOCATION

# Get Workspace ID
WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --query id -o tsv)

# Create Application Insights
az monitor app-insights component create \
  --app $APP_INSIGHTS_NAME \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --workspace $WORKSPACE_ID

# Get Connection String
az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query connectionString -o tsv
```

### Option B: Using Azure Portal
1. Go to https://portal.azure.com
2. Click "Create a resource"
3. Search "Application Insights"
4. Fill in details and create
5. Copy connection string from Overview page

## 4. Configure Backend

```bash
# Navigate to backend
cd backend

# Create/update .env file
echo "APPLICATIONINSIGHTS_CONNECTION_STRING=<your-connection-string>" >> .env

# Install dependencies
npm install applicationinsights

# Build and start
npm run build
npm start
```

## 5. Create Action Group for Alerts

```bash
# Set variables
ACTION_GROUP_NAME="AdminAlerts"
EMAIL="your-email@example.com"

# Create action group
az monitor action-group create \
  --name $ACTION_GROUP_NAME \
  --resource-group $RESOURCE_GROUP \
  --short-name "AdminAlert" \
  --email-receiver name=AdminEmail email=$EMAIL
```

## 6. Create Alert Rules

### Alert 1: High Error Rate
```bash
az monitor metrics alert create \
  --name "High Error Rate" \
  --resource-group $RESOURCE_GROUP \
  --scopes "/subscriptions/{subscription-id}/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Insights/components/$APP_INSIGHTS_NAME" \
  --condition "count exceptions > 50" \
  --window-size 5m \
  --evaluation-frequency 5m \
  --action $ACTION_GROUP_NAME \
  --description "Triggers when error rate exceeds 50 errors in 5 minutes"
```

### Alert 2: Slow Response Time
```bash
az monitor metrics alert create \
  --name "Slow Response Time" \
  --resource-group $RESOURCE_GROUP \
  --scopes "/subscriptions/{subscription-id}/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Insights/components/$APP_INSIGHTS_NAME" \
  --condition "avg requests/duration > 2000" \
  --window-size 10m \
  --evaluation-frequency 5m \
  --action $ACTION_GROUP_NAME \
  --description "Triggers when average response time exceeds 2 seconds"
```

## 7. Import Dashboard

```bash
# Download dashboard template
# Edit azure-monitoring/dashboard-config.json with your resource IDs

# Create dashboard
az portal dashboard create \
  --resource-group $RESOURCE_GROUP \
  --name "Mess-Feedback-Dashboard" \
  --input-path azure-monitoring/dashboard-config.json \
  --location $LOCATION
```

## 8. Verify Setup

```bash
# Test monitoring endpoint
curl http://localhost:5000/api/monitoring/status

# Generate test traffic
for i in {1..100}; do
  curl http://localhost:5000/api/monitoring/health
  sleep 0.1
done

# Check metrics
curl http://localhost:5000/api/monitoring/metrics
```

## 9. View Data in Azure Portal

```bash
# Open Application Insights in browser
az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query "appId" -o tsv | \
  xargs -I {} echo "https://portal.azure.com/#@/resource/subscriptions/{subscription-id}/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Insights/components/$APP_INSIGHTS_NAME/overview"
```

## 10. Useful Kusto Queries

### Save these queries in Application Insights → Logs

**Request Performance:**
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

**Error Analysis:**
```kusto
exceptions
| where timestamp > ago(24h)
| summarize Count = count() by type, outerMessage
| order by Count desc
```

**Custom Events:**
```kusto
customEvents
| where name == "FeedbackSubmitted"
| where timestamp > ago(7d)
| summarize Count = count() by bin(timestamp, 1d)
| render barchart
```

## Troubleshooting Commands

### Check if data is flowing
```bash
# Query recent requests
az monitor app-insights query \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --analytics-query "requests | where timestamp > ago(1h) | count"
```

### Verify connection string
```bash
# Show connection string
az monitor app-insights component show \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP \
  --query connectionString
```

### List all alerts
```bash
az monitor metrics alert list \
  --resource-group $RESOURCE_GROUP \
  --output table
```

### Test action group
```bash
az monitor action-group test-notifications create \
  --action-group-name $ACTION_GROUP_NAME \
  --resource-group $RESOURCE_GROUP \
  --notification-type Email \
  --receiver-name AdminEmail
```

## Cleanup Commands (if needed)

```bash
# Delete alert rules
az monitor metrics alert delete \
  --name "High Error Rate" \
  --resource-group $RESOURCE_GROUP

# Delete action group
az monitor action-group delete \
  --name $ACTION_GROUP_NAME \
  --resource-group $RESOURCE_GROUP

# Delete Application Insights
az monitor app-insights component delete \
  --app $APP_INSIGHTS_NAME \
  --resource-group $RESOURCE_GROUP

# Delete Log Analytics Workspace
az monitor log-analytics workspace delete \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME
```

## Environment Variables Template

Add to `backend/.env`:
```env
# Azure Application Insights
APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx;IngestionEndpoint=https://xxx;LiveEndpoint=https://xxx

# Optional: Custom settings
NODE_ENV=production
APPINSIGHTS_SAMPLING_PERCENTAGE=100
```

## Quick Test Script

Save as `test-monitoring.sh`:
```bash
#!/bin/bash

echo "Testing monitoring endpoints..."

# Test status
echo "1. Checking monitoring status..."
curl -s http://localhost:5000/api/monitoring/status | jq

# Test health
echo "2. Checking health..."
curl -s http://localhost:5000/api/monitoring/health | jq

# Test metrics
echo "3. Getting metrics..."
curl -s http://localhost:5000/api/monitoring/metrics | jq

# Generate traffic
echo "4. Generating test traffic..."
for i in {1..20}; do
  curl -s http://localhost:5000/api/monitoring/health > /dev/null
  echo -n "."
done
echo ""

# Check metrics again
echo "5. Checking updated metrics..."
curl -s http://localhost:5000/api/monitoring/metrics | jq '.metrics.requestCount'

echo "Done! Check Azure Portal for data."
```

Make executable:
```bash
chmod +x test-monitoring.sh
./test-monitoring.sh
```

## PowerShell Version (for Windows)

```powershell
# Test monitoring
Write-Host "Testing monitoring endpoints..."

# Status
Invoke-RestMethod -Uri "http://localhost:5000/api/monitoring/status" | ConvertTo-Json

# Health
Invoke-RestMethod -Uri "http://localhost:5000/api/monitoring/health" | ConvertTo-Json

# Generate traffic
1..20 | ForEach-Object {
    Invoke-RestMethod -Uri "http://localhost:5000/api/monitoring/health" | Out-Null
    Write-Host "." -NoNewline
}
Write-Host ""

# Metrics
Invoke-RestMethod -Uri "http://localhost:5000/api/monitoring/metrics" | ConvertTo-Json
```

## References

- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure/)
- [Application Insights CLI](https://docs.microsoft.com/cli/azure/monitor/app-insights)
- [Kusto Query Language](https://docs.microsoft.com/azure/data-explorer/kusto/query/)
