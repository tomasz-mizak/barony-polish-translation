# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the official Polish translation for Barony, a 3D first-person roguelike game. The repository contains translated game text files, books, UI elements, and installation scripts for Windows and Linux platforms.

## Directory Structure

- **lang/** - Main language files (en.txt contains Polish translations despite the filename)
- **books/** - All 34 in-game books translated to Polish
- **data/** - UI translations (achievements, tutorials, story endings, character sheets)
- **items/** - Item names and tooltips
- **fonts/** - Custom fonts supporting Polish diacritics (ą, ć, ę, ł, ń, ó, ś, ź, ż)
- **scripts/** - Installation scripts for Windows and Linux

## Installation Commands

### Linux
```bash
cd scripts/linux
chmod +x install_translation.sh restore_original.sh
./install_translation.sh    # Install Polish translation
./restore_original.sh       # Restore original English files
```

### Windows (PowerShell)
```powershell
cd scripts\windows
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\install_translation.ps1   # Install Polish translation
.\restore_original.ps1      # Restore original English files
```

### Windows (Command Prompt)
```cmd
cd scripts\windows
install_translation.bat     # Install Polish translation
restore_original.bat        # Restore original English files
```

## Translation File Format

### Main language file (lang/en.txt)
- Format: `[ID] [text]#`
- Lines starting with `#` are comments
- Each entry must end with `#`
- Example: `1900 Barbarzyńca#`

### JSON files
- All JSON files use UTF-8 encoding
- Preserve original structure and key names
- Only translate string values, never keys
- Special characters must be properly escaped

## Testing Translation

After making changes:
1. Run the appropriate installation script
2. Launch Barony via Steam
3. Verify text displays correctly with Polish diacritics
4. Check all menus, tooltips, and in-game books

## Key Translation Files

- **lang/en.txt** - Main UI and dialog translations (4000+ lines)
- **lang/item_names.json** - All item names
- **data/achievements.json** - Achievement names and descriptions
- **data/tutorial_strings.json** - Tutorial text
- **books/*.txt** - In-game books (34 files)

## Important Notes

- The installer creates automatic backups in `BACKUP_ORIGINAL/` folder
- Translation covers 100% of game text
- Fonts have been modified to support Polish diacritics
- Scripts auto-detect Steam installation paths on both platforms
- All scripts include error handling and user confirmations
- Always use conventional commits
- Always use english to generate commits