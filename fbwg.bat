@echo off

:START
echo.
echo Script to get older versions of Fireboy ^& Watergirl
echo.
echo The script assumes that you have the steam version of Fireboy ^& Watergirl Elements in either of the following locations:
echo.
echo 1. %homedrive%\Program Files (x86)\Steam\steamapps\common\Fireboy ^& Watergirl Elements
echo 2. %homedrive%\Program Files\Steam\steamapps\common\Fireboy ^& Watergirl Elements
echo.
echo -------------------------------------

:CHECK
echo.
echo Finding installation of Fireboy ^& Watergirl Elements
echo.

if exist "%homedrive%\Program Files (x86)\Steam\steamapps\common\Fireboy & Watergirl Elements" (
	set "FBWG_PATH=%homedrive%\Program Files (x86)\Steam\steamapps\common"
) else if exist "%homedrive%\Program Files\Steam\steamapps\common\Fireboy & Watergirl Elements" (
	set "FBWG_PATH=%homedrive%\Program Files\Steam\steamapps\common"
) else (
	echo No installation detected!
	goto EXIT
)
echo Installation found at:
echo.
echo %FBWG_PATH%\Fireboy ^& Watergirl Elements
echo.
echo -------------------------------------

:GIT
echo.
echo Checking for git installation
echo.
where git >nul 2>&1
if %ERRORLEVEL% == 0 (
	echo git is already installed!
	goto :GET_PATCH
) else (
	echo git installation not detected!
	goto :INSTALL_GIT
)

:INSTALL_GIT
echo.
echo -------------------------------------
echo.
echo Downloading git
echo.
curl -L# https://github.com/AdityaGarg8/fireboy-and-watergirl-patches/releases/download/win/Git.zip > %temp%\Git.zip
tar -xf %temp%\git.zip -C %temp%

:GET_PATCH
echo.
echo -------------------------------------
echo.
echo What version do you want to install?
echo.
echo 1. Fireboy ^& Watergirl: Forest Temple
echo 2. Fireboy ^& Watergirl: Light Temple
echo 3. Fireboy ^& Watergirl: Ice Temple
echo 4. Fireboy ^& Watergirl: Crystal Temple
set /p ANSWER=""
echo.

if %ANSWER% == 1 (
	set VER=forest
	set "NAME=Fireboy ^& Watergirl: Forest Temple"
	set "FOLDER=Fireboy & Watergirl Forest Temple"
) else if %ANSWER% == 2 (
	set VER=light
	set "NAME=Fireboy ^& Watergirl: Light Temple"
	set "FOLDER=Fireboy & Watergirl Light Temple"
) else if %ANSWER% == 3 (
	set VER=ice
	set "NAME=Fireboy ^& Watergirl: Ice Temple"
	set "FOLDER=Fireboy & Watergirl Ice Temple"
) else if %ANSWER% == 4 (
	set VER=crystal
	set "NAME=Fireboy ^& Watergirl: Crystal Temple"
	set "FOLDER=Fireboy & Watergirl Crystal Temple"
) else (
	echo Invalid Option!
	goto :EXIT
)

if exist "%FBWG_PATH%\%FOLDER%" (
	echo The version selected in already installed!
	goto :CONFIRM
)

echo.
echo Downloading patch for %NAME%
echo.
curl -L# https://github.com/AdityaGarg8/fireboy-and-watergirl-patches/releases/download/win/%VER%.patch > %temp%\%VER%.patch
echo.

:APPLY_PATCH
echo Applying patch!
robocopy "%FBWG_PATH%\Fireboy & Watergirl Elements" "%FBWG_PATH%\%FOLDER%" /E /NFL /NDL /NJH /NJS /nc /ns /np
set "PREV_DIR=%cd%"
cd "%FBWG_PATH%\%FOLDER%"
if exist %temp%\Git\bin\git.exe (
	%temp%\Git\bin\git.exe apply --whitespace=nowarn %temp%\%VER%.patch
) else (
	git.exe apply --whitespace=nowarn %temp%\%VER%.patch
)
echo Installation successfull at "%FBWG_PATH%\%FOLDER%"
del /F %temp%\%VER%.patch
cd "%PREV_DIR%"

:CONFIRM
echo.
echo -------------------------------------
echo.
echo Do you want to install another version (y/N)?
set /p RESTARTQ=""

if %RESTARTQ% == y goto :GET_PATCH
if %RESTARTQ% == Y goto :GET_PATCH
goto :EXIT

:EXIT
if exist %temp%\Git.zip (
	del /F %temp%\Git.zip
)
if exist %temp%\Git (
	rmdir /S /Q %temp%\Git
)
echo.
echo Press any key to exit...
pause >nul