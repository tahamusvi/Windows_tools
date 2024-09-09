@echo off
setlocal enabledelayedexpansion

CALL D:\bats\deploy.bat

set "zipFile=output.zip"
set "ignoreFile=.gitignore"
set "filesToZip="

rem Reading the gitignore file
if exist "%ignoreFile%" (
    for /f "usebackq delims=" %%i in ("%ignoreFile%") do (
        if exist "%%i" (
            set "ignoreList[%%i]=1"
        )
    )
)

rem Function to check and add files and folders
call :addFilesAndFolders "."

rem Compressing with WinRAR
set "rarPath=D:\Program Files\WinRAR\Rar.exe"
"%rarPath%" a "%zipFile%" !filesToZip!

echo Compression completed.
endlocal
exit /b

:addFilesAndFolders
set "currentDir=%~1"
pushd "%currentDir%"

rem Checking files
for /f "delims=" %%f in ('dir /b /a-d') do (
    if not defined ignoreList[%%f] (
        set "filesToZip=!filesToZip! %%f"
    )
)

rem Checking directories and calling the function for subfolders
for /f "delims=" %%d in ('dir /b /ad') do (
    if not defined ignoreList[%%d] (
        set "filesToZip=!filesToZip! %%d"
        call :addFilesAndFolders "%%d"
    )
)

popd
exit /b
