param(
    [string]$RepoRoot = (git rev-parse --show-toplevel),
    [bool]$EncodeSlashInBranch = $true
)

$ErrorActionPreference = "Stop"

# Branch corrente
$branchName = (git -C $RepoRoot rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrWhiteSpace($branchName) -or $branchName -eq "HEAD") {
    Write-Host "Branch non valido o detached HEAD, skip."
    exit 0
}

# Se il branch contiene "/", lo codifichiamo per restare in un solo segmento URL
$branchSegment = if ($EncodeSlashInBranch) { $branchName -replace "/", "%2F" } else { $branchName }

Write-Host "Branch corrente: $branchName"
Write-Host "Segmento path usato: $branchSegment"

# Regex: sostituisce solo il pezzo tra /npa/ e lo slash successivo
# /anticorruzione-test/npa/<VECCHIO>/ -> /anticorruzione-test/npa/<NUOVO>/
$pattern = "(/anticorruzione-test/npa/)([^/]+)(/)"

# Estensioni da processare
$extensions = @(".yml", ".yaml", ".json", ".xml", ".md", ".txt", ".properties", ".conf")

# Directory da escludere
$excludeDirNames = @(".git", "node_modules", "target", ".idea", "bin", "obj", ".githooks")

function Is-ExcludedPath([string]$fullPath) {
    foreach ($d in $excludeDirNames) {
        if ($fullPath -match "(^|[\\/])$([regex]::Escape($d))([\\/]|$)") {
            return $true
        }
    }
    return $false
}

$updated = 0
$checked = 0

Get-ChildItem -Path $RepoRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    if (Is-ExcludedPath $file.FullName) { return }
    if (-not $extensions.Contains($file.Extension.ToLowerInvariant())) { return }

    $checked++
    try {
        $content = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
        if ($null -eq $content) { return }

        $newContent = [regex]::Replace($content, $pattern, {
            param($m)
            return "$($m.Groups[1].Value)$branchSegment/"
        })

        if ($newContent -ne $content) {
            Set-Content -LiteralPath $file.FullName -Value $newContent -Encoding UTF8 -ErrorAction Stop
            $updated++
            Write-Host "  ✓ $($file.FullName -replace [regex]::Escape($RepoRoot), '.')"
        }
    }
    catch {
        # Ignora file non leggibili (p.es. binari)
    }
}

Write-Host ""
Write-Host "✅ Sostituzione completata. File controllati: $checked, aggiornati: $updated (branch: $branchName)"
exit 0

