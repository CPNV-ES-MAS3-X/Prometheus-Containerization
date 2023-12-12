FROM debian:latest
WORKDIR /src/rerebooteur
ADD . /src/rerebooteur


RUN apt-get update && apt-get install -y openssh-server wget sshpass
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN wget "https://github.com/adnanh/webhook/releases/download/2.8.1/webhook-linux-amd64.tar.gz" 
RUN tar -xf ./webhook-linux-amd64.tar.gz
RUN cp webhook-linux-amd64/webhook /usr/local/bin/rerebooteur
RUN mkdir /etc/rerebooteur
COPY ./hooks.yml /etc/rerebooteur/
COPY ./redeploy-apache.sh /etc/rerebooteur/
RUN chmod 777 /etc/rerebooteur/redeploy-apache.sh
RUN nohup /usr/local/bin/rerebooteur -ip 127.0.0.1 -hooks /etc/rerebooteur/hooks.yml -verbose &


RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N ""
RUN sshpass -p david ssh-copy-id -o StrictHostKeyChecking=no david@192.168.15.146

ENTRYPOINT service ssh start && bash

