# Test Monitoring Endpoints
# Run this after the backend is running

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Testing Monitoring Endpoints" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:5000"

Write-Host "1️⃣  Testing Health Endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/health" -Method Get
    Write-Host "✅ Health Check:" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ Health check failed: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "2️⃣  Testing Monitoring Status..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/monitoring/status" -Method Get
    Write-Host "✅ Monitoring Status:" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ Monitoring status failed: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "3️⃣  Testing Monitoring Metrics..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/monitoring/metrics" -Method Get
    Write-Host "✅ Monitoring Metrics:" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "❌ Monitoring metrics failed: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "4️⃣  Generating Test Traffic (20 requests)..." -ForegroundColor Yellow
for ($i = 1; $i -le 20; $i++) {
    try {
        Invoke-RestMethod -Uri "$baseUrl/api/monitoring/health" -Method Get | Out-Null
        Write-Host "." -NoNewline -ForegroundColor Green
    } catch {
        Write-Host "x" -NoNewline -ForegroundColor Red
    }
    Start-Sleep -Milliseconds 100
}
Write-Host ""
Write-Host "✅ Test traffic generated!" -ForegroundColor Green
Write-Host ""

Write-Host "5️⃣  Checking Updated Metrics..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/monitoring/metrics" -Method Get
    Write-Host "✅ Updated Metrics:" -ForegroundColor Green
    Write-Host "   Request Count: $($response.metrics.requestCount)" -ForegroundColor Cyan
    Write-Host "   Error Count: $($response.metrics.errorCount)" -ForegroundColor Cyan
    Write-Host "   Feedback Submissions: $($response.metrics.feedbackSubmissions)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to get updated metrics: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Monitoring Test Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Check Azure Portal for Application Insights data" -ForegroundColor White
Write-Host "2. View Live Metrics in Azure Portal" -ForegroundColor White
Write-Host "3. Run custom queries in Logs section" -ForegroundColor White
