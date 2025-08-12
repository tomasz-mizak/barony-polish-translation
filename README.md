# Barony - Polskie Tłumaczenie

Ulepszone polskie tłumaczenie gry Barony - trójwymiarowej roguelike z widokiem pierwszoosobowym.

## O projekcie

To tłumaczenie bazuje na modzie ze Steam Workshop ([Polish Translation](https://steamcommunity.com/sharedfiles/filedetails/?id=3078243671)), jednak zostało znacząco ulepszone:
- **Poprawione akcenty i błędy językowe** - usunięto śmieszne akcenty i nienaturalne tłumaczenia
- **Zachowany oryginalny charakter gry** - tłumaczenie respektuje klimat i lore Barony
- **Łatwa instalacja** - nie musisz korzystać z Workshop ani ładować modów przy każdym uruchomieniu
- **Natywne wsparcie** - gra automatycznie działa po polsku bez dodatkowych kroków

To repozytorium zawiera kompletne tłumaczenie gry Barony na język polski, obejmujące:
- Interfejs użytkownika i dialogi (ponad 4000 linii tekstu)
- Wszystkie 34 książki dostępne w grze
- Nazwy przedmiotów i opisy
- Osiągnięcia i samouczek
- Zakończenia fabularne i karty postaci
- Zmodyfikowane czcionki wspierające polskie znaki diakrytyczne (ą, ć, ę, ł, ń, ó, ś, ź, ż)

## Wymagania

- Gra Barony zainstalowana przez Steam, GOG lub Epic Games Store
- System operacyjny: Windows lub Linux
- Około 10 MB wolnego miejsca na dysku

## Zalety względem modu Workshop

1. **Brak konieczności ładowania modu** - nie musisz wybierać modu przy każdym uruchomieniu gry
2. **Stabilność** - tłumaczenie jest zintegrowane z plikami gry, nie wymaga synchronizacji z Workshop
3. **Offline** - działa bez połączenia z internetem i Steam Workshop
4. **Pełna kontrola** - możesz łatwo przywrócić oryginalne pliki lub modyfikować tłumaczenie
5. **Uniwersalność** - działa również z wersjami GOG i Epic Games

## Instalacja

### Metoda automatyczna (zalecana)

#### Linux
```bash
chmod +x install_translation.sh
./install_translation.sh
```

#### Windows
```cmd
install_translation.bat
```

Skrypty automatycznie:
- Wykryją lokalizację instalacji gry
- Utworzą kopie zapasowe oryginalnych plików
- Zainstalują polskie tłumaczenie
- Wyświetlą potwierdzenie zakończenia instalacji

### Metoda ręczna

1. **Zlokalizuj folder instalacyjny gry:**
   - **Steam (Linux)**: `~/.steam/steam/steamapps/common/Barony/`
   - **Steam (Windows)**: `C:\Program Files (x86)\Steam\steamapps\common\Barony\`
   - **GOG**: Zazwyczaj w folderze wybranym podczas instalacji
   - **Epic Games**: `C:\Program Files\Epic Games\Barony\`

2. **Utwórz kopię zapasową oryginalnych plików:**
   ```bash
   # Linux
   cp -r ~/ścieżka/do/Barony/lang ~/ścieżka/do/Barony/lang_backup
   cp -r ~/ścieżka/do/Barony/books ~/ścieżka/do/Barony/books_backup
   cp -r ~/ścieżka/do/Barony/data ~/ścieżka/do/Barony/data_backup
   cp -r ~/ścieżka/do/Barony/fonts ~/ścieżka/do/Barony/fonts_backup
   cp -r ~/ścieżka/do/Barony/items ~/ścieżka/do/Barony/items_backup
   ```

3. **Skopiuj pliki tłumaczenia:**
   - Skopiuj zawartość folderu `lang/` do `Barony/lang/`
   - Skopiuj zawartość folderu `books/` do `Barony/books/`
   - Skopiuj zawartość folderu `data/` do `Barony/data/`
   - Skopiuj zawartość folderu `fonts/` do `Barony/fonts/`
   - Skopiuj zawartość folderu `items/` do `Barony/items/`

4. **Uruchom grę** - tłumaczenie powinno być aktywne automatycznie

## Przywracanie oryginalnych plików

### Metoda automatyczna

#### Linux
```bash
./restore_original.sh
```

#### Windows
```cmd
restore_original.bat
```

### Metoda ręczna

Przywróć pliki z utworzonych wcześniej kopii zapasowych lub zweryfikuj pliki gry przez Steam/GOG/Epic.

## Struktura projektu

```
barony-polish-translation/
├── lang/                       # Główne pliki językowe
├── books/                      # Tłumaczenia książek w grze (34 pliki)
├── data/                       # Tłumaczenia UI (osiągnięcia, samouczek, zakończenia)
├── items/                      # Nazwy przedmiotów i opisy
├── fonts/                      # Czcionki z polskimi znakami
├── install_translation.sh      # Skrypt instalacyjny dla Linux
├── install_translation.bat     # Skrypt instalacyjny dla Windows
├── restore_original.sh         # Skrypt przywracania dla Linux
└── restore_original.bat        # Skrypt przywracania dla Windows
```

## Rozwiązywanie problemów

### Polskie znaki nie wyświetlają się poprawnie
- Upewnij się, że skopiowałeś folder `fonts/` do katalogu gry
- Zrestartuj grę po instalacji

### Skrypt nie może znaleźć gry
- Sprawdź czy gra jest zainstalowana w standardowej lokalizacji
- Dla niestandardowych instalacji, edytuj ścieżkę w skrypcie lub użyj metody ręcznej

### Brak uprawnień w Windows
- Uruchom wiersz poleceń (cmd) jako Administrator

## Licencja

To tłumaczenie jest udostępnione do swobodnego użytku.

## Wsparcie

W przypadku problemów z instalacją lub błędów w tłumaczeniu, prosimy o zgłoszenie w zakładce Issues.

## Podziękowania

Dziękujemy twórcom gry Barony za stworzenie tej niesamowitej gry roguelike oraz społeczności graczy za wsparcie i feedback.