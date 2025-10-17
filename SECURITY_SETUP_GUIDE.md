# Security Scanning Setup Guide

## Quick Setup (10 Minutes)

### Prerequisites
- GitHub repository with your code
- GitHub account with admin access
- SonarCloud account (free for public repos)

---

## Step-by-Step Setup

### 1. Enable GitHub Actions (2 minutes)

1. Go to your GitHub repository
2. Click **Settings** → **Actions** → **General**
3. Under "Actions permissions", select:
   - ✅ Allow all actions and reusable workflows
4. Click **Save**

### 2. Configure CodeQL (Already Done! ✅)

The CodeQL workflow is already configured in `.github/workflows/security-scan.yml`.

**What it does:**
- Scans JavaScript and TypeScript code
- Runs on every push and pull request
- Checks for 100+ security vulnerability patterns
- Results appear in Security tab

**No additional setup needed!**

### 3. Set up SonarCloud (5 minutes)

#### 3.1 Create SonarCloud Account
1. Go to [https://sonarcloud.io](https://sonarcloud.io)
2. Click **Log in** → **With GitHub**
3. Authorize SonarCloud to access your repositories

#### 3.2 Import Your Project
1. Click **+** (top right) → **Analyze new project**
2. Select your repository: `DailyMessFeedbackSystem-Web`
3. Click **Set Up**
4. Choose **With GitHub Actions**
5. Copy the provided **SONAR_TOKEN**

#### 3.3 Add GitHub Secret
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `SONAR_TOKEN`
5. Value: Paste the token from SonarCloud
6. Click **Add secret**

#### 3.4 Update Configuration
1. Open `sonar-project.properties`
2. Update these lines:
   ```properties
   sonar.organization=your-sonarcloud-org-name
   sonar.projectKey=your-project-key
   ```
3. Get these values from SonarCloud project settings
4. Commit and push:
   ```bash
   git add sonar-project.properties
   git commit -m "Configure SonarCloud"
   git push
   ```

### 4. OWASP ZAP Setup (Already Configured! ✅)

OWASP ZAP is integrated in the workflow and will:
- Start your backend server
- Run security scans against it
- Generate HTML, JSON, and Markdown reports
- Upload results as artifacts

**No additional setup needed!**

---

## Running Your First Security Scan

### Trigger the Workflow

```bash
# Make any change to trigger the scan
git add .
git commit -m "Trigger security scan"
git push origin main
```

### Monitor Progress

1. Go to GitHub repository
2. Click **Actions** tab
3. Click on the latest workflow run: "Security Scanning (SAST & DAST)"
4. Watch the progress of each job:
   - ✅ CodeQL Analysis
   - ✅ SonarCloud
   - ✅ OWASP ZAP Scan
   - ✅ Security Summary

### View Results

#### CodeQL Results
1. Go to **Security** tab → **Code scanning**
2. View all detected issues
3. Click on any alert for:
   - Detailed description
   - Affected code location
   - Remediation advice
   - Severity level

#### SonarCloud Results
1. Go to [SonarCloud Dashboard](https://sonarcloud.io)
2. Click on your project
3. View:
   - **Overview**: Quality gate status
   - **Issues**: Bugs, vulnerabilities, code smells
   - **Security Hotspots**: Areas to review
   - **Measures**: Metrics and trends

#### OWASP ZAP Results
1. Go to **Actions** → Latest workflow run
2. Scroll to **Artifacts** section
3. Download **zap-scan-results**
4. Extract and open `report_html.html`
5. Review:
   - Alerts by risk level (High, Medium, Low)
   - Affected URLs
   - Remediation guidance

---

## Understanding the Results

### CodeQL Alert Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| 🔴 Critical | Severe security flaw | Fix immediately |
| 🟠 High | Significant vulnerability | Fix within 1 week |
| 🟡 Medium | Potential security issue | Review and fix |
| 🔵 Low | Minor issue or best practice | Fix when possible |

### SonarCloud Metrics

**Quality Gate**: Overall pass/fail status
- 🟢 Passed: Code meets quality standards
- 🔴 Failed: Issues need attention

**Key Metrics:**
- **Bugs**: Logic errors that could cause failures
- **Vulnerabilities**: Security weaknesses
- **Code Smells**: Maintainability issues
- **Coverage**: Percentage of code tested
- **Duplications**: Repeated code blocks

### OWASP ZAP Risk Levels

| Risk | Color | Priority |
|------|-------|----------|
| High | 🔴 Red | Fix immediately |
| Medium | 🟠 Orange | Fix soon |
| Low | 🟡 Yellow | Review |
| Informational | 🔵 Blue | Good to know |

---

## Common Issues Found & Fixes

### 1. Missing Security Headers

**Issue**: X-Content-Type-Options header not set

**Fix**: Add helmet middleware
```bash
cd backend
npm install helmet
```

```typescript
// backend/src/server.ts
const helmet = require('helmet');
app.use(helmet());
```

### 2. SQL Injection Risk

**Issue**: Dynamic SQL query construction

**Fix**: Use parameterized queries
```typescript
// ❌ Vulnerable
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Secure
const result = await pool.request()
  .input('userId', sql.Int, userId)
  .query('SELECT * FROM users WHERE id = @userId');
```

### 3. Weak Password Hashing

**Issue**: Using weak hashing algorithm

**Fix**: Use bcrypt with proper salt rounds
```typescript
const bcrypt = require('bcryptjs');
const saltRounds = 10;
const hashedPassword = await bcrypt.hash(password, saltRounds);
```

### 4. CORS Misconfiguration

**Issue**: Overly permissive CORS settings

**Fix**: Restrict to specific origins
```typescript
app.use(cors({
  origin: ['https://your-frontend.com'],
  credentials: true
}));
```

---

## Creating Your Security Report

### Required Screenshots

1. **GitHub Actions Workflow**
   - Navigate to Actions tab
   - Show successful workflow run
   - Screenshot the summary page

2. **CodeQL Alerts**
   - Go to Security → Code scanning
   - Screenshot the alerts list
   - Click on 1-2 alerts and screenshot details

3. **SonarCloud Dashboard**
   - Screenshot the project overview
   - Screenshot the issues page
   - Screenshot security hotspots

4. **OWASP ZAP Report**
   - Open the HTML report
   - Screenshot the summary
   - Screenshot 2-3 specific alerts

### Report Structure

```markdown
# Security Scan Report

## Executive Summary
- Total scans performed: 3 (CodeQL, SonarCloud, ZAP)
- Vulnerabilities found: X
- Critical issues: X
- Issues fixed: X

## CodeQL Analysis
[Screenshots and findings]

## SonarCloud Analysis
[Screenshots and findings]

## OWASP ZAP Scan
[Screenshots and findings]

## Vulnerabilities Fixed
### 1. [Vulnerability Name]
- **Severity**: High
- **Location**: [File:Line]
- **Fix Applied**: [Description]
- **Code Changes**: [Before/After]

### 2. [Vulnerability Name]
...

## Conclusion
[Summary of improvements]
```

---

## Automated Scanning Schedule

The security scan runs automatically:

✅ **On every push** to main or develop branches  
✅ **On every pull request**  
✅ **Weekly on Mondays** at 9:00 AM UTC  

You can also trigger manually:
1. Go to **Actions** tab
2. Select "Security Scanning (SAST & DAST)"
3. Click **Run workflow**
4. Select branch and click **Run workflow**

---

## Best Practices

### 1. Review Alerts Regularly
- Check Security tab weekly
- Address critical issues immediately
- Track progress in issues/projects

### 2. Don't Ignore Warnings
- Even "Low" severity issues can be exploited
- Review all security hotspots
- Document why issues are dismissed (if any)

### 3. Keep Dependencies Updated
- Run `npm audit` regularly
- Update vulnerable packages
- Use Dependabot for automated updates

### 4. Educate Your Team
- Share scan results in team meetings
- Discuss common vulnerabilities
- Learn from each finding

---

## Troubleshooting

### Workflow Fails to Run

**Problem**: Workflow doesn't trigger  
**Solution**: 
- Check if Actions are enabled in Settings
- Verify workflow file is in `.github/workflows/`
- Check branch protection rules

### SonarCloud Scan Fails

**Problem**: "SONAR_TOKEN not found"  
**Solution**:
- Verify secret is added in GitHub Settings
- Check secret name is exactly `SONAR_TOKEN`
- Regenerate token in SonarCloud if needed

### ZAP Scan Times Out

**Problem**: Backend server doesn't start  
**Solution**:
- Check backend dependencies are installed
- Verify build step completes successfully
- Review server startup logs in workflow

### No Vulnerabilities Found

**Problem**: Scans show no issues (suspicious!)  
**Solution**:
- Verify scans are actually running
- Check if code is being analyzed
- Review scan configuration
- This might be good news! 🎉

---

## Next Steps

After setup:

1. ✅ Run your first scan
2. ✅ Review all findings
3. ✅ Fix at least 2 vulnerabilities
4. ✅ Document your fixes
5. ✅ Create Security_Report.pdf
6. ✅ Record demo video

---

## Support Resources

- **CodeQL**: [Documentation](https://codeql.github.com/docs/)
- **SonarCloud**: [Support](https://community.sonarsource.com/)
- **OWASP ZAP**: [User Guide](https://www.zaproxy.org/docs/)
- **GitHub Actions**: [Help](https://docs.github.com/actions)

---

**Need Help?** Check the workflow logs in GitHub Actions for detailed error messages.
