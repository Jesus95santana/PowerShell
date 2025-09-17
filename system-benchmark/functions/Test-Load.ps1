function Test-Load {
    param([string]$ReportPath)

    $cpu = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 5
    $avg = [math]::Round(($cpu.CounterSamples.CookedValue | Measure-Object -Average).Average, 2)

    Write-CsvRow -Path $ReportPath -Test "system_load" -Metric "cpu_usage_avg" -Value $avg -Unit "%" -Details "sample=5s"
}
