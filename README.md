# Music Library Manager

In-memory музыкальная библиотека с текстовым CLI: треки, плейлисты,
поиск по инвертированному индексу, статистика и экспорт в JSON/M3U.
Собственный pet-проект для практики C++20 и современного CMake.

## Возможности

- **Треки** — `ADD` / `GET` / `UPDATE` / `DELETE` / `COUNT`
- **Плейлисты** — ссылочная семантика через `std::weak_ptr`
  (`PLCREATE` / `PLADD` / `PLINSERT` / `PLREMOVE` / `PLMOVE` / `PLGET` / ...)
- **Поиск** — инвертированный индекс, фильтры по полям, топ треков
  (`FIND` / `FILTER` / `SEARCH` / `TOPTRACKS`)
- **Статистика** — по жанрам, исполнителям, десятилетиям
  (`STATS` / `GENRE_STATS` / `ARTIST_STATS` / `DECADE_STATS`)
- **Экспорт/импорт** — JSON и M3U (`EXPORT` / `IMPORT` / `PLAYLIST_EXPORT`)

## Сборка

Требуется CMake >= 3.20 и компилятор с поддержкой C++20 (clang).
Все зависимости скачиваются автоматически через FetchContent.

```powershell
cmake -S . -B build -G Ninja
cmake --build build
```

Опции:

| Опция             | По умолчанию | Описание                         |
|-------------------|--------------|----------------------------------|
| `BUILD_TESTS`     | `ON`         | собирать unit-тесты              |
| `BUILD_BIN`       | `ON`         | собирать CLI-исполняемый файл    |
| `MLM_WITH_TAGLIB` | `OFF`        | включить TagLib (теги MP3/FLAC)  |

## Структура проекта

```
src/
├── core/       треки, библиотека, плейлисты
├── search/     инвертированный индекс, поисковый движок
├── storage/    экспорт в JSON/M3U
├── stats/      сбор статистики
└── cli/        парсер команд, токенизатор
bin/            точка входа (main.cpp)
tests/          модульные и интеграционные тесты (GoogleTest)
cmake/          модули сборки (dependencies.cmake, CompilerWarnings.cmake)
```

Заголовки и реализации лежат рядом в `src/<module>/` (как в folly).
Каждый модуль — отдельная статическая библиотека, агрегат —
`music_manager_lib`.

## Зависимости

Все зависимости фетчатся из git через `FetchContent`
(см. `cmake/dependencies.cmake`):

| Библиотека          | Репозиторий                    | Использование          |
|---------------------|--------------------------------|------------------------|
| Boost.Tokenizer     | github.com/boostorg/tokenizer  | токенизация команд     |
| Boost.PropertyTree  | github.com/boostorg/property_tree | JSON экспорт/импорт |
| Boost.Filesystem    | github.com/boostorg/filesystem | работа с путями/файлами|
| Boost.System        | github.com/boostorg/system     | коды ошибок            |
| GoogleTest          | github.com/google/googletest   | тесты                  |
| TagLib (опц.)       | github.com/taglib/taglib       | метаданные MP3/FLAC    |
