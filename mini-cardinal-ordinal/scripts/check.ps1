# MiniCardinalOrdinal — Windows build check
Write-Host "== MiniCardinalOrdinal Build Check ==" -ForegroundColor Cyan

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "[1/3] Checking lakefile..." -ForegroundColor Yellow
if (Test-Path "lakefile.lean") {
    Write-Host "  lakefile.lean found." -ForegroundColor Green
} else {
    Write-Host "  ERROR: lakefile.lean not found!" -ForegroundColor Red
    exit 1
}

Write-Host "[2/3] Running lake build..." -ForegroundColor Yellow
lake build 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Build succeeded." -ForegroundColor Green
} else {
    Write-Host "  Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "[3/3] Running smoke tests..." -ForegroundColor Yellow
lake env lean --run Test/Smoke.lean 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Smoke tests passed." -ForegroundColor Green
} else {
    Write-Host "  Smoke tests failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "== All checks passed! ==" -ForegroundColor Green
