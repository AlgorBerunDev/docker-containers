#!/bin/bash

# Указываем путь к директории с бэкапами
BACKUP_DIR="/backups"

# Количество дней, после которых бэкапы считаются устаревшими
DAYS_TO_KEEP=30

# Лог-файл для записи действий скрипта
LOG_FILE="/var/log/remove_outdated_backups.log"

# Записываем в лог текущую дату и время начала работы скрипта
echo "$(date): Starting the removal of outdated backups older than $DAYS_TO_KEEP days." >> "$LOG_FILE"

# Находим и удаляем устаревшие бэкапы
find "$BACKUP_DIR" -type f -name "*.gz" -mtime +$DAYS_TO_KEEP -exec rm -f {} \; >> "$LOG_FILE" 2>&1

# Проверяем, выполнена ли команда успешно
if [ $? -eq 0 ]; then
    echo "$(date): Outdated backups removal completed successfully." >> "$LOG_FILE"
else
    echo "$(date): An error occurred during the removal of outdated backups." >> "$LOG_FILE"
fi
