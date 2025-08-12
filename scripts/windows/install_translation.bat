@echo off
chcp 65001 >nul
REM Barony Polish Translation Installer for Windows

setlocal enabledelayedexpansion

echo === Instalator polskiego tłumaczenia Barony ===
echo.

set "BARONY_PATH="
set "STEAM_PATH="

for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam" /v InstallPath 2^>nul') do set "STEAM_PATH=%%b"
if "%STEAM_PATH%"=="" (
    for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam" /v InstallPath 2^>nul') do set "STEAM_PATH=%%b"
)

  
if not "!STEAM_PATH!"=="" (
    if exist "!STEAM_PATH!\steamapps\common\Barony" (
        set "BARONY_PATH=!STEAM_PATH!\steamapps\common\Barony"
        echo ✅ Znaleziono Barony w głównej bibliotece Steam
    )
)

if "!BARONY_PATH!"=="" (
    echo 🔍 Przeszukiwanie wszystkich dysków w poszukiwaniu Steam/Barony...
    
    set "FOUND_FLAG=0"
    for %%d in (C D E F G H I J K L) do (
        if "!FOUND_FLAG!"=="0" (
            if exist "%%d:\" (
                echo   Sprawdzam dysk %%d:...
                if exist "%%d:\Program Files (x86)\Steam\steamapps\common\Barony" if "!FOUND_FLAG!"=="0" (
                    set "BARONY_PATH=%%d:\Program Files (x86)\Steam\steamapps\common\Barony"
                    set "STEAM_PATH=%%d:\Program Files (x86)\Steam"
                    set "FOUND_FLAG=1"
                    echo ✅ Znaleziono Barony na %%d: w "Program Files (x86)\Steam"
                )
                if exist "%%d:\Program Files\Steam\steamapps\common\Barony" if "!FOUND_FLAG!"=="0" (
                    set "BARONY_PATH=%%d:\Program Files\Steam\steamapps\common\Barony"
                    set "STEAM_PATH=%%d:\Program Files\Steam"
                    set "FOUND_FLAG=1"
                    echo ✅ Znaleziono Barony na %%d: w "Program Files\Steam"
                )
                if exist "%%d:\Steam\steamapps\common\Barony" if "!FOUND_FLAG!"=="0" (
                    set "BARONY_PATH=%%d:\Steam\steamapps\common\Barony"
                    set "STEAM_PATH=%%d:\Steam"
                    set "FOUND_FLAG=1"
                    echo ✅ Znaleziono Barony na %%d: w Steam
                )
                if exist "%%d:\SteamLibrary\steamapps\common\Barony" if "!FOUND_FLAG!"=="0" (
                    set "BARONY_PATH=%%d:\SteamLibrary\steamapps\common\Barony"
                    set "STEAM_PATH=%%d:\SteamLibrary"
                    set "FOUND_FLAG=1"
                    echo ✅ Znaleziono Barony na %%d: w SteamLibrary
                )
            )
        )
    )
)

if not "!BARONY_PATH!"=="" goto :after_manual_prompt
echo ❌ Nie znaleziono gry Barony automatycznie
echo.
echo 🔍 Sprawdź lokalizację gry w Steam:
echo Steam ^> Biblioteka ^> Barony ^> Prawym przyciskiem ^> Właściwości
echo ^> Pliki lokalne ^> Przeglądaj pliki lokalne
echo.
echo 📝 Możesz podać ścieżkę ręcznie (przykład: C:\Program Files\Steam\steamapps\common\Barony)
echo    lub naciśnij Enter aby anulować
echo.
set /p "MANUAL_PATH=Wpisz pełną ścieżkę do folderu gry Barony: "

if "!MANUAL_PATH!"=="" (
    echo ❌ Anulowano instalację
    pause
    exit /b 1
)

if not exist "!MANUAL_PATH!" (
    echo ❌ BŁĄD: Podana ścieżka nie istnieje: !MANUAL_PATH!
    pause
    exit /b 1
)

if not exist "!MANUAL_PATH!\Barony.exe" (
    echo ❌ BŁĄD: W podanej ścieżce nie znaleziono pliku Barony.exe
    echo Sprawdź czy to właściwy folder gry
    pause
    exit /b 1
)

set "BARONY_PATH=!MANUAL_PATH!"
echo ✅ Używam ręcznej ścieżki: "!BARONY_PATH!"

:after_manual_prompt
set "TRANSLATION_PATH=%~dp0"

echo ✅ Znaleziono grę Barony w: "!BARONY_PATH!"
echo ✅ Znaleziono tłumaczenie w: "!TRANSLATION_PATH!"
echo.

set "BACKUP_PATH=!BARONY_PATH!\BACKUP_ORIGINAL"
if not exist "!BACKUP_PATH!" (
    echo 📦 Tworzenie backupu oryginalnych plików...
    mkdir "!BACKUP_PATH!" 2>nul
    if exist "!BARONY_PATH!\lang" xcopy "!BARONY_PATH!\lang" "!BACKUP_PATH!\lang" /E /I /Q >nul 2>&1
    if exist "!BARONY_PATH!\books" xcopy "!BARONY_PATH!\books" "!BACKUP_PATH!\books" /E /I /Q >nul 2>&1
    if exist "!BARONY_PATH!\data" xcopy "!BARONY_PATH!\data" "!BACKUP_PATH!\data" /E /I /Q >nul 2>&1
    if exist "!BARONY_PATH!\items" xcopy "!BARONY_PATH!\items" "!BACKUP_PATH!\items" /E /I /Q >nul 2>&1
    if exist "!BARONY_PATH!\fonts" xcopy "!BARONY_PATH!\fonts" "!BACKUP_PATH!\fonts" /E /I /Q >nul 2>&1
    echo ✅ Backup utworzony w: !BACKUP_PATH!
) else (
    echo ✅ Backup już istnieje: !BACKUP_PATH!
)

echo.
echo 🔄 Instalowanie polskiego tłumaczenia...

if exist "!TRANSLATION_PATH!lang" (
    xcopy "!TRANSLATION_PATH!lang\*" "!BARONY_PATH!\lang\" /E /Y /Q >nul 2>&1
)
if exist "!TRANSLATION_PATH!books" (
    xcopy "!TRANSLATION_PATH!books\*" "!BARONY_PATH!\books\" /E /Y /Q >nul 2>&1
)
if exist "!TRANSLATION_PATH!data" (
    xcopy "!TRANSLATION_PATH!data\*" "!BARONY_PATH!\data\" /E /Y /Q >nul 2>&1
)
if exist "!TRANSLATION_PATH!items" (
    xcopy "!TRANSLATION_PATH!items\*" "!BARONY_PATH!\items\" /E /Y /Q >nul 2>&1
)
if exist "!TRANSLATION_PATH!fonts" (
    xcopy "!TRANSLATION_PATH!fonts\*" "!BARONY_PATH!\fonts\" /E /Y /Q >nul 2>&1
)

echo ✅ Tłumaczenie zostało zainstalowane!
echo.
echo 🎮 Możesz teraz uruchomić Barony i cieszyć się grą w języku polskim!
echo.
echo 📋 Zainstalowano:
echo    • Główne pliki językowe (interfejs, dialogi^)
echo    • Wszystkie książki (34 pliki^)
echo    • Nazwy przedmiotów i osiągnięć
echo    • Nazwy poziomów (np. 'Mroczna Twierdza'^)
echo    • Fonty z polskimi znakami
echo.
echo 🔙 Aby przywrócić oryginał, uruchom: restore_original.bat
echo.
pause