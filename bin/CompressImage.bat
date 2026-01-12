@echo off
setlocal

set "scriptDir=%~dp0"

set "file=%~1"
if "%file%"=="" (
    echo No file specified.
    exit /b 1
)

for %%i in ("%file%") do set "ext=%%~xi"

if /i "%ext%"==".jpg" (
    "%scriptDir%magick.exe" "%file%" -strip -quality 75 "%~dpn1.compressed.jpg"
    echo Compressed JPG to %~dpn1.compressed.jpg
) else if /i "%ext%"==".jpeg" (
    "%scriptDir%magick.exe" "%file%" -strip -quality 75 "%~dpn1.compressed.jpg"
    echo Compressed JPG to %~dpn1.compressed.jpg
) else if /i "%ext%"==".png" (
    "%scriptDir%pngquant.exe" --quality 65-80 --ext .compressed.png "%file%"
    echo Compressed PNG to %~dpn1.compressed.png
) else (
    echo Unsupported file type: %ext%
    exit /b 1
)

endlocal
