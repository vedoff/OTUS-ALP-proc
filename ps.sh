#!/bin/bash

# Получение Uid пользователя
get_uid(){
  cat /proc/$pc/status | grep Uid | awk '{print $2}'
 }

# Получение username из Uid
get_username(){
  cat /etc/passwd | grep "x:$(get_uid)" | awk -F":" '{print $1}'
}

# Получение логина пользователя
get_env_user(){
  env | awk -F"=" '/LOGNAME/{print $2}'
}

# Получение CMD
get_cmd(){
  # Получаем строку убираем нулевой байт, перенос строки и пробелы, выводим первые 100 символов
  cat /proc/$pc/cmdline | strings -1  |  tr -d '\n' | tr -d ' '| head -c 100
}

# Получение состояния процесса
get_stat(){
  cat /proc/$pc/status | awk '/State/{print $2}'
}

# Получение потребления VMRSS
get_vmrss(){
  cat /proc/$pc/status | awk '/VmRSS/{print $2}'
}


get_uniq_user(){
  # Форматируем вывод текста на экран
  format_line="%-20s%-10s%-10s%-10s%-100s\n"
  printf "$format_line" USER PID STAT VMRSS COMMAND
  
  # Получаем все папки из /proc у которых только цифры
  # и сортируем их в порядке возростания
  for pc in `ls /proc | grep "^[0-9]" | sort -n`
  do
    # Получаем путь к директории файловой системы сервиса
    if [ -f /proc/$pc/status ]
        then
        # Вывод скрипта только для залогиненго пользователя
        if [[ $(get_env_user) == $(get_username) ]]
        then
        PID=$pc
        # Выводим результат
        printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $(get_cmd)
        fi
    fi
  done
}

get_param_ps(){
  # Форматируем вывод текста на экран
  format_line="%-20s%-10s%-10s%-10s%-100s\n"
  printf "$format_line" USER PID STAT VMRSS COMMAND

  # Получаем все папки из /proc у которых только цифры
  # и сортируем их в порядке возростания
  for pc in `ls /proc | grep "^[0-9]" | sort -n`
  do
    # Получаем путь к директории файловой системы сервиса
    if [ -f /proc/$pc/status ]
        then
        getcmd=`cat /proc/$pc/cmdline | strings -1`
      if [ "$getcmd" != '' ]
        then
           getcmd=`cat /proc/$pc/cmdline | strings -1  |  tr -d '\n' | tr -d ' '| head -c 100`
            PID=$pc
           # Выводим результат
           printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $getcmd
           else
           getcmd="[`awk '/Name/{print $2}' /proc/$pc/status`]"
            PID=$pc
           # Выводим результат
           printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $getcmd
      fi
    fi
  done
}

get_param_ps_(){
  # Форматируем вывод текста на экран
  format_line="%-20s%-10s%-10s%-10s%-100s\n"
  printf "$format_line" USER PID STAT VMRSS COMMAND

  # Получаем все папки из /proc у которых только цифры
  # и сортируем их в порядке возростания
  for pc in `ls /proc | grep "^[0-9]" | sort -n`
  do
    # Получаем путь к директории файловой системы сервиса
    if [ -f /proc/$pc/status ]
    then
      PID=$pc
      # Выводим результат
      printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $(get_cmd)
    fi
  done
}

case "$1" in
  a  ) get_uniq_user;;
  x  ) get_param_ps_;; # - Промежуточный вариант, так для полноты исседования
  ax ) get_param_ps;;
  #[0-9]   ) echo "Цифра";; - оставил что бы не забыть!!!
  #[a-z]   ) echo "Буква";; - оставил что бы не забыть!!!
  *   ) echo "Не допустимая комманда";;
esac  # Допускается указыватль диапазоны символов в [квадратных скобках].

