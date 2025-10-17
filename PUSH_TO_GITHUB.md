# How to Push Your Code to GitHub - Step by Step

## Your GitHub Repository: https://github.com/DHANASREE-1312/3_rd_review

---

## 🚀 Step-by-Step Guide

### **Step 1: Open PowerShell in Your Project Folder**

```powershell
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main"
```

---

### **Step 2: Initialize Git (If Not Already Done)**

```powershell
# Check if git is already initialized
git status

# If you see "fatal: not a git repository", initialize it:
git init
```

---

### **Step 3: Add Your GitHub Repository as Remote**

```powershell
# Add your GitHub repository
git remote add origin https://github.com/DHANASREE-1312/3_rd_review.git

# Verify it was added
git remote -v
```

**Expected output:**
```
origin  https://github.com/DHANASREE-1312/3_rd_review.git (fetch)
origin  https://github.com/DHANASREE-1312/3_rd_review.git (push)
```

---

### **Step 4: Create .gitignore (Important!)**

```powershell
# Check if .gitignore exists
Test-Path .gitignore

# If it doesn't exist, create it
notepad .gitignore
```

**Add this content to .gitignore:**
```
# Dependencies
node_modules/
package-lock.json

# Environment variables
.env
*.env
!.env.example

# Build output
dist/
build/
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Azure
.azure/
```

**Save and close**

---

### **Step 5: Add All Files**

```powershell
# Add all files to git
git add .

# Check what will be committed
git status
```

**You should see:**
- Green files = will be committed
- Make sure `.env` is NOT in the list (should be ignored)

---

### **Step 6: Commit Your Code**

```powershell
# Commit with a message
git commit -m "Initial commit - Review III implementation with security scanning and monitoring"
```

---

### **Step 7: Set Branch to Main**

```powershell
# Rename branch to main (if needed)
git branch -M main
```

---

### **Step 8: Push to GitHub**

```powershell
# Push to GitHub
git push -u origin main
```

**You might be asked to login:**
- Enter your GitHub username
- Enter your Personal Access Token (PAT) as password

---

## 🔑 If You Need GitHub Personal Access Token

### **Create a Personal Access Token:**

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Give it a name: `Review III Project`
4. Select scopes:
   - ✅ `repo` (all)
   - ✅ `workflow`
