FROM alpine:latest
EXPOSE 443
RUN apk upgrade --update
RUN apk add bash
RUN wget https://raw.githubusercontent.com/PikachuCN/DockerFile/master/Xray_GRPC/Xray_gRPC
RUN bash Xray_GRPC.sh
CMD /bin/sh -c /root/start.sh
