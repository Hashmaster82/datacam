@echo off
echo Checking for repository updates...
git fetch origin

git status -uno | findstr "behind" >nul
if %errorlevel% equ 0 (
    echo Updates found in remote repository!
    echo Performing automatic code update...
    git pull origin
    echo.
    echo Code successfully updated!
    echo.
)

echo Checking and installing dependencies...
pip install -r requirements.txt

echo.
echo Starting IP Camera Manager...
python main.py

pause