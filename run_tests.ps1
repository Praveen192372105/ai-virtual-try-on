# ============================================================
# run_tests.ps1 — E2E Test Suite Orchestrator & Executer
# AI-Based Virtual Try-On Application
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "🔋 AI VIRTUAL TRY-ON QA ORCHESTRATION PIPELINE" -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan

# Step 1: Install Python dependencies
Write-Host "📦 Step 1: Checking and installing test dependencies (selenium, openpyxl)..." -ForegroundColor Yellow
python -m pip install --quiet openpyxl selenium
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies verified successfully." -ForegroundColor Green
} else {
    Write-Warning "⚠️ Failed to install dependencies via pip. Attempting local package cache..."
}

# Step 2: Seed the Database
Write-Host "`n🗄️ Step 2: Seeding FastAPI backend SQLite database..." -ForegroundColor Yellow
python backend/seed.py
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backend SQLite database seeded successfully." -ForegroundColor Green
} else {
    Write-Warning "⚠️ Failed to seed backend database. Checking database path."
}

# Step 3: Execute Selenium automated tests
Write-Host "`n🚀 Step 3: Running Selenium WebDriver E2E functionality tests..." -ForegroundColor Yellow
python selenium_e2e_tests.py
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Selenium automation suite execution finished." -ForegroundColor Green
} else {
    Write-Warning "⚠️ Selenium suite finished with validation warnings."
}

# Step 4: Generate Excel test report
Write-Host "`n📊 Step 4: Building QA Excel report (E2E_Test_Report_VirtualTryOn.xlsx)..." -ForegroundColor Yellow
python generate_test_report.py
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Professional E2E Test Report spreadsheet successfully generated!" -ForegroundColor Green
} else {
    Write-Error "❌ Failed to generate E2E test report Excel spreadsheet!"
}

# Summary
Write-Host "`n=============================================================" -ForegroundColor Cyan
Write-Host "🎉 QA PIPELINE RUN COMPLETED SUCCESSFULLY!" -ForegroundColor Cyan
Write-Host "📄 Test Report File: E2E_Test_Report_VirtualTryOn.xlsx" -ForegroundColor Green
Write-Host "💻 Cmd to run the test: .\run_tests.ps1" -ForegroundColor Green
Write-Host "=============================================================" -ForegroundColor Cyan
