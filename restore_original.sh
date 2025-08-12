#!/bin/bash

# Barony Original Files Restoration Script
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
    exit 1
fi

BARONY_PATH="$STEAM_PATH/steamapps/common/Barony"
BACKUP_PATH="$BARONY_PATH/BACKUP_ORIGINAL"

echo "=== Przywracanie oryginalnych plików Barony ==="
echo ""

if [ ! -d "$BACKUP_PATH" ]; then
    echo "❌ BŁĄD: Nie znaleziono backupu w: $BACKUP_PATH"
    echo "Prawdopodobnie nie wykonano backupu przed instalacją tłumaczenia."
    exit 1
fi

echo "✅ Znaleziono backup w: $BACKUP_PATH"
echo ""

read -p "❓ Czy na pewno chcesz przywrócić oryginalne pliki? (t/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Tt]$ ]]; then
    echo "❌ Anulowano przywracanie."
    exit 0
fi

echo "🔄 Przywracanie oryginalnych plików..."

if [ -d "$BACKUP_PATH/lang" ]; then
    rm -rf "$BARONY_PATH/lang"
    cp -r "$BACKUP_PATH/lang" "$BARONY_PATH/"
    echo "✅ Przywrócono: lang/"
fi

if [ -d "$BACKUP_PATH/books" ]; then
    rm -rf "$BARONY_PATH/books"
    cp -r "$BACKUP_PATH/books" "$BARONY_PATH/"
    echo "✅ Przywrócono: books/"
fi

if [ -d "$BACKUP_PATH/data" ]; then
    cp -r "$BACKUP_PATH/data"/* "$BARONY_PATH/data/"
    echo "✅ Przywrócono: data/ (zachowano nowe pliki)"
fi

if [ -d "$BACKUP_PATH/items" ]; then
    rm -rf "$BARONY_PATH/items"
    cp -r "$BACKUP_PATH/items" "$BARONY_PATH/"
    echo "✅ Przywrócono: items/"
fi

if [ -d "$BACKUP_PATH/fonts" ]; then
    rm -rf "$BARONY_PATH/fonts"
    cp -r "$BACKUP_PATH/fonts" "$BARONY_PATH/"
    echo "✅ Przywrócono: fonts/"
fi

echo ""
echo "✅ Oryginalne pliki zostały przywrócone!"
echo "🎮 Gra powróciła do wersji angielskiej."
echo ""
echo "🔄 Aby ponownie zainstalować tłumaczenie, uruchom: ./install_translation.sh"