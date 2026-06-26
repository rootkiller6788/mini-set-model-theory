# Smoke check script for mini-order-equivalence
Write-Output "mini-order-equivalence check..."
lake build 2>&1
if ($LASTEXITCODE -eq 0) { Write-Output "BUILD OK" } else { Write-Output "BUILD FAILED" }
