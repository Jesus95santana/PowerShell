function Test-Network {
    param([string]$ReportPath)

    # Shared timestamp for all network rows
    $ts = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")

    # ---------------------------
    # Ping test (Google DNS)
    # ---------------------------
    Write-Host "Ping test"
    try {
        $pingResult = Test-Connection -ComputerName "8.8.8.8" -Count 4 -ErrorAction Stop |
        Measure-Object -Property ResponseTime -Average
        $pingAvg = [math]::Round($pingResult.Average, 2)
        Write-CsvRow -Path $ReportPath -Test "network" -Metric "ping" -Value $pingAvg -Unit "ms" -Details "" -Timestamp $ts
    }
    catch {
        Write-CsvRow -Path $ReportPath -Test "network" -Metric "ping" -Value "SKIPPED" -Unit "" -Details "ping failed: $($_.Exception.Message)" -Timestamp $ts
    }

    # ---------------------------
    # Download test (Tele2 50MB file)
    # ---------------------------
    Write-Host "Download test"
    try {
        $filePath = "$env:TEMP\50MB.zip"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Invoke-WebRequest -Uri "http://speedtest.tele2.net/50MB.zip" -OutFile $filePath -UseBasicParsing -ErrorAction Stop
        $sw.Stop()

        $file = Get-Item $filePath
        $sizeMB = [math]::Round($file.Length / 1MB, 2)
        $mbps = [math]::Round(($sizeMB * 8) / $sw.Elapsed.TotalSeconds, 2)

        Write-CsvRow -Path $ReportPath -Test "network" -Metric "download" -Value $mbps -Unit "Mbit/s" -Details "Tele2 50MB test file" -Timestamp $ts
        Remove-Item $file.FullName -Force
    }
    catch {
        Write-CsvRow -Path $ReportPath -Test "network" -Metric "download" -Value "SKIPPED" -Unit "" -Details "download failed: $($_.Exception.Message)" -Timestamp $ts
    }

    # ---------------------------
    # Upload test (Hetzner upload endpoint)
    # ---------------------------
    Write-Host "Upload test"
    try {
        $uploadFile = "$env:TEMP\upload_test_50MB.bin"

        # Create the file only once
        if (-not (Test-Path $uploadFile)) {
            Write-Host "Creating 50 MB upload test file..."
            [IO.File]::WriteAllBytes($uploadFile, (0..(50MB - 1) | ForEach-Object { 0 }))
        }

        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Invoke-WebRequest -Uri "https://speed.hetzner.de/upload" -Method Post -InFile $uploadFile -UseBasicParsing -ErrorAction Stop | Out-Null
        $sw.Stop()

        $uploadSizeMB = 50
        $uploadMbps = [math]::Round(($uploadSizeMB * 8) / $sw.Elapsed.TotalSeconds, 2)

        Write-CsvRow -Path $ReportPath -Test "network" -Metric "upload" -Value $uploadMbps -Unit "Mbit/s" -Details "50 MB POST to hetzner.de" -Timestamp $ts
    }
    catch {
        Write-CsvRow -Path $ReportPath -Test "network" -Metric "upload" -Value "SKIPPED" -Unit "" -Details "upload failed: $($_.Exception.Message)" -Timestamp $ts
    }

}
