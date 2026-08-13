[CmdletBinding()]
param(
    [string]$CodexHome = (Join-Path $env:USERPROFILE '.codex')
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot 'pet'
$targetRoot = Join-Path $CodexHome 'pets'
$target = Join-Path $targetRoot 'kotone-nunu'
$backupRoot = Join-Path $CodexHome 'pets-backup'

& (Join-Path $PSScriptRoot 'validate.ps1') -PetDirectory $source

if (Test-Path -LiteralPath $target) {
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = Join-Path $backupRoot "kotone-nunu-$stamp"
    Copy-Item -LiteralPath $target -Destination $backup -Recurse
    Write-Host "Backed up existing pet to: $backup"
}

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -LiteralPath (Join-Path $source 'pet.json') -Destination (Join-Path $target 'pet.json') -Force
Copy-Item -LiteralPath (Join-Path $source 'spritesheet.webp') -Destination (Join-Path $target 'spritesheet.webp') -Force

& (Join-Path $PSScriptRoot 'validate.ps1') -PetDirectory $target
Write-Host "Installed Kotone Nunu to: $target"
Write-Host 'Re-select the pet or restart Codex to reload it.'
