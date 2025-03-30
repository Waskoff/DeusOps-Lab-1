FROM alpine:3.16

# Обновляем списки пакетов и устанавливаем nginx и libcap (для setcap)
RUN apk update && apk add --no-cache nginx libcap

# Устанавливаем capability для nginx, чтобы он мог привязываться к порту 80 даже от непривилегированного пользователя
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

# Создаем каталоги для статических файлов и конфигурации nginx
RUN mkdir -p /var/www/html /etc/nginx/conf.d

# Копируем внешний конфигурационный файл, чтобы можно было изменять настройки без пересборки образа
COPY default.conf /etc/nginx/conf.d/default.conf

# Устанавливаем рабочую директорию для статических файлов
WORKDIR /var/www/html

# Открываем порт 80 внутри контейнера (этот порт будет проброшен на 8080)
EXPOSE 80

# Переключаемся на пользователя nginx, чтобы работать от непривилегированного пользователя
USER nginx

# Запускаем nginx в режиме foreground, чтобы контейнер не завершался сразу
CMD ["nginx", "-g", "daemon off;"]
