
# Имитация работы комманды "ps ax"
### Задание:
  1. Написать свою реализацию ps ax используя анализ /proc
  2. Результат ДЗ - рабочий скрипт который можно запустить
  3. Дописать обработчики сигналов в прилагаемом скрипте, оттестировать, приложить сам скрипт, инструкции по использованию \
Скрипт имитирует работу утилты ps. Принимает несколько параметров в качестве аргументов имитируя вывод ps.
     > Параметр "a" - имитирует вывод для пользователя \
     > Параметр "ax" - имитирует вывод для всех процессов \
     > Параметр "x" - не форматированный вывод
     ## Пример:
     bash ps.sh a \
     bash ps.sh ax
## Перехват сигналов
Так же в скрипте реализован перехват сигнала SIGINT "CTRL-C"
### Как это работает:
    При работе скрипта жмем CTRL-C произойдет останов выполнения скрипта, а так же запрос на продолжение. Но сама работа скрипта не прервется.
И сигнала EXIT который выводит сообщение при закрытии скрипта.
## Полезно
Ресурс на хабре \
https://habr.com/en/company/ruvds/blog/325522/
