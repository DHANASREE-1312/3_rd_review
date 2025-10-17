# How to Run Everything Manually - Step by Step

## 🚀 Complete Manual Setup & Run Guide

---

## Prerequisites Check

### 1. Check Node.js
```powershell
node --version
# Should show: v18.x or v20.x
```

### 2. Check npm
```powershell
npm --version
# Should show: 9.x or 10.x
```

### 3. Check Git
```powershell
git --version
# Should show: git version 2.x
```

---

## Part 1: Backend Setup (Manual)

### Step 1: Navigate to Backend
```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main\backend"
```

### Step 2: Create .env File (If Not Exists)
```powershell
# Copy the example file
Copy-Item .env.example .env

# Open it for editing
notepad .env
```

### Step 3: Edit .env File
Update these values in the .env file:

```env
# Azure SQL Database (Required for full functionality)
DB_SERVER=your-server.database.windows.net
DB_NAME=messdata
DB_USER=your-username
DB_PASSWORD=your-password

# Gemini AI (Required for AI features)
GEMINI_API_KEY=your_actual_gemini_api_key

# Port (Default is fine)
PORT=5000

# Frontend URL (Default is fine)
FRONTEND_URL=http://localhost:5173

# Application Insights (Optional - for cloud monitoring)
APPLICATIONINSIGHTS_CONNECTION_STRING=
# Leave empty for now, or add your Azure connection string
```

**Save and close the file**

### Step 4: Install Dependencies
```powershell
# Make sure you're in backend folder
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main\backend"

# Install all packages
npm install
```

**This will take 2-3 minutes**

### Step 5: Build the Backend
```powershell
# Compile TypeScript to JavaScript
npm run build
```

**This creates the `dist` folder with compiled code**

### Step 6: Start the Backend Server
```powershell
# Start the server
npm start
```

**You should see:**
```
Server running on port 5000
✅ Application Insights monitoring enabled (or console mode)
```

**Keep this terminal open!**

---

## Part 2: Test Backend is Running

### Open a NEW Terminal (PowerShell)

### Test 1: Health Check
```powershell
curl http://localhost:5000/health
```

**Expected Output:**
```json
{
  "status": "OK",
  "timestamp": "2025-10-17T...",
  "database": "Connected" or "Disconnected"
}
```

### Test 2: Monitoring Status
```powershell
curl http://localhost:5000/api/monitoring/status
```

**Expected Output:**
```json
{
  "monitoring": {
    "enabled": true,
    "provider": "Azure Application Insights",
    "features": [...]
  }
}
```

### Test 3: Monitoring Metrics
```powershell
curl http://localhost:5000/api/monitoring/metrics
```

**Expected Output:**
```json
{
  "success": true,
  "metrics": {
    "requestCount": 2,
    "errorCount": 0,
    "uptime": 45.23,
    "memoryUsage": {...}
  }
}
```

---

## Part 3: Frontend Setup (Optional)

### Step 1: Navigate to Frontend
```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main\frontend"
```

### Step 2: Install Dependencies
```powershell
npm install
```

### Step 3: Start Frontend
```powershell
npm run dev
```

**You should see:**
```
VITE v5.x.x  ready in xxx ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

### Step 4: Open Browser
Open your browser and go to:
```
http://localhost:5173
```

---

## Part 4: Test Monitoring Features Manually

### Test Script (Copy & Paste in PowerShell)

```powershell
# Test all monitoring endpoints
Write-Host "Testing Monitoring Endpoints..." -ForegroundColor Cyan

Write-Host "`n1. Health Check:" -ForegroundColor Yellow
curl http://localhost:5000/health

Write-Host "`n2. Monitoring Status:" -ForegroundColor Yellow
curl http://localhost:5000/api/monitoring/status

Write-Host "`n3. Current Metrics:" -ForegroundColor Yellow
curl http://localhost:5000/api/monitoring/metrics

Write-Host "`n4. Detailed Health:" -ForegroundColor Yellow
curl http://localhost:5000/api/monitoring/health

Write-Host "`nAll tests complete!" -ForegroundColor Green
```

---

## Part 5: Generate Test Traffic (For Demo)

### Generate Multiple Requests
```powershell
# Generate 10 requests to see metrics change
for ($i=1; $i -le 10; $i++) {
    Write-Host "Request $i..." -ForegroundColor Cyan
    curl http://localhost:5000/health
    Start-Sleep -Milliseconds 500
}

# Check updated metrics
Write-Host "`nUpdated Metrics:" -ForegroundColor Green
curl http://localhost:5000/api/monitoring/metrics
```

---

## Part 6: Security Scanning (Manual Trigger)

### Prerequisites:
1. Code must be pushed to GitHub
2. SonarCloud account created
3. SONAR_TOKEN added to GitHub Secrets

### Step 1: Push Code to GitHub
```powershell
# Navigate to project root
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main"

# Add all files
git add .

# Commit
git commit -m "Trigger security scan"

