# Azure DevOps Security Scanning Setup

## Using Azure Pipelines Instead of GitHub Actions

---

## 🎯 What You'll Set Up

1. **Azure DevOps Project**
2. **Azure Pipelines** (CI/CD)
3. **Security Scanning Tools**:
   - Microsoft Security Code Analysis (SAST)
   - SonarCloud (Code Quality)
   - OWASP ZAP (DAST)

---

## 📋 Prerequisites

- ✅ Azure Account (Free tier is fine)
- ✅ Your project code
- ✅ Azure DevOps account (free at dev.azure.com)

---

## 🚀 Step-by-Step Setup

### **Step 1: Create Azure DevOps Organization**

1. Go to: https://dev.azure.com
2. Sign in with your Microsoft account
3. Click **"Create new organization"**
4. Name: `DHANASREE-DevOps` (or any name)
5. Click **"Continue"**

---

### **Step 2: Create Azure DevOps Project**

1. Click **"+ New project"**
2. Fill in:
   - **Project name**: `MessFeedbackSystem-Review3`
   - **Visibility**: Private
   - **Version control**: Git
3. Click **"Create"**

---

### **Step 3: Push Code to Azure Repos**

#### **Option A: Push from Local**

```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main"

# Initialize git if needed
git init

# Add Azure DevOps as remote
git remote add azure https://dev.azure.com/YOUR-ORG-NAME/MessFeedbackSystem-Review3/_git/MessFeedbackSystem-Review3

# Add, commit, push
git add .
git commit -m "Initial commit - Review III"
git branch -M main
git push -u azure main
```

#### **Option B: Import from GitHub**

1. In Azure DevOps project, go to **Repos**
2. Click **"Import"**
3. Enter: `https://github.com/DHANASREE-1312/3_rd_review`
4. Click **"Import"**

---

### **Step 4: Create Azure Pipeline File**

Create file: `azure-pipelines-security.yml`

