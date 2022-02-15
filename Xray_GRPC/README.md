1. wget https://raw.githubusercontent.com/PikachuCN/DockerFile/master/Xray_GRPC/Dockerfile
2. docker build -t [镜像名]:[版本号] .
3. docker login --[登陆账号] registry.ap-northeast-1.aliyuncs.com
4. docker tag [镜像名]:[版本号] registry.ap-northeast-1.aliyuncs.com/[仓库名]/[镜像名]:[版本号]
5. docker push registry.ap-northeast-1.aliyuncs.com/[仓库名]/[镜像名]:[版本号]


第3~5步参考阿里云
