# Установка

1. Установите `git` (нужен для lazy.nvim, чтобы скачивать плагины):
   - macOS:   `brew install git` (или `xcode-select --install`)
   - Ubuntu:  `sudo apt install git`
   - Arch:    `sudo pacman -S git`
2. Установите `clangd` (нужен для LSP C/C++):
   - macOS:   `brew install llvm` (или `xcode-select --install`)
   - Ubuntu:  `sudo apt install clangd`
   - Arch:    `sudo pacman -S clang`
3. Скопируйте `init.lua` в `~/.config/nvim/init.lua`.
4. Запустите `nvim` — плагины (lazy.nvim и всё остальное) установятся автоматически при первом запуске.
