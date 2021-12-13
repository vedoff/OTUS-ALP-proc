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
  cat /proc/$pc/cmdline | head -c 20
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
  format_line="%-20s%-10s%-10s%-10s%-10s\n"
  printf "$format_line" USER PID STAT VMRSS COMMAND

  for pc in `ls /proc | grep "^[0-9]" | sort -n`
  do
    # Добавляем PID
    if [ -f /proc/$pc/status ]
        then
        #PID=$pc
        # Выводим результат
        #echo $PID
        if [[ $(get_env_user) == $(get_username) ]]
        then
        PID=$pc
        printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $(get_cmd)
        fi
    fi
  done
}

get_param_ps(){
  # Форматируем вывод текста на экран
  format_line="%-20s%-10s%-10s%-10s%-10s\n"
  printf "$format_line" USER PID STAT VMRSS COMMAND

  # Получаем все папки из /proc у которых только цифры
  # и сортируем их в порядке возростания
  for pc in `ls /proc | grep "^[0-9]" | sort -n`
  do
    #echo $pc
    # Добавляем PID
    if [ -f /proc/$pc/status ]
        then
        PID=$pc
        # Выводим результат
        printf "$format_line" $(get_username) $PID $(get_stat) $(get_vmrss) $(get_cmd)
    fi
  done
}

get_uniq_user