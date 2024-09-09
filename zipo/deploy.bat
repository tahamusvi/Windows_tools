@echo off
setlocal enabledelayedexpansion

set "pythonFile=config\settings.py"
set "newValue=True"

rem Read and change
(
    for /f "delims=" %%i in ('findstr /n "^" "%pythonFile%"') do (
        set "line=%%i"
        set "line=!line:*:=!"  rem Remove line number added by findstr

        rem Check if the line is not empty
        if "!line!"=="" (
            echo.
        ) else (
            if "!line!"=="deploy = False" (
                echo deploy = %newValue%
            ) else (
                echo !line!
            )
        )
    )
) > temp.py

rem replace file
move /y temp.py "%pythonFile%"

echo Variable updated successfully.
endlocal
