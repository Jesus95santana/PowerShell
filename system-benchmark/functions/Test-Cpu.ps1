function Test-Cpu {
    param([string]$ReportPath)

    $threads = [Environment]::ProcessorCount
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $jobs = @()
    for ($i = 0; $i -lt $threads; $i++) {
        $jobs += Start-Job { 
            $x = 0; for ($j = 0; $j -lt 5000000; $j++) { $x += [math]::Sqrt($j) } 
            $x 
        }
    }
    Wait-Job $jobs
    $sw.Stop()

    $events = 5000000 * $threads
    $evps = [math]::Round($events / $sw.Elapsed.TotalSeconds, 2)

    Write-CsvRow -Path $ReportPath -Test "cpu" -Metric "events_per_second" -Value $evps -Unit "ev/s" -Details "threads=$threads"
    Remove-Job $jobs -Force
}
