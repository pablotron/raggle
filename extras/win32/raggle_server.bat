@echo off
cd %PROGRAMFILES%\Raggle
ruby raggle --server
explorer.exe "http://localhost:2222/"
