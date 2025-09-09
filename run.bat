@echo off
setlocal

REM --- Настройки ---
set REPO_URL=https://github.com/Hashmaster82/datacam.git
set REPO_DIR=datacam
set VENV_DIR=venv
set MAIN_SCRIPT=main.py
set REQ_FILE=requirements.txt

REM --- Шаг 1: Проверка наличия Git ---
echo Проверка наличия Git...
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Git не найден.
    echo Пожалуйста, установите Git: https://git-scm.com/downloads
    echo После установки перезапустите этот скрипт.
    echo.
    pause
    exit /b 1
)
echo ✅ Git найден.

REM --- Шаг 2: Проверка и клонирование/обновление репозитория ---
if not exist "%REPO_DIR%" (
    echo.
    echo Клонирование репозитория: %REPO_URL%
    git clone %REPO_URL%
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ❌ Не удалось клонировать репозиторий.
        pause
        exit /b 1
    )
    echo ✅ Репозиторий успешно клонирован.
) else (
    echo.
    echo Обновление репозитория из %REPO_URL%...
    cd "%REPO_DIR%"
    git pull origin main
    if %ERRORLEVEL% NEQ 0 (
        git pull origin master
        if %ERRORLEVEL% NEQ 0 (
            echo.
            echo ⚠️  Не удалось обновить репозиторий. Продолжаем с текущей версией.
        ) else (
            echo ✅ Репозиторий успешно обновлен (ветка master).
        )
    ) else (
        echo ✅ Репозиторий успешно обновлен (ветка main).
    )
    cd ..
)

REM --- Шаг 3: Переход в директорию проекта ---
cd "%REPO_DIR%"

REM --- Шаг 4: Создание и активация виртуального окружения ---
if not exist "%VENV_DIR%" (
    echo.
    echo Создание виртуального окружения...
    python -m venv %VENV_DIR%
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ❌ Не удалось создать виртуальное окружение.
        pause
        exit /b 1
    )
    echo ✅ Виртуальное окружение создано.
)

echo Активация виртуального окружения...
call %VENV_DIR%\Scripts\activate.bat

REM --- Шаг 5: Установка или обновление зависимостей ---
if exist "%REQ_FILE%" (
    echo.
    echo Установка зависимостей из %REQ_FILE%...
    pip install --upgrade pip >nul
    pip install -r %REQ_FILE%
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ❌ Произошла ошибка при установке зависимостей.
        pause
        exit /b 1
    )
    echo ✅ Зависимости установлены.
) else (
    echo.
    echo ⚠️  Файл %REQ_FILE% не найден. Продолжаем запуск, но могут возникнуть ошибки.
)

REM --- Шаг 6: Запуск приложения ---
echo.
echo Запуск приложения Datacam...
python "%MAIN_SCRIPT%"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Произошла ошибка при запуске приложения.
    pause
    exit /b 1
)

REM --- Завершение ---
echo.
echo Приложение завершило работу.
pause

endlocal