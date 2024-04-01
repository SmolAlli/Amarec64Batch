@echo off
setlocal enabledelayedexpansion

REM	Check if the live411beta folder exists
if not exist live411beta\ (
    REM	Give some sort of error here and give exit option (press any key to close)
    echo Error: Unable to find live411beta folder. Please make sure it is in the same directory as this file.
    echo Closing on button press...
    pause
    exit /b
)

REM	Copy all files from live411beta file into base folder
xcopy /s/y "%~dp0\live411beta\" "%~dp0\"
echo Copied files from live411beta folder into current folder.

REM	Run the live411_install.bat file
call "live411_install.bat"
echo Installed 4.11 beta Amarec Live.

REM	Edit the lines in register.bat from 'regsvr32 "%~dp0\AmAudioCapture.ax"' and 'regsvr32 "%~dp0\AmVideoCapture.ax"' to 'regsvr32 "%~dp0\AmAudioCapture64.ax"' and 'regsvr32 "%~dp0\AmVideoCapture64.ax"'

set "textFile=register.bat"

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:AmAudioCapture.ax=AmAudioCapture64.ax!
    endlocal
)

for /f "delims=" %%i in ('type "%textFile%" ^& break ^> "%textFile%" ') do (
    set "line=%%i"
    setlocal enabledelayedexpansion
    >>"%textFile%" echo(!line:AmVideoCapture.ax=AmVideoCapture64.ax!
    endlocal
)

echo Edited register.bat

REM	Run the register.bat file
call "register.bat"
echo Installed 64-bit compatibility files.

REM	Delete live411beta folder
rmdir /s /q "%~dp0\live411beta"

echo Removed the live411beta folder.
echo 64-bit amarec compatibility successfully installed. 

pause