```yaml
# Azure Pipeline for Security Scanning - Review III
# Includes: Security Code Analysis, SonarCloud, OWASP ZAP

trigger:
  branches:
    include:
    - main
    - develop

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'
  nodeVersion: '20.x'

stages:
- stage: SecurityScanning
  displayName: 'Security Scanning Stage'
  jobs:
  
  # Job 1: Static Application Security Testing (SAST)
  - job: SAST_Analysis
    displayName: 'Static Security Analysis'
    steps:
    
    - task: NodeTool@0
      displayName: 'Install Node.js'
      inputs:
        versionSpec: $(nodeVersion)
    
    - script: |
        cd backend
        npm install
        npm run build
      displayName: 'Install Backend Dependencies'
    
    - script: |
        cd frontend
        npm install
      displayName: 'Install Frontend Dependencies'
    
    # Microsoft Security Code Analysis
    - task: CredScan@3
      displayName: 'Run Credential Scanner'
      inputs:
        outputFormat: 'sarif'
        debugMode: false
    
    # SonarCloud Analysis
    - task: SonarCloudPrepare@1
      displayName: 'Prepare SonarCloud Analysis'
      inputs:
        SonarCloud: 'SonarCloud-Connection'
        organization: 'your-sonarcloud-org'
        scannerMode: 'CLI'
        configMode: 'file'
    
    - task: SonarCloudAnalyze@1
      displayName: 'Run SonarCloud Analysis'
    
    - task: SonarCloudPublish@1
      displayName: 'Publish SonarCloud Results'
      inputs:
        pollingTimeoutSec: '300'
    
    # Publish Security Analysis Results
    - task: PublishSecurityAnalysisLogs@3
      displayName: 'Publish Security Analysis Logs'
    
    - task: PostAnalysis@2
      displayName: 'Post Analysis'
      inputs:
        CredScan: true
  
  # Job 2: Dynamic Application Security Testing (DAST)
  - job: DAST_Analysis
    displayName: 'Dynamic Security Testing'
    dependsOn: SAST_Analysis
    steps:
    
    - task: NodeTool@0
      displayName: 'Install Node.js'
      inputs:
        versionSpec: $(nodeVersion)
    
    - script: |
        cd backend
        npm install
        npm run build
      displayName: 'Build Backend'
    
    - script: |
        cd backend
        cat > .env << EOF
        DB_SERVER=test-server.database.windows.net
        DB_NAME=test-db
        DB_USER=test-user
        DB_PASSWORD=test-password
        PORT=5000
        GEMINI_API_KEY=test-key
        EOF
      displayName: 'Create Test Environment'
    
    - script: |
        cd backend
        npm start &
        sleep 10
        curl http://localhost:5000/health || echo "Server starting..."
      displayName: 'Start Backend Server'
    
    # OWASP ZAP Scan
    - task: Bash@3
      displayName: 'Run OWASP ZAP Baseline Scan'
      inputs:
        targetType: 'inline'
        script: |
          docker run --network="host" -v $(Build.SourcesDirectory):/zap/wrk/:rw \
            -t owasp/zap2docker-stable zap-baseline.py \
            -t http://localhost:5000 \
            -r zap-report.html \
            -J zap-report.json \
            -w zap-report.md || true
    
    - task: PublishBuildArtifacts@1
      displayName: 'Publish ZAP Report'
      inputs:
        PathtoPublish: '$(Build.SourcesDirectory)/zap-report.html'
        ArtifactName: 'ZAP-Security-Report'
    
    - task: PublishBuildArtifacts@1
      displayName: 'Publish ZAP JSON Report'
      inputs:
        PathtoPublish: '$(Build.SourcesDirectory)/zap-report.json'
        ArtifactName: 'ZAP-JSON-Report'

- stage: SecurityReporting
  displayName: 'Security Reporting'
  dependsOn: SecurityScanning
  jobs:
  - job: GenerateReport
    displayName: 'Generate Security Summary'
    steps:
    - script: |
        echo "# Security Scan Summary" > security-summary.md
        echo "" >> security-summary.md
        echo "**Date:** $(date)" >> security-summary.md
        echo "**Build:** $(Build.BuildNumber)" >> security-summary.md
        echo "" >> security-summary.md
        echo "## Scans Performed" >> security-summary.md
        echo "- ✅ Credential Scanning" >> security-summary.md
        echo "- ✅ SonarCloud Analysis" >> security-summary.md
        echo "- ✅ OWASP ZAP Baseline Scan" >> security-summary.md
      displayName: 'Create Security Summary'
    
    - task: PublishBuildArtifacts@1
      displayName: 'Publish Security Summary'
      inputs:
        PathtoPublish: 'security-summary.md'
        ArtifactName: 'Security-Summary'
```

---

### **Step 5: Set Up SonarCloud for Azure DevOps**

#### **A. Create SonarCloud Service Connection**

