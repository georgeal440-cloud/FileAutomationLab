Write-Host "=== Starting File Automation Script ===" -ForegroundColor Cyan

$DaysThreshold = -7
$CutoffDate = (Get-Date).AddDays($DaysThreshold)
Write-Host "Looking for files modified after: $CutoffDate" -ForegroundColor Yellow

$RecentFiles = Get-ChildItem -Path "." -File | Where-Object { $_.LastWriteTime -gt $CutoffDate }

if ($null -eq $RecentFiles -or $RecentFiles.Count -eq 0) {
    Write-Host "No recent files found matching the criteria." -ForegroundColor Red
} else {
    Write-Host "Found $($RecentFiles.Count) file(s) to process." -ForegroundColor Green

    $DestinationFolder = ".\logs"
    if (!(Test-Path -Path $DestinationFolder)) {
        New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
        Write-Host "Created destination folder: $DestinationFolder" -ForegroundColor DarkGreen
    }

    foreach ($file in $RecentFiles) {
        Write-Host "Backing up file: $($file.Name)" -ForegroundColor Gray
        Copy-Item -Path $file.FullName -Destination ".\logs\" -WhatIf
    }
}

Write-Host "=== Script Completed Successfully ===" -ForegroundColor Cyan