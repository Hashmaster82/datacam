@echo off
echo Проверка наличия файла requirements.txt...
if not exist requirements.txt (
    echo Файл requirements.txt не найден!
    echo Запустите requirements.bat для его создания
    pause
    exit /b 1
)

echo Установка необходимых библиотек из requirements.txt...
pip install -r requirements.txt

if %errorlevel% equ 0 (
    echo.
    echo Все библиотеки установлены успешно!
) else (
    echo.
    echo Произошла ошибка при установке библиотек!
)

pause