1. In Azure DevOps, go to **Project Settings** (bottom left)
2. Click **Service connections**
3. Click **"New service connection"**
4. Select **"SonarCloud"**
5. Click **"Next"**
6. Enter:
   - **SonarCloud Token**: (get from https://sonarcloud.io → My Account → Security)
   - **Service connection name**: `SonarCloud-Connection`
7. Click **"Save"**

#### **B. Update Pipeline with Your SonarCloud Org**

Edit `azure-pipelines-security.yml`:
```yaml
- task: SonarCloudPrepare@1
  inputs:
    SonarCloud: 'SonarCloud-Connection'
    organization: 'YOUR-SONARCLOUD-ORG'  # Update this
    scannerMode: 'CLI'
    configMode: 'file'
```

---

### **Step 6: Enable Microsoft Security Code Analysis**

#### **A. Install Extension**

1. Go to: https://marketplace.visualstudio.com/items?itemName=ms-securityeng.microsoft-security-code-analysis
2. Click **"Get it free"**
3. Select your Azure DevOps organization
4. Click **"Install"**

#### **B. Enable in Pipeline**

The tasks are already in the pipeline:
- `CredScan@3` - Credential Scanner
- `PublishSecurityAnalysisLogs@3` - Publish logs
- `PostAnalysis@2` - Post analysis

---

### **Step 7: Create and Run Pipeline**

1. In Azure DevOps, go to **Pipelines**
2. Click **"New pipeline"**
3. Select **"Azure Repos Git"**
4. Select your repository
5. Select **"Existing Azure Pipelines YAML file"**
6. Choose `/azure-pipelines-security.yml`
7. Click **"Run"**

---

## 📊 View Results

### **1. Pipeline Results**
- Go to: **Pipelines** → Select your pipeline run
- See all stages and jobs

### **2. Security Analysis Results**
- Go to: **Pipelines** → Select run → **Extensions** tab
- View security findings

### **3. SonarCloud Dashboard**
- Go to: https://sonarcloud.io
- View detailed code quality and security analysis

### **4. OWASP ZAP Report**
- Go to: **Pipelines** → Select run → **Artifacts**
- Download **ZAP-Security-Report**
- Open `zap-report.html` in browser

---

## 🔧 Alternative: Use Existing azure-pipelines.yml

You already have `azure-pipelines.yml` in your project! Let me update it:

```powershell
notepad azure-pipelines.yml
```

Add security scanning stages to your existing pipeline.

---

## 🎯 Azure vs GitHub Actions Comparison

| Feature | Azure DevOps | GitHub Actions |
|---------|-------------|----------------|
| **Cost** | Free (1800 min/month) | Free (2000 min/month) |
| **Security Tools** | Microsoft Security Code Analysis | CodeQL (native) |
| **Integration** | Azure services | GitHub ecosystem |
| **Setup** | More steps | Simpler |
| **Enterprise** | Better for enterprise | Better for open source |

---

## ✅ Advantages of Using Azure

1. **Native Azure Integration**
   - Works seamlessly with Azure SQL, App Service, etc.
   - Single sign-on with Azure account

2. **Microsoft Security Tools**
   - Credential Scanner
   - BinSkim
   - Security Code Analysis

3. **Better for Your Project**
   - You're already using Azure SQL Database
   - You're already using Azure App Service
   - Consistent Azure ecosystem

4. **Enterprise Features**
   - Better access control
   - Audit logs
   - Compliance features

---

## 🚀 Quick Start Commands

### **Push to Azure Repos:**
```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main"

# Add Azure DevOps remote
git remote add azure https://dev.azure.com/YOUR-ORG/MessFeedbackSystem-Review3/_git/MessFeedbackSystem-Review3

# Push
git push -u azure main
```

### **Create Pipeline:**
1. Azure DevOps → Pipelines → New pipeline
2. Select Azure Repos Git
3. Select your repo
4. Use existing `azure-pipelines.yml` or create new one
5. Run

---

## 📝 What to Show Professor

### **Demo Flow:**

1. **Show Azure DevOps Project**
   - "Here's our Azure DevOps project"

2. **Show Pipeline Configuration**
   - Open `azure-pipelines-security.yml`
   - "This pipeline runs three security scans"

3. **Show Pipeline Run**
   - Pipelines → Latest run
   - "Here's the pipeline running with all security stages"

4. **Show Security Results**
   - Extensions tab → Security analysis
   - "These are the vulnerabilities found"

5. **Show SonarCloud**
   - SonarCloud dashboard
   - "Here's the detailed code quality analysis"

---

## 🎓 Why Azure is Good for Review III

**For Professor:**
> "I chose Azure DevOps because:
> 1. We're already using Azure SQL Database and Azure App Service from Review II
> 2. Azure DevOps provides native integration with Azure services
> 3. Microsoft Security Code Analysis tools are built specifically for Azure
> 4. It demonstrates understanding of the complete Azure ecosystem
> 5. Enterprise-ready with better security and compliance features"

---

## ✅ Complete Checklist

- [ ] Azure DevOps organization created
- [ ] Azure DevOps project created
- [ ] Code pushed to Azure Repos
- [ ] SonarCloud service connection created
- [ ] Microsoft Security Code Analysis extension installed
- [ ] azure-pipelines-security.yml created
- [ ] Pipeline created and run
- [ ] Security results viewed
- [ ] Screenshots taken
- [ ] Report created

---

**Yes, Azure is actually BETTER for your project since you're already using Azure services!** 🎉
