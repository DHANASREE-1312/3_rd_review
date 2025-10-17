# Review III Demo Script

## 🎬 Demo 1: Security Scanning (1 minute)

### Preparation
- Ensure code is pushed to GitHub
- Security workflow has run at least once
- Have browser tabs ready:
  - GitHub repository Actions tab
  - GitHub Security tab
  - SonarCloud dashboard

### Script

**[0:00 - 0:15] Introduction**
> "Hello! I'm demonstrating our CI/CD security implementation for the Daily Mess Feedback System. We've integrated three security scanning tools: CodeQL for static analysis, SonarCloud for code quality, and OWASP ZAP for dynamic testing."

**[0:15 - 0:30] Show GitHub Actions Workflow**
1. Navigate to repository → **Actions** tab
2. Point to "Security Scanning (SAST & DAST)" workflow
3. Click on latest successful run
4. Show the three jobs:
   - ✅ CodeQL Analysis
   - ✅ SonarCloud
   - ✅ OWASP ZAP Scan

> "This workflow runs automatically on every push, pull request, and weekly on Mondays."

**[0:30 - 0:45] Show CodeQL Results**
1. Navigate to **Security** tab
2. Click **Code scanning**
3. Show any alerts (or mention if none found)
4. Click on one alert to show:
   - Severity level
   - Affected code
   - Remediation advice

> "CodeQL identified [X] potential security issues. Here's an example showing [describe issue]."

**[0:45 - 1:00] Show SonarCloud Dashboard**
1. Switch to SonarCloud tab
2. Show project overview:
   - Quality gate status
   - Bugs, Vulnerabilities, Code Smells
   - Code coverage percentage
3. Click on **Issues** to show detailed findings

> "SonarCloud provides comprehensive code quality metrics. Our project currently has [X] issues, with [Y] security vulnerabilities that we're addressing."

**[End]**
> "All scan results are automatically generated and available for review. We've documented fixes for multiple vulnerabilities in our security report."

---

## 🎬 Demo 2: Monitoring & Observability (2 minutes)

### Preparation
- Backend server running with Application Insights configured
- Azure Portal open to Application Insights resource
- Terminal ready for generating test traffic
- Have browser tabs ready:
  - Azure Application Insights Overview
  - Live Metrics
  - Logs (with queries ready)

### Script

**[0:00 - 0:20] Introduction & Overview**
> "I'm now demonstrating our monitoring implementation using Azure Application Insights. This provides real-time observability into our application's performance, errors, and custom business metrics."

1. Show Application Insights **Overview** page
2. Point to key metrics:
   - Total requests (last hour)
   - Average response time
   - Failed requests
   - Server availability

> "Here's our monitoring dashboard showing [X] requests in the last hour with an average response time of [Y] milliseconds."

**[0:20 - 0:50] Live Metrics Demonstration**
1. Click **Live Metrics** in left menu
2. Show real-time dashboard with:
   - Incoming request rate
   - Request duration
   - Servers online

3. In terminal, generate traffic:
   ```bash
   # Run this in background
   for i in {1..20}; do
     curl http://localhost:5000/api/monitoring/health
     sleep 1
   done
   ```

4. Point to the dashboard updating in real-time:
   - Request count increasing
   - Response times being tracked
   - Success rate

> "Watch as I make API calls - you can see the metrics updating in real-time. Each request is tracked with its duration and status."

**[0:50 - 1:20] Custom Metrics & Queries**
1. Click **Logs** in left menu
2. Run pre-prepared query:
   ```kusto
   requests
   | where timestamp > ago(1h)
   | summarize 
       Count = count(),
       AvgDuration = avg(duration)
       by bin(timestamp, 5m)
   | render timechart
   ```

3. Show the resulting chart

> "We can query our telemetry data using Kusto Query Language. This chart shows request volume and response times over the last hour."

4. Run second query for custom events:
   ```kusto
   customEvents
   | where name == "FeedbackSubmitted"
   | where timestamp > ago(24h)
   | summarize Count = count() by bin(timestamp, 1h)
   ```

> "We also track custom business metrics like feedback submissions, which helps us understand usage patterns."

