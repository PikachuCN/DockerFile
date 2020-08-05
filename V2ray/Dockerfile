FROM alpine:latest
EXPOSE 3389
RUN apk upgrade --update
RUN apk add bash
RUN wget https://raw.githubusercontent.com/PikachuCN/DockerFile/master/V2ray/V2ray.sh
RUN bash v2ray.sh
CMD /bin/sh -c /root/start.sh
