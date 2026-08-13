[CmdletBinding()]
param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex')
)

$ErrorActionPreference = 'Stop'
$target = Join-Path (Join-Path $CodexHome 'pets') 'kotone-nunu'

if (-not (Test-Path -LiteralPath $target)) {
    Write-Host "Kotone Nunu is not installed at: $target"
    return
}

$backupRoot = Join-Path $CodexHome 'pets-backup'
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $backupRoot "kotone-nunu-uninstalled-$stamp"
Move-Item -LiteralPath $target -Destination $backup
Write-Host "Uninstalled Kotone Nunu. Recoverable copy: $backup"
