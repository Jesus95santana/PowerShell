function Remove-TempFiles {
    param (
        [string]$Path
    )

    if (-Not (Test-Path $Path)) {
        throw "Path does not exist: $Path"
    }

    $files = Get-ChildItem -Path $Path -Filter *.tmp -File
    foreach ($file in $files) {
        Remove-Item $file.FullName -Force
    }
    return $files.Count
}
