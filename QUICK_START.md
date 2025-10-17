# Quick Start Guide - Review III Implementation

## ⚡ Get Started in 10 Minutes

This guide will help you quickly set up and demonstrate the Review III features.

---

## 🎯 What You'll Accomplish

1. ✅ Run security scans on your code
2. ✅ Set up monitoring for your application
3. ✅ Generate demo materials

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] GitHub account
- [ ] Azure account (free tier works)
- [ ] Code pushed to GitHub repository
- [ ] Backend running locally

---

## 🚀 Part 1: Security Scanning (5 minutes)

### Step 1: Enable GitHub Actions
```bash
# Your code should already be on GitHub
# If not:
git add .
git commit -m "Add security scanning"
git push origin main
```

### Step 2: Set Up SonarCloud
1. Go to https://sonarcloud.io
2. Click "Log in with GitHub"
3. Click "+" → "Analyze new project"
4. Select your repository
5. Copy the **SONAR_TOKEN**

### Step 3: Add GitHub Secret
1. GitHub repo → Settings → Secrets → Actions
2. Click "New repository secret"
3. Name: `SONAR_TOKEN`
4. Paste the token
5. Click "Add secret"

### Step 4: Update SonarCloud Config
Edit `sonar-project.properties`:
```properties
sonar.organization=YOUR-ORG-NAME
sonar.projectKey=YOUR-PROJECT-KEY
```

### Step 5: Trigger Scan
```bash
git add sonar-project.properties
git commit -m "Configure SonarCloud"
git push origin main
```

### ✅ Verify
- Go to GitHub → Actions tab
- Watch "Security Scanning" workflow run
- Check GitHub → Security tab for results

---

## 📊 Part 2: Monitoring Setup (5 minutes)

### Step 1: Create Application Insights

**Option A: Azure Portal (Easiest)**
1. Go to https://portal.azure.com
2. Search "Application Insights" → Create
3. Fill in:
   - Name: `mess-feedback-insights`
   - Resource Group: `mess_fb`
   - Region: Same as your app
4. Click "Create"
5. Copy **Connection String**

**Option B: Azure CLI (Faster)**
```bash
az login

az monitor app-insights component create \
  --app mess-feedback-insights \
  --location eastus \
  --resource-group mess_fb \
  --workspace /subscriptions/YOUR-SUB/resourceGroups/mess_fb/providers/Microsoft.OperationalInsights/workspaces/mess-workspace

# Get connection string
az monitor app-insights component show \
  --app mess-feedback-insights \
  --resource-group mess_fb \
  --query connectionString -o tsv
```

### Step 2: Configure Backend
```bash
cd backend

# Add to .env file
echo "APPLICATIONINSIGHTS_CONNECTION_STRING=<paste-connection-string>" >> .env

# Install dependency
npm install applicationinsights

# Restart server
npm run build
npm start
```

### Step 3: Verify Monitoring
```bash
# Check status
curl http://localhost:5000/api/monitoring/status

# Generate test traffic
for i in {1..50}; do curl http://localhost:5000/api/monitoring/health; done

# Check metrics
curl http://localhost:5000/api/monitoring/metrics
```

### ✅ Verify
- Azure Portal → Application Insights → Live Metrics
- Should see incoming requests
- Data appears within 2-3 minutes

---

## 📸 Part 3: Create Demo Materials (30 minutes)

### Security Screenshots Needed

1. **GitHub Actions**
   - Actions tab → Latest workflow run
   - Screenshot: Workflow summary

2. **CodeQL Results**
   - Security tab → Code scanning
   - Screenshot: Alerts list (or "No alerts found")

3. **SonarCloud Dashboard**
   - https://sonarcloud.io → Your project
   - Screenshot: Overview page

4. **OWASP ZAP Report**
   - Actions → Workflow run → Artifacts
   - Download "zap-scan-results"
   - Open report_html.html
   - Screenshot: Summary page

### Monitoring Screenshots Needed

1. **Application Insights Overview**
   - Azure Portal → Application Insights
   - Screenshot: Overview dashboard

2. **Live Metrics**
   - Click "Live Metrics"
   - Generate traffic (curl commands)
   - Screenshot: Live data streaming

3. **Custom Query**
   - Click "Logs"
   - Run this query:
   ```kusto
   requests
   | where timestamp > ago(1h)
   | summarize Count = count(), AvgDuration = avg(duration) by bin(timestamp, 5m)
   | render timechart
   ```
   - Screenshot: Chart

4. **Alerts**
   - Click "Alerts"
   - Screenshot: Alert rules list

---

## 🎥 Part 4: Record Demos (20 minutes)

### Security Demo (1 minute)
```
[0:00-0:15] "This is our security scanning workflow..."
            → Show GitHub Actions workflow file

[0:15-0:30] "It runs automatically on every push..."
            → Show Actions tab with workflow runs

[0:30-0:45] "CodeQL found these security issues..."
            → Show Security tab with alerts

[0:45-1:00] "SonarCloud provides code quality metrics..."
            → Show SonarCloud dashboard
```

### Monitoring Demo (2 minutes)
```
[0:00-0:30] "Application Insights monitors our app..."
            → Show overview dashboard

[0:30-1:00] "Here's live metrics as I make requests..."
            → Generate traffic, show live metrics

[1:00-1:30] "We can query our telemetry data..."
            → Run query, show chart

[1:30-2:00] "Alerts notify us of issues..."
            → Show alert configuration
```