# Push to GitHub
git push origin main
```

### Step 2: View Workflow Running
1. Go to your GitHub repository
2. Click "Actions" tab
3. See "Security Scanning (SAST & DAST)" workflow running

### Step 3: View Results
**CodeQL Results:**
- GitHub → Security tab → Code scanning

**SonarCloud Results:**
- Go to https://sonarcloud.io
- Select your project

**OWASP ZAP Results:**
- GitHub → Actions → Select workflow run
- Download "zap-scan-results" artifact

---

## Part 7: Azure Application Insights (Optional)

### If You Want Cloud Monitoring:

### Step 1: Create Application Insights in Azure
1. Go to https://portal.azure.com
2. Click "Create a resource"
3. Search "Application Insights"
4. Fill in:
   - Name: `mess-feedback-insights`
   - Resource Group: `mess_fb`
   - Region: Your region
5. Click "Create"

### Step 2: Get Connection String
1. Go to your Application Insights resource
2. Click "Overview"
3. Copy the "Connection String"

### Step 3: Add to .env
```powershell
# Open .env file
notepad backend\.env
```

Add this line:
```env
APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx;IngestionEndpoint=https://xxx;LiveEndpoint=https://xxx
```

### Step 4: Restart Backend
```powershell
# Stop the server (Ctrl+C in backend terminal)
# Start it again
cd backend
npm start
```

### Step 5: Verify Data in Azure
1. Wait 2-3 minutes
2. Go to Azure Portal → Application Insights
3. Click "Live Metrics" - See real-time data
4. Click "Logs" - Run Kusto queries

---

## 🎯 Quick Commands Reference

### Start Backend Only:
```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main\backend"
npm start
```

### Start Frontend Only:
```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main\frontend"
npm run dev
```

### Test Monitoring:
```powershell
curl http://localhost:5000/api/monitoring/status
curl http://localhost:5000/api/monitoring/metrics
```

### Stop Server:
```
Press Ctrl+C in the terminal
```

### Rebuild Backend:
```powershell
cd backend
npm run build
npm start
```

---

## 🐛 Troubleshooting

### Problem: "Port 5000 already in use"

**Solution 1: Kill the process**
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill it (replace PID with actual number)
taskkill /PID <PID> /F
```

**Solution 2: Change port**
```powershell
# Edit .env file
notepad backend\.env

# Change PORT=5000 to PORT=5001
```

---

### Problem: "Cannot find module"

**Solution:**
```powershell
cd backend
npm install
npm run build
npm start
```

---

### Problem: "Database connection failed"

**Solution:**
- Check DB credentials in `.env`
- Verify Azure SQL firewall allows your IP
- Database is optional for monitoring demo

---

### Problem: "Monitoring not working"

**Solution:**
- Monitoring works in console mode without Azure
- Check terminal output for monitoring logs
- Verify endpoints respond: `curl http://localhost:5000/api/monitoring/status`

---

## 📊 What to Show Professor

### Demo Flow (5 minutes):

**1. Show Backend Running (30 seconds)**
```powershell
# In terminal, show server running
# Point to console output
```

**2. Test Monitoring Endpoints (1 minute)**
```powershell
curl http://localhost:5000/api/monitoring/status
curl http://localhost:5000/api/monitoring/metrics
```

**3. Show Code Files (2 minutes)**
- Open `.github/workflows/security-scan.yml`
- Open `backend/src/monitoring/appInsights.ts`
- Open `backend/src/middleware/monitoring.ts`
- Explain what each does

**4. Show Documentation (1 minute)**
- Open `REVIEW_III_IMPLEMENTATION.md`
- Show comprehensive guides

**5. Generate Traffic & Show Metrics Update (30 seconds)**
```powershell
# Generate requests
for ($i=1; $i -le 5; $i++) { curl http://localhost:5000/health }

# Show updated metrics
curl http://localhost:5000/api/monitoring/metrics
```

---

## ✅ Success Checklist

Before your demo, verify:

- [ ] Backend starts without errors
- [ ] Health endpoint responds: `curl http://localhost:5000/health`
- [ ] Monitoring status works: `curl http://localhost:5000/api/monitoring/status`
- [ ] Metrics endpoint works: `curl http://localhost:5000/api/monitoring/metrics`
- [ ] Can generate traffic and see metrics change
- [ ] Security workflow file exists: `.github/workflows/security-scan.yml`
- [ ] Monitoring code exists: `backend/src/monitoring/appInsights.ts`
- [ ] Documentation is complete

---

## 🎤 What to Say While Running

### When starting backend:
> "I'm starting the backend server. It initializes the monitoring service and connects to the database. The monitoring system is now tracking all requests."

### When testing endpoints:
> "These are the monitoring endpoints I created. The status endpoint shows monitoring is enabled. The metrics endpoint shows real-time data like request count, error count, and system uptime."

### When showing code:
> "This is the monitoring service I implemented. It integrates with Azure Application Insights and tracks custom events and metrics. This middleware wraps every request to measure performance."

### When generating traffic:
> "Let me generate some test traffic. Watch how the request count increases in the metrics. This demonstrates the monitoring system is working in real-time."

---

## 📝 Important Notes

1. **Database is Optional**: Monitoring works without database connection
2. **Azure is Optional**: Monitoring works in console mode without Azure
3. **Frontend is Optional**: Backend monitoring works independently
4. **Security Scans**: Require GitHub push to trigger
5. **Keep Terminal Open**: Server runs in foreground

---

**You're ready to run and demo everything manually! 🚀**
