# Barony Polish Translation Installer for Windows (PowerShell)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Instalator polskiego tłumaczenia Barony ===" -ForegroundColor Cyan
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
                $steamPath = Split-Path (Split-Path (Split-Path $location -Parent) -Parent) -Parent
                Write-Host "✅ Znaleziono Barony na dysku ${driveLetter}: w $(Split-Path $steamPath -Leaf)" -ForegroundColor Green
                break
            }
        }
        
        if ($baronyPath) { break }
    }
}

if (-not $baronyPath) {
    Write-Host "❌ Nie znaleziono gry Barony automatycznie" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔍 Sprawdź lokalizację gry w Steam:" -ForegroundColor Yellow
    Write-Host "Steam > Biblioteka > Barony > Prawym przyciskiem > Właściwości" -ForegroundColor Yellow
    Write-Host "> Pliki lokalne > Przeglądaj pliki lokalne" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📝 Możesz podać ścieżkę ręcznie lub naciśnij Enter aby anulować" -ForegroundColor Cyan
    Write-Host "   (przykład: C:\Program Files\Steam\steamapps\common\Barony)" -ForegroundColor Gray
    Write-Host ""
    
    $manualPath = Read-Host "Wpisz pełną ścieżkę do folderu gry Barony"
    
    if ([string]::IsNullOrWhiteSpace($manualPath)) {
        Write-Host "❌ Anulowano instalację" -ForegroundColor Red
        Read-Host "Naciśnij Enter aby zakończyć"
        exit 1
    }
    
    # Sprawdź czy podana ścieżka istnieje i zawiera grę
    if (-not (Test-Path $manualPath)) {
        Write-Host "❌ BŁĄD: Podana ścieżka nie istnieje: $manualPath" -ForegroundColor Red
        Read-Host "Naciśnij Enter aby zakończyć"
        exit 1
    }
    
    if (-not (Test-Path (Join-Path $manualPath "Barony.exe"))) {
        Write-Host "❌ BŁĄD: W podanej ścieżce nie znaleziono pliku Barony.exe" -ForegroundColor Red
        Write-Host "Sprawdź czy to właściwy folder gry" -ForegroundColor Yellow
        Read-Host "Naciśnij Enter aby zakończyć"
        exit 1
    }
    
    $baronyPath = $manualPath
    Write-Host "✅ Używam ręcznej ścieżki: $baronyPath" -ForegroundColor Green
}

$translationPath = $PSScriptRoot

Write-Host "✅ Znaleziono grę Barony w: $baronyPath" -ForegroundColor Green
Write-Host "✅ Znaleziono tłumaczenie w: $translationPath" -ForegroundColor Green
Write-Host ""

$backupPath = Join-Path $baronyPath "BACKUP_ORIGINAL"
if (-not (Test-Path $backupPath)) {
    Write-Host "📦 Tworzenie backupu oryginalnych plików..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    
    $foldersToBackup = @("lang", "books", "data", "items", "fonts")
    foreach ($folder in $foldersToBackup) {
        $sourcePath = Join-Path $baronyPath $folder
        $destPath = Join-Path $backupPath $folder
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "✅ Backup utworzony w: $backupPath" -ForegroundColor Green
} else {
    Write-Host "✅ Backup już istnieje: $backupPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔄 Instalowanie polskiego tłumaczenia..." -ForegroundColor Yellow

$foldersToTranslate = @("lang", "books", "data", "items", "fonts")
foreach ($folder in $foldersToTranslate) {
    $sourcePath = Join-Path $translationPath $folder
    $destPath = Join-Path $baronyPath $folder
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path "$sourcePath\*" -Destination $destPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "✅ Tłumaczenie zostało zainstalowane!" -ForegroundColor Green
Write-Host ""
Write-Host "🎮 Możesz teraz uruchomić Barony i cieszyć się grą w języku polskim!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Zainstalowano:" -ForegroundColor White
Write-Host "   • Główne pliki językowe (interfejs, dialogi)" -ForegroundColor White
Write-Host "   • Wszystkie książki (34 pliki)" -ForegroundColor White
Write-Host "   • Nazwy przedmiotów i osiągnięć" -ForegroundColor White
Write-Host "   • Nazwy poziomów (np. 'Mroczna Twierdza')" -ForegroundColor White
Write-Host "   • Fonty z polskimi znakami" -ForegroundColor White
Write-Host ""
Write-Host "🔙 Aby przywrócić oryginał, uruchom: restore_original.ps1" -ForegroundColor Yellow
Write-Host ""
Read-Host "Naciśnij Enter aby zakończyć"