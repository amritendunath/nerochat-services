@echo off
chcp 65001
cd /d "%~dp0src"
set PORT=8081
python main.py
