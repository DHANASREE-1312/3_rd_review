# Check Project Setup
# Run this to verify your environment is ready

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Project Setup Checker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js installed: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js" -ForegroundColor Red
    $allGood = $false
}

# Check npm
Write-Host "Checking npm..." -ForegroundColor Yellow
try {
    $npmVersion = npm --version
    Write-Host "✅ npm installed: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm not found" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# Check .env file
Write-Host "Checking .env file..." -ForegroundColor Yellow
if (Test-Path ".\backend\.env") {
    Write-Host "✅ .env file exists" -ForegroundColor Green
    
    # Check if it has real values
    $envContent = Get-Content ".\backend\.env" -Raw
    if ($envContent -match "your-server.database.windows.net" -or 
        $envContent -match "your_gemini_api_key_here") {
        Write-Host "⚠️  .env file contains placeholder values" -ForegroundColor Yellow
        Write-Host "   Please update with your actual credentials" -ForegroundColor Yellow
    } else {
        Write-Host "✅ .env file appears to be configured" -ForegroundColor Green
    }
} else {
    Write-Host "❌ .env file not found in backend/" -ForegroundColor Red
    Write-Host "   Run: Copy-Item backend\.env.example backend\.env" -ForegroundColor Yellow
    $allGood = $false
}
Write-Host ""

# Check backend node_modules
Write-Host "Checking backend dependencies..." -ForegroundColor Yellow
if (Test-Path ".\backend\node_modules") {
    Write-Host "✅ Backend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "⚠️  Backend dependencies not installed" -ForegroundColor Yellow
    Write-Host "   Run: cd backend && npm install" -ForegroundColor Yellow
}

# Check frontend node_modules
Write-Host "Checking frontend dependencies..." -ForegroundColor Yellow
if (Test-Path ".\frontend\node_modules") {
    Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "⚠️  Frontend dependencies not installed" -ForegroundColor Yellow
    Write-Host "   Run: cd frontend && npm install" -ForegroundColor Yellow
}
Write-Host ""

# Check backend build
Write-Host "Checking backend build..." -ForegroundColor Yellow
if (Test-Path ".\backend\dist") {
    Write-Host "✅ Backend is built" -ForegroundColor Green
} else {
    Write-Host "⚠️  Backend not built yet" -ForegroundColor Yellow
    Write-Host "   Run: cd backend && npm run build" -ForegroundColor Yellow
}
Write-Host ""

# Check monitoring files
Write-Host "Checking Review III files..." -ForegroundColor Yellow
$reviewFiles = @(
    ".github\workflows\security-scan.yml",
    "backend\src\monitoring\appInsights.ts",
    "backend\src\middleware\monitoring.ts",
    "backend\src\routes\monitoring.ts",
    "sonar-project.properties",
    "QUICK_START.md",
    "MONITORING_SETUP_GUIDE.md",
    "SECURITY_SETUP_GUIDE.md"
)

$filesFound = 0
foreach ($file in $reviewFiles) {
    if (Test-Path $file) {
        $filesFound++
    }
}

Write-Host "✅ Review III files: $filesFound/$($reviewFiles.Count) found" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "✅ Setup looks good! Ready to run." -ForegroundColor Green
    Write-Host ""
    Write-Host "To start the project:" -ForegroundColor Cyan
    Write-Host "  .\RUN_PROJECT.ps1" -ForegroundColor Yellow
} else {
    Write-Host "⚠️  Please fix the issues above" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
