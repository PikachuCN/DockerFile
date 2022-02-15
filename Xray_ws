FROM alpine:latest
EXPOSE 443
RUN apk upgrade --update
RUN apk add bash
RUN wget https://raw.githubusercontent.com/PikachuCN/DockerFile/master/Xray_ws/Xray_ws.sh
RUN bash Xray_ws.sh
CMD /bin/sh -c /root/start.sh
