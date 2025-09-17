function Get-SystemSnapshot {
    param([string]$ReportPath)

    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 -Property Name, NumberOfCores
    $os = Get-CimInstance Win32_OperatingSystem
    $mem = [math]::Round($os.TotalVisibleMemorySize / 1024)

    Write-CsvRow -Path $ReportPath -Test "system" -Metric "cpu_model" -Value $cpu.Name -Unit "" -Details "cores=$($cpu.NumberOfCores); os=$($os.Caption); version=$($os.Version)"
    Write-CsvRow -Path $ReportPath -Test "system" -Metric "mem_total" -Value $mem -Unit "MiB" -Details "uptime_seconds=$([int]$os.LastBootUpTime.ToUniversalTime().Subtract((Get-Date).ToUniversalTime()).TotalSeconds * -1)"
}
