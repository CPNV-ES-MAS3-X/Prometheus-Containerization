FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY src/index.html /usr/share/nginx/html.html
COPY src/prometheus.conf /etc/nginx/conf.d  
VOLUME /var/log/nginx/log 