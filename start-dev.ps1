# Starts PostgreSQL + API for local development.
# Run after reboot: right-click -> Run with PowerShell, or: .\start-dev.ps1

Set-Location $PSScriptRoot

Write-Host "Starting database and API..." -ForegroundColor Cyan
docker compose up -d

Write-Host ""
Write-Host "Waiting for API..." -ForegroundColor Cyan
$ready = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $r = Invoke-RestMethod -Uri "http://localhost:3000/health" -TimeoutSec 2
        if ($r.ok) { $ready = $true; break }
    } catch { Start-Sleep -Seconds 2 }
}

if ($ready) {
    Write-Host "Ready! API: http://localhost:3000" -ForegroundColor Green
    Write-Host "Now run: flutter run -d windows" -ForegroundColor Green
} else {
    Write-Host "API not responding yet. Check: docker compose logs api" -ForegroundColor Yellow
}
