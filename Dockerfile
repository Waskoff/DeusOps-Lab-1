FROM alpine:3.16

# Объединяем установку пакетов, создание нужных директорий и нового пользователя
RUN apk update && apk add --no-cache nginx \
    && mkdir -p /var/www/html /etc/nginx/http.d \
    && mkdir -p /var/lib/nginx/logs /var/lib/nginx/tmp/client_body \
    && mkdir -p /var/log/nginx \
    && mkdir -p /run/nginx \
    && adduser -D -g 'abobus' abobus \
    && chown -R abobus:abobus /var/lib/nginx /var/log/nginx /run/nginx

# Копируем кастомный конфигурационный файл nginx
COPY default.conf /etc/nginx/http.d/default.conf

# Устанавливаем рабочую директорию для статики
WORKDIR /var/www/html

# Открываем порт 8080
EXPOSE 8080

# Запускаем контейнер от пользователя abobus
USER abobus

# Запускаем nginx в режиме foreground
CMD ["nginx", "-g", "daemon off;"]
