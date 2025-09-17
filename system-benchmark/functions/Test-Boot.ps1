function Test-Boot {
    param([string]$ReportPath)

    $events = Get-WinEvent -ProviderName "Microsoft-Windows-Diagnostics-Performance" -MaxEvents 50 |
    Where-Object { $_.Id -eq 100 } | Select-Object -First 5

    foreach ($e in $events) {
        $delay = $e.Properties[5].Value
        $svc = $e.Properties[6].Value
        Write-CsvRow -Path $ReportPath -Test "boot" -Metric "service_delay" -Value $delay -Unit "ms" -Details $svc
    }
}
