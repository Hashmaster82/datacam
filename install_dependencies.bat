@echo off
REM Проверяем, установлен ли Python
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Ошибка: Python не найден. Пожалуйста, установите Python 3.8 или выше.
    echo Скачать можно здесь: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Проверяем наличие файла requirements.txt
IF NOT EXIST requirements.txt (
    echo Ошибка: Файл requirements.txt не найден в текущей директории.
    pause
    exit /b 1
)

echo Установка зависимостей из requirements.txt...
echo.

REM Устанавливаем зависимости
pip install -r requirements.txt

REM Проверяем успешность установки
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Все зависимости успешно установлены!
    echo Теперь вы можете запустить программу командой: python main.py
) ELSE (
    echo.
    echo ❌ Произошла ошибка при установке зависимостей.
    echo Пожалуйста, проверьте подключение к интернету и права доступа.
)

pause