function Test-DiskRead {
    param([string]$ReportPath)

    $file = "$env:TEMP\disk_write_test.tmp"

    if (-not (Test-Path $file)) {
        Write-Host "No test file found for read benchmark."
        return
    }

    $buffer = New-Object byte[] (64MB)   # 64 MB chunks
    $sizeMB = [math]::Round((Get-Item $file).Length / 1MB, 0)

    $fs = [System.IO.File]::Open($file, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $sw = [Diagnostics.Stopwatch]::StartNew()

    while ($fs.Read($buffer, 0, $buffer.Length) -gt 0) { }

    $fs.Close()
    $sw.Stop()

    $mbps = [math]::Round($sizeMB / $sw.Elapsed.TotalSeconds, 2)
    Write-Host "Finished reading $sizeMB MB in $($sw.Elapsed.TotalSeconds) sec = $mbps MB/s"

    Write-CsvRow -Path $ReportPath -Test "disk_read" -Metric "buffered_reads" -Value $mbps -Unit "MB/s" -Details "$sizeMB MB test"

    Remove-Item $file -Force
}
