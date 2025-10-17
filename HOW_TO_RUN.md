# 🚀 How to Run Your Project - Step by Step

## Quick Start (3 Easy Steps)

### Step 1: Check Your Setup
```powershell
.\CHECK_SETUP.ps1
```
This will verify everything is ready.

### Step 2: Configure Environment
If you don't have a `.env` file:
```powershell
Copy-Item backend\.env.example backend\.env
```

Then edit `backend\.env` with your actual credentials:
- Database connection details
- Gemini API key
- (Optional) Application Insights connection string

### Step 3: Run the Project
```powershell
.\RUN_PROJECT.ps1
```

That's it! Your backend will start on http://localhost:5000

---

## Detailed Instructions

### 1️⃣ First Time Setup

#### A. Create .env File
```powershell
cd backend
Copy-Item .env.example .env
notepad .env
```

Update these values in `.env`:
```env
# Your Azure SQL Database
DB_SERVER=your-server.database.windows.net
DB_NAME=messdata
DB_USER=your-username
DB_PASSWORD=your-password

# Your Gemini API Key
GEMINI_API_KEY=your_actual_api_key

# Leave this empty for now (we'll add later)
APPLICATIONINSIGHTS_CONNECTION_STRING=
```

#### B. Install Dependencies
```powershell
# Backend
cd backend
npm install

# Frontend (in new terminal)
cd frontend
npm install
```

### 2️⃣ Running the Application

#### Option A: Use the Helper Script (Easiest)
```powershell
.\RUN_PROJECT.ps1
```

#### Option B: Manual Commands

**Terminal 1 - Backend:**
```powershell
cd backend
npm run build
npm start
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

### 3️⃣ Verify It's Working

#### Test Basic Endpoints
```powershell
# Health check
curl http://localhost:5000/health

# API root
curl http://localhost:5000/

# Monitoring status
curl http://localhost:5000/api/monitoring/status
```

#### Use the Test Script
```powershell
.\TEST_MONITORING.ps1
```

This will:
- Test all monitoring endpoints
- Generate test traffic
- Show metrics

### 4️⃣ Access the Application

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:5000
- **Health Check**: http://localhost:5000/health
- **Monitoring Status**: http://localhost:5000/api/monitoring/status
- **Monitoring Metrics**: http://localhost:5000/api/monitoring/metrics

---

## 🔧 Development Mode

For development with hot reload:

**Backend:**
```powershell
cd backend
npm run dev
```

**Frontend:**
```powershell
cd frontend
npm run dev
```

---

## 📊 Testing Monitoring Features

### Without Azure Application Insights
The monitoring will work in "console mode" - all metrics are logged to console.

```powershell
# Check status
curl http://localhost:5000/api/monitoring/status

# View metrics
curl http://localhost:5000/api/monitoring/metrics

# Generate traffic
.\TEST_MONITORING.ps1
```

### With Azure Application Insights

1. **Create Application Insights** in Azure Portal
2. **Copy Connection String**
3. **Add to .env:**
   ```env
   APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=xxx;IngestionEndpoint=https://xxx
   ```
4. **Restart backend**
5. **Check Azure Portal** (data appears in 2-3 minutes)

---

## 🔒 Testing Security Scanning

### Prerequisites
- Code pushed to GitHub
- SonarCloud account created
- SONAR_TOKEN added to GitHub Secrets

### Trigger Security Scan
```powershell
git add .
git commit -m "Trigger security scan"
git push origin main
```

### View Results
1. **GitHub Actions**: See workflow runs
2. **GitHub Security Tab**: View CodeQL alerts
3. **SonarCloud Dashboard**: View code quality
4. **Workflow Artifacts**: Download ZAP scan reports

---

## 🐛 Troubleshooting

### Backend Won't Start

**Error: "Cannot find module"**
```powershell
cd backend
npm install
npm run build
```

**Error: "Port 5000 already in use"**
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F

# Or change port in .env
PORT=5001
```

**Error: "Database connection failed"**
- Check DB credentials in `.env`
- Verify Azure SQL firewall allows your IP
- Test connection with Azure Data Studio

### Frontend Won't Start

**Error: "EADDRINUSE: address already in use"**
```powershell
# Frontend will try port 5174 if 5173 is busy
# Or kill the process:
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

### Monitoring Not Working

**No monitoring data:**
1. Check `.env` has `APPLICATIONINSIGHTS_CONNECTION_STRING`
2. Restart backend after adding connection string
3. Wait 2-3 minutes for data to appear in Azure
4. Generate traffic: `.\TEST_MONITORING.ps1`

**"Monitoring not enabled" message:**
- This is OK! Monitoring works in console mode
- Add Azure connection string to enable cloud monitoring

---

## 📋 Quick Reference

### Useful Commands

```powershell
# Check setup
.\CHECK_SETUP.ps1

# Run project
.\RUN_PROJECT.ps1

# Test monitoring
.\TEST_MONITORING.ps1

# Build backend
cd backend && npm run build

# Start backend (production)
cd backend && npm start

# Start backend (development)
cd backend && npm run dev

# Start frontend
cd frontend && npm run dev

# Install all dependencies
cd backend && npm install
cd ../frontend && npm install
```

### Monitoring Endpoints

| Endpoint | Description |
|----------|-------------|
| `/health` | Basic health check |
| `/api/monitoring/status` | Monitoring system status |
| `/api/monitoring/metrics` | Current metrics |
| `/api/monitoring/health` | Detailed health info |

### Important Files

| File | Purpose |
|------|---------|
| `backend\.env` | Environment configuration |
| `backend\src\server.ts` | Main server file |
| `backend\src\monitoring\appInsights.ts` | Monitoring service |
| `.github\workflows\security-scan.yml` | Security workflow |

---

## 🎯 Next Steps After Running

### 1. Set Up Monitoring (Optional but Recommended)
- Follow [MONITORING_SETUP_GUIDE.md](MONITORING_SETUP_GUIDE.md)
- Create Application Insights
- Add connection string to `.env`
- Restart and verify data in Azure Portal

### 2. Set Up Security Scanning
- Follow [SECURITY_SETUP_GUIDE.md](SECURITY_SETUP_GUIDE.md)
- Configure SonarCloud
- Add GitHub secrets
- Trigger first scan

### 3. Create Demo Materials
- Follow [DEMO_SCRIPT.md](DEMO_SCRIPT.md)
- Take screenshots
- Record videos
- Create reports

---

## ✅ Success Checklist

- [ ] `.env` file created and configured
- [ ] Backend starts without errors
- [ ] Frontend starts without errors
- [ ] Can access http://localhost:5173
- [ ] Health endpoint responds: http://localhost:5000/health
- [ ] Monitoring endpoints work
- [ ] (Optional) Azure Application Insights receiving data
- [ ] (Optional) Security scans running on GitHub

---

## 🆘 Still Having Issues?

1. **Run the setup checker:**
   ```powershell
   .\CHECK_SETUP.ps1
   ```

2. **Check the logs:**
   - Backend logs appear in the terminal
   - Look for error messages
   - Check for "✅ Application Insights monitoring enabled"

3. **Verify prerequisites:**
   - Node.js installed: `node --version`
   - npm installed: `npm --version`
   - Git installed: `git --version`

4. **Review detailed guides:**
   - [QUICK_START.md](QUICK_START.md)
   - [REVIEW_III_IMPLEMENTATION.md](REVIEW_III_IMPLEMENTATION.md)
   - [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Ready to start? Run:** `.\CHECK_SETUP.ps1` then `.\RUN_PROJECT.ps1`

Good luck! 🚀
