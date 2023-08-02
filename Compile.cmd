@echo off

TITLE SS13 Build Script

IF DEFINED ProgramFiles(x86) (
	SET "_dmexec=C:\Program Files (x86)\BYOND\bin\dm.exe"
) ELSE (
	SET "_dmexec=C:\Program Files\BYOND\bin\dm.exe"
)

ECHO Attempting to look for %_dmexec%
if exist "%_dmexec%" (
	ECHO DM executable found!
) else (
	ECHO DM executable not found. Exiting.....
	GOTO end
)

"%_dmexec%" vorestation.dme

:end
pause

REM This was shamelessly stolen/copied from the World Server Redux. All credit for the orignal script goes to them.