5. Click **"Generate token"**
6. **COPY THE TOKEN** (you won't see it again!)
7. Use this token as your password when pushing

---

## ✅ Verify Upload

### **Check on GitHub:**

1. Go to: https://github.com/DHANASREE-1312/3_rd_review
2. Refresh the page
3. You should see all your files!

---

## 🔧 Update SonarCloud Configuration

### **Step 1: Open sonar-project.properties**

```powershell
notepad sonar-project.properties
```

### **Step 2: Update with Your Repository Info**

```properties
sonar.projectKey=DHANASREE-1312_3_rd_review
sonar.organization=dhanasree-1312

# Project information
sonar.projectName=3_rd_review
sonar.projectVersion=1.0

# Source code location
sonar.sources=backend/src,frontend/src
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**,**/*.test.js,**/*.spec.js

# Test coverage (if you have tests)
sonar.javascript.lcov.reportPaths=backend/coverage/lcov.info,frontend/coverage/lcov.info

# Language
sonar.language=js
```

### **Step 3: Commit and Push**

```powershell
git add sonar-project.properties
git commit -m "Update SonarCloud configuration"
git push origin main
```

---

## 🎯 Set Up SonarCloud

### **Step 1: Go to SonarCloud**

1. Visit: https://sonarcloud.io
2. Click **"Log in"** → **"With GitHub"**
3. Authorize SonarCloud

### **Step 2: Import Your Repository**

1. Click **"+"** (top right) → **"Analyze new project"**
2. Find and select: **"3_rd_review"**
3. Click **"Set Up"**

### **Step 3: Choose Analysis Method**

1. Select **"With GitHub Actions"**
2. You'll see your organization key and project key
3. **Copy these values**

### **Step 4: Update sonar-project.properties (If Different)**

If the keys are different from what you put, update them:

```powershell
notepad sonar-project.properties
```

Update:
```properties
sonar.organization=YOUR-ACTUAL-ORG-KEY
sonar.projectKey=YOUR-ACTUAL-PROJECT-KEY
```

Save and push:
```powershell
git add sonar-project.properties
git commit -m "Update SonarCloud keys"
git push origin main
```

### **Step 5: Add SONAR_TOKEN to GitHub**

1. In SonarCloud, go to **My Account** → **Security**
2. Generate token: Name it `GitHub Actions`
3. **Copy the token**

4. Go to: https://github.com/DHANASREE-1312/3_rd_review/settings/secrets/actions
5. Click **"New repository secret"**
6. Name: `SONAR_TOKEN`
7. Value: (paste the token)
8. Click **"Add secret"**

---

## 🚀 Enable GitHub Actions

### **Step 1: Enable Actions**

1. Go to: https://github.com/DHANASREE-1312/3_rd_review/settings/actions
2. Under "Actions permissions", select:
   - ✅ **"Allow all actions and reusable workflows"**
3. Click **"Save"**

### **Step 2: Trigger the Workflow**

The workflow will run automatically on push. To trigger it manually:

1. Go to: https://github.com/DHANASREE-1312/3_rd_review/actions
2. Click on **"Security Scanning (SAST & DAST)"**
3. Click **"Run workflow"** → **"Run workflow"**

---

## 📊 View Results

### **1. GitHub Actions**
- URL: https://github.com/DHANASREE-1312/3_rd_review/actions
- See workflow runs and status

### **2. CodeQL Security**
- URL: https://github.com/DHANASREE-1312/3_rd_review/security/code-scanning
- See security vulnerabilities found

### **3. SonarCloud Dashboard**
- URL: https://sonarcloud.io/project/overview?id=DHANASREE-1312_3_rd_review
- See code quality and security analysis

---

## 🐛 Troubleshooting

### **Problem: "fatal: not a git repository"**
```powershell
git init
```

### **Problem: "remote origin already exists"**
```powershell
git remote remove origin
git remote add origin https://github.com/DHANASREE-1312/3_rd_review.git
```

### **Problem: "failed to push"**
```powershell
# Pull first, then push
git pull origin main --allow-unrelated-histories
git push origin main
```

### **Problem: Authentication failed**
- Use Personal Access Token, not password
- Create token at: https://github.com/settings/tokens

### **Problem: .env file is being committed**
- Make sure `.env` is in `.gitignore`
- Remove it from git:
```powershell
git rm --cached backend/.env
git commit -m "Remove .env file"
git push origin main
```

---

## ✅ Complete Checklist

- [ ] Git initialized in project folder
- [ ] Remote origin added (https://github.com/DHANASREE-1312/3_rd_review.git)
- [ ] .gitignore created (excludes .env, node_modules)
- [ ] All files added and committed
- [ ] Code pushed to GitHub
- [ ] Repository visible on GitHub
- [ ] SonarCloud account created
- [ ] SonarCloud project imported
- [ ] SONAR_TOKEN added to GitHub Secrets
- [ ] sonar-project.properties updated
- [ ] GitHub Actions enabled
- [ ] Workflow triggered
- [ ] Results visible

---

## 🎬 Quick Command Summary

```powershell
# Navigate to project
cd "d:\final-review-3-mess_feedback_management system\DailyMessFeedbackSystem-Web-main"

# Initialize and add remote
git init
git remote add origin https://github.com/DHANASREE-1312/3_rd_review.git

# Add, commit, push
git add .
git commit -m "Initial commit - Review III implementation"
git branch -M main
git push -u origin main
```

---

**After pushing, your security scans will run automatically! 🚀**
