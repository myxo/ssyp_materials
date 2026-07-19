# Установка

1. 
```
sudo apt install git clangd tree-sitter-cli
```

3. Из https://github.com/neovim/neovim/releases берем AppImage 12 версии (запустите команду ниже)
```
wget https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.appimage
```

4.
Делаем файл запускаемым
```
chmod u+x nvim-linux-x86_64.appimage
```
и устанавливаем в систему
```
sudo ln -s $(pwd)/nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

5. Скопируйте содержимое файла `init.lua` в `~/.config/nvim/init.lua`.
6. Запустите `nvim`
