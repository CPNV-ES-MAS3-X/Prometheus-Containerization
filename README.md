# Prometheus



## Installation de Prometheus

```bash
sudo apt update 
sudo apt upgrade 

sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

wget https://github.com/prometheus/prometheus/releases/download/v2.37.8/prometheus-2.37.8.linux-amd64.tar.gz
tar xvf prometheus-2.37.8.linux-amd64.tar.gz prometheus-2.37.8.linux-amd64/
cd prometheus-2.37.8.linux-amd64/

sudo mv prometheus promtool /usr/local/bin/

prometheus --version

sudo mv consoles/ console_libraries/ /etc/prometheus/
cd $HOME


sudo nano /etc/systemd/system/prometheus.service

And paste the following:

[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

sudo chown prometheus:prometheus /var/lib/prometheus

#auto reload service afetr reboot
sudo systemctl daemon-reload 
sudo systemctl enable --now prometheus
sudo systemctl status prometheus.service 

cd /etc/prometheus/  

sudo systemctl start prometheus.service 
sudo systemctl status prometheus.service 

```

## Configuration de base

```yaml
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']
```

Là on à ajouté un job `prometheus` qui à comme config `localhost:9090`

### Ajouter d'autres targets

```bash
tar -xzvf node_exporter-*.*.tar.gz
cd node_exporter-*.*

# Start 3 example targets in separate terminals:
./node_exporter --web.listen-address 192.168.10.10:8080
```

```yaml
scrape_configs:
  - job_name:       'node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['192.168.10.10:8080']
        labels:
          group: 'production'
```



## Services

```bash
systemctl status prometheus.services
```

## Logs

```
```

