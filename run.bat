@echo off
setlocal

REM --- Конфигурация ---
set REPO_URL=https://github.com/Hashmaster82/datacam.git
set REPO_DIR=datacam
set VENV_DIR=venv
set MAIN_SCRIPT=main.py
set REQ_FILE=requirements.txt

REM --- Заголовок ---
cls
echo ==================================================
echo   Запуск приложения Datacam
echo   Проверка обновлений и зависимостей...
echo ==================================================
echo.

REM --- Шаг 1: Проверка наличия Git ---
echo [1/5] Проверка наличия Git...
git --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ КРИТИЧЕСКАЯ ОШИБКА: Git не установлен.
    echo Пожалуйста, установите Git с официального сайта: https://git-scm.com/downloads
    echo После установки перезапустите этот скрипт.
    echo.
    goto :END
)
echo ✅ Git найден.

REM --- Шаг 2: Проверка и клонирование/обновление репозитория ---
echo [2/5] Проверка репозитория...
if not exist "%REPO_DIR%" (
    echo     Клонирование репозитория...
    git clone %REPO_URL%
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ❌ КРИТИЧЕСКАЯ ОШИБКА: Не удалось клонировать репозиторий.
        echo Проверьте URL репозитория и подключение к интернету.
        echo.
        goto :END
    )
    echo ✅ Репозиторий успешно клонирован.
) else (
    echo     Обновление репозитория...
    cd "%REPO_DIR%"
    git pull origin main 2>nul
    if %ERRORLEVEL% NEQ 0 (
        git pull origin master 2>nul
        if %ERRORLEVEL% NEQ 0 (
            echo     ⚠️  Не удалось обновить репозиторий. Продолжаем с текущей версией.
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
echo [3/5] Проверка виртуального окружения...
if not exist "%VENV_DIR%" (
    echo     Создание виртуального окружения...
    python -m venv %VENV_DIR%
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ❌ КРИТИЧЕСКАЯ ОШИБКА: Не удалось создать виртуальное окружение.
        echo Убедитесь, что Python установлен корректно.
        echo.
        goto :END
    )
    echo ✅ Виртуальное окружение создано.
)

echo     Активация виртуального окружения...
call %VENV_DIR%\Scripts\activate.bat >nul

REM --- Шаг 5: Установка или обновление зависимостей ---
echo [4/5] Проверка зависимостей...
if exist "%REQ_FILE%" (
    pip install --upgrade pip >nul 2>&1
    pip install -r %REQ_FILE% >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ⚠️  Предупреждение: Не удалось установить некоторые зависимости.
        echo Попробуйте запустить 'install_dependencies.bat' от имени администратора.
        echo Продолжаем запуск...
        echo.
    ) else (
        echo ✅ Все зависимости установлены.
    )
) else (
    echo.
    echo ⚠️  Предупреждение: Файл '%REQ_FILE%' не найден.
    echo Зависимости могут быть не установлены.
    echo.
)

REM --- Шаг 6: Запуск приложения ---
echo [5/5] Запуск приложения...
echo.
echo ==================================================
echo   Datacam запущен. Закройте это окно для выхода.
echo ==================================================
echo.

python "%MAIN_SCRIPT%"

REM --- Обработка ошибки запуска ---
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ КРИТИЧЕСКАЯ ОШИБКА: Не удалось запустить '%MAIN_SCRIPT%'.
    echo Убедитесь, что файл существует и в нем нет синтаксических ошибок.
    echo.
    pause
    goto :END
)

REM --- Успешное завершение ---
echo.
echo ==================================================
echo   Datacam завершил работу.
echo ==================================================
pause

:END
end