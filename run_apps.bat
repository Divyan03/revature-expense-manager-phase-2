@echo off
setlocal

REM Get the absolute path of the folder this script lives in (ends with a backslash)
set "projectpath=%~dp0"

REM Shared SQLite database used by both apps (inherited by the windows started below)
set "DATABASE_PATH=%projectpath%employee\expense_manager.db"

if not exist "%projectpath%employee\.venv\Scripts\python.exe" (
    echo [ERROR] Python venv not found at "%projectpath%employee\.venv".
    echo Create it with:  cd employee ^&^& python -m venv .venv ^&^& .venv\Scripts\pip install -r requirements.txt
    pause
    exit /b 1
)

REM ---- Start the Employee and Manager Apps in PowerShell windows ----
start "Employee App" /d "%projectpath%employee" powershell -NoExit -NoProfile -Command "& '.\.venv\Scripts\python.exe' main.py"
start "Manager App" /d "%projectpath%manager" powershell -NoExit -NoProfile -Command "mvn exec:java '-Dexec.mainClass=com.revature.Main'"

REM ---- Small pause to allow the servers to start before opening the browser ----
timeout /t 5 /nobreak >nul
start "" "http://localhost:5000"
start "" "http://localhost:5001"

endlocal
