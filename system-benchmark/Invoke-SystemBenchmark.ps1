param(
    [string]$ReportPath = "./system_benchmark_report.csv"
)

# Import all helper functions
Get-ChildItem "$PSScriptRoot/functions/*.ps1" | ForEach-Object { . $_.FullName }

# Run tests
Write-Host "Getting SystemSnapshot"
Get-SystemSnapshot -ReportPath $ReportPath

Write-Host "Testing Cpu"
Test-Cpu -ReportPath $ReportPath

Write-Host "Testing Memory"
Test-Memory -ReportPath $ReportPath

Write-Host "Testing DiskWrite"
Test-DiskWrite -ReportPath $ReportPath

Write-Host "Testing DiskRead"
Test-DiskRead -ReportPath $ReportPath

Write-Host "Testing Load"
Test-Load -ReportPath $ReportPath

Write-Host "Testing Boot"
Test-Boot -ReportPath $ReportPath

Write-Host "Testing Network"
Test-Network -ReportPath $ReportPath


Write-Host "Done. CSV saved to: $ReportPath"
