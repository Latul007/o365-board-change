@echo off
:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::--------------------------------------

::ENTER YOUR CODE BELOW:
setlocal

:: Chemin du dossier existant
set "old_folder=C:\Users\%username%\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"

:: Nouveau chemin ou nouveau nom du dossier
set "new_folder=C:\Users\%username%\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_old"

:: Planifier le renommage au prochain redémarrage
echo Planification du renommage avec MoveFileEx...
move "%old_folder%" "%new_folder%"

if %errorlevel% equ 0 (
    echo Le renommage a été planifié. L'ordinateur redémarrera dans 5 secondes...
    timeout /t 5 /nobreak >nul
    shutdown /r /t 0
) else (
    echo Échec de la planification. Assurez-vous d'avoir les permissions nécessaires.
    pause
)

exit
