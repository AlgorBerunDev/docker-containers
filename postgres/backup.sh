#!/bin/bash

# Загрузка переменных окружения
set -a
source /etc/environment
set +a

# Указываем путь для сохранения бэкапа
BACKUP_PATH="/backups"
BACKUP_FILENAME="postgres-backup-$(date +%Y-%m-%d_%H%M%S).sql"
LOG_FILE="/var/log/backup.log"

# Проверяем, что переменные окружения установлены
if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_DB" ]; then
  echo "$(date): Backup failed - POSTGRES_USER and POSTGRES_DB must be set" >> "$LOG_FILE"
  exit 1
fi

# Экспортируем пароль для использования в pg_dump, если он установлен
if [ -n "$POSTGRES_PASSWORD" ]; then
  export PGPASSWORD="$POSTGRES_PASSWORD"
fi

# Проверяем готовность PostgreSQL к соединениям
until pg_isready -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
  echo "$(date): Waiting for PostgreSQL to start" >> "$LOG_FILE"
  sleep 1
done

# Команда для бэкапа, используя переменные окружения
pg_dump -U "$POSTGRES_USER" -h localhost -d "$POSTGRES_DB" > "$BACKUP_PATH/$BACKUP_FILENAME"

# Сжимаем созданный бэкап с использованием gzip
gzip "$BACKUP_PATH/$BACKUP_FILENAME"

# Логируем результат операции
if [ $? -eq 0 ]; then
  echo "$(date): Backup and compression successful" >> "$LOG_FILE"
else
  echo "$(date): Backup or compression failed" >> "$LOG_FILE"
fi

# Очищаем переменную окружения пароля, если она была установлена
if [ -n "$POSTGRES_PASSWORD" ]; then
  unset PGPASSWORD
fi