**[1:20 - 1:50] Alert Configuration**
1. Click **Alerts** in left menu
2. Show list of configured alert rules:
   - High Error Rate
   - Slow Response Time
   - High CPU Usage

3. Click on one alert to show configuration:
   - Condition/threshold
   - Evaluation frequency
   - Action group (email notifications)

> "We've configured three critical alerts. For example, this alert triggers when error rate exceeds 50 errors in 5 minutes, and automatically emails the admin team."

**[1:50 - 2:00] Conclusion**
1. Navigate back to Overview
2. Show the three key metrics tracked:
   - **Request Count**: Total API calls
   - **Error Rate**: Exceptions and failures
   - **Response Time**: Performance metrics

> "In summary, we're monitoring request performance, tracking errors, and measuring response times. All data is visualized in dashboards with automated alerts for critical issues."

**[End]**
> "This monitoring solution provides complete observability into our application's health and performance, enabling proactive issue detection and resolution."

---

## 📸 Screenshot Checklist

### Security Scanning Screenshots

#### For Security_Report.pdf:

1. **GitHub Actions Workflow**
   - [ ] Actions tab showing workflow runs
   - [ ] Successful workflow run summary
   - [ ] Individual job details (CodeQL, SonarCloud, ZAP)

2. **CodeQL Results**
   - [ ] Security tab → Code scanning alerts list
   - [ ] Detailed view of 2-3 specific alerts
   - [ ] Alert showing severity, location, and fix

3. **SonarCloud Dashboard**
   - [ ] Project overview with quality gate
   - [ ] Issues page showing bugs/vulnerabilities
   - [ ] Security hotspots page
   - [ ] Code coverage metrics

4. **OWASP ZAP Report**
   - [ ] HTML report summary page
   - [ ] Alert details (High/Medium/Low)
   - [ ] Specific vulnerability example

5. **Vulnerability Fixes**
   - [ ] Before/after code comparison
   - [ ] Git diff showing the fix
   - [ ] Re-scan showing issue resolved

### Monitoring Screenshots

#### For Monitoring_Dashboard.pdf:

1. **Application Insights Overview**
   - [ ] Main dashboard with key metrics
   - [ ] Request count graph
   - [ ] Response time chart
   - [ ] Failure rate

2. **Live Metrics**
   - [ ] Live metrics stream showing real-time data
   - [ ] Incoming requests counter
   - [ ] Request duration graph
   - [ ] Servers online status

3. **Custom Queries**
   - [ ] Request performance query + chart
   - [ ] Error rate query + chart
   - [ ] Feedback submissions query + chart

4. **Alert Configuration**
   - [ ] List of alert rules
   - [ ] Detailed alert rule configuration
   - [ ] Action group setup
   - [ ] Alert history (if any triggered)

5. **Performance Analysis**
   - [ ] Application map showing dependencies
   - [ ] Performance investigation page
   - [ ] Database query performance

---

## 🎤 Presentation Slides (3 slides for Monitoring)

### Slide 1: Monitoring Overview
**Title**: Application Monitoring with Azure Application Insights

**Content**:
- Screenshot: Application Insights Overview Dashboard
- Key Metrics Highlighted:
  - 📊 Total Requests: [X] (last hour)
  - ⚡ Avg Response Time: [Y]ms
  - ❌ Error Rate: [Z]%
  - ✅ Availability: 99.9%

**Speaker Notes**:
"We implemented Azure Application Insights for comprehensive monitoring. This dashboard shows our application is handling [X] requests per hour with an average response time of [Y] milliseconds and minimal errors."

---

### Slide 2: Key Metrics Tracked
**Title**: Three Critical Metric Categories

**Content**:
**1. Request Metrics** 📈
- Total request count
- Average response time
- Success/failure rate
- [Include line chart showing request volume]

**2. Error Tracking** ⚠️
- Exception count and types
- Error rate trends
- Stack traces for debugging
- [Include bar chart showing error distribution]

**3. Performance Metrics** 🚀
- CPU usage percentage
- Memory consumption
- Database query performance
- [Include performance timeline]

**Speaker Notes**:
"We track three main categories: Request metrics show traffic patterns, error tracking helps identify issues quickly, and performance metrics ensure optimal resource usage."

---

