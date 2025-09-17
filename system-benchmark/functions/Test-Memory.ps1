function Test-Memory {
    param([string]$ReportPath)

    $arr = New-Object byte[] (100MB)
    $sw = [Diagnostics.Stopwatch]::StartNew()
    for ($i = 0; $i -lt $arr.Length; $i++) { $arr[$i] = 0xFF }
    $sw.Stop()

    $mbps = [math]::Round((100 / $sw.Elapsed.TotalSeconds), 2)
    Write-CsvRow -Path $ReportPath -Test "memory" -Metric "throughput" -Value $mbps -Unit "MiB/s" -Details "buffer=100MB"
}
