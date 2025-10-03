Import-Module Pester
. "$PSScriptRoot\FolderCleaner.ps1"

Describe "Remove-TempFiles" {
    It "Throws if the path does not exist" {
        { Remove-TempFiles -Path "C:\NotARealPath" } | Should -Throw
    }

    It "Removes .tmp files" {
        $testPath = "$PSScriptRoot\TestFolder"
        New-Item -ItemType Directory -Path $testPath -Force | Out-Null
        New-Item -Path "$testPath\file1.tmp" -ItemType File | Out-Null
        New-Item -Path "$testPath\file2.tmp" -ItemType File | Out-Null
        New-Item -Path "$testPath\file3.txt" -ItemType File | Out-Null

        $result = Remove-TempFiles -Path $testPath
        $result | Should -Be 2

        Test-Path "$testPath\file1.tmp" | Should -BeFalse
        Test-Path "$testPath\file2.tmp" | Should -BeFalse
        Test-Path "$testPath\file3.txt" | Should -BeTrue

        Remove-Item $testPath -Recurse -Force
    }
}
