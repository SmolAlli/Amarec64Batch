@echo off

:: BatchGotAdmin from https://superuser.com/a/852877
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

REM	Check if the live411beta folder exists
if not exist live411beta\ (
    REM	Give some sort of error here and give exit option (press any key to close)
    echo Error: Unable to find live411beta folder. Please make sure it is in the same directory as this file.
    echo Closing on button press...
    pause
    exit /b
)

REM	Copy all files from live411beta file into base folder
copy /y "%~dp0\live411beta\" "%~dp0\" > nul
echo Copied files from live411beta folder into current folder.

REM Edit the file to make commands silent
set "textFile=live411_install.bat"
for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:regsvr32 =regsvr32 /s !
    endlocal
)

REM	Run the live411_install.bat file
call "live411_install.bat"
echo Installed 4.11 beta AmaRec Live.

REM	Delete live411beta folder
rmdir /s /q "%~dp0\live411beta"

echo Removed the live411beta folder.
echo 64-bit AmaRec compatibility successfully installed. 

pause
