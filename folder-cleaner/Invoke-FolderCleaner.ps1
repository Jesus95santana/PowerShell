param(
    [string]$Path
)

# Import all helper functions
Get-ChildItem "$PSScriptRoot/functions/*.ps1" | ForEach-Object { . $_.FullName }

Remove-TempFiles -Path $Path
