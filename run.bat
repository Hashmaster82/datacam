@echo off
echo Проверка обновлений репозитория...
git fetch origin

git status -uno | findstr "behind" >nul
if %errorlevel% equ 0 (
    echo Обнаружены обновления в удаленном репозитории!
    echo Выполняется автоматическое обновление кода...
    git pull origin
    echo.
    echo Код успешно обновлен!
    echo.
)

echo Проверка и установка зависимостей...
pip install -r requirements.txt

echo.
echo Запуск программы IP Camera Manager...
python main.py

pause