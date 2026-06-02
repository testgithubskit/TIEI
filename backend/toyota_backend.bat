@echo off
call "D:\Projects\Toyota\tiei_main\venv\Scripts\activate.bat"
"D:\Projects\Toyota\tiei_main\venv\Scripts\uvicorn.exe" main:APP --reload --host localhost --port 6699
pause
