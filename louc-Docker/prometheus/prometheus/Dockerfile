FROM prom/prometheus

ADD config_files/prometheus.yml /etc/prometheus
ADD config_files/rules.yml /etc/prometheus
ADD config_files/web.yml /etc/prometheus
# set environment variables
ENV TZ=Eurpoe/Zurich

# expose the Prometheus server port
EXPOSE 9090

# set the entrypoint command
ENTRYPOINT [ "prometheus", \
             "--config.file=/etc/prometheus/prometheus.yml", \
             "--web.config.file=/etc/prometheus/web.yml" \
             "--storage.tsdb.path=/prometheus", \
             "--storage.tsdb.retention=365d", \
             "--web.external-url=http://prometheus.cld.education", \
             "--log.level=warn", \
             "--log.format=logger:stderr" ] 
