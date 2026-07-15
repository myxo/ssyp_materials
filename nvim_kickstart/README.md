# Установка

1. 
```
sudo apt install git
sudo apt install clangd
```

3. Из https://github.com/neovim/neovim/releases берем AppImage 12 версии
```
wget https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.appimage
```

Потом устанавливаем в систему
```
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
sudo ln -s $(pwd)/nvim-linux-x86_64.appimage /usr/local/bin/nvim
```


4. Скопируйте `init.lua` в `~/.config/nvim/init.lua`.
5. Запустите `nvim` — плагины (lazy.nvim и всё остальное) установятся автоматически при первом запуске.
