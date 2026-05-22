param(
    [string]$RepoRoot = (git rev-parse --show-toplevel),
    [bool]$EncodeSlashInBranch = $true
)

$ErrorActionPreference = "Stop"

$branchName = (git -C $RepoRoot rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrWhiteSpace($branchName) -or $branchName -eq "HEAD") {
    Write-Host "Branch non valido o detached HEAD, skip."
    exit 0
}

$branchSegment = if ($EncodeSlashInBranch) { $branchName -replace "/", "%2F" } else { $branchName }

Write-Host "Branch corrente: $branchName"
Write-Host "Segmento path usato: $branchSegment"

# Pattern domain-aware: intercetta SOLO le URL dove il branch ha senso.
#
# Formato 1 - raw.githubusercontent.com (contenuto file):
#   https://raw.githubusercontent.com/anticorruzione-test/npa/<branch>/path/file
#
# Formato 2 - github.com blob/tree (vista file/cartella):
#   https://github.com/anticorruzione-test/npa/blob/<branch>/path/file
#   https://github.com/anticorruzione-test/npa/tree/<branch>/path/cartella
#
# NON viene mai toccato nulla del tipo:
#   https://github.com/anticorruzione-test/npa/issues
#   https://github.com/anticorruzione-test/npa/issues/1215
#   https://github.com/anticorruzione-test/npa/pulls
#   (qualsiasi altra sezione GitHub)

# Pattern 1: raw.githubusercontent.com — il branch è subito dopo /npa/
$patternRaw  = "(https://raw\.githubusercontent\.com/anticorruzione-test/npa/)([^/\s#]+)(/)"

# Pattern 2: github.com blob o tree — il branch è dopo /blob/ o /tree/
$patternTree = "(https://github\.com/anticorruzione-test/npa/(?:blob|tree)/)([^/\s]+)(/)"
$extensions = @(".yml", ".yaml", ".json", ".xml", ".md", ".txt", ".properties", ".conf")
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

# Lettura/scrittura byte-level per non introdurre BOM o newline extra.
$utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)

Get-ChildItem -Path $RepoRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    if (Is-ExcludedPath $file.FullName) { return }
    if (-not $extensions.Contains($file.Extension.ToLowerInvariant())) { return }

    $checked++
    try {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $hasUtf8Bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
        $start = if ($hasUtf8Bom) { 3 } else { 0 }
        $count = $bytes.Length - $start

        $content = if ($count -gt 0) {
            $utf8Strict.GetString($bytes, $start, $count)
        } else {
            ""
        }

        $newContent = $content
        foreach ($pat in @($patternRaw, $patternTree)) {
            $newContent = [regex]::Replace($newContent, $pat, {
                param($m)
                return "$($m.Groups[1].Value)$branchSegment/"
            })
        }

        if ($newContent -ne $content) {
            $newBody = $utf8Strict.GetBytes($newContent)
            if ($hasUtf8Bom) {
                $out = New-Object byte[] (3 + $newBody.Length)
                $out[0] = 0xEF; $out[1] = 0xBB; $out[2] = 0xBF
                [System.Buffer]::BlockCopy($newBody, 0, $out, 3, $newBody.Length)
                [System.IO.File]::WriteAllBytes($file.FullName, $out)
            }
            else {
                [System.IO.File]::WriteAllBytes($file.FullName, $newBody)
            }

            $updated++
            Write-Host "  updated: $($file.FullName -replace [regex]::Escape($RepoRoot), '.')"
        }
    }
    catch {
        # Ignora file non leggibili o non UTF-8
    }
}

Write-Host ""
Write-Host "Sostituzione completata. File controllati: $checked, aggiornati: $updated (branch: $branchName)"
exit 0
