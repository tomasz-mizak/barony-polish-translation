@echo off
chcp 65001 >nul
REM Barony Original Files Restoration Script for Windows

setlocal enabledelayedexpansion

echo === Przywracanie oryginalnych plików Barony ===
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
    )
)

if "!BARONY_PATH!"=="" (
    echo 🔍 Przeszukiwanie dysków w poszukiwaniu Barony...
    
    for %%d in (C D E F G H I J K L) do (
        if exist "%%d:\" (
            echo   Sprawdzam dysk %%d:...
            if exist "%%d:\Program Files (x86)\Steam\steamapps\common\Barony" (
                set "BARONY_PATH=%%d:\Program Files (x86)\Steam\steamapps\common\Barony"
                echo ✅ Znaleziono Barony na %%d: w "Program Files (x86)\Steam"
                goto :found_restore
            )
            if exist "%%d:\Program Files\Steam\steamapps\common\Barony" (
                set "BARONY_PATH=%%d:\Program Files\Steam\steamapps\common\Barony"
                echo ✅ Znaleziono Barony na %%d: w "Program Files\Steam"
                goto :found_restore
            )
            if exist "%%d:\Steam\steamapps\common\Barony" (
                set "BARONY_PATH=%%d:\Steam\steamapps\common\Barony"
                echo ✅ Znaleziono Barony na %%d: w Steam
                goto :found_restore
            )
            if exist "%%d:\SteamLibrary\steamapps\common\Barony" (
                set "BARONY_PATH=%%d:\SteamLibrary\steamapps\common\Barony"
                echo ✅ Znaleziono Barony na %%d: w SteamLibrary
                goto :found_restore
            )
        )
    )
)

:found_restore
if "!BARONY_PATH!"=="" (
    echo ❌ BŁĄD: Nie znaleziono gry Barony na żadnym dysku
    pause
    exit /b 1
)

set "BACKUP_PATH=!BARONY_PATH!\BACKUP_ORIGINAL"

if not exist "!BACKUP_PATH!" (
    echo ❌ BŁĄD: Nie znaleziono backupu w: !BACKUP_PATH!
    echo Prawdopodobnie nie wykonano backupu przed instalacją tłumaczenia.
    echo.
    pause
    exit /b 1
)

echo ✅ Znaleziono backup w: "!BACKUP_PATH!"
echo.

set /p "confirm=❓ Czy na pewno chcesz przywrócić oryginalne pliki? (t/N): "
if /i not "%confirm%"=="t" (
    echo ❌ Anulowano przywracanie.
    pause
    exit /b 0
)

echo.
echo 🔄 Przywracanie oryginalnych plików...

if exist "!BACKUP_PATH!\lang" (
    rmdir /s /q "!BARONY_PATH!\lang" 2>nul
    xcopy "!BACKUP_PATH!\lang" "!BARONY_PATH!\lang" /E /I /Q >nul
    echo ✅ Przywrócono: lang/
)

if exist "!BACKUP_PATH!\books" (
    rmdir /s /q "!BARONY_PATH!\books" 2>nul
    xcopy "!BACKUP_PATH!\books" "!BARONY_PATH!\books" /E /I /Q >nul
    echo ✅ Przywrócono: books/
)

if exist "!BACKUP_PATH!\data" (
    xcopy "!BACKUP_PATH!\data\*" "!BARONY_PATH!\data\" /E /Y /Q >nul
    echo ✅ Przywrócono: data/ (zachowano nowe pliki^)
)

if exist "!BACKUP_PATH!\items" (
    rmdir /s /q "!BARONY_PATH!\items" 2>nul
    xcopy "!BACKUP_PATH!\items" "!BARONY_PATH!\items" /E /I /Q >nul
    echo ✅ Przywrócono: items/
)

if exist "!BACKUP_PATH!\fonts" (
    rmdir /s /q "!BARONY_PATH!\fonts" 2>nul
    xcopy "!BACKUP_PATH!\fonts" "!BARONY_PATH!\fonts" /E /I /Q >nul
    echo ✅ Przywrócono: fonts/
)

echo.
echo ✅ Oryginalne pliki zostały przywrócone!
echo 🎮 Gra powróciła do wersji angielskiej.
echo.
echo 🔄 Aby ponownie zainstalować tłumaczenie, uruchom: install_translation.bat
echo.
pause