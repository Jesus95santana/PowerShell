function Test-DiskWrite {
    param([string]$ReportPath)

    $file = "$env:TEMP\disk_write_test.tmp"
    $sizeGB = 3      # total file size
    $bufferMB = 64     # chunk size
    $iterations = ($sizeGB * 1024) / $bufferMB

    $buffer = New-Object byte[] ($bufferMB * 1MB)

    Write-Host "Writing $sizeGB GB file in $bufferMB MB chunks..."
    $fs = [System.IO.File]::Open($file, [System.IO.FileMode]::Create)
    $sw = [Diagnostics.Stopwatch]::StartNew()

    for ($i = 1; $i -le $iterations; $i++) {
        $fs.Write($buffer, 0, $buffer.Length)
        if ($i % 16 -eq 0) { Write-Host ("  {0:N1} GB written..." -f (($i * $bufferMB) / 1024.0)) }
    }

    $fs.Close()
    $sw.Stop()

    $mbps = [math]::Round(($sizeGB * 1024) / $sw.Elapsed.TotalSeconds, 2)
    Write-Host "Finished: $sizeGB GB in $($sw.Elapsed.TotalSeconds) sec = $mbps MB/s"

    Write-CsvRow -Path $ReportPath -Test "disk_write" -Metric "sequential_readback" -Value $mbps -Unit "MB/s" -Details "$sizeGB GB test"
}
