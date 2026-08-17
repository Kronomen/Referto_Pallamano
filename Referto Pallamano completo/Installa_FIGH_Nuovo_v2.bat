@echo off
setlocal EnableExtensions

title Installazione Referto Pallamano FIGH

echo.
echo ============================================================
echo        INSTALLAZIONE REFERTO PALLAMANO FIGH
echo ============================================================
echo.

REM ============================================================
REM CARTELLA DI INSTALLAZIONE
REM ============================================================

set "INSTALL_DIR=%USERPROFILE%\Referto Pallamano FIGH"

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

echo Installazione in:
echo "%INSTALL_DIR%"
echo.

REM ============================================================
REM ENTRA NELLA CARTELLA DELL'INSTALLER
REM ============================================================

pushd "%~dp0"

if errorlevel 1 (
    echo.
    echo ERRORE: impossibile accedere alla cartella dell'installer.
    pause
    exit /b 1
)

REM ============================================================
REM COPIA DEI FILE
REM
REM Usiamo "." come origine per evitare problemi con i percorsi
REM contenenti spazi.
REM ============================================================

echo Copia dei file del progetto...
echo.

robocopy "." "%INSTALL_DIR%" /E /R:1 /W:1 /XF "Installa_FIGH.bat" "Installa_FIGH_Nuovo.bat" "Installa_FIGH_Nuovo_v2.bat"

set "RC=%ERRORLEVEL%"

popd

REM Robocopy considera 0-7 come esito positivo.
if %RC% GEQ 8 (
    echo.
    echo ============================================================
    echo ERRORE durante la copia dei file.
    echo Codice Robocopy: %RC%
    echo ============================================================
    echo.
    pause
    exit /b 1
)

echo.
echo Copia completata correttamente.
echo.

REM ============================================================
REM VERIFICA DEL REFERTO
REM ============================================================

set "TARGET=%INSTALL_DIR%\Referto Pallamano.html"

if not exist "%TARGET%" (
    echo.
    echo ============================================================
    echo ERRORE: non trovo:
    echo "%TARGET%"
    echo ============================================================
    echo.
    pause
    exit /b 1
)

REM ============================================================
REM CREAZIONE COLLEGAMENTO DESKTOP
REM ============================================================

set "DESKTOP=%USERPROFILE%\Desktop"
set "SHORTCUT=%DESKTOP%\Referto Pallamano FIGH.lnk"

echo Creazione del collegamento sul Desktop...

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
 "$W=New-Object -ComObject WScript.Shell; $S=$W.CreateShortcut('%SHORTCUT%'); $S.TargetPath='%TARGET%'; $S.WorkingDirectory='%INSTALL_DIR%'; $S.Description='Referto Pallamano FIGH'; $S.Save()"

if not exist "%SHORTCUT%" (
    echo.
    echo ATTENZIONE: il collegamento Desktop non e' stato creato.
) else (
    echo Collegamento creato correttamente.
)

echo.

REM ============================================================
REM INSTALLAZIONE TERMINATA
REM ============================================================

echo ============================================================
echo        INSTALLAZIONE COMPLETATA
echo ============================================================
echo.
echo Il Referto Pallamano e' installato in:
echo "%INSTALL_DIR%"
echo.

choice /C SN /N /M "Vuoi avviare subito il Referto Pallamano? [S/N]: "

if errorlevel 2 goto FINE

start "" "%TARGET%"

:FINE

echo.
echo Premere un tasto per chiudere...
pause >nul

endlocal
