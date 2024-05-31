# Используем конкретную версию образа PostgreSQL
FROM postgres:13

# Устанавливаем cron
RUN apt-get update && apt-get install -y cron

# Копируем скрипт бэкапа и файл crontab в контейнер
COPY ./backup.sh /usr/local/bin/backup.sh
COPY ./remove_outdated_backup.sh /usr/local/bin/remove_outdated_backup.sh
COPY ./my-crontab /etc/cron.d/backup-cron

# Даем права на выполнение скрипта бэкапа
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/remove_outdated_backup.sh

# Даем права на файл crontab и устанавливаем его
RUN chmod 0644 /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

# Создаем лог файл для cron и даем права на его запись
RUN touch /var/log/cron.log && chmod 0666 /var/log/cron.log

# Создаем лог файл для бэкапов и даем права на его запись
RUN touch /var/log/backup.log && chmod 0666 /var/log/backup.log
RUN touch /var/log/remove_outdated_backup.log && chmod 0666 /var/log/remove_outdated_backup.log

# Передаем переменные окружения в cron и запускаем cron в фоновом режиме, а затем основной процесс PostgreSQL
CMD printenv > /etc/environment && cron && docker-entrypoint.sh postgres
