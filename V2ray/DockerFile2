FROM alpine:latest
EXPOSE 443
RUN apk upgrade --update
RUN apk add bash
RUN wget https://raw.githubusercontent.com/PikachuCN/DockerFile/master/V2ray/Xray_GRPC.sh
RUN bash Xray_GRPC.sh
CMD /bin/sh -c /root/start.sh
