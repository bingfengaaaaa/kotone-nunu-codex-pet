[CmdletBinding()]
param(
    [string]$PetDirectory = (Join-Path (Split-Path -Parent $PSScriptRoot) 'pet')
)

$ErrorActionPreference = 'Stop'

function Test-KotoneNunuPackage {
    param([Parameter(Mandatory)][string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $manifestPath = Join-Path $resolved 'pet.json'
    $sheetPath = Join-Path $resolved 'spritesheet.webp'

    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        throw "Missing manifest: $manifestPath"
    }
    if (-not (Test-Path -LiteralPath $sheetPath -PathType Leaf)) {
        throw "Missing spritesheet: $sheetPath"
    }

    $manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($manifest.id -ne 'kotone-nunu') {
        throw "Unexpected pet id: $($manifest.id)"
    }
    if ([int]$manifest.spriteVersionNumber -ne 2) {
        throw "spriteVersionNumber must be 2."
    }
    if ($manifest.spritesheetPath -ne 'spritesheet.webp') {
        throw "spritesheetPath must be spritesheet.webp."
    }

    $bytes = [System.IO.File]::ReadAllBytes($sheetPath)
    if ($bytes.Length -lt 30) {
        throw 'Spritesheet is unexpectedly small.'
    }
    $ascii = [System.Text.Encoding]::ASCII.GetString($bytes, 0, [Math]::Min($bytes.Length, 32))
    if (-not ($ascii.StartsWith('RIFF') -and $ascii.Substring(8, 4) -eq 'WEBP')) {
        throw 'spritesheet.webp is not a RIFF WebP file.'
    }

    [pscustomobject]@{
        Ok = $true
        PetDirectory = $resolved
        PetId = $manifest.id
        SpriteVersionNumber = [int]$manifest.spriteVersionNumber
        SpritesheetBytes = $bytes.Length
    }
}

$result = Test-KotoneNunuPackage -Path $PetDirectory
$result | Format-List
