#!/bin/bash

# Barony Polish Translation Installer
STEAM_PATH=""
if [ -d "$HOME/.steam/steam" ]; then
    STEAM_PATH="$HOME/.steam/steam"
elif [ -d "$HOME/.local/share/Steam" ]; then
    STEAM_PATH="$HOME/.local/share/Steam"
elif [ -d "/home/$(whoami)/.steam/steam" ]; then
    STEAM_PATH="/home/$(whoami)/.steam/steam"
fi

if [ -z "$STEAM_PATH" ]; then
    echo "❌ BŁĄD: Nie można automatycznie wykryć ścieżki Steam"
    echo "Sprawdź czy Steam jest zainstalowany i uruchom ponownie"
    exit 1
fi

BARONY_PATH="$STEAM_PATH/steamapps/common/Barony"
TRANSLATION_PATH="$(dirname "$(realpath "$0")")"

echo "=== Instalator polskiego tłumaczenia Barony ==="
echo ""

if [ ! -d "$BARONY_PATH" ]; then
    echo "❌ BŁĄD: Nie znaleziono katalogu gry Barony: $BARONY_PATH"
    exit 1
fi

if [ ! -d "$TRANSLATION_PATH" ]; then
    echo "❌ BŁĄD: Nie znaleziono katalogu z tłumaczeniem: $TRANSLATION_PATH"
    exit 1
fi

echo "✅ Wykryto Steam w: $STEAM_PATH"
echo "✅ Znaleziono grę Barony w: $BARONY_PATH"
echo "✅ Znaleziono tłumaczenie w: $TRANSLATION_PATH"
echo ""

BACKUP_PATH="$BARONY_PATH/BACKUP_ORIGINAL"
if [ ! -d "$BACKUP_PATH" ]; then
    echo "📦 Tworzenie backupu oryginalnych plików..."
    mkdir -p "$BACKUP_PATH"
    cp -r "$BARONY_PATH/lang" "$BACKUP_PATH/" 2>/dev/null
    cp -r "$BARONY_PATH/books" "$BACKUP_PATH/" 2>/dev/null
    cp -r "$BARONY_PATH/data" "$BACKUP_PATH/" 2>/dev/null
    cp -r "$BARONY_PATH/items" "$BACKUP_PATH/" 2>/dev/null
    cp -r "$BARONY_PATH/fonts" "$BACKUP_PATH/" 2>/dev/null
    echo "✅ Backup utworzony w: $BACKUP_PATH"
else
    echo "✅ Backup już istnieje: $BACKUP_PATH"
fi

echo ""
echo "🔄 Instalowanie polskiego tłumaczenia..."

cp -r "$TRANSLATION_PATH/lang"/* "$BARONY_PATH/lang/" 2>/dev/null
cp -r "$TRANSLATION_PATH/books"/* "$BARONY_PATH/books/" 2>/dev/null
cp -r "$TRANSLATION_PATH/data"/* "$BARONY_PATH/data/" 2>/dev/null
cp -r "$TRANSLATION_PATH/items"/* "$BARONY_PATH/items/" 2>/dev/null
cp -r "$TRANSLATION_PATH/fonts"/* "$BARONY_PATH/fonts/" 2>/dev/null

echo "✅ Tłumaczenie zostało zainstalowane!"
echo ""
echo "🎮 Możesz teraz uruchomić Barony i cieszyć się grą w języku polskim!"
echo ""
echo "📋 Zainstalowano:"
echo "   • Główne pliki językowe (interfejs, dialogi)"
echo "   • Wszystkie książki (34 pliki)"
echo "   • Nazwy przedmiotów i osiągnięć"
echo "   • Nazwy poziomów (np. 'Mroczna Twierdza')"
echo "   • Fonty z polskimi znakami"
echo ""
echo "🔙 Aby przywrócić oryginał, uruchom: ./restore_original.sh"