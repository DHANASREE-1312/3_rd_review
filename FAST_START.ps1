# Fast Start Script - No checks, just run
Write-Host "🚀 Starting Backend Server..." -ForegroundColor Cyan

Set-Location backend

# Check if dist folder exists, if not build
if (-Not (Test-Path "dist\server.js")) {
    Write-Host "📦 Building backend..." -ForegroundColor Yellow
    npm run build
}

Write-Host "✅ Starting server on http://localhost:5000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""

npm start