---

## 📝 Part 5: Create Documents (1 hour)

### Security_Report.pdf
Create a PDF with:
1. **Cover Page**
   - Title: "Security Scan Report"
   - Date, Team name

2. **Executive Summary**
   - Tools used: CodeQL, SonarCloud, OWASP ZAP
   - Total vulnerabilities found
   - Critical issues addressed

3. **Scan Results** (one page per tool)
   - CodeQL results + screenshot
   - SonarCloud results + screenshot
   - OWASP ZAP results + screenshot

4. **Vulnerabilities Fixed**
   - Pick 2 issues from the scans
   - Show before/after code
   - Explain the fix
   - (Use examples from docs/VULNERABILITY_FIXES_EXAMPLE.md)

5. **Conclusion**
   - Security improvements made
   - Ongoing monitoring plan

### Monitoring_Dashboard.pdf
Create a PDF with:
1. **Cover Page**
   - Title: "Monitoring Dashboard"
   - Date, Team name

2. **Overview**
   - Screenshot of Application Insights overview
   - Key metrics highlighted

3. **Metrics Tracked**
   - Request count
   - Error rate
   - Response time
   - Include charts/graphs

4. **Alert Configuration**
   - Screenshot of alert rules
   - Explain each alert

5. **Conclusion**
   - Benefits of monitoring
   - How it helps operations

### 3-Slide Presentation
Use the template in DEMO_SCRIPT.md:
- Slide 1: Monitoring Overview
- Slide 2: Key Metrics
- Slide 3: Alert Configuration

---

## ✅ Final Checklist

Before submission:

### Code & Configuration
- [ ] Security workflow running on GitHub
- [ ] SonarCloud configured and scanning
- [ ] Monitoring integrated in backend
- [ ] All dependencies installed
- [ ] .env file updated

### Documentation
- [ ] Security_Report.pdf created
- [ ] Monitoring_Dashboard.pdf created
- [ ] 3-slide presentation created
- [ ] Vulnerability fixes documented

### Videos
- [ ] Security demo recorded (1 min)
- [ ] Monitoring demo recorded (2 min)
- [ ] Videos reviewed for quality

### Testing
- [ ] Security scans completed successfully
- [ ] Monitoring endpoints working
- [ ] Data flowing to Application Insights
- [ ] Screenshots captured

---

## 🆘 Troubleshooting

### Security Scan Not Running
```bash
# Check workflow file exists
ls .github/workflows/security-scan.yml

# Check GitHub Actions are enabled
# Settings → Actions → General → Allow all actions

# Trigger manually
# Actions → Security Scanning → Run workflow
```

### Monitoring Not Working
```bash
# Check connection string is set
cat backend/.env | grep APPLICATIONINSIGHTS

# Check dependency installed
cd backend
npm list applicationinsights

# Check server logs
npm start
# Look for: "✅ Application Insights monitoring enabled"
```

### No Data in Azure Portal
```bash
# Wait 2-3 minutes for initial data
# Generate more traffic
for i in {1..100}; do curl http://localhost:5000/api/monitoring/health; done

# Check Live Metrics (updates immediately)
# Check Logs (may take 2-3 minutes)
```

---

## 📚 Additional Resources

### Detailed Guides
- [REVIEW_III_IMPLEMENTATION.md](REVIEW_III_IMPLEMENTATION.md) - Complete overview
- [SECURITY_SETUP_GUIDE.md](SECURITY_SETUP_GUIDE.md) - Detailed security setup
- [MONITORING_SETUP_GUIDE.md](MONITORING_SETUP_GUIDE.md) - Detailed monitoring setup
- [DEMO_SCRIPT.md](DEMO_SCRIPT.md) - Full demo scripts

### Example Materials
- [docs/VULNERABILITY_FIXES_EXAMPLE.md](docs/VULNERABILITY_FIXES_EXAMPLE.md) - Example fixes
- [azure-monitoring/SETUP_COMMANDS.md](azure-monitoring/SETUP_COMMANDS.md) - Azure CLI commands

---

## ⏱️ Time Breakdown

| Task | Time | Total |
|------|------|-------|
| Security Setup | 5 min | 0:05 |
| Monitoring Setup | 5 min | 0:10 |
| Screenshots | 30 min | 0:40 |
| Videos | 20 min | 1:00 |
| Documents | 60 min | 2:00 |
| **Total** | | **~2 hours** |

---

## 🎯 Success Criteria

You're ready when:
- ✅ Security scans running automatically
- ✅ Monitoring data visible in Azure Portal
- ✅ All screenshots captured
- ✅ Videos recorded and reviewed
- ✅ Documents created and polished

---

## 💡 Pro Tips

1. **Start Early**: Don't wait until the last minute
2. **Test Everything**: Run through demos before recording
3. **Keep It Simple**: Focus on core requirements first
4. **Document As You Go**: Take screenshots immediately
5. **Ask for Help**: Use the troubleshooting guides

---

## 🎉 You're Ready!

Follow this guide step-by-step and you'll have everything ready for your Review III demonstration. The implementation is solid, the documentation is comprehensive, and you have all the tools you need to succeed.

**Good luck! 🚀**

---

**Questions?** Review the detailed guides linked above or check the troubleshooting section.
