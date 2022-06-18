@echo off
python --version 3>NUL
if errorlevel 1 goto errorNoPython

python ./scripts/rotate_map.py
goto:eof

:errorNoPython
echo.
echo Error^: Python 3 is not installed