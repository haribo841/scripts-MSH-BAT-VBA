@echo off
setlocal enabledelayedexpansion

set "folder_path=path\to\your\folder"
set "output_file=output.txt"

dir /b /s "%folder_path%" > "%output_file%"
echo Files listed and written to %output_file%

exit /b
