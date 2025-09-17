function Write-CsvRow {
    param(
        [string]$Path,
        [string]$Test,
        [string]$Metric,
        [string]$Value,
        [string]$Unit,
        [string]$Details = "",
        [string]$Timestamp = $(Get-Date).ToString("yyyy-MM-ddTHH:mm:ssK")
    )

    if (-not (Test-Path $Path)) {
        "timestamp,test,metric,value,unit,details" | Out-File -FilePath $Path -Encoding utf8
    }

    $line = '"' + ($Timestamp -replace '"', '""') + '","' +
    ($Test -replace '"', '""') + '","' +
    ($Metric -replace '"', '""') + '","' +
    ($Value -replace '"', '""') + '","' +
    ($Unit -replace '"', '""') + '","' +
    ($Details -replace '"', '""') + '"'

    Add-Content -Path $Path -Value $line
}
