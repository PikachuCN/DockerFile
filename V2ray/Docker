FROM alpine:latest
EXPOSE 3389
RUN apk upgrade --update
RUN apk add bash
RUN wget 【放置本目录的V2ary.sh至一个网址，让他自行下载】
RUN bash v2ray.sh
CMD /bin/sh -c /root/start.sh
