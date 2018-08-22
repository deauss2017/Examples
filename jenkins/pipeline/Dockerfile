# 基础镜像
FROM openjdk:8-jre-alpine

# 构建作者及版权
MAINTAINER "LeeYue" liyue1@dyrs.com.cn

RUN mkdir /initfile/

# 指定工作目录
WORKDIR /initfile/

# 时区设置
RUN apk update && apk add tzdata && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime

EXPOSE 8080 8081 8082 8083 8084 8085 8086 8087 8088 8089 8090 9000 9001

# COPY .dyedp\dyedp-cloud-discoveryservice/build/libs/ .
# RUN export jarfile="$(find . -type f -exec ls -al {} \; | sort -nr -k5 | head -n 1)"
# CMD java -jar $jarfile

COPY ./build/libs/*.jar .
CMD java -jar -Duser.timezone=Asia/Hongkong ./*.jar
CMD rm -rf *.jar 
