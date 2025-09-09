@echo off
echo Проверка обновлений репозитория...
git fetch origin

git status -uno | findstr "behind" >nul
if %errorlevel% equ 0 (
    echo Обнаружены обновления в удаленном репозитории!
    echo.
    set /p choice="Хотите обновить код? (y/n): "
    if /i "%choice%"=="y" (
        echo Выполняется обновление кода...
        git pull origin
        echo.
        echo Код обновлен!
        echo.
    )
)

echo Проверка установленных библиотек...
pip list | findstr "opencv-python" >nul
if %errorlevel% neq 0 (
    echo Библиотеки не установлены!
    echo Запустите install_requirements.bat для установки
    pause
    exit /b 1
)

echo.
echo Запуск программы IP Camera Manager...
python datacam.py

pause