### Slide 3: Alert Configuration & Response
**Title**: Proactive Monitoring with Automated Alerts

**Content**:
**Configured Alerts**:
1. 🔴 **High Error Rate**
   - Threshold: >50 errors in 5 minutes
   - Action: Email admin team

2. 🟡 **Slow Response Time**
   - Threshold: >2 seconds average
   - Action: Email DevOps team

3. 🟠 **High CPU Usage**
   - Threshold: >80% for 15 minutes
   - Action: Email infrastructure team

**Alert Flow Diagram**:
```
Metric Exceeds Threshold → Alert Rule Triggered → 
Action Group Activated → Email/SMS Notification → 
Team Responds
```

[Include screenshot of alert rules configuration]

**Speaker Notes**:
"We've configured three critical alerts that automatically notify the appropriate teams when thresholds are exceeded. This enables proactive response before users are impacted."

---

## 🎥 Video Recording Tips

### Equipment Setup
- Use screen recording software (OBS Studio, Loom, or built-in)
- Enable microphone for narration
- Close unnecessary applications
- Set browser zoom to 100%
- Use full-screen mode for demos

### Recording Best Practices
1. **Before Recording**:
   - Practice the demo 2-3 times
   - Have all tabs/windows ready
   - Clear browser history/cache
   - Disable notifications
   - Check audio levels

2. **During Recording**:
   - Speak clearly and at moderate pace
   - Pause briefly between sections
   - Use mouse to highlight important items
   - Keep cursor movements smooth
   - Mention what you're clicking

3. **After Recording**:
   - Review for audio/video quality
   - Trim any mistakes or long pauses
   - Add title slide if needed
   - Export in MP4 format
   - Keep file size under 50MB

### Common Mistakes to Avoid
- ❌ Speaking too fast
- ❌ Not explaining what you're doing
- ❌ Clicking too quickly
- ❌ Forgetting to show important details
- ❌ Background noise/interruptions

---

## 📝 Quick Reference Commands

### Generate Test Traffic
```bash
# Simple requests
for i in {1..50}; do curl http://localhost:5000/api/monitoring/health; done

# With Apache Bench
ab -n 100 -c 10 http://localhost:5000/api/monitoring/health
```

### Trigger Test Errors
```bash
# Multiple error requests
for i in {1..20}; do curl http://localhost:5000/api/test-error; done
```

### Check Monitoring Status
```bash
curl http://localhost:5000/api/monitoring/status
curl http://localhost:5000/api/monitoring/metrics
```

### View Logs
```bash
# Backend logs
cd backend
npm start

# Watch for monitoring messages
# Look for: "✅ Application Insights monitoring enabled"
```

---

## ⏱️ Time Management

| Section | Time | Total |
|---------|------|-------|
| Security Demo Intro | 0:15 | 0:15 |
| GitHub Actions | 0:15 | 0:30 |
| CodeQL Results | 0:15 | 0:45 |
| SonarCloud | 0:15 | 1:00 |
| **Security Total** | **1:00** | |
| | | |
| Monitoring Intro | 0:20 | 0:20 |
| Live Metrics | 0:30 | 0:50 |
| Custom Queries | 0:30 | 1:20 |
| Alert Config | 0:30 | 1:50 |
| Conclusion | 0:10 | 2:00 |
| **Monitoring Total** | **2:00** | |
| | | |
| **Grand Total** | **3:00** | |

---

## ✅ Final Checklist

Before submission:

### Documentation
- [ ] Security_Report.pdf created with all screenshots
- [ ] Vulnerability_Fixes.md documenting 2+ fixes
- [ ] Monitoring_Dashboard.pdf with dashboard screenshots
- [ ] 3-slide presentation created

### Videos
- [ ] Security demo recorded (1 minute)
- [ ] Monitoring demo recorded (2 minutes)
- [ ] Videos reviewed for quality
- [ ] Videos exported in correct format

### Code
- [ ] All security workflows committed
- [ ] Monitoring code integrated
- [ ] Environment variables documented
- [ ] README updated

### Testing
- [ ] Security scans run successfully
- [ ] Monitoring endpoints working
- [ ] Alerts configured and tested
- [ ] Dashboard accessible

---

**Good luck with your demo! 🚀**
