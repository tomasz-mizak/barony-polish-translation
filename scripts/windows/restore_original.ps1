# Barony Original Files Restoration Script for Windows (PowerShell)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Przywracanie oryginalnych plików Barony ===" -ForegroundColor Cyan
Write-Host ""

$baronyPath = $null
$steamPath = $null

try {
    $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath" -ErrorAction SilentlyContinue).InstallPath
    if (-not $steamPath) {
        $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Valve\Steam" -Name "InstallPath" -ErrorAction SilentlyContinue).InstallPath
    }
} catch {
    $steamPath = $null
}

if ($steamPath -and (Test-Path (Join-Path $steamPath "steamapps\common\Barony"))) {
    $baronyPath = Join-Path $steamPath "steamapps\common\Barony"
    Write-Host "✅ Znaleziono Barony w głównej bibliotece Steam" -ForegroundColor Green
}

if (-not $baronyPath) {
    Write-Host "🔍 Przeszukiwanie wszystkich dysków w poszukiwaniu Steam/Barony..." -ForegroundColor Yellow
    
    $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }
    
    foreach ($drive in $drives) {
        $driveLetter = $drive.Name
        
        $locations = @(
            "${driveLetter}:\Program Files (x86)\Steam\steamapps\common\Barony",
            "${driveLetter}:\Program Files\Steam\steamapps\common\Barony", 
            "${driveLetter}:\Steam\steamapps\common\Barony",
            "${driveLetter}:\SteamLibrary\steamapps\common\Barony"
        )
        
        foreach ($location in $locations) {
            if (Test-Path $location) {
                $baronyPath = $location
                Write-Host "✅ Znaleziono Barony na dysku ${driveLetter}:" -ForegroundColor Green
                break
            }
        }
        
        if ($baronyPath) { break }
    }
}

if (-not $baronyPath) {
    Write-Host "❌ BŁĄD: Nie znaleziono gry Barony na żadnym dysku" -ForegroundColor Red
    Read-Host "Naciśnij Enter aby zakończyć"
    exit 1
}

$backupPath = Join-Path $baronyPath "BACKUP_ORIGINAL"

if (-not (Test-Path $backupPath)) {
    Write-Host "❌ BŁĄD: Nie znaleziono backupu w: $backupPath" -ForegroundColor Red
    Write-Host "Prawdopodobnie nie wykonano backupu przed instalacją tłumaczenia." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Naciśnij Enter aby zakończyć"
    exit 1
}

Write-Host "✅ Znaleziono backup w: $backupPath" -ForegroundColor Green
Write-Host ""

$confirm = Read-Host "❓ Czy na pewno chcesz przywrócić oryginalne pliki? (t/N)"
if ($confirm -ne 't' -and $confirm -ne 'T') {
    Write-Host "❌ Anulowano przywracanie." -ForegroundColor Red
    Read-Host "Naciśnij Enter aby zakończyć"
    exit 0
}

Write-Host ""
Write-Host "🔄 Przywracanie oryginalnych plików..." -ForegroundColor Yellow

$foldersToRestore = @("lang", "books", "data", "items", "fonts")

foreach ($folder in $foldersToRestore) {
    $backupFolderPath = Join-Path $backupPath $folder
    $destFolderPath = Join-Path $baronyPath $folder
    
    if (Test-Path $backupFolderPath) {
        if ($folder -eq "data") {
            # Dla folderu data zachowujemy nowe pliki, tylko nadpisujemy istniejące
            Copy-Item -Path "$backupFolderPath\*" -Destination $destFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Przywrócono: $folder/ (zachowano nowe pliki)" -ForegroundColor Green
        } else {
            # Dla innych folderów całkowicie usuwamy i przywracamy
            if (Test-Path $destFolderPath) {
                Remove-Item -Path $destFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            }
            Copy-Item -Path $backupFolderPath -Destination $destFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Przywrócono: $folder/" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "✅ Oryginalne pliki zostały przywrócone!" -ForegroundColor Green
Write-Host "🎮 Gra powróciła do wersji angielskiej." -ForegroundColor Cyan
Write-Host ""
Write-Host "🔄 Aby ponownie zainstalować tłumaczenie, uruchom: install_translation.ps1" -ForegroundColor Yellow
Write-Host ""
Read-Host "Naciśnij Enter aby zakończyć"