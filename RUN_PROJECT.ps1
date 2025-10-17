# Daily Mess Feedback System - Quick Start Script
# Run this script to start your project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Daily Mess Feedback System - Startup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
$envPath = ".\backend\.env"
if (-Not (Test-Path $envPath)) {
    Write-Host "⚠️  .env file not found!" -ForegroundColor Yellow
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item ".\backend\.env.example" $envPath
    Write-Host "✅ .env file created!" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: Edit backend\.env with your actual credentials:" -ForegroundColor Red
    Write-Host "   - DB_SERVER" -ForegroundColor Yellow
    Write-Host "   - DB_NAME" -ForegroundColor Yellow
    Write-Host "   - DB_USER" -ForegroundColor Yellow
    Write-Host "   - DB_PASSWORD" -ForegroundColor Yellow
    Write-Host "   - GEMINI_API_KEY" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key after editing .env file..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Write-Host "📦 Step 1: Installing Backend Dependencies..." -ForegroundColor Cyan
Set-Location backend
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install backend dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Backend dependencies installed!" -ForegroundColor Green
Write-Host ""

Write-Host "🔨 Step 2: Building Backend..." -ForegroundColor Cyan
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build backend" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Backend built successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "🚀 Step 3: Starting Backend Server..." -ForegroundColor Cyan
Write-Host "Backend will run on http://localhost:5000" -ForegroundColor Yellow
Write-Host ""
Write-Host "To start frontend (in a new terminal):" -ForegroundColor Cyan
Write-Host "  cd frontend" -ForegroundColor Yellow
Write-Host "  npm install" -ForegroundColor Yellow
Write-Host "  npm run dev" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

npm start
