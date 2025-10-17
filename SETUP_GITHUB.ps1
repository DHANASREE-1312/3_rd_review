# GitHub Setup Script for Review III
# Repository: https://github.com/DHANASREE-1312/3_rd_review

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Setup - Review III" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is installed
Write-Host "Checking Git installation..." -ForegroundColor Yellow
$gitVersion = git --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Git is not installed!" -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Git installed: $gitVersion" -ForegroundColor Green
Write-Host ""

# Check if .gitignore exists
Write-Host "Checking .gitignore..." -ForegroundColor Yellow
if (-Not (Test-Path ".gitignore")) {
    Write-Host "Creating .gitignore..." -ForegroundColor Yellow
    @"
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
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "✅ .gitignore created" -ForegroundColor Green
} else {
    Write-Host "✅ .gitignore exists" -ForegroundColor Green
}
Write-Host ""

# Initialize git if needed
Write-Host "Checking Git repository..." -ForegroundColor Yellow
git status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git already initialized" -ForegroundColor Green
}
Write-Host ""

# Check if remote exists
Write-Host "Checking remote repository..." -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Adding remote origin..." -ForegroundColor Yellow
    git remote add origin https://github.com/DHANASREE-1312/3_rd_review.git
    Write-Host "✅ Remote added: https://github.com/DHANASREE-1312/3_rd_review.git" -ForegroundColor Green
} else {
    Write-Host "✅ Remote exists: $remoteUrl" -ForegroundColor Green
    if ($remoteUrl -ne "https://github.com/DHANASREE-1312/3_rd_review.git") {
        Write-Host "⚠️  Remote URL is different!" -ForegroundColor Yellow
        Write-Host "Current: $remoteUrl" -ForegroundColor Yellow
        Write-Host "Expected: https://github.com/DHANASREE-1312/3_rd_review.git" -ForegroundColor Yellow
        $response = Read-Host "Update remote? (y/n)"
        if ($response -eq "y") {
            git remote set-url origin https://github.com/DHANASREE-1312/3_rd_review.git
            Write-Host "✅ Remote updated" -ForegroundColor Green
        }
    }
}
Write-Host ""

# Check for uncommitted changes
Write-Host "Checking for changes..." -ForegroundColor Yellow
git add .
$status = git status --porcelain
if ($status) {
    Write-Host "✅ Found changes to commit" -ForegroundColor Green
    Write-Host ""
    Write-Host "Files to be committed:" -ForegroundColor Cyan
    git status --short
    Write-Host ""
    
    $commitMsg = Read-Host "Enter commit message (or press Enter for default)"
    if ([string]::IsNullOrWhiteSpace($commitMsg)) {
        $commitMsg = "Review III implementation - Security scanning and monitoring"
    }
    
    git commit -m "$commitMsg"
    Write-Host "✅ Changes committed" -ForegroundColor Green
} else {
    Write-Host "ℹ️  No changes to commit" -ForegroundColor Yellow
}
Write-Host ""

# Set branch to main
Write-Host "Setting branch to main..." -ForegroundColor Yellow
git branch -M main
Write-Host "✅ Branch set to main" -ForegroundColor Green
Write-Host ""

# Push to GitHub
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Ready to push to GitHub!" -ForegroundColor Green
Write-Host "Repository: https://github.com/DHANASREE-1312/3_rd_review" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  You will need to authenticate with GitHub" -ForegroundColor Yellow
Write-Host "Use your Personal Access Token (PAT) as password" -ForegroundColor Yellow
Write-Host ""
$response = Read-Host "Push to GitHub now? (y/n)"

if ($response -eq "y") {
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✅ SUCCESS! Code pushed to GitHub" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Visit: https://github.com/DHANASREE-1312/3_rd_review" -ForegroundColor Yellow
        Write-Host "2. Go to Actions tab to see security scans running" -ForegroundColor Yellow
        Write-Host "3. Set up SonarCloud (see PUSH_TO_GITHUB.md)" -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "❌ Push failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Common issues:" -ForegroundColor Yellow
        Write-Host "1. Authentication failed - Use Personal Access Token" -ForegroundColor Yellow
        Write-Host "2. Create token at: https://github.com/settings/tokens" -ForegroundColor Yellow
        Write-Host "3. Select 'repo' and 'workflow' scopes" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Try again with:" -ForegroundColor Cyan
        Write-Host "git push -u origin main" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Push cancelled. Run this when ready:" -ForegroundColor Yellow
    Write-Host "git push -u origin main